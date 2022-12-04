; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Test that this transform works:
; udiv X, (Select Cond, C1, C2) --> Select Cond, (shr X, C1), (shr X, C2)

define i64 @test(i64 %X, i1 %Cond ) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[QUOTIENT1:%.*]] = lshr i64 [[X:%.*]], 4
; CHECK-NEXT:    [[QUOTIENT2:%.*]] = lshr i64 [[X]], 3
; CHECK-NEXT:    [[SUM:%.*]] = add nuw nsw i64 [[QUOTIENT1]], [[QUOTIENT2]]
; CHECK-NEXT:    ret i64 [[SUM]]
;
  %divisor1 = select i1 %Cond, i64 16, i64 8
  %quotient1 = udiv i64 %X, %divisor1
  %divisor2 = select i1 %Cond, i64 8, i64 0
  %quotient2 = udiv i64 %X, %divisor2
  %sum = add i64 %quotient1, %quotient2
  ret i64 %sum
}

; https://bugs.llvm.org/show_bug.cgi?id=34856
; This would assert/crash because we didn't propagate the condition with the correct vector type.

define <2 x i32> @PR34856(<2 x i32> %t0, <2 x i32> %t1) {
; CHECK-LABEL: @PR34856(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt <2 x i32> [[T1:%.*]], <i32 -8, i32 -8>
; CHECK-NEXT:    [[DIV1:%.*]] = zext <2 x i1> [[TMP1]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[DIV1]]
;
  %cmp = icmp eq <2 x i32> %t0, <i32 1, i32 1>
  %zext = zext <2 x i1> %cmp to <2 x i32>
  %neg = select <2 x i1> %cmp, <2 x i32> zeroinitializer, <2 x i32> <i32 -7, i32 -7>
  %div1 = udiv <2 x i32> %t1, %neg
  %use_cmp_again = add <2 x i32> %div1, %zext
  ret <2 x i32> %use_cmp_again
}

