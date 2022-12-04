; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -memcpyopt < %s | FileCheck %s

define void @test_copy_uninit([1000 x [1000 x i32]]* %arg) {
; CHECK-LABEL: @test_copy_uninit(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [1000 x i32], align 4
; CHECK-NEXT:    [[ALLOCA_I8:%.*]] = bitcast [1000 x i32]* [[ALLOCA]] to i8*
; CHECK-NEXT:    [[BEGIN:%.*]] = getelementptr inbounds [1000 x [1000 x i32]], [1000 x [1000 x i32]]* [[ARG:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[END:%.*]] = getelementptr inbounds [1000 x [1000 x i32]], [1000 x [1000 x i32]]* [[ARG]], i64 0, i64 1000
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[CURRENT:%.*]] = phi [1000 x i32]* [ [[BEGIN]], [[START:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[CURRENT_I8:%.*]] = bitcast [1000 x i32]* [[CURRENT]] to i8*
; CHECK-NEXT:    [[NEXT]] = getelementptr inbounds [1000 x i32], [1000 x i32]* [[CURRENT]], i64 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq [1000 x i32]* [[NEXT]], [[END]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
start:
  %alloca = alloca [1000 x i32], align 4
  %alloca.i8 = bitcast [1000 x i32]* %alloca to i8*
  %begin = getelementptr inbounds [1000 x [1000 x i32]], [1000 x [1000 x i32]]* %arg, i64 0, i64 0
  %end = getelementptr inbounds [1000 x [1000 x i32]], [1000 x [1000 x i32]]* %arg, i64 0, i64 1000
  br label %loop

loop:                                             ; preds = %loop, %start
  %current = phi [1000 x i32]* [ %begin, %start ], [ %next, %loop ]
  %current.i8 = bitcast [1000 x i32]* %current to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(4000) %current.i8, i8* nonnull align 4 dereferenceable(4000) %alloca.i8, i64 4000, i1 false)
  %next = getelementptr inbounds [1000 x i32], [1000 x i32]* %current, i64 1
  %cond = icmp eq [1000 x i32]* %next, %end
  br i1 %cond, label %exit, label %loop

exit:                                             ; preds = %loop
  ret void
}

define void @test_copy_zero([1000 x [1000 x i32]]* %arg) {
; CHECK-LABEL: @test_copy_zero(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [1000 x i32], align 4
; CHECK-NEXT:    [[ALLOCA_I8:%.*]] = bitcast [1000 x i32]* [[ALLOCA]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(4000) [[ALLOCA_I8]], i8 0, i64 4000, i1 false)
; CHECK-NEXT:    [[BEGIN:%.*]] = getelementptr inbounds [1000 x [1000 x i32]], [1000 x [1000 x i32]]* [[ARG:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[END:%.*]] = getelementptr inbounds [1000 x [1000 x i32]], [1000 x [1000 x i32]]* [[ARG]], i64 0, i64 1000
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[CURRENT:%.*]] = phi [1000 x i32]* [ [[BEGIN]], [[START:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[CURRENT_I8:%.*]] = bitcast [1000 x i32]* [[CURRENT]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[CURRENT_I8]], i8 0, i64 4000, i1 false)
; CHECK-NEXT:    [[NEXT]] = getelementptr inbounds [1000 x i32], [1000 x i32]* [[CURRENT]], i64 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq [1000 x i32]* [[NEXT]], [[END]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
start:
  %alloca = alloca [1000 x i32], align 4
  %alloca.i8 = bitcast [1000 x i32]* %alloca to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(4000) %alloca.i8, i8 0, i64 4000, i1 false)
  %begin = getelementptr inbounds [1000 x [1000 x i32]], [1000 x [1000 x i32]]* %arg, i64 0, i64 0
  %end = getelementptr inbounds [1000 x [1000 x i32]], [1000 x [1000 x i32]]* %arg, i64 0, i64 1000
  br label %loop

loop:                                             ; preds = %loop, %start
  %current = phi [1000 x i32]* [ %begin, %start ], [ %next, %loop ]
  %current.i8 = bitcast [1000 x i32]* %current to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(4000) %current.i8, i8* nonnull align 4 dereferenceable(4000) %alloca.i8, i64 4000, i1 false)
  %next = getelementptr inbounds [1000 x i32], [1000 x i32]* %current, i64 1
  %cond = icmp eq [1000 x i32]* %next, %end
  br i1 %cond, label %exit, label %loop

exit:                                             ; preds = %loop
  ret void
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)