//===-- SPIRVPrepareFunctions.cpp - modify function signatures --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass modifies function signatures containing aggregate arguments
// and/or return value. Also it substitutes some llvm intrinsic calls by
// function calls, generating these functions as the translator does.
//
// NOTE: this pass is a module-level one due to the necessity to modify
// GVs/functions.
//
//===----------------------------------------------------------------------===//

#include "SPIRV.h"
#include "SPIRVTargetMachine.h"
#include "SPIRVUtils.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/LowerMemIntrinsics.h"

using namespace llvm;

namespace llvm {
void initializeSPIRVPrepareFunctionsPass(PassRegistry &);
}

namespace {

class SPIRVPrepareFunctions : public ModulePass {
  Function *processFunctionSignature(Function *F);

public:
  static char ID;
  SPIRVPrepareFunctions() : ModulePass(ID) {
    initializeSPIRVPrepareFunctionsPass(*PassRegistry::getPassRegistry());
  }

  bool runOnModule(Module &M) override;

  StringRef getPassName() const override { return "SPIRV prepare functions"; }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    ModulePass::getAnalysisUsage(AU);
  }
};

} // namespace

char SPIRVPrepareFunctions::ID = 0;

INITIALIZE_PASS(SPIRVPrepareFunctions, "prepare-functions",
                "SPIRV prepare functions", false, false)

Function *SPIRVPrepareFunctions::processFunctionSignature(Function *F) {
  IRBuilder<> B(F->getContext());

  bool IsRetAggr = F->getReturnType()->isAggregateType();
  bool HasAggrArg =
      std::any_of(F->arg_begin(), F->arg_end(), [](Argument &Arg) {
        return Arg.getType()->isAggregateType();
      });
  bool DoClone = IsRetAggr || HasAggrArg;
  if (!DoClone)
    return F;
  SmallVector<std::pair<int, Type *>, 4> ChangedTypes;
  Type *RetType = IsRetAggr ? B.getInt32Ty() : F->getReturnType();
  if (IsRetAggr)
    ChangedTypes.push_back(std::pair<int, Type *>(-1, F->getReturnType()));
  SmallVector<Type *, 4> ArgTypes;
  for (const auto &Arg : F->args()) {
    if (Arg.getType()->isAggregateType()) {
      ArgTypes.push_back(B.getInt32Ty());
      ChangedTypes.push_back(
          std::pair<int, Type *>(Arg.getArgNo(), Arg.getType()));
    } else
      ArgTypes.push_back(Arg.getType());
  }
  FunctionType *NewFTy =
      FunctionType::get(RetType, ArgTypes, F->getFunctionType()->isVarArg());
  Function *NewF =
      Function::Create(NewFTy, F->getLinkage(), F->getName(), *F->getParent());

  ValueToValueMapTy VMap;
  auto NewFArgIt = NewF->arg_begin();
  for (auto &Arg : F->args()) {
    StringRef ArgName = Arg.getName();
    NewFArgIt->setName(ArgName);
    VMap[&Arg] = &(*NewFArgIt++);
  }
  SmallVector<ReturnInst *, 8> Returns;

  CloneFunctionInto(NewF, F, VMap, CloneFunctionChangeType::LocalChangesOnly,
                    Returns);
  NewF->takeName(F);

  NamedMDNode *FuncMD =
      F->getParent()->getOrInsertNamedMetadata("spv.cloned_funcs");
  SmallVector<Metadata *, 2> MDArgs;
  MDArgs.push_back(MDString::get(B.getContext(), NewF->getName()));
  for (auto &ChangedTyP : ChangedTypes)
    MDArgs.push_back(MDNode::get(
        B.getContext(),
        {ConstantAsMetadata::get(B.getInt32(ChangedTyP.first)),
         ValueAsMetadata::get(Constant::getNullValue(ChangedTyP.second))}));
  MDNode *ThisFuncMD = MDNode::get(B.getContext(), MDArgs);
  FuncMD->addOperand(ThisFuncMD);

  for (auto *U : make_early_inc_range(F->users())) {
    if (auto *CI = dyn_cast<CallInst>(U))
      CI->mutateFunctionType(NewF->getFunctionType());
    U->replaceUsesOfWith(F, NewF);
  }
  return NewF;
}

