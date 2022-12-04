; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

@hello = private constant [11 x i8] c"helloworld\00", align 1
@NoNulTerminator = private constant [10 x i8] c"helloworld", align 1
@StopCharAfterNulTerminator = private constant [12 x i8] c"helloworld\00x", align 1
@StringWithEOF =  constant [14 x i8] c"helloworld\FFab\00", align 1

declare i8* @memccpy(i8*, i8*, i32, i64)

define i8* @memccpy_to_memcpy(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[DST:%.*]] to i64*
; CHECK-NEXT:    store i64 8245940763182785896, i64* [[TMP1]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8* [[DST]], i64 8
; CHECK-NEXT:    ret i8* [[TMP2]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 12) ; 114 is 'r'
  ret i8* %call
}

define i8* @memccpy_to_memcpy2(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy2(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[DST:%.*]] to i64*
; CHECK-NEXT:    store i64 8245940763182785896, i64* [[TMP1]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8* [[DST]], i64 8
; CHECK-NEXT:    ret i8* [[TMP2]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 8); ; 114 is 'r'
  ret i8* %call
}

define void @memccpy_to_memcpy3(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy3(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(5) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(5) getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i64 5, i1 false)
; CHECK-NEXT:    ret void
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 111, i64 10) ; 111 is 'o'
  ret void
}

define void @memccpy_to_memcpy3_tail(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy3_tail(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(5) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(5) getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i64 5, i1 false)
; CHECK-NEXT:    ret void
;
  %call = tail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 111, i64 10) ; 111 is 'o'
  ret void
}

define i8* @memccpy_to_memcpy3_musttail(i8* %dst, i8* %x, i32 %y, i64 %z) {
; CHECK-LABEL: @memccpy_to_memcpy3_musttail(
; CHECK-NEXT:    %call = musttail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 111, i64 10)
; CHECK-NEXT:    ret i8* %call
;
  %call = musttail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 111, i64 10) ; 111 is 'o'
  ret i8* %call
}


define void @memccpy_to_memcpy4(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy4(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(11) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(11) getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i64 11, i1 false)
; CHECK-NEXT:    ret void
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 0, i64 12)
  ret void
}

define i8* @memccpy_to_memcpy5(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy5(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(7) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(7) getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i64 7, i1 false)
; CHECK-NEXT:    ret i8* null
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 7)
  ret i8* %call
}

define i8* @memccpy_to_memcpy5_tail(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy5_tail(
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(7) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(7) getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i64 7, i1 false)
; CHECK-NEXT:    ret i8* null
;
  %call = tail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 7)
  ret i8* %call
}

define i8* @memccpy_to_memcpy5_musttail(i8* %dst, i8* %x, i32 %y, i64 %z) {
; CHECK-LABEL: @memccpy_to_memcpy5_musttail(
; CHECK-NEXT:    %call = musttail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 7)
; CHECK-NEXT:    ret i8* %call
;
  %call = musttail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 7)
  ret i8* %call
}

define i8* @memccpy_to_memcpy6(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy6(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(6) getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i64 6, i1 false)
; CHECK-NEXT:    ret i8* null
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 6);
  ret i8* %call
}

define i8* @memccpy_to_memcpy7(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy7(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(5) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(5) getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i64 5, i1 false)
; CHECK-NEXT:    ret i8* null
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 115, i64 5) ; 115 is 's'
  ret i8* %call
}

define i8* @memccpy_to_memcpy8(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy8(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(11) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(11) getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i64 11, i1 false)
; CHECK-NEXT:    ret i8* null
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 115, i64 11) ; 115 is 's'
  ret i8* %call
}

define i8* @memccpy_to_memcpy9(i8* %dst, i64 %n) {
; CHECK-LABEL: @memccpy_to_memcpy9(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(12) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(12) getelementptr inbounds ([12 x i8], [12 x i8]* @StopCharAfterNulTerminator, i64 0, i64 0), i64 12, i1 false)
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[DST]], i64 12
; CHECK-NEXT:    ret i8* [[TMP1]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @StopCharAfterNulTerminator, i64 0, i64 0), i32 120, i64 15) ; 120 is 'x'
  ret i8* %call
}

define i8* @memccpy_to_memcpy10(i8* %dst, i64 %n) {
; CHECK-LABEL: @memccpy_to_memcpy10(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(11) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(11) getelementptr inbounds ([14 x i8], [14 x i8]* @StringWithEOF, i64 0, i64 0), i64 11, i1 false)
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[DST]], i64 11
; CHECK-NEXT:    ret i8* [[TMP1]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @StringWithEOF, i64 0, i64 0), i32 255, i64 15)
  ret i8* %call
}

