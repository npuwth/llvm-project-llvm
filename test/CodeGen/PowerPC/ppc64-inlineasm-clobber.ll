; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-unknown-linux-unknown -verify-machineinstrs %s \
; RUN: -ppc-asm-full-reg-names -o - | FileCheck %s --check-prefix=PPC64LE
; RUN: llc -mtriple=powerpc64-unknown-linux-unknown -verify-machineinstrs %s \
; RUN: -ppc-asm-full-reg-names -o - | FileCheck %s --check-prefix=PPC64BE

define dso_local void @ClobberLR() local_unnamed_addr #0 {
; PPC64LE-LABEL: ClobberLR:
; PPC64LE:       # %bb.0: # %entry
; PPC64LE-NEXT:    mflr r0
; PPC64LE-NEXT:    std r0, 16(r1)
; PPC64LE-NEXT:    stdu r1, -32(r1)
; PPC64LE-NEXT:    #APP
; PPC64LE-NEXT:    #NO_APP
; PPC64LE-NEXT:    addi r1, r1, 32
; PPC64LE-NEXT:    ld r0, 16(r1)
; PPC64LE-NEXT:    mtlr r0
; PPC64LE-NEXT:    blr
;
; PPC64BE-LABEL: ClobberLR:
; PPC64BE:       # %bb.0: # %entry
; PPC64BE-NEXT:    mflr r0
; PPC64BE-NEXT:    std r0, 16(r1)
; PPC64BE-NEXT:    stdu r1, -48(r1)
; PPC64BE-NEXT:    #APP
; PPC64BE-NEXT:    #NO_APP
; PPC64BE-NEXT:    addi r1, r1, 48
; PPC64BE-NEXT:    ld r0, 16(r1)
; PPC64BE-NEXT:    mtlr r0
; PPC64BE-NEXT:    blr
entry:
  tail call void asm sideeffect "", "~{lr}"()
  ret void
}

define dso_local void @ClobberR5() local_unnamed_addr #0 {
; PPC64LE-LABEL: ClobberR5:
; PPC64LE:       # %bb.0: # %entry
; PPC64LE-NEXT:    #APP
; PPC64LE-NEXT:    #NO_APP
; PPC64LE-NEXT:    blr
;
; PPC64BE-LABEL: ClobberR5:
; PPC64BE:       # %bb.0: # %entry
; PPC64BE-NEXT:    #APP
; PPC64BE-NEXT:    #NO_APP
; PPC64BE-NEXT:    blr
entry:
  tail call void asm sideeffect "", "~{r5}"()
  ret void
}

define dso_local void @ClobberR15() local_unnamed_addr #0 {
; PPC64LE-LABEL: ClobberR15:
; PPC64LE:       # %bb.0: # %entry
; PPC64LE-NEXT:    std r15, -136(r1) # 8-byte Folded Spill
; PPC64LE-NEXT:    #APP
; PPC64LE-NEXT:    #NO_APP
; PPC64LE-NEXT:    ld r15, -136(r1) # 8-byte Folded Reload
; PPC64LE-NEXT:    blr
;
; PPC64BE-LABEL: ClobberR15:
; PPC64BE:       # %bb.0: # %entry
; PPC64BE-NEXT:    std r15, -136(r1) # 8-byte Folded Spill
; PPC64BE-NEXT:    #APP
; PPC64BE-NEXT:    #NO_APP
; PPC64BE-NEXT:    ld r15, -136(r1) # 8-byte Folded Reload
; PPC64BE-NEXT:    blr
entry:
  tail call void asm sideeffect "", "~{r15}"()
  ret void
}