std::string lowerLLVMIntrinsicName(IntrinsicInst *II) {
  Function *IntrinsicFunc = II->getCalledFunction();
  assert(IntrinsicFunc && "Missing function");
  std::string FuncName = IntrinsicFunc->getName().str();
  std::replace(FuncName.begin(), FuncName.end(), '.', '_');
  FuncName = "spirv." + FuncName;
  return FuncName;
}

static Function *getOrCreateFunction(Module *M, Type *RetTy,
                                     ArrayRef<Type *> ArgTypes,
                                     StringRef Name) {
  FunctionType *FT = FunctionType::get(RetTy, ArgTypes, false);
  Function *F = M->getFunction(Name);
  if (F && F->getFunctionType() == FT)
    return F;
  Function *NewF = Function::Create(FT, GlobalValue::ExternalLinkage, Name, M);
  if (F)
    NewF->setDSOLocal(F->isDSOLocal());
  NewF->setCallingConv(CallingConv::SPIR_FUNC);
  return NewF;
}

static void lowerFunnelShifts(Module *M, IntrinsicInst *FSHIntrinsic) {
  // Get a separate function - otherwise, we'd have to rework the CFG of the
  // current one. Then simply replace the intrinsic uses with a call to the new
  // function.
  // Generate LLVM IR for  i* @spirv.llvm_fsh?_i* (i* %a, i* %b, i* %c)
  FunctionType *FSHFuncTy = FSHIntrinsic->getFunctionType();
  Type *FSHRetTy = FSHFuncTy->getReturnType();
  const std::string FuncName = lowerLLVMIntrinsicName(FSHIntrinsic);
  Function *FSHFunc =
      getOrCreateFunction(M, FSHRetTy, FSHFuncTy->params(), FuncName);

  if (!FSHFunc->empty()) {
    FSHIntrinsic->setCalledFunction(FSHFunc);
    return;
  }
  BasicBlock *RotateBB = BasicBlock::Create(M->getContext(), "rotate", FSHFunc);
  IRBuilder<> IRB(RotateBB);
  Type *Ty = FSHFunc->getReturnType();
  // Build the actual funnel shift rotate logic.
  // In the comments, "int" is used interchangeably with "vector of int
  // elements".
  FixedVectorType *VectorTy = dyn_cast<FixedVectorType>(Ty);
  Type *IntTy = VectorTy ? VectorTy->getElementType() : Ty;
  unsigned BitWidth = IntTy->getIntegerBitWidth();
  ConstantInt *BitWidthConstant = IRB.getInt({BitWidth, BitWidth});
  Value *BitWidthForInsts =
      VectorTy
          ? IRB.CreateVectorSplat(VectorTy->getNumElements(), BitWidthConstant)
          : BitWidthConstant;
  Value *RotateModVal =
      IRB.CreateURem(/*Rotate*/ FSHFunc->getArg(2), BitWidthForInsts);
  Value *FirstShift = nullptr, *SecShift = nullptr;
  if (FSHIntrinsic->getIntrinsicID() == Intrinsic::fshr) {
    // Shift the less significant number right, the "rotate" number of bits
    // will be 0-filled on the left as a result of this regular shift.
    FirstShift = IRB.CreateLShr(FSHFunc->getArg(1), RotateModVal);
  } else {
    // Shift the more significant number left, the "rotate" number of bits
    // will be 0-filled on the right as a result of this regular shift.
    FirstShift = IRB.CreateShl(FSHFunc->getArg(0), RotateModVal);
  }
  // We want the "rotate" number of the more significant int's LSBs (MSBs) to
  // occupy the leftmost (rightmost) "0 space" left by the previous operation.
  // Therefore, subtract the "rotate" number from the integer bitsize...
  Value *SubRotateVal = IRB.CreateSub(BitWidthForInsts, RotateModVal);
  if (FSHIntrinsic->getIntrinsicID() == Intrinsic::fshr) {
    // ...and left-shift the more significant int by this number, zero-filling
    // the LSBs.
    SecShift = IRB.CreateShl(FSHFunc->getArg(0), SubRotateVal);
  } else {
    // ...and right-shift the less significant int by this number, zero-filling
    // the MSBs.
    SecShift = IRB.CreateLShr(FSHFunc->getArg(1), SubRotateVal);
  }
  // A simple binary addition of the shifted ints yields the final result.
  IRB.CreateRet(IRB.CreateOr(FirstShift, SecShift));

  FSHIntrinsic->setCalledFunction(FSHFunc);
}

