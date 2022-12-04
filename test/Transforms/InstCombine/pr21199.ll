; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare void @f(i32)

; Do not replace a 'select' with 'or' in 'select - cmp - br' sequence
define void @test(i32 %len) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.umin.i32(i32 [[LEN:%.*]], i32 8)
; CHECK-NEXT:    [[CMP11_NOT:%.*]] = icmp eq i32 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[CMP11_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_02:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    tail call void @f(i32 [[TMP0]])
; CHECK-NEXT:    [[INC]] = add i32 [[I_02]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[INC]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp ult i32 %len, 8
  %cond = select i1 %cmp, i32 %len, i32 8
  %cmp11 = icmp ult i32 0, %cond
  br i1 %cmp11, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.02 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  tail call void @f(i32 %cond)
  %inc = add i32 %i.02, 1
  %cmp1 = icmp ult i32 %inc, %cond
  br i1 %cmp1, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}
