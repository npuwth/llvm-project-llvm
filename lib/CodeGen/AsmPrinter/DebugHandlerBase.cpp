//===-- llvm/lib/CodeGen/AsmPrinter/DebugHandlerBase.cpp -------*- C++ -*--===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Common functionality for different debug information format backends.
// LLVM currently supports DWARF and CodeView.
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/DebugHandlerBase.h"
#include "llvm/ADT/Optional.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Support/CommandLine.h"

using namespace llvm;

#define DEBUG_TYPE "dwarfdebug"

/// If true, we drop variable location ranges which exist entirely outside the
/// variable's lexical scope instruction ranges.
static cl::opt<bool> TrimVarLocs("trim-var-locs", cl::Hidden, cl::init(true));

Optional<DbgVariableLocation>
DbgVariableLocation::extractFromMachineInstruction(
    const MachineInstr &Instruction) {
  DbgVariableLocation Location;
  // Variables calculated from multiple locations can't be represented here.
  if (Instruction.getNumDebugOperands() != 1)
    return None;
  if (!Instruction.getDebugOperand(0).isReg())
    return None;
  Location.Register = Instruction.getDebugOperand(0).getReg();
  Location.FragmentInfo.reset();
  // We only handle expressions generated by DIExpression::appendOffset,
  // which doesn't require a full stack machine.
  int64_t Offset = 0;
  const DIExpression *DIExpr = Instruction.getDebugExpression();
  auto Op = DIExpr->expr_op_begin();
  // We can handle a DBG_VALUE_LIST iff it has exactly one location operand that
  // appears exactly once at the start of the expression.
  if (Instruction.isDebugValueList()) {
    if (Instruction.getNumDebugOperands() == 1 &&
        Op->getOp() == dwarf::DW_OP_LLVM_arg)
      ++Op;
    else
      return None;
  }
  while (Op != DIExpr->expr_op_end()) {
    switch (Op->getOp()) {
    case dwarf::DW_OP_constu: {
      int Value = Op->getArg(0);
      ++Op;
      if (Op != DIExpr->expr_op_end()) {
        switch (Op->getOp()) {
        case dwarf::DW_OP_minus:
          Offset -= Value;
          break;
        case dwarf::DW_OP_plus:
          Offset += Value;
          break;
        default:
          continue;
        }
      }
    } break;
    case dwarf::DW_OP_plus_uconst:
      Offset += Op->getArg(0);
      break;
    case dwarf::DW_OP_LLVM_fragment:
      Location.FragmentInfo = {Op->getArg(1), Op->getArg(0)};
      break;
    case dwarf::DW_OP_deref:
      Location.LoadChain.push_back(Offset);
      Offset = 0;
      break;
    default:
      return None;
    }
    ++Op;
  }

  // Do one final implicit DW_OP_deref if this was an indirect DBG_VALUE
  // instruction.
  // FIXME: Replace these with DIExpression.
  if (Instruction.isIndirectDebugValue())
    Location.LoadChain.push_back(Offset);

  return Location;
}

DebugHandlerBase::DebugHandlerBase(AsmPrinter *A) : Asm(A), MMI(Asm->MMI) {}

void DebugHandlerBase::beginModule(Module *M) {
  if (M->debug_compile_units().empty())
    Asm = nullptr;
}

// Each LexicalScope has first instruction and last instruction to mark
// beginning and end of a scope respectively. Create an inverse map that list
// scopes starts (and ends) with an instruction. One instruction may start (or
// end) multiple scopes. Ignore scopes that are not reachable.
void DebugHandlerBase::identifyScopeMarkers() {
  SmallVector<LexicalScope *, 4> WorkList;
  WorkList.push_back(LScopes.getCurrentFunctionScope());
  while (!WorkList.empty()) {
    LexicalScope *S = WorkList.pop_back_val();

    const SmallVectorImpl<LexicalScope *> &Children = S->getChildren();
    if (!Children.empty())
      WorkList.append(Children.begin(), Children.end());

    if (S->isAbstractScope())
      continue;

    for (const InsnRange &R : S->getRanges()) {
      assert(R.first && "InsnRange does not have first instruction!");
      assert(R.second && "InsnRange does not have second instruction!");
      requestLabelBeforeInsn(R.first);
      requestLabelAfterInsn(R.second);
    }
  }
}

