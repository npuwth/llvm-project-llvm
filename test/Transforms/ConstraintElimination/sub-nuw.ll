; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

define void @test.not.uge.ult(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ult(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB_PTR_I:%.*]] = sub nuw i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[SUB_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[T_0:%.*]] = icmp ult i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_0]])
; CHECK-NEXT:    [[START_1:%.*]] = sub nuw i8 [[START]], 1
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[START_2:%.*]] = sub nuw i8 [[START]], 2
; CHECK-NEXT:    [[T_2:%.*]] = icmp ult i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[START_3:%.*]] = sub nuw i8 [[START]], 3
; CHECK-NEXT:    [[T_3:%.*]] = icmp ult i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_4:%.*]] = sub nuw i8 [[START]], 4
; CHECK-NEXT:    [[C_4:%.*]] = icmp ult i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
;
entry:
  %sub.ptr.i = sub nuw i8 %start, 3
  %c.1 = icmp uge i8 %sub.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %t.0 = icmp ult i8 %start, %high
  call void @use(i1 %t.0)
  %start.1 = sub nuw i8 %start, 1
  %t.1 = icmp ult i8 %start.1, %high
  call void @use(i1 %t.1)
  %start.2 = sub nuw i8 %start, 2
  %t.2 = icmp ult i8 %start.2, %high
  call void @use(i1 %t.2)
  %start.3 = sub nuw i8 %start, 3
  %t.3 = icmp ult i8 %start.3, %high
  call void @use(i1 %t.3)
  %start.4 = sub nuw i8 %start, 4
  %c.4 = icmp ult i8 %start.4, %high
  call void @use(i1 %c.4)
  ret void
}

define void @test.not.uge.ule(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ule(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB_PTR_I:%.*]] = sub nuw i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[SUB_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[T_0:%.*]] = icmp ule i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_0]])
; CHECK-NEXT:    [[START_1:%.*]] = sub nuw i8 [[START]], 1
; CHECK-NEXT:    [[T_1:%.*]] = icmp ule i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[START_2:%.*]] = sub nuw i8 [[START]], 2
; CHECK-NEXT:    [[T_2:%.*]] = icmp ule i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_3:%.*]] = sub nuw i8 [[START]], 3
; CHECK-NEXT:    [[T_3:%.*]] = icmp ule i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_4:%.*]] = sub nuw i8 [[START]], 4
; CHECK-NEXT:    [[T_4:%.*]] = icmp ule i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_5:%.*]] = sub nuw i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp ule i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
;
entry:
  %sub.ptr.i = sub nuw i8 %start, 3
  %c.1 = icmp uge i8 %sub.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %t.0 = icmp ule i8 %start, %high
  call void @use(i1 %t.0)
  %start.1 = sub nuw i8 %start, 1
  %t.1 = icmp ule i8 %start.1, %high
  call void @use(i1 %t.1)
  %start.2 = sub nuw i8 %start, 2
  %t.2 = icmp ule i8 %start.2, %high
  call void @use(i1 %t.2)
  %start.3 = sub nuw i8 %start, 3
  %t.3 = icmp ule i8 %start.3, %high
  call void @use(i1 %t.3)
  %start.4 = sub nuw i8 %start, 4
  %t.4 = icmp ule i8 %start.4, %high
  call void @use(i1 %t.4)

  %start.5 = sub nuw i8 %start, 5
  %c.5 = icmp ule i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}

