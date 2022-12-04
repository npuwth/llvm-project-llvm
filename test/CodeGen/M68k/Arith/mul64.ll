; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=m68k-linux -verify-machineinstrs | FileCheck %s

; Currenlty making the libcall is ok, x20 supports i32 mul/div which
; yields saner expansion for i64 mul
define i64 @foo(i64 %t, i64 %u) nounwind {
; CHECK-LABEL: foo:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    suba.l #20, %sp
; CHECK-NEXT:    move.l (36,%sp), (12,%sp)
; CHECK-NEXT:    move.l (32,%sp), (8,%sp)
; CHECK-NEXT:    move.l (28,%sp), (4,%sp)
; CHECK-NEXT:    move.l (24,%sp), (%sp)
; CHECK-NEXT:    jsr __muldi3@PLT
; CHECK-NEXT:    adda.l #20, %sp
; CHECK-NEXT:    rts
  %k = mul i64 %t, %u
  ret i64 %k
}