// Return Label preceding the instruction.
MCSymbol *DebugHandlerBase::getLabelBeforeInsn(const MachineInstr *MI) {
  MCSymbol *Label = LabelsBeforeInsn.lookup(MI);
  assert(Label && "Didn't insert label before instruction");
  return Label;
}

// Return Label immediately following the instruction.
MCSymbol *DebugHandlerBase::getLabelAfterInsn(const MachineInstr *MI) {
  return LabelsAfterInsn.lookup(MI);
}

/// If this type is derived from a base type then return base type size.
uint64_t DebugHandlerBase::getBaseTypeSize(const DIType *Ty) {
  assert(Ty);
  const DIDerivedType *DDTy = dyn_cast<DIDerivedType>(Ty);
  if (!DDTy)
    return Ty->getSizeInBits();

  unsigned Tag = DDTy->getTag();

  if (Tag != dwarf::DW_TAG_member && Tag != dwarf::DW_TAG_typedef &&
      Tag != dwarf::DW_TAG_const_type && Tag != dwarf::DW_TAG_volatile_type &&
      Tag != dwarf::DW_TAG_restrict_type && Tag != dwarf::DW_TAG_atomic_type &&
      Tag != dwarf::DW_TAG_immutable_type)
    return DDTy->getSizeInBits();

  DIType *BaseType = DDTy->getBaseType();

  if (!BaseType)
    return 0;

  // If this is a derived type, go ahead and get the base type, unless it's a
  // reference then it's just the size of the field. Pointer types have no need
  // of this since they're a different type of qualification on the type.
  if (BaseType->getTag() == dwarf::DW_TAG_reference_type ||
      BaseType->getTag() == dwarf::DW_TAG_rvalue_reference_type)
    return Ty->getSizeInBits();

  return getBaseTypeSize(BaseType);
}

bool DebugHandlerBase::isUnsignedDIType(const DIType *Ty) {
  if (isa<DIStringType>(Ty)) {
    // Some transformations (e.g. instcombine) may decide to turn a Fortran
    // character object into an integer, and later ones (e.g. SROA) may
    // further inject a constant integer in a llvm.dbg.value call to track
    // the object's value. Here we trust the transformations are doing the
    // right thing, and treat the constant as unsigned to preserve that value
    // (i.e. avoid sign extension).
    return true;
  }

  if (auto *CTy = dyn_cast<DICompositeType>(Ty)) {
    if (CTy->getTag() == dwarf::DW_TAG_enumeration_type) {
      if (!(Ty = CTy->getBaseType()))
        // FIXME: Enums without a fixed underlying type have unknown signedness
        // here, leading to incorrectly emitted constants.
        return false;
    } else
      // (Pieces of) aggregate types that get hacked apart by SROA may be
      // represented by a constant. Encode them as unsigned bytes.
      return true;
  }

  if (auto *DTy = dyn_cast<DIDerivedType>(Ty)) {
    dwarf::Tag T = (dwarf::Tag)Ty->getTag();
    // Encode pointer constants as unsigned bytes. This is used at least for
    // null pointer constant emission.
    // FIXME: reference and rvalue_reference /probably/ shouldn't be allowed
    // here, but accept them for now due to a bug in SROA producing bogus
    // dbg.values.
    if (T == dwarf::DW_TAG_pointer_type ||
        T == dwarf::DW_TAG_ptr_to_member_type ||
        T == dwarf::DW_TAG_reference_type ||
        T == dwarf::DW_TAG_rvalue_reference_type)
      return true;
    assert(T == dwarf::DW_TAG_typedef || T == dwarf::DW_TAG_const_type ||
           T == dwarf::DW_TAG_volatile_type ||
           T == dwarf::DW_TAG_restrict_type || T == dwarf::DW_TAG_atomic_type ||
           T == dwarf::DW_TAG_immutable_type);
    assert(DTy->getBaseType() && "Expected valid base type");
    return isUnsignedDIType(DTy->getBaseType());
  }

  auto *BTy = cast<DIBasicType>(Ty);
  unsigned Encoding = BTy->getEncoding();
  assert((Encoding == dwarf::DW_ATE_unsigned ||
          Encoding == dwarf::DW_ATE_unsigned_char ||
          Encoding == dwarf::DW_ATE_signed ||
          Encoding == dwarf::DW_ATE_signed_char ||
          Encoding == dwarf::DW_ATE_float || Encoding == dwarf::DW_ATE_UTF ||
          Encoding == dwarf::DW_ATE_boolean ||
          (Ty->getTag() == dwarf::DW_TAG_unspecified_type &&
           Ty->getName() == "decltype(nullptr)")) &&
         "Unsupported encoding");
  return Encoding == dwarf::DW_ATE_unsigned ||
         Encoding == dwarf::DW_ATE_unsigned_char ||
         Encoding == dwarf::DW_ATE_UTF || Encoding == dwarf::DW_ATE_boolean ||
         Ty->getTag() == dwarf::DW_TAG_unspecified_type;
}

