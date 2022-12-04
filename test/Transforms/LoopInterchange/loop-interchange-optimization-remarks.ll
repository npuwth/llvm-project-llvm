; Test optimization remarks generated by the LoopInterchange pass.
;
; RUN: opt < %s -basic-aa -loop-interchange -cache-line-size=64 -verify-dom-info -verify-loop-info \
; RUN:     -pass-remarks-output=%t -pass-remarks-missed='loop-interchange' \
; RUN:     -pass-remarks='loop-interchange' -S
; RUN: cat %t |  FileCheck %s

; RUN: opt < %s -basic-aa -loop-interchange -cache-line-size=64 -verify-dom-info -verify-loop-info \
; RUN:     -pass-remarks-output=%t -pass-remarks-missed='loop-interchange' \
; RUN:     -pass-remarks='loop-interchange' -S -da-disable-delinearization-checks
; RUN: cat %t |  FileCheck --check-prefix=DELIN %s

@A = common global [100 x [100 x i32]] zeroinitializer
@B = common global [100 x [100 x i32]] zeroinitializer
@C = common global [100 x i32] zeroinitializer

;;---------------------------------------Test case 01---------------------------------
;; Loops interchange is not profitable.
;;   for(int i=1;i<N;i++)
;;     for(int j=1;j<N;j++)
;;       A[i-1][j-1] = A[i - 1][j-1] + B[i][j];

define void @test01(i32 %N){
entry:
  %cmp31 = icmp sgt i32 %N, 1
  br i1 %cmp31, label %for.cond1.preheader.lr.ph, label %for.end19

for.cond1.preheader.lr.ph:
  %0 = add i32 %N, -1
  br label %for.body3.lr.ph

for.body3.lr.ph:
  %indvars.iv34 = phi i64 [ 1, %for.cond1.preheader.lr.ph ], [ %indvars.iv.next35, %for.inc17 ]
  %1 = add nsw i64 %indvars.iv34, -1
  br label %for.body3

for.body3:
  %indvars.iv = phi i64 [ 1, %for.body3.lr.ph ], [ %indvars.iv.next, %for.body3 ]
  %2 = add nsw i64 %indvars.iv, -1
  %arrayidx6 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @A, i64 0, i64 %1, i64 %2
  %3 = load i32, i32* %arrayidx6
  %arrayidx10 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @B, i64 0, i64 %indvars.iv34, i64 %indvars.iv
  %4 = load i32, i32* %arrayidx10
  %add = add nsw i32 %4, %3
  store i32 %add, i32* %arrayidx6
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv to i32
  %exitcond = icmp eq i32 %lftr.wideiv, %0
  br i1 %exitcond, label %for.inc17, label %for.body3

for.inc17:
  %indvars.iv.next35 = add nuw nsw i64 %indvars.iv34, 1
  %lftr.wideiv37 = trunc i64 %indvars.iv34 to i32
  %exitcond38 = icmp eq i32 %lftr.wideiv37, %0
  br i1 %exitcond38, label %for.end19, label %for.body3.lr.ph

for.end19:
  ret void
}

; CHECK: --- !Missed
; CHECK-NEXT: Pass:            loop-interchange
; CHECK-NEXT: Name:            Dependence
; CHECK-NEXT: Function:        test01
; CHECK-NEXT: Args:
; CHECK-NEXT:   - String:          Cannot interchange loops due to dependences.
; CHECK-NEXT: ...

; DELIN: --- !Missed
; DELIN-NEXT: Pass:            loop-interchange
; DELIN-NEXT: Name:            InterchangeNotProfitable
; DELIN-NEXT: Function:        test01
; DELIN-NEXT: Args:
; DELIN-NEXT:   - String:          Interchanging loops is too costly and it does not improve parallelism.
; DELIN-NEXT: ...