define i8* @memccpy_to_memcpy11(i8* %dst, i64 %n) {
; CHECK-LABEL: @memccpy_to_memcpy11(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(11) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(11) getelementptr inbounds ([14 x i8], [14 x i8]* @StringWithEOF, i64 0, i64 0), i64 11, i1 false)
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[DST]], i64 11
; CHECK-NEXT:    ret i8* [[TMP1]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @StringWithEOF, i64 0, i64 0), i32 -1, i64 15)
  ret i8* %call
}

define i8* @memccpy_to_memcpy12(i8* %dst, i64 %n) {
; CHECK-LABEL: @memccpy_to_memcpy12(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(11) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(11) getelementptr inbounds ([14 x i8], [14 x i8]* @StringWithEOF, i64 0, i64 0), i64 11, i1 false)
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[DST]], i64 11
; CHECK-NEXT:    ret i8* [[TMP1]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @StringWithEOF, i64 0, i64 0), i32 1023, i64 15)
  ret i8* %call
}

define i8* @memccpy_to_null(i8* %dst, i8* %src, i32 %c) {
; CHECK-LABEL: @memccpy_to_null(
; CHECK-NEXT:    ret i8* null
;
  %call = call i8* @memccpy(i8* %dst, i8* %src, i32 %c, i64 0)
  ret i8* %call
}

define void @memccpy_dst_src_same_retval_unused(i8* %dst, i32 %c, i64 %n) {
; CHECK-LABEL: @memccpy_dst_src_same_retval_unused(
; CHECK-NEXT:    ret void
;
  %call = call i8* @memccpy(i8* %dst, i8* %dst, i32 %c, i64 %n)
  ret void
}

; Negative tests
define i8* @unknown_src(i8* %dst, i8* %src) {
; CHECK-LABEL: @unknown_src(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* [[SRC:%.*]], i32 114, i64 12)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* %src, i32 114, i64 12)
  ret i8* %call
}

define i8* @unknown_stop_char(i8* %dst, i32 %c) {
; CHECK-LABEL: @unknown_stop_char(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 [[C:%.*]], i64 12)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 %c, i64 12)
  ret i8* %call
}

define i8* @unknown_size_n(i8* %dst, i64 %n) {
; CHECK-LABEL: @unknown_size_n(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 %n)
  ret i8* %call
}

define i8* @no_nul_terminator(i8* %dst, i64 %n) {
; CHECK-LABEL: @no_nul_terminator(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([12 x i8], [12 x i8]* @StopCharAfterNulTerminator, i64 0, i64 0), i32 120, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @StopCharAfterNulTerminator, i64 0, i64 0), i32 120, i64 %n) ; 120 is 'x'
  ret i8* %call
}

define i8* @possibly_valid_data_after_array(i8* %dst, i64 %n) {
; CHECK-LABEL: @possibly_valid_data_after_array(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([10 x i8], [10 x i8]* @NoNulTerminator, i64 0, i64 0), i32 115, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @NoNulTerminator, i64 0, i64 0), i32 115, i64 %n) ; 115 is 's'
  ret i8* %call
}

define i8* @possibly_valid_data_after_array2(i8* %dst, i64 %n) {
; CHECK-LABEL: @possibly_valid_data_after_array2(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 115, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 115, i64 %n) ; 115 is 's'
  ret i8* %call
}

define i8* @possibly_valid_data_after_array3(i8* %dst) {
; CHECK-LABEL: @possibly_valid_data_after_array3(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 115, i64 12)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 115, i64 12) ; 115 is 's'
  ret i8* %call
}

define i8* @memccpy_dst_src_same_retval_used(i8* %dst, i32 %c, i64 %n) {
; CHECK-LABEL: @memccpy_dst_src_same_retval_used(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* [[DST]], i32 [[C:%.*]], i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* %dst, i32 %c, i64 %n)
  ret i8* %call
}

define i8* @memccpy_to_memcpy_musttail(i8* %dst, i8* %x, i32 %y, i64 %z) {
; CHECK-LABEL: @memccpy_to_memcpy_musttail(
; CHECK-NEXT:    %call = musttail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 12)
; CHECK-NEXT:    ret i8* %call
;
  %call = musttail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 12) ; 114 is 'r'
  ret i8* %call
}

define i8* @memccpy_to_memcpy2_musttail(i8* %dst, i8* %x, i32 %y, i64 %z) {
; CHECK-LABEL: @memccpy_to_memcpy2_musttail(
; CHECK-NEXT:    %call = musttail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 8)
; CHECK-NEXT:    ret i8* %call
;
  %call = musttail call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 8) ; 114 is 'r'
  ret i8* %call
}

