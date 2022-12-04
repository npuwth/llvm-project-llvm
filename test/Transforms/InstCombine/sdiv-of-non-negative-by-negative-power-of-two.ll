; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Fold
;   x s/ (-1 << y)
; to
;   -(x >> y)
; iff x is known non-negative.

declare void @llvm.assume(i1)

define i8 @t0(i8 %x, i8 %y) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[X_IS_NONNEGATIVE:%.*]] = icmp sgt i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @llvm.assume(i1 [[X_IS_NONNEGATIVE]])
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i8 [[X]], 5
; CHECK-NEXT:    [[DIV:%.*]] = sub nsw i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[DIV]]
;
  %x_is_nonnegative = icmp sge i8 %x, 0
  call void @llvm.assume(i1 %x_is_nonnegative)
  %div = sdiv i8 %x, -32
  ret i8 %div
}
define i8 @n1(i8 %x, i8 %y) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[X_IS_NONNEGATIVE:%.*]] = icmp sgt i8 [[X:%.*]], -2
; CHECK-NEXT:    call void @llvm.assume(i1 [[X_IS_NONNEGATIVE]])
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i8 [[X]], -32
; CHECK-NEXT:    ret i8 [[DIV]]
;
  %x_is_nonnegative = icmp sge i8 %x, -1 ; could be negative
  call void @llvm.assume(i1 %x_is_nonnegative)
  %div = sdiv i8 %x, -32
  ret i8 %div
}
define i8 @n2(i8 %x, i8 %y) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[X_IS_NONNEGATIVE:%.*]] = icmp sgt i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @llvm.assume(i1 [[X_IS_NONNEGATIVE]])
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i8 [[X]], -31
; CHECK-NEXT:    ret i8 [[DIV]]
;
  %x_is_nonnegative = icmp sge i8 %x, 0
  call void @llvm.assume(i1 %x_is_nonnegative)
  %div = sdiv i8 %x, -31 ; not a negative power of two
  ret i8 %div
}