;; Test for INLINEASM_BR
define dso_local signext i32 @ClobberLR_BR(i32 signext %in) #0 {
; PPC64LE-LABEL: ClobberLR_BR:
; PPC64LE:       # %bb.0: # %entry
; PPC64LE-NEXT:    mflr r0
; PPC64LE-NEXT:    std r0, 16(r1)
; PPC64LE-NEXT:    stdu r1, -32(r1)
; PPC64LE-NEXT:    #APP
; PPC64LE-NEXT:    nop
; PPC64LE-NEXT:    #NO_APP
; PPC64LE-NEXT:  .LBB3_1: # %return
; PPC64LE-NEXT:    extsw r3, r3
; PPC64LE-NEXT:    addi r1, r1, 32
; PPC64LE-NEXT:    ld r0, 16(r1)
; PPC64LE-NEXT:    mtlr r0
; PPC64LE-NEXT:    blr
; PPC64LE-NEXT:  .Ltmp0: # Block address taken
; PPC64LE-NEXT:  .LBB3_2: # %return_early
; PPC64LE-NEXT:    li r3, 0
; PPC64LE-NEXT:    b .LBB3_1
;
; PPC64BE-LABEL: ClobberLR_BR:
; PPC64BE:       # %bb.0: # %entry
; PPC64BE-NEXT:    mflr r0
; PPC64BE-NEXT:    std r0, 16(r1)
; PPC64BE-NEXT:    stdu r1, -48(r1)
; PPC64BE-NEXT:    #APP
; PPC64BE-NEXT:    nop
; PPC64BE-NEXT:    #NO_APP
; PPC64BE-NEXT:  .LBB3_1: # %return
; PPC64BE-NEXT:    extsw r3, r3
; PPC64BE-NEXT:    addi r1, r1, 48
; PPC64BE-NEXT:    ld r0, 16(r1)
; PPC64BE-NEXT:    mtlr r0
; PPC64BE-NEXT:    blr
; PPC64BE-NEXT:  .Ltmp0: # Block address taken
; PPC64BE-NEXT:  .LBB3_2: # %return_early
; PPC64BE-NEXT:    li r3, 0
; PPC64BE-NEXT:    b .LBB3_1
entry:
  callbr void asm sideeffect "nop", "!i,~{lr}"()
          to label %return [label %return_early]

return_early:
  br label %return

return:
  %retval.0 = phi i32 [ 0, %return_early ], [ %in, %entry ]
  ret i32 %retval.0
}

define dso_local signext i32 @ClobberR5_BR(i32 signext %in) #0 {
; PPC64LE-LABEL: ClobberR5_BR:
; PPC64LE:       # %bb.0: # %entry
; PPC64LE-NEXT:    #APP
; PPC64LE-NEXT:    nop
; PPC64LE-NEXT:    #NO_APP
; PPC64LE-NEXT:  # %bb.1: # %return
; PPC64LE-NEXT:    extsw r3, r3
; PPC64LE-NEXT:    blr
; PPC64LE-NEXT:  .Ltmp1: # Block address taken
; PPC64LE-NEXT:  .LBB4_2: # %return_early
; PPC64LE-NEXT:    li r3, 0
; PPC64LE-NEXT:    extsw r3, r3
; PPC64LE-NEXT:    blr
;
; PPC64BE-LABEL: ClobberR5_BR:
; PPC64BE:       # %bb.0: # %entry
; PPC64BE-NEXT:    #APP
; PPC64BE-NEXT:    nop
; PPC64BE-NEXT:    #NO_APP
; PPC64BE-NEXT:  # %bb.1: # %return
; PPC64BE-NEXT:    extsw r3, r3
; PPC64BE-NEXT:    blr
; PPC64BE-NEXT:  .Ltmp1: # Block address taken
; PPC64BE-NEXT:  .LBB4_2: # %return_early
; PPC64BE-NEXT:    li r3, 0
; PPC64BE-NEXT:    extsw r3, r3
; PPC64BE-NEXT:    blr
entry:
  callbr void asm sideeffect "nop", "!i,~{r5}"()
          to label %return [label %return_early]

return_early:
  br label %return

return:
  %retval.0 = phi i32 [ 0, %return_early ], [ %in, %entry ]
  ret i32 %retval.0
}



define dso_local void @DefLR() local_unnamed_addr #0 {
; PPC64LE-LABEL: DefLR:
; PPC64LE:       # %bb.0: # %entry
; PPC64LE-NEXT:    mflr r0
; PPC64LE-NEXT:    std r0, 16(r1)
; PPC64LE-NEXT:    stdu r1, -32(r1)
; PPC64LE-NEXT:    #APP
; PPC64LE-NEXT:    #NO_APP
; PPC64LE-NEXT:    addi r1, r1, 32
; PPC64LE-NEXT:    ld r0, 16(r1)
; PPC64LE-NEXT:    mtlr r0
; PPC64LE-NEXT:    blr
;
; PPC64BE-LABEL: DefLR:
; PPC64BE:       # %bb.0: # %entry
; PPC64BE-NEXT:    mflr r0
; PPC64BE-NEXT:    std r0, 16(r1)
; PPC64BE-NEXT:    stdu r1, -48(r1)
; PPC64BE-NEXT:    #APP
; PPC64BE-NEXT:    #NO_APP
; PPC64BE-NEXT:    addi r1, r1, 48
; PPC64BE-NEXT:    ld r0, 16(r1)
; PPC64BE-NEXT:    mtlr r0
; PPC64BE-NEXT:    blr
entry:
  tail call i64 asm sideeffect "", "={lr}"()
  ret void
}