define void @test.not.uge.ugt(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ugt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB_PTR_I:%.*]] = sub nuw i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[SUB_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[F_0:%.*]] = icmp ugt i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_0]])
; CHECK-NEXT:    [[START_1:%.*]] = sub nuw i8 [[START]], 1
; CHECK-NEXT:    [[F_1:%.*]] = icmp ugt i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[START_2:%.*]] = sub nuw i8 [[START]], 2
; CHECK-NEXT:    [[F_2:%.*]] = icmp ugt i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_3:%.*]] = sub nuw i8 [[START]], 3
; CHECK-NEXT:    [[F_3:%.*]] = icmp ugt i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_4:%.*]] = sub nuw i8 [[START]], 4
; CHECK-NEXT:    [[F_4:%.*]] = icmp ugt i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_5:%.*]] = sub nuw i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp ugt i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    ret void
;
entry:
  %sub.ptr.i = sub nuw i8 %start, 3
  %c.1 = icmp uge i8 %sub.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %f.0 = icmp ugt i8 %start, %high
  call void @use(i1 %f.0)

  %start.1 = sub nuw i8 %start, 1
  %f.1 = icmp ugt i8 %start.1, %high
  call void @use(i1 %f.1)

  %start.2 = sub nuw i8 %start, 2
  %f.2 = icmp ugt i8 %start.2, %high
  call void @use(i1 %f.2)

  %start.3 = sub nuw i8 %start, 3
  %f.3 = icmp ugt i8 %start.3, %high
  call void @use(i1 %f.3)

  %start.4 = sub nuw i8 %start, 4
  %f.4 = icmp ugt i8 %start.4, %high
  call void @use(i1 %f.4)

  %start.5 = sub nuw i8 %start, 5
  %c.5 = icmp ugt i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}

define void @test.not.uge.uge(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.uge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB_PTR_I:%.*]] = sub nuw i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[SUB_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[F_0:%.*]] = icmp ugt i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_0]])
; CHECK-NEXT:    [[START_1:%.*]] = sub nuw i8 [[START]], 1
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[START_2:%.*]] = sub nuw i8 [[START]], 2
; CHECK-NEXT:    [[F_2:%.*]] = icmp uge i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_2]])
; CHECK-NEXT:    [[START_3:%.*]] = sub nuw i8 [[START]], 3
; CHECK-NEXT:    [[F_3:%.*]] = icmp uge i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_4:%.*]] = sub nuw i8 [[START]], 4
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_5:%.*]] = sub nuw i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    ret void
;
entry:
  %sub.ptr.i = sub nuw i8 %start, 3
  %c.1 = icmp uge i8 %sub.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %f.0 = icmp ugt i8 %start, %high
  call void @use(i1 %f.0)

  %start.1 = sub nuw i8 %start, 1
  %f.1 = icmp uge i8 %start.1, %high
  call void @use(i1 %f.1)

  %start.2 = sub nuw i8 %start, 2
  %f.2 = icmp uge i8 %start.2, %high
  call void @use(i1 %f.2)

  %start.3 = sub nuw i8 %start, 3
  %f.3 = icmp uge i8 %start.3, %high
  call void @use(i1 %f.3)

  %start.4 = sub nuw i8 %start, 4
  %c.4 = icmp uge i8 %start.4, %high
  call void @use(i1 %c.4)

  %start.5 = sub nuw i8 %start, 5
  %c.5 = icmp uge i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}