;;--------------------------------------Test case 02------------------------------------
;; [FIXME] This loop though valid is currently not interchanged due to the
;; limitation that we cannot split the inner loop latch due to multiple use of inner induction
;; variable.(used to increment the loop counter and to access A[j+1][i+1]
;;  for(int i=0;i<N-1;i++)
;;    for(int j=1;j<N-1;j++)
;;      A[j+1][i+1] = A[j+1][i+1] + k;

define void @test02(i32 %k, i32 %N) {
 entry:
   %sub = add nsw i32 %N, -1
   %cmp26 = icmp sgt i32 %N, 1
   br i1 %cmp26, label %for.cond1.preheader.lr.ph, label %for.end17

 for.cond1.preheader.lr.ph:
   %cmp324 = icmp sgt i32 %sub, 1
   %0 = add i32 %N, -2
   %1 = sext i32 %sub to i64
   br label %for.cond1.preheader

 for.cond.loopexit:
   %cmp = icmp slt i64 %indvars.iv.next29, %1
   br i1 %cmp, label %for.cond1.preheader, label %for.end17

 for.cond1.preheader:
   %indvars.iv28 = phi i64 [ 0, %for.cond1.preheader.lr.ph ], [ %indvars.iv.next29, %for.cond.loopexit ]
   %indvars.iv.next29 = add nuw nsw i64 %indvars.iv28, 1
   br i1 %cmp324, label %for.body4, label %for.cond.loopexit

 for.body4:
   %indvars.iv = phi i64 [ %indvars.iv.next, %for.body4 ], [ 1, %for.cond1.preheader ]
   %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
   %arrayidx7 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @A, i64 0, i64 %indvars.iv.next, i64 %indvars.iv.next29
   %2 = load i32, i32* %arrayidx7
   %add8 = add nsw i32 %2, %k
   store i32 %add8, i32* %arrayidx7
   %lftr.wideiv = trunc i64 %indvars.iv to i32
   %exitcond = icmp eq i32 %lftr.wideiv, %0
   br i1 %exitcond, label %for.cond.loopexit, label %for.body4

 for.end17:
   ret void
}

; CHECK: --- !Missed
; CHECK-NEXT: Pass:            loop-interchange
; CHECK-NEXT: Name:            Dependence
; CHECK-NEXT: Function:        test02
; CHECK-NEXT: Args:
; CHECK-NEXT:   - String:          Cannot interchange loops due to dependences.
; CHECK-NEXT: ...

; DELIN: --- !Passed
; DELIN-NEXT: Pass:            loop-interchange
; DELIN-NEXT: Name:            Interchanged
; DELIN-NEXT: Function:        test02
; DELIN-NEXT: Args:
; DELIN-NEXT:   - String:           Loop interchanged with enclosing loop.
; DELIN-NEXT: ...

;;-----------------------------------Test case 03-------------------------------
;; Test to make sure we can handle output dependencies.
;;
;;  for (int i = 0; i < 2; ++i)
;;    for(int j = 0; j < 3; ++j) {
;;      A[j][i] = i;
;;      A[j][i+1] = j;
;;    }

@A10 = local_unnamed_addr global [3 x [3 x i32]] zeroinitializer, align 16

define void @test03() {
entry:
  br label %for.cond1.preheader

for.cond.loopexit:                                ; preds = %for.body4
  %exitcond28 = icmp ne i64 %indvars.iv.next27, 2
  br i1 %exitcond28, label %for.cond1.preheader, label %for.cond.cleanup

for.cond1.preheader:                              ; preds = %for.cond.loopexit, %entry
  %indvars.iv26 = phi i64 [ 0, %entry ], [ %indvars.iv.next27, %for.cond.loopexit ]
  %indvars.iv.next27 = add nuw nsw i64 %indvars.iv26, 1
  br label %for.body4

for.cond.cleanup:                                 ; preds = %for.cond.loopexit
  ret void

for.body4:                                        ; preds = %for.body4, %for.cond1.preheader
  %indvars.iv = phi i64 [ 0, %for.cond1.preheader ], [ %indvars.iv.next, %for.body4 ]
  %arrayidx6 = getelementptr inbounds [3 x [3 x i32]], [3 x [3 x i32]]* @A10, i64 0, i64 %indvars.iv, i64 %indvars.iv26
  %tmp = trunc i64 %indvars.iv26 to i32
  store i32 %tmp, i32* %arrayidx6, align 4
  %arrayidx10 = getelementptr inbounds [3 x [3 x i32]], [3 x [3 x i32]]* @A10, i64 0, i64 %indvars.iv, i64 %indvars.iv.next27
  %tmp1 = trunc i64 %indvars.iv to i32
  store i32 %tmp1, i32* %arrayidx10, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, 3
  br i1 %exitcond, label %for.body4, label %for.cond.loopexit
}

; CHECK: --- !Passed
; CHECK-NEXT: Pass:            loop-interchange
; CHECK-NEXT: Name:            Interchanged
; CHECK-NEXT: Function:        test03
; CHECK-NEXT: Args:
; CHECK-NEXT:   - String:          Loop interchanged with enclosing loop.
; CHECK-NEXT: ...

; DELIN: --- !Passed
; DELIN-NEXT: Pass:            loop-interchange
; DELIN-NEXT: Name:            Interchanged
; DELIN-NEXT: Function:        test03
; DELIN-NEXT: Args:
; DELIN-NEXT:  - String:          Loop interchanged with enclosing loop.
; DELIN-NEXT: ...

;;--------------------------------------Test case 04-------------------------------------
;; Loops not tightly nested are not interchanged
;;  for(int j=0;j<N;j++) {
;;    B[j] = j+k;
;;    for(int i=0;i<N;i++)
;;      A[j][i] = A[j][i]+B[j];
;;  }

define void @test04(i32 %k, i32 %N){
entry:
  %cmp30 = icmp sgt i32 %N, 0
  br i1 %cmp30, label %for.body.lr.ph, label %for.end17

for.body.lr.ph:
  %0 = add i32 %N, -1
  %1 = zext i32 %k to i64
  br label %for.body

for.body:
  %indvars.iv32 = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next33, %for.inc15 ]
  %2 = add nsw i64 %indvars.iv32, %1
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @C, i64 0, i64 %indvars.iv32
  %3 = trunc i64 %2 to i32
  store i32 %3, i32* %arrayidx
  br label %for.body3

for.body3:
  %indvars.iv = phi i64 [ 0, %for.body ], [ %indvars.iv.next, %for.body3 ]
  %arrayidx7 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @A, i64 0, i64 %indvars.iv32, i64 %indvars.iv
  %4 = load i32, i32* %arrayidx7
  %add10 = add nsw i32 %3, %4
  store i32 %add10, i32* %arrayidx7
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv to i32
  %exitcond = icmp eq i32 %lftr.wideiv, %0
  br i1 %exitcond, label %for.inc15, label %for.body3

for.inc15:
  %indvars.iv.next33 = add nuw nsw i64 %indvars.iv32, 1
  %lftr.wideiv35 = trunc i64 %indvars.iv32 to i32
  %exitcond36 = icmp eq i32 %lftr.wideiv35, %0
  br i1 %exitcond36, label %for.end17, label %for.body

for.end17:
  ret void
}

; CHECK: --- !Missed
; CHECK-NEXT: Pass:            loop-interchange
; CHECK-NEXT: Name:            Dependence
; CHECK-NEXT: Function:        test04
; CHECK-NEXT: Args:
; CHECK-NEXT:   - String:          Cannot interchange loops due to dependences.
; CHECK-NEXT: ...

; DELIN: --- !Missed
; DELIN-NEXT: Pass:            loop-interchange
; DELIN-NEXT: Name:            NotTightlyNested
; DELIN-NEXT: Function:        test04
; DELIN-NEXT: Args:
; DELIN-NEXT:  - String:          Cannot interchange loops because they are not tightly nested.
; DELIN-NEXT: ...
