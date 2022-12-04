; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64-unknown-unknown -verify-machineinstrs \
; RUN:   -ppc-asm-full-reg-names < %s | FileCheck %s
@a = dso_local local_unnamed_addr global double 0.000000e+00, align 8

define dso_local signext i32 @b() local_unnamed_addr #0 {
; CHECK-LABEL: b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -144(r1)
; CHECK-NEXT:    addis r3, r2, a@toc@ha
; CHECK-NEXT:    li r4, 1
; CHECK-NEXT:    lfd f0, a@toc@l(r3)
; CHECK-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-NEXT:    rldic r4, r4, 63, 0
; CHECK-NEXT:    lfs f1, .LCPI0_0@toc@l(r3)
; CHECK-NEXT:    fsub f2, f0, f1
; CHECK-NEXT:    fctidz f2, f2
; CHECK-NEXT:    stfd f2, 128(r1)
; CHECK-NEXT:    fctidz f2, f0
; CHECK-NEXT:    stfd f2, 120(r1)
; CHECK-NEXT:    ld r3, 128(r1)
; CHECK-NEXT:    ld r5, 120(r1)
; CHECK-NEXT:    fcmpu cr0, f0, f1
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    bc 12, lt, .LBB0_1
; CHECK-NEXT:    b .LBB0_2
; CHECK-NEXT:  .LBB0_1: # %entry
; CHECK-NEXT:    addi r3, r5, 0
; CHECK-NEXT:  .LBB0_2: # %entry
; CHECK-NEXT:    std r3, 112(r1)
; CHECK-NEXT:    addis r3, r2, .LCPI0_1@toc@ha
; CHECK-NEXT:    lfd f0, 112(r1)
; CHECK-NEXT:    lfs f1, .LCPI0_1@toc@l(r3)
; CHECK-NEXT:    fcfid f0, f0
; CHECK-NEXT:    fmul f0, f0, f1
; CHECK-NEXT:    fctiwz f0, f0
; CHECK-NEXT:    stfd f0, 136(r1)
; CHECK-NEXT:    lwa r3, 140(r1)
; CHECK-NEXT:    bl g
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi r1, r1, 144
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %0 = load double, double* @a, align 8
  %conv = fptoui double %0 to i64
  %conv1 = sitofp i64 %conv to double
  %mul = fmul double %conv1, 1.000000e+06
  %conv2 = fptosi double %mul to i32
  %call = tail call signext i32 @g(i32 signext %conv2) #0
  ret i32 %call
}

declare signext i32 @g(i32 signext) local_unnamed_addr

attributes #0 = { nounwind }
