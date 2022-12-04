; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i32 @factorize(i32 %x, i32 %y) {
; CHECK-LABEL: @factorize(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
; (X | 1) & (X | 2) -> X | (1 & 2) -> X
  %l = or i32 %x, 1
  %r = or i32 %x, 2
  %z = and i32 %l, %r
  ret i32 %z
}

define i32 @factorize2(i32 %x) {
; CHECK-LABEL: @factorize2(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
; 3*X - 2*X -> X
  %l = mul i32 3, %x
  %r = mul i32 2, %x
  %z = sub i32 %l, %r
  ret i32 %z
}

define i32 @factorize3(i32 %x, i32 %a, i32 %b) {
; CHECK-LABEL: @factorize3(
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[B:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
; (X | (A|B)) & (X | B) -> X | ((A|B) & B) -> X | B
  %aORb = or i32 %a, %b
  %l = or i32 %x, %aORb
  %r = or i32 %x, %b
  %z = and i32 %l, %r
  ret i32 %z
}

define i32 @factorize4(i32 %x, i32 %y) {
; CHECK-LABEL: @factorize4(
; CHECK-NEXT:    [[S:%.*]] = mul i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[S]]
;
; ((Y << 1) * X) - (X * Y) -> (X * (Y * 2 - Y)) -> (X * Y)
  %sh = shl i32 %y, 1
  %ml = mul i32 %sh, %x
  %mr = mul i32 %x, %y
  %s = sub i32 %ml, %mr
  ret i32 %s
}

define i32 @factorize5(i32 %x, i32 %y) {
; CHECK-LABEL: @factorize5(
; CHECK-NEXT:    [[S:%.*]] = mul i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[S]]
;
; ((Y * 2) * X) - (X * Y) -> (X * Y)
  %sh = mul i32 %y, 2
  %ml = mul i32 %sh, %x
  %mr = mul i32 %x, %y
  %s = sub i32 %ml, %mr
  ret i32 %s
}

define i32 @expand(i32 %x) {
; CHECK-LABEL: @expand(
; CHECK-NEXT:    [[A:%.*]] = and i32 [[X:%.*]], 1
; CHECK-NEXT:    ret i32 [[A]]
;
; ((X & 1) | 2) & 1 -> ((X & 1) & 1) | (2 & 1) -> (X & 1) | 0 -> X & 1
  %a = and i32 %x, 1
  %b = or i32 %a, 2
  %c = and i32 %b, 1
  ret i32 %c
}
