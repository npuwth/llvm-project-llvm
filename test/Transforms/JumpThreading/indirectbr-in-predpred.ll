; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -jump-threading | FileCheck %s

define i1 @test1(i32 %0) #0 {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  PredPredBB1:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[TMP0:%.*]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 32, [[TMP0]]
; CHECK-NEXT:    [[INDIRECT_GOTO_DEST:%.*]] = select i1 [[CMP]], i8* blockaddress(@test1, [[PREDBB1:%.*]]), i8* blockaddress(@test1, [[PREDPREDBB2:%.*]])
; CHECK-NEXT:    indirectbr i8* [[INDIRECT_GOTO_DEST]], [label [[PREDBB1]], label %PredPredBB2]
; CHECK:       PredPredBB2:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i32 [[TMP0]], 1
; CHECK-NEXT:    br i1 [[CMP1]], label [[PREDBB1]], label [[BB2:%.*]]
; CHECK:       PredBB1:
; CHECK-NEXT:    [[NUM:%.*]] = phi i32 [ 0, [[PREDPREDBB1:%.*]] ], [ [[TMP1]], [[PREDPREDBB2]] ]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[TMP1]], 100
; CHECK-NEXT:    br i1 [[CMP2]], label [[BB1:%.*]], label [[BB2]]
; CHECK:       BB1:
; CHECK-NEXT:    [[CMP3:%.*]] = icmp eq i32 [[NUM]], 0
; CHECK-NEXT:    br i1 [[CMP3]], label [[BB2]], label [[BB3:%.*]]
; CHECK:       BB2:
; CHECK-NEXT:    [[TMP2:%.*]] = or i1 [[CMP]], true
; CHECK-NEXT:    ret i1 [[TMP2]]
; CHECK:       BB3:
; CHECK-NEXT:    ret i1 true
;
PredPredBB1:
  %cmp = icmp ne i32 %0, 0
  %1 = add i32 32, %0
  %indirect.goto.dest = select i1 %cmp, i8* blockaddress(@test1, %PredBB1), i8* blockaddress(@test1, %PredPredBB2)
  indirectbr i8* %indirect.goto.dest, [label %PredBB1, label %PredPredBB2]

PredPredBB2:                                      ; preds = %PredPredBB1
  %cmp1 = icmp ne i32 %0, 1
  br i1 %cmp1, label %PredBB1, label %BB2

PredBB1:                                          ; preds = %PredPredBB2, %PredPredBB1
  %num = phi i32 [ 0, %PredPredBB1 ], [ %1, %PredPredBB2 ]
  %cmp2 = icmp eq i32 %1, 100
  br i1 %cmp2, label %BB1, label %BB2

BB1:                                              ; preds = %PredBB1
  %cmp3 = icmp eq i32 %num, 0
  br i1 %cmp3, label %BB2, label %BB3

BB2:                                              ; preds = %BB1, %PredBB1, %PredPredBB2
  %2 = or i1 %cmp, true
  ret i1 %2

BB3:                                              ; preds = %BB1
  ret i1 true
}

attributes #0 = { nounwind }