static bool hasDebugInfo(const MachineModuleInfo *MMI,
                         const MachineFunction *MF) {
  if (!MMI->hasDebugInfo())
    return false;
  auto *SP = MF->getFunction().getSubprogram();
  if (!SP)
    return false;
  assert(SP->getUnit());
  auto EK = SP->getUnit()->getEmissionKind();
  if (EK == DICompileUnit::NoDebug)
    return false;
  return true;
}

void DebugHandlerBase::beginFunction(const MachineFunction *MF) {
  PrevInstBB = nullptr;

  if (!Asm || !hasDebugInfo(MMI, MF)) {
    skippedNonDebugFunction();
    return;
  }

  // Grab the lexical scopes for the function, if we don't have any of those
  // then we're not going to be able to do anything.
  LScopes.initialize(*MF);
  if (LScopes.empty()) {
    beginFunctionImpl(MF);
    return;
  }

  // Make sure that each lexical scope will have a begin/end label.
  identifyScopeMarkers();

  // Calculate history for local variables.
  assert(DbgValues.empty() && "DbgValues map wasn't cleaned!");
  assert(DbgLabels.empty() && "DbgLabels map wasn't cleaned!");
  calculateDbgEntityHistory(MF, Asm->MF->getSubtarget().getRegisterInfo(),
                            DbgValues, DbgLabels);
  InstOrdering.initialize(*MF);
  if (TrimVarLocs)
    DbgValues.trimLocationRanges(*MF, LScopes, InstOrdering);
  LLVM_DEBUG(DbgValues.dump());

  // Request labels for the full history.
  for (const auto &I : DbgValues) {
    const auto &Entries = I.second;
    if (Entries.empty())
      continue;

    auto IsDescribedByReg = [](const MachineInstr *MI) {
      return any_of(MI->debug_operands(),
                    [](auto &MO) { return MO.isReg() && MO.getReg(); });
    };

    // The first mention of a function argument gets the CurrentFnBegin label,
    // so arguments are visible when breaking at function entry.
    //
    // We do not change the label for values that are described by registers,
    // as that could place them above their defining instructions. We should
    // ideally not change the labels for constant debug values either, since
    // doing that violates the ranges that are calculated in the history map.
    // However, we currently do not emit debug values for constant arguments
    // directly at the start of the function, so this code is still useful.
    const DILocalVariable *DIVar =
        Entries.front().getInstr()->getDebugVariable();
    if (DIVar->isParameter() &&
        getDISubprogram(DIVar->getScope())->describes(&MF->getFunction())) {
      if (!IsDescribedByReg(Entries.front().getInstr()))
        LabelsBeforeInsn[Entries.front().getInstr()] = Asm->getFunctionBegin();
      if (Entries.front().getInstr()->getDebugExpression()->isFragment()) {
        // Mark all non-overlapping initial fragments.
        for (const auto *I = Entries.begin(); I != Entries.end(); ++I) {
          if (!I->isDbgValue())
            continue;
          const DIExpression *Fragment = I->getInstr()->getDebugExpression();
          if (std::any_of(Entries.begin(), I,
                          [&](DbgValueHistoryMap::Entry Pred) {
                            return Pred.isDbgValue() &&
                                   Fragment->fragmentsOverlap(
                                       Pred.getInstr()->getDebugExpression());
                          }))
            break;
          // The code that generates location lists for DWARF assumes that the
          // entries' start labels are monotonically increasing, and since we
          // don't change the label for fragments that are described by
          // registers, we must bail out when encountering such a fragment.
          if (IsDescribedByReg(I->getInstr()))
            break;
          LabelsBeforeInsn[I->getInstr()] = Asm->getFunctionBegin();
        }
      }
    }

    for (const auto &Entry : Entries) {
      if (Entry.isDbgValue())
        requestLabelBeforeInsn(Entry.getInstr());
      else
        requestLabelAfterInsn(Entry.getInstr());
    }
  }

  // Ensure there is a symbol before DBG_LABEL.
  for (const auto &I : DbgLabels) {
    const MachineInstr *MI = I.second;
    requestLabelBeforeInsn(MI);
  }

  PrevInstLoc = DebugLoc();
  PrevLabel = Asm->getFunctionBegin();
  beginFunctionImpl(MF);
}