define dso_local void @EarlyClobberLR() local_unnamed_addr #0 {
; PPC64LE-LABEL: EarlyClobberLR:
; PPC64LE:       # %bb.0: # %entry
; PPC64LE-NEXT:    mflr r0
; PPC64LE-NEXT:    std r0, 16(r1)
; PPC64LE-NEXT:    stdu r1, -32(r1)
; PPC64LE-NEXT:    #APP
; PPC64LE-NEXT:    #NO_APP
; PPC64LE-NEXT:    addi r1, r1, 32
; PPC64LE-NEXT:    ld r0, 16(r1)
; PPC64LE-NEXT:    mtlr r0
; PPC64LE-NEXT:    blr
;
; PPC64BE-LABEL: EarlyClobberLR:
; PPC64BE:       # %bb.0: # %entry
; PPC64BE-NEXT:    mflr r0
; PPC64BE-NEXT:    std r0, 16(r1)
; PPC64BE-NEXT:    stdu r1, -48(r1)
; PPC64BE-NEXT:    #APP
; PPC64BE-NEXT:    #NO_APP
; PPC64BE-NEXT:    addi r1, r1, 48
; PPC64BE-NEXT:    ld r0, 16(r1)
; PPC64BE-NEXT:    mtlr r0
; PPC64BE-NEXT:    blr
entry:
  tail call i64 asm sideeffect "", "=&{lr}"()
  ret void
}

define dso_local void @ClobberMulti() local_unnamed_addr #0 {
; PPC64LE-LABEL: ClobberMulti:
; PPC64LE:       # %bb.0: # %entry
; PPC64LE-NEXT:    mflr r0
; PPC64LE-NEXT:    std r15, -136(r1) # 8-byte Folded Spill
; PPC64LE-NEXT:    std r16, -128(r1) # 8-byte Folded Spill
; PPC64LE-NEXT:    std r0, 16(r1)
; PPC64LE-NEXT:    stdu r1, -176(r1)
; PPC64LE-NEXT:    #APP
; PPC64LE-NEXT:    #NO_APP
; PPC64LE-NEXT:    addi r1, r1, 176
; PPC64LE-NEXT:    ld r0, 16(r1)
; PPC64LE-NEXT:    ld r16, -128(r1) # 8-byte Folded Reload
; PPC64LE-NEXT:    ld r15, -136(r1) # 8-byte Folded Reload
; PPC64LE-NEXT:    mtlr r0
; PPC64LE-NEXT:    blr
;
; PPC64BE-LABEL: ClobberMulti:
; PPC64BE:       # %bb.0: # %entry
; PPC64BE-NEXT:    mflr r0
; PPC64BE-NEXT:    std r0, 16(r1)
; PPC64BE-NEXT:    stdu r1, -192(r1)
; PPC64BE-NEXT:    std r15, 56(r1) # 8-byte Folded Spill
; PPC64BE-NEXT:    std r16, 64(r1) # 8-byte Folded Spill
; PPC64BE-NEXT:    #APP
; PPC64BE-NEXT:    #NO_APP
; PPC64BE-NEXT:    ld r16, 64(r1) # 8-byte Folded Reload
; PPC64BE-NEXT:    ld r15, 56(r1) # 8-byte Folded Reload
; PPC64BE-NEXT:    addi r1, r1, 192
; PPC64BE-NEXT:    ld r0, 16(r1)
; PPC64BE-NEXT:    mtlr r0
; PPC64BE-NEXT:    blr
entry:
  tail call void asm sideeffect "", "~{lr},~{r15},~{r16}"()
  ret void
}

attributes #0 = { nounwind }