static void buildUMulWithOverflowFunc(Module *M, Function *UMulFunc) {
  // The function body is already created.
  if (!UMulFunc->empty())
    return;

  BasicBlock *EntryBB = BasicBlock::Create(M->getContext(), "entry", UMulFunc);
  IRBuilder<> IRB(EntryBB);
  // Build the actual unsigned multiplication logic with the overflow
  // indication. Do unsigned multiplication Mul = A * B. Then check
  // if unsigned division Div = Mul / A is not equal to B. If so,
  // then overflow has happened.
  Value *Mul = IRB.CreateNUWMul(UMulFunc->getArg(0), UMulFunc->getArg(1));
  Value *Div = IRB.CreateUDiv(Mul, UMulFunc->getArg(0));
  Value *Overflow = IRB.CreateICmpNE(UMulFunc->getArg(0), Div);

  // umul.with.overflow intrinsic return a structure, where the first element
  // is the multiplication result, and the second is an overflow bit.
  Type *StructTy = UMulFunc->getReturnType();
  Value *Agg = IRB.CreateInsertValue(UndefValue::get(StructTy), Mul, {0});
  Value *Res = IRB.CreateInsertValue(Agg, Overflow, {1});
  IRB.CreateRet(Res);
}

static void lowerUMulWithOverflow(Module *M, IntrinsicInst *UMulIntrinsic) {
  // Get a separate function - otherwise, we'd have to rework the CFG of the
  // current one. Then simply replace the intrinsic uses with a call to the new
  // function.
  FunctionType *UMulFuncTy = UMulIntrinsic->getFunctionType();
  Type *FSHLRetTy = UMulFuncTy->getReturnType();
  const std::string FuncName = lowerLLVMIntrinsicName(UMulIntrinsic);
  Function *UMulFunc =
      getOrCreateFunction(M, FSHLRetTy, UMulFuncTy->params(), FuncName);
  buildUMulWithOverflowFunc(M, UMulFunc);
  UMulIntrinsic->setCalledFunction(UMulFunc);
}

static void substituteIntrinsicCalls(Module *M, Function *F) {
  for (BasicBlock &BB : *F) {
    for (Instruction &I : BB) {
      auto Call = dyn_cast<CallInst>(&I);
      if (!Call)
        continue;
      Call->setTailCall(false);
      Function *CF = Call->getCalledFunction();
      if (!CF || !CF->isIntrinsic())
        continue;
      auto *II = cast<IntrinsicInst>(Call);
      if (II->getIntrinsicID() == Intrinsic::fshl ||
          II->getIntrinsicID() == Intrinsic::fshr)
        lowerFunnelShifts(M, II);
      else if (II->getIntrinsicID() == Intrinsic::umul_with_overflow)
        lowerUMulWithOverflow(M, II);
    }
  }
}

bool SPIRVPrepareFunctions::runOnModule(Module &M) {
  for (Function &F : M)
    substituteIntrinsicCalls(&M, &F);

  std::vector<Function *> FuncsWorklist;
  bool Changed = false;
  for (auto &F : M)
    FuncsWorklist.push_back(&F);

  for (auto *Func : FuncsWorklist) {
    Function *F = processFunctionSignature(Func);

    bool CreatedNewF = F != Func;

    if (Func->isDeclaration()) {
      Changed |= CreatedNewF;
      continue;
    }

    if (CreatedNewF)
      Func->eraseFromParent();
  }

  return Changed;
}

ModulePass *llvm::createSPIRVPrepareFunctionsPass() {
  return new SPIRVPrepareFunctions();
}
