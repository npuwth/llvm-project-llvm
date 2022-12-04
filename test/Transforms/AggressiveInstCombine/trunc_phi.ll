; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -aggressive-instcombine -S | FileCheck %s

define i16 @trunc_phi(i8 %x) {
; CHECK-LABEL: @trunc_phi(
; CHECK-NEXT:  LoopHeader:
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[X:%.*]] to i16
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[ZEXT2:%.*]] = phi i16 [ [[ZEXT]], [[LOOPHEADER:%.*]] ], [ [[SHL:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[LOOPHEADER]] ], [ [[I:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[SHL]] = shl i16 [[ZEXT2]], 1
; CHECK-NEXT:    [[I]] = add i32 [[J]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[I]], 10
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOPEND:%.*]], label [[LOOP]]
; CHECK:       LoopEnd:
; CHECK-NEXT:    ret i16 [[SHL]]
;
LoopHeader:
  %zext = zext i8 %x to i32
  br label %Loop

Loop:
  %zext2 = phi i32 [%zext, %LoopHeader], [%shl, %Loop]
  %j = phi i32 [0, %LoopHeader], [%i, %Loop]
  %shl = shl i32 %zext2, 1
  %trunc = trunc i32 %shl to i16
  %i = add i32 %j, 1
  %cmp = icmp eq i32 %i, 10
  br i1 %cmp, label %LoopEnd, label %Loop

LoopEnd:
  ret i16 %trunc
}

define i16 @trunc_phi2(i8 %x, i32 %sw) {
; CHECK-LABEL: @trunc_phi2(
; CHECK-NEXT:  LoopHeader:
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[X:%.*]] to i16
; CHECK-NEXT:    switch i32 [[SW:%.*]], label [[LOOPEND:%.*]] [
; CHECK-NEXT:    i32 0, label [[LOOP:%.*]]
; CHECK-NEXT:    i32 1, label [[LOOP]]
; CHECK-NEXT:    ]
; CHECK:       Loop:
; CHECK-NEXT:    [[ZEXT2:%.*]] = phi i16 [ [[ZEXT]], [[LOOPHEADER:%.*]] ], [ [[ZEXT]], [[LOOPHEADER]] ], [ [[SHL:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[LOOPHEADER]] ], [ 0, [[LOOPHEADER]] ], [ [[I:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[SHL]] = shl i16 [[ZEXT2]], 1
; CHECK-NEXT:    [[I]] = add i32 [[J]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[I]], 10
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOPEND]], label [[LOOP]]
; CHECK:       LoopEnd:
; CHECK-NEXT:    [[ZEXT3:%.*]] = phi i16 [ [[ZEXT]], [[LOOPHEADER]] ], [ [[ZEXT2]], [[LOOP]] ]
; CHECK-NEXT:    ret i16 [[ZEXT3]]
;
LoopHeader:
  %zext = zext i8 %x to i32
  switch i32 %sw, label %LoopEnd [ i32 0, label %Loop
  i32 1, label %Loop ]

Loop:
  %zext2 = phi i32 [%zext, %LoopHeader], [%zext, %LoopHeader], [%shl, %Loop]
  %j = phi i32 [0, %LoopHeader], [0, %LoopHeader], [%i, %Loop]
  %shl = shl i32 %zext2, 1
  %i = add i32 %j, 1
  %cmp = icmp eq i32 %i, 10
  br i1 %cmp, label %LoopEnd, label %Loop

LoopEnd:
  %zext3 = phi i32 [%zext, %LoopHeader], [%zext2, %Loop]
  %trunc = trunc i32 %zext3 to i16
  ret i16 %trunc
}