define i16 @test_pr53123_sub_constraint_sign(i16 %v) {
; CHECK-LABEL: @test_pr53123_sub_constraint_sign(
; CHECK-NEXT:  bb.0:
; CHECK-NEXT:    [[SUB:%.*]] = sub nuw nsw i16 32767, [[V:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i16 [[V]], [[SUB]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[BB_2:%.*]], label [[BB_1:%.*]]
; CHECK:       bb.1:
; CHECK-NEXT:    [[ADD:%.*]] = shl nuw nsw i16 [[V]], 1
; CHECK-NEXT:    [[SUB9:%.*]] = sub nuw nsw i16 32767, [[ADD]]
; CHECK-NEXT:    [[CMP11:%.*]] = icmp ugt i16 [[ADD]], [[SUB9]]
; CHECK-NEXT:    br i1 [[CMP11]], label [[BB_3:%.*]], label [[BB_2]]
; CHECK:       bb.2:
; CHECK-NEXT:    ret i16 1
; CHECK:       bb.3:
; CHECK-NEXT:    ret i16 0
;
bb.0:
  %sub = sub nuw nsw i16 32767, %v
  %cmp1 = icmp ugt i16 %v, %sub
  br i1 %cmp1, label %bb.2, label %bb.1

bb.1:
  %add = shl nuw nsw i16 %v, 1
  %sub9 = sub nuw nsw i16 32767, %add
  %cmp11 = icmp ugt i16 %add, %sub9
  br i1 %cmp11, label %bb.3, label %bb.2

bb.2:
  ret i16 1

bb.3:
  ret i16 0
}

declare void @use(i1)

define i1 @sub_nuw_i16_simp(i16 %a) {
; CHECK-LABEL: @sub_nuw_i16_simp(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NEG2:%.*]] = sub nuw i16 [[A:%.*]], 305
; CHECK-NEXT:    [[C_1:%.*]] = icmp ugt i16 0, [[NEG2]]
; CHECK-NEXT:    br i1 [[C_1]], label [[EXIT_1:%.*]], label [[EXIT_2:%.*]]
; CHECK:       exit.1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i16 [[A]], 0
; CHECK-NEXT:    ret i1 [[C_2]]
; CHECK:       exit.2:
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i16 [[A]], 0
; CHECK-NEXT:    ret i1 true
;
entry:
  %neg2 = sub nuw i16 %a, 305
  %c.1 = icmp ugt i16 0, %neg2
  br i1 %c.1, label %exit.1, label %exit.2

exit.1:
  %c.2 = icmp ugt i16 %a, 0
  ret i1 %c.2

exit.2:
  %c.3 = icmp ugt i16 %a, 0
  ret i1 %c.3
}

define i1 @sub_nuw_i64_simp(i64 %a) {
; CHECK-LABEL: @sub_nuw_i64_simp(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NEG2:%.*]] = sub nuw i64 [[A:%.*]], 305
; CHECK-NEXT:    [[C_1:%.*]] = icmp ugt i64 0, [[NEG2]]
; CHECK-NEXT:    br i1 [[C_1]], label [[EXIT_1:%.*]], label [[EXIT_2:%.*]]
; CHECK:       exit.1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i64 [[A]], 0
; CHECK-NEXT:    ret i1 [[C_2]]
; CHECK:       exit.2:
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i64 [[A]], 0
; CHECK-NEXT:    ret i1 true
;
entry:
  %neg2 = sub nuw i64 %a, 305
  %c.1 = icmp ugt i64 0, %neg2
  br i1 %c.1, label %exit.1, label %exit.2

exit.1:
  %c.2 = icmp ugt i64 %a, 0
  ret i1 %c.2

exit.2:
  %c.3 = icmp ugt i64 %a, 0
  ret i1 %c.3
}

define i1 @sub_nuw_neg_i16(i16 %a) {
; CHECK-LABEL: @sub_nuw_neg_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NEG2:%.*]] = sub nuw i16 [[A:%.*]], -305
; CHECK-NEXT:    [[C_1:%.*]] = icmp ugt i16 0, [[NEG2]]
; CHECK-NEXT:    br i1 [[C_1]], label [[EXIT_1:%.*]], label [[EXIT_2:%.*]]
; CHECK:       exit.1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i16 [[A]], 0
; CHECK-NEXT:    ret i1 false
; CHECK:       exit.2:
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i16 [[A]], 0
; CHECK-NEXT:    ret i1 [[C_3]]
;
entry:
  %neg2 = sub nuw i16 %a, -305
  %c.1 = icmp ugt i16 0, %neg2
  br i1 %c.1, label %exit.1, label %exit.2

exit.1:
  %c.2 = icmp ugt i16 %a, 0
  ret i1 %c.2

exit.2:
  %c.3 = icmp ugt i16 %a, 0
  ret i1 %c.3
}

declare void @llvm.assume(i1)

define i1 @wrapping_offset_sum(i64 %x) {
; CHECK-LABEL: @wrapping_offset_sum(
; CHECK-NEXT:    [[NON_ZERO:%.*]] = icmp ugt i64 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[NON_ZERO]])
; CHECK-NEXT:    [[ADD:%.*]] = sub nuw i64 [[X]], 9223372036854775802
; CHECK-NEXT:    [[ULT:%.*]] = icmp ugt i64 200, [[ADD]]
; CHECK-NEXT:    ret i1 [[ULT]]
;
  %non.zero = icmp ugt i64 %x, 0
  call void @llvm.assume(i1 %non.zero)
  %add = sub nuw i64 %x, 9223372036854775802
  %ult = icmp ugt i64 200, %add
  ret i1 %ult
}
