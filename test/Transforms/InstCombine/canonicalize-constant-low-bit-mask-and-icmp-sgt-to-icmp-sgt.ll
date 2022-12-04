; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=38123

; Pattern:
;   x s> x & C
; Should be transformed into:
;   x s> C
; Iff: isPowerOf2(C + 1)
; C must not be -1, but may be 0.

; NOTE: this pattern is not commutative!

declare i8 @gen8()
declare <2 x i8> @gen2x8()
declare <3 x i8> @gen3x8()

; ============================================================================ ;
; Basic positive tests
; ============================================================================ ;

define i1 @p0() {
; CHECK-LABEL: @p0(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i8 [[X]], 3
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %x = call i8 @gen8()
  %tmp0 = and i8 %x, 3
  %ret = icmp sgt i8 %x, %tmp0
  ret i1 %ret
}

; ============================================================================ ;
; Vector tests
; ============================================================================ ;

define <2 x i1> @p1_vec_splat() {
; CHECK-LABEL: @p1_vec_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @gen2x8()
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <2 x i8> [[X]], <i8 3, i8 3>
; CHECK-NEXT:    ret <2 x i1> [[TMP1]]
;
  %x = call <2 x i8> @gen2x8()
  %tmp0 = and <2 x i8> %x, <i8 3, i8 3>
  %ret = icmp sgt <2 x i8> %x, %tmp0
  ret <2 x i1> %ret
}

define <2 x i1> @p2_vec_nonsplat() {
; CHECK-LABEL: @p2_vec_nonsplat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @gen2x8()
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <2 x i8> [[X]], <i8 3, i8 15>
; CHECK-NEXT:    ret <2 x i1> [[TMP1]]
;
  %x = call <2 x i8> @gen2x8()
  %tmp0 = and <2 x i8> %x, <i8 3, i8 15> ; doesn't have to be splat.
  %ret = icmp sgt <2 x i8> %x, %tmp0
  ret <2 x i1> %ret
}

define <2 x i1> @p2_vec_nonsplat_edgecase() {
; CHECK-LABEL: @p2_vec_nonsplat_edgecase(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @gen2x8()
; CHECK-NEXT:    [[TMP0:%.*]] = and <2 x i8> [[X]], <i8 3, i8 0>
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt <2 x i8> [[X]], [[TMP0]]
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %x = call <2 x i8> @gen2x8()
  %tmp0 = and <2 x i8> %x, <i8 3, i8 0>
  %ret = icmp sgt <2 x i8> %x, %tmp0
  ret <2 x i1> %ret
}

define <3 x i1> @p3_vec_splat_undef() {
; CHECK-LABEL: @p3_vec_splat_undef(
; CHECK-NEXT:    [[X:%.*]] = call <3 x i8> @gen3x8()
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <3 x i8> [[X]], <i8 3, i8 3, i8 3>
; CHECK-NEXT:    ret <3 x i1> [[TMP1]]
;
  %x = call <3 x i8> @gen3x8()
  %tmp0 = and <3 x i8> %x, <i8 3, i8 undef, i8 3>
  %ret = icmp sgt <3 x i8> %x, %tmp0
  ret <3 x i1> %ret
}

define <3 x i1> @p3_vec_nonsplat_undef() {
; CHECK-LABEL: @p3_vec_nonsplat_undef(
; CHECK-NEXT:    [[X:%.*]] = call <3 x i8> @gen3x8()
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <3 x i8> [[X]], <i8 15, i8 3, i8 15>
; CHECK-NEXT:    ret <3 x i1> [[TMP1]]
;
  %x = call <3 x i8> @gen3x8()
  %tmp0 = and <3 x i8> %x, <i8 15, i8 3, i8 undef>
  %ret = icmp sgt <3 x i8> %x, %tmp0
  ret <3 x i1> %ret
}

; ============================================================================ ;
; One-use tests. We don't care about multi-uses here.
; ============================================================================ ;

declare void @use8(i8)

define i1 @oneuse0() {
; CHECK-LABEL: @oneuse0(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X]], 3
; CHECK-NEXT:    call void @use8(i8 [[TMP0]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i8 [[X]], 3
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %x = call i8 @gen8()
  %tmp0 = and i8 %x, 3
  call void @use8(i8 %tmp0)
  %ret = icmp sgt i8 %x, %tmp0
  ret i1 %ret
}

; ============================================================================ ;
; Negative tests
; ============================================================================ ;

; Commutativity tests.

define i1 @c0(i8 %x) {
; CHECK-LABEL: @c0(
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X:%.*]], 3
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt i8 [[TMP0]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %tmp0 = and i8 %x, 3
  %ret = icmp sgt i8 %tmp0, %x ; swapped order
  ret i1 %ret
}

; ============================================================================ ;
; Rest of negative tests
; ============================================================================ ;

define i1 @n0() {
; CHECK-LABEL: @n0(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X]], 4
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt i8 [[X]], [[TMP0]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = and i8 %x, 4 ; power-of-two, but invalid.
  %ret = icmp sgt i8 %x, %tmp0
  ret i1 %ret
}

define i1 @n1(i8 %y, i8 %notx) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X]], 3
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt i8 [[TMP0]], [[NOTX:%.*]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = and i8 %x, 3
  %ret = icmp sgt i8 %tmp0, %notx ; not %x
  ret i1 %ret
}

define <2 x i1> @n2() {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @gen2x8()
; CHECK-NEXT:    [[TMP0:%.*]] = and <2 x i8> [[X]], <i8 3, i8 16>
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt <2 x i8> [[X]], [[TMP0]]
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %x = call <2 x i8> @gen2x8()
  %tmp0 = and <2 x i8> %x, <i8 3, i8 16> ; only the first one is valid.
  %ret = icmp sgt <2 x i8> %x, %tmp0
  ret <2 x i1> %ret
}

; ============================================================================ ;
; Potential miscompiles.
; ============================================================================ ;

define i1 @pv(i8 %y) {
; CHECK-LABEL: @pv(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], [[X]]
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt i8 [[X]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = lshr i8 -1, %y
  %tmp1 = and i8 %tmp0, %x
  %ret = icmp sgt i8 %x, %tmp1
  ret i1 %ret
}

define <2 x i1> @n3_vec() {
; CHECK-LABEL: @n3_vec(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @gen2x8()
; CHECK-NEXT:    [[TMP0:%.*]] = and <2 x i8> [[X]], <i8 3, i8 -1>
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt <2 x i8> [[X]], [[TMP0]]
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %x = call <2 x i8> @gen2x8()
  %tmp0 = and <2 x i8> %x, <i8 3, i8 -1>
  %ret = icmp sgt <2 x i8> %x, %tmp0
  ret <2 x i1> %ret
}

define <3 x i1> @n4_vec() {
; CHECK-LABEL: @n4_vec(
; CHECK-NEXT:    [[X:%.*]] = call <3 x i8> @gen3x8()
; CHECK-NEXT:    [[TMP0:%.*]] = and <3 x i8> [[X]], <i8 3, i8 undef, i8 -1>
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt <3 x i8> [[X]], [[TMP0]]
; CHECK-NEXT:    ret <3 x i1> [[RET]]
;
  %x = call <3 x i8> @gen3x8()
  %tmp0 = and <3 x i8> %x, <i8 3, i8 undef, i8 -1>
  %ret = icmp sgt <3 x i8> %x, %tmp0
  ret <3 x i1> %ret
}

; Commutativity tests with variable

; Ok, this one should fold. We only testing commutativity of 'and'.
define i1 @cv0_GOOD(i8 %y) {
; CHECK-LABEL: @cv0_GOOD(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], [[X]]
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt i8 [[X]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = lshr i8 -1, %y
  %tmp1 = and i8 %tmp0, %x ; swapped order
  %ret = icmp sgt i8 %x, %tmp1
  ret i1 %ret
}

define i1 @cv1(i8 %y) {
; CHECK-LABEL: @cv1(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X]], [[TMP0]]
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt i8 [[TMP1]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = lshr i8 -1, %y
  %tmp1 = and i8 %x, %tmp0
  %ret = icmp sgt i8 %tmp1, %x ; swapped order
  ret i1 %ret
}

define i1 @cv2(i8 %x, i8 %y) {
; CHECK-LABEL: @cv2(
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], [[X:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = icmp sgt i8 [[TMP1]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %tmp0 = lshr i8 -1, %y
  %tmp1 = and i8 %tmp0, %x ; swapped order
  %ret = icmp sgt i8 %tmp1, %x ; swapped order
  ret i1 %ret
}
