; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O0 --march=ve -mattr=+vpu | FileCheck %s

declare i64 @llvm.vp.reduce.xor.v256i64(i64, <256 x i64>, <256 x i1>, i32)

define fastcc i64 @vp_reduce_xor_v256i64(i64 %s, <256 x i64> %v, <256 x i1> %m, i32 %n) {
; CHECK-LABEL: vp_reduce_xor_v256i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    # kill: def $sw1 killed $sw1 killed $sx1
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vrxor %v0, %v0, %vm1
; CHECK-NEXT:    lvs %s1, %v0(0)
; CHECK-NEXT:    xor %s0, %s0, %s1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = call i64 @llvm.vp.reduce.xor.v256i64(i64 %s, <256 x i64> %v, <256 x i1> %m, i32 %n)
  ret i64 %r
}

declare i32 @llvm.vp.reduce.xor.v256i32(i32, <256 x i32>, <256 x i1>, i32)

define fastcc i32 @vp_reduce_xor_v256i32(i32 %s, <256 x i32> %v, <256 x i1> %m, i32 %n) {
; CHECK-LABEL: vp_reduce_xor_v256i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s2, %s0, (32)0
; CHECK-NEXT:    # kill: def $sw2 killed $sw2 killed $sx2
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    # kill: def $sw1 killed $sw1 killed $sx1
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vrxor %v0, %v0, %vm1
; CHECK-NEXT:    lvs %s1, %v0(0)
; CHECK-NEXT:    or %s2, 0, %s1
; CHECK-NEXT:    # implicit-def: $sx1
; CHECK-NEXT:    or %s1, 0, %s2
; CHECK-NEXT:    xor %s0, %s0, %s1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = call i32 @llvm.vp.reduce.xor.v256i32(i32 %s, <256 x i32> %v, <256 x i1> %m, i32 %n)
  ret i32 %r
}