void DebugHandlerBase::beginInstruction(const MachineInstr *MI) {
  if (!Asm || !MMI->hasDebugInfo())
    return;

  assert(CurMI == nullptr);
  CurMI = MI;

  // Insert labels where requested.
  DenseMap<const MachineInstr *, MCSymbol *>::iterator I =
      LabelsBeforeInsn.find(MI);

  // No label needed.
  if (I == LabelsBeforeInsn.end())
    return;

  // Label already assigned.
  if (I->second)
    return;

  if (!PrevLabel) {
    PrevLabel = MMI->getContext().createTempSymbol();
    Asm->OutStreamer->emitLabel(PrevLabel);
  }
  I->second = PrevLabel;
}

void DebugHandlerBase::endInstruction() {
  if (!Asm || !MMI->hasDebugInfo())
    return;

  assert(CurMI != nullptr);
  // Don't create a new label after DBG_VALUE and other instructions that don't
  // generate code.
  if (!CurMI->isMetaInstruction()) {
    PrevLabel = nullptr;
    PrevInstBB = CurMI->getParent();
  }

  DenseMap<const MachineInstr *, MCSymbol *>::iterator I =
      LabelsAfterInsn.find(CurMI);

  // No label needed or label already assigned.
  if (I == LabelsAfterInsn.end() || I->second) {
    CurMI = nullptr;
    return;
  }

  // We need a label after this instruction.  With basic block sections, just
  // use the end symbol of the section if this is the last instruction of the
  // section.  This reduces the need for an additional label and also helps
  // merging ranges.
  if (CurMI->getParent()->isEndSection() && CurMI->getNextNode() == nullptr) {
    PrevLabel = CurMI->getParent()->getEndSymbol();
  } else if (!PrevLabel) {
    PrevLabel = MMI->getContext().createTempSymbol();
    Asm->OutStreamer->emitLabel(PrevLabel);
  }
  I->second = PrevLabel;
  CurMI = nullptr;
}

void DebugHandlerBase::endFunction(const MachineFunction *MF) {
  if (Asm && hasDebugInfo(MMI, MF))
    endFunctionImpl(MF);
  DbgValues.clear();
  DbgLabels.clear();
  LabelsBeforeInsn.clear();
  LabelsAfterInsn.clear();
  InstOrdering.clear();
}

void DebugHandlerBase::beginBasicBlock(const MachineBasicBlock &MBB) {
  if (!MBB.isBeginSection())
    return;

  PrevLabel = MBB.getSymbol();
}

void DebugHandlerBase::endBasicBlock(const MachineBasicBlock &MBB) {
  if (!MBB.isEndSection())
    return;

  PrevLabel = nullptr;
}
