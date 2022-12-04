; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -aggressive-instcombine -S | FileCheck %s

define i16 @udiv_one_arg(i8 %x) {
; CHECK-LABEL: @udiv_one_arg(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[X:%.*]] to i16
; CHECK-NEXT:    [[DIV:%.*]] = udiv i16 [[ZEXT]], 42
; CHECK-NEXT:    ret i16 [[DIV]]
;
  %zext = zext i8 %x to i32
  %div = udiv i32 %zext, 42
  %trunc = trunc i32 %div to i16
  ret i16 %trunc
}

define i16 @udiv_two_args(i16 %x, i16 %y) {
; CHECK-LABEL: @udiv_two_args(
; CHECK-NEXT:    [[I0:%.*]] = udiv i16 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i16 [[I0]]
;
  %zextx = zext i16 %x to i32
  %zexty = zext i16 %y to i32
  %i0 = udiv i32 %zextx, %zexty
  %r = trunc i32 %i0 to i16
  ret i16 %r
}

; Negative test
define i16 @udiv_big_const(i8 %x) {
; CHECK-LABEL: @udiv_big_const(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[ZEXT]], 70000
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[DIV]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC]]
;
  %zext = zext i8 %x to i32
  %div = udiv i32 %zext, 70000
  %trunc = trunc i32 %div to i16
  ret i16 %trunc
}

define <2 x i16> @udiv_vector(<2 x i8> %x) {
; CHECK-LABEL: @udiv_vector(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i16>
; CHECK-NEXT:    [[S:%.*]] = udiv <2 x i16> [[Z]], <i16 4, i16 10>
; CHECK-NEXT:    ret <2 x i16> [[S]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %s = udiv <2 x i32> %z, <i32 4, i32 10>
  %t = trunc <2 x i32> %s to <2 x i16>
  ret <2 x i16> %t
}

; Negative test: can only fold to <2 x i16>, requiring new vector type
define <2 x i8> @udiv_vector_need_new_vector_type(<2 x i8> %x) {
; CHECK-LABEL: @udiv_vector_need_new_vector_type(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[S:%.*]] = udiv <2 x i32> [[Z]], <i32 4, i32 500>
; CHECK-NEXT:    [[T:%.*]] = trunc <2 x i32> [[S]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[T]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %s = udiv <2 x i32> %z, <i32 4, i32 500>
  %t = trunc <2 x i32> %s to <2 x i8>
  ret <2 x i8> %t
}

; Negative test
define <2 x i16> @udiv_vector_big_const(<2 x i8> %x) {
; CHECK-LABEL: @udiv_vector_big_const(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[S:%.*]] = udiv <2 x i32> [[Z]], <i32 16, i32 70000>
; CHECK-NEXT:    [[T:%.*]] = trunc <2 x i32> [[S]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[T]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %s = udiv <2 x i32> %z, <i32 16, i32 70000>
  %t = trunc <2 x i32> %s to <2 x i16>
  ret <2 x i16> %t
}

define i16 @udiv_exact(i16 %x, i16 %y) {
; CHECK-LABEL: @udiv_exact(
; CHECK-NEXT:    [[I0:%.*]] = udiv exact i16 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i16 [[I0]]
;
  %zextx = zext i16 %x to i32
  %zexty = zext i16 %y to i32
  %i0 = udiv exact i32 %zextx, %zexty
  %r = trunc i32 %i0 to i16
  ret i16 %r
}


define i16 @urem_one_arg(i8 %x) {
; CHECK-LABEL: @urem_one_arg(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[X:%.*]] to i16
; CHECK-NEXT:    [[DIV:%.*]] = urem i16 [[ZEXT]], 42
; CHECK-NEXT:    ret i16 [[DIV]]
;
  %zext = zext i8 %x to i32
  %div = urem i32 %zext, 42
  %trunc = trunc i32 %div to i16
  ret i16 %trunc
}

define i16 @urem_two_args(i16 %x, i16 %y) {
; CHECK-LABEL: @urem_two_args(
; CHECK-NEXT:    [[I0:%.*]] = urem i16 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i16 [[I0]]
;
  %zextx = zext i16 %x to i32
  %zexty = zext i16 %y to i32
  %i0 = urem i32 %zextx, %zexty
  %r = trunc i32 %i0 to i16
  ret i16 %r
}

; Negative test
define i16 @urem_big_const(i8 %x) {
; CHECK-LABEL: @urem_big_const(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[DIV:%.*]] = urem i32 [[ZEXT]], 70000
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[DIV]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC]]
;
  %zext = zext i8 %x to i32
  %div = urem i32 %zext, 70000
  %trunc = trunc i32 %div to i16
  ret i16 %trunc
}

define <2 x i16> @urem_vector(<2 x i8> %x) {
; CHECK-LABEL: @urem_vector(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i16>
; CHECK-NEXT:    [[S:%.*]] = urem <2 x i16> [[Z]], <i16 4, i16 10>
; CHECK-NEXT:    ret <2 x i16> [[S]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %s = urem <2 x i32> %z, <i32 4, i32 10>
  %t = trunc <2 x i32> %s to <2 x i16>
  ret <2 x i16> %t
}

; Negative test: can only fold to <2 x i16>, requiring new vector type
define <2 x i8> @urem_vector_need_new_vector_type(<2 x i8> %x) {
; CHECK-LABEL: @urem_vector_need_new_vector_type(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[S:%.*]] = urem <2 x i32> [[Z]], <i32 500, i32 10>
; CHECK-NEXT:    [[T:%.*]] = trunc <2 x i32> [[S]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[T]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %s = urem <2 x i32> %z, <i32 500, i32 10>
  %t = trunc <2 x i32> %s to <2 x i8>
  ret <2 x i8> %t
}

; Negative test
define <2 x i16> @urem_vector_big_const(<2 x i8> %x) {
; CHECK-LABEL: @urem_vector_big_const(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[S:%.*]] = urem <2 x i32> [[Z]], <i32 16, i32 70000>
; CHECK-NEXT:    [[T:%.*]] = trunc <2 x i32> [[S]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[T]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %s = urem <2 x i32> %z, <i32 16, i32 70000>
  %t = trunc <2 x i32> %s to <2 x i16>
  ret <2 x i16> %t
}

