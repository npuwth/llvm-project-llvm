; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Verify that memchr calls with constant arrays, or constant characters,
; or constant bounds are folded (or not) as expected.

declare i8* @memchr(i8*, i32, i64)

@ax = external global [0 x i8]
@a12345 = constant [5 x i8] c"\01\02\03\04\05"
@a123f45 = constant [5 x i8] c"\01\02\03\f4\05"


; Fold memchr(a12345, '\06', n) to null.

define i8* @fold_memchr_a12345_6_n(i64 %n) {
; CHECK-LABEL: @fold_memchr_a12345_6_n(
; CHECK-NEXT:    ret i8* null
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 6, i64 %n)
  ret i8* %res
}


; Fold memchr(a12345, '\04', 2) to null.

define i8* @fold_memchr_a12345_4_2() {
; CHECK-LABEL: @fold_memchr_a12345_4_2(
; CHECK-NEXT:    ret i8* null
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 4, i64 2)
  ret i8* %res
}


; Fold memchr(a12345, '\04', 3) to null.

define i8* @fold_memchr_a12345_4_3() {
; CHECK-LABEL: @fold_memchr_a12345_4_3(
; CHECK-NEXT:    ret i8* null
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 4, i64 3)
  ret i8* %res
}


; Fold memchr(a12345, '\03', 3) to a12345 + 2.

define i8* @fold_memchr_a12345_3_3() {
; CHECK-LABEL: @fold_memchr_a12345_3_3(
; CHECK-NEXT:    ret i8* getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 2)
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 3, i64 3)
  ret i8* %res
}


; Fold memchr(a12345, '\03', 9) to a12345 + 2.

define i8* @fold_memchr_a12345_3_9() {
; CHECK-LABEL: @fold_memchr_a12345_3_9(
; CHECK-NEXT:    ret i8* getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 2)
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 3, i64 9)
  ret i8* %res
}


; Fold memchr(a123f45, 500, 9) to a123f45 + 3 (verify that 500 is
; truncated to (unsigned char)500 == '\xf4')

define i8* @fold_memchr_a123f45_500_9() {
; CHECK-LABEL: @fold_memchr_a123f45_500_9(
; CHECK-NEXT:    ret i8* getelementptr inbounds ([5 x i8], [5 x i8]* @a123f45, i64 0, i64 3)
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a123f45, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 500, i64 9)
  ret i8* %res
}


; Fold memchr(a12345, '\03', n) to n < 3 ? null : a12345 + 2.

define i8* @fold_a12345_3_n(i64 %n) {
; CHECK-LABEL: @fold_a12345_3_n(
; CHECK-NEXT:    [[MEMCHR_CMP:%.*]] = icmp ult i64 [[N:%.*]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[MEMCHR_CMP]], i8* null, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 2)
; CHECK-NEXT:    ret i8* [[TMP1]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 3, i64 %n)
  ret i8* %res
}


; Fold memchr(a12345, 259, n) to n < 3 ? null : a12345 + 2
; to verify the constant 259 is converted to unsigned char (yielding 3).

define i8* @fold_a12345_259_n(i64 %n) {
; CHECK-LABEL: @fold_a12345_259_n(
; CHECK-NEXT:    [[MEMCHR_CMP:%.*]] = icmp ult i64 [[N:%.*]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[MEMCHR_CMP]], i8* null, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 2)
; CHECK-NEXT:    ret i8* [[TMP1]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 259, i64 %n)
  ret i8* %res
}


; Do no fold memchr(ax, 1, n).

define i8* @call_ax_1_n(i64 %n) {
; CHECK-LABEL: @call_ax_1_n(
; CHECK-NEXT:    [[RES:%.*]] = call i8* @memchr(i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), i32 1, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[RES]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 1, i64 %n)
  ret i8* %res
}
