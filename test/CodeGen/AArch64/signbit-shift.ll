; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

; If positive...

define i32 @zext_ifpos(i32 %x) {
; CHECK-LABEL: zext_ifpos:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w8, w0
; CHECK-NEXT:    lsr w0, w8, #31
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %x, -1
  %e = zext i1 %c to i32
  ret i32 %e
}

define i32 @add_zext_ifpos(i32 %x) {
; CHECK-LABEL: add_zext_ifpos:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr w8, w0, #31
; CHECK-NEXT:    add w0, w8, #42
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %x, -1
  %e = zext i1 %c to i32
  %r = add i32 %e, 41
  ret i32 %r
}

define <4 x i32> @add_zext_ifpos_vec_splat(<4 x i32> %x) {
; CHECK-LABEL: add_zext_ifpos_vec_splat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0xffffffffffffffff
; CHECK-NEXT:    movi v2.4s, #41
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    sub v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    ret
  %c = icmp sgt <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %e = zext <4 x i1> %c to <4 x i32>
  %r = add <4 x i32> %e, <i32 41, i32 41, i32 41, i32 41>
  ret <4 x i32> %r
}

define i32 @sel_ifpos_tval_bigger(i32 %x) {
; CHECK-LABEL: sel_ifpos_tval_bigger:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #41
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cinc w0, w8, ge
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %x, -1
  %r = select i1 %c, i32 42, i32 41
  ret i32 %r
}

define i32 @sext_ifpos(i32 %x) {
; CHECK-LABEL: sext_ifpos:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w8, w0
; CHECK-NEXT:    asr w0, w8, #31
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %x, -1
  %e = sext i1 %c to i32
  ret i32 %e
}

define i32 @add_sext_ifpos(i32 %x) {
; CHECK-LABEL: add_sext_ifpos:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w8, w0, #31
; CHECK-NEXT:    add w0, w8, #41
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %x, -1
  %e = sext i1 %c to i32
  %r = add i32 %e, 42
  ret i32 %r
}

define <4 x i32> @add_sext_ifpos_vec_splat(<4 x i32> %x) {
; CHECK-LABEL: add_sext_ifpos_vec_splat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0xffffffffffffffff
; CHECK-NEXT:    movi v2.4s, #42
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    ret
  %c = icmp sgt <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %e = sext <4 x i1> %c to <4 x i32>
  %r = add <4 x i32> %e, <i32 42, i32 42, i32 42, i32 42>
  ret <4 x i32> %r
}

define i32 @sel_ifpos_fval_bigger(i32 %x) {
; CHECK-LABEL: sel_ifpos_fval_bigger:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #41
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cinc w0, w8, lt
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %x, -1
  %r = select i1 %c, i32 41, i32 42
  ret i32 %r
}

; If negative...

define i32 @zext_ifneg(i32 %x) {
; CHECK-LABEL: zext_ifneg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w0, w0, #31
; CHECK-NEXT:    ret
  %c = icmp slt i32 %x, 0
  %r = zext i1 %c to i32
  ret i32 %r
}

define i32 @add_zext_ifneg(i32 %x) {
; CHECK-LABEL: add_zext_ifneg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w8, w0, #31
; CHECK-NEXT:    add w0, w8, #41
; CHECK-NEXT:    ret
  %c = icmp slt i32 %x, 0
  %e = zext i1 %c to i32
  %r = add i32 %e, 41
  ret i32 %r
}

define i32 @sel_ifneg_tval_bigger(i32 %x) {
; CHECK-LABEL: sel_ifneg_tval_bigger:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #41
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cinc w0, w8, lt
; CHECK-NEXT:    ret
  %c = icmp slt i32 %x, 0
  %r = select i1 %c, i32 42, i32 41
  ret i32 %r
}

define i32 @sext_ifneg(i32 %x) {
; CHECK-LABEL: sext_ifneg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr w0, w0, #31
; CHECK-NEXT:    ret
  %c = icmp slt i32 %x, 0
  %r = sext i1 %c to i32
  ret i32 %r
}

define i32 @add_sext_ifneg(i32 %x) {
; CHECK-LABEL: add_sext_ifneg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr w8, w0, #31
; CHECK-NEXT:    add w0, w8, #42
; CHECK-NEXT:    ret
  %c = icmp slt i32 %x, 0
  %e = sext i1 %c to i32
  %r = add i32 %e, 42
  ret i32 %r
}

define i32 @sel_ifneg_fval_bigger(i32 %x) {
; CHECK-LABEL: sel_ifneg_fval_bigger:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #41
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cinc w0, w8, ge
; CHECK-NEXT:    ret
  %c = icmp slt i32 %x, 0
  %r = select i1 %c, i32 41, i32 42
  ret i32 %r
}

define i32 @add_lshr_not(i32 %x) {
; CHECK-LABEL: add_lshr_not:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr w8, w0, #31
; CHECK-NEXT:    add w0, w8, #42
; CHECK-NEXT:    ret
  %not = xor i32 %x, -1
  %sh = lshr i32 %not, 31
  %r = add i32 %sh, 41
  ret i32 %r
}

define <4 x i32> @add_lshr_not_vec_splat(<4 x i32> %x) {
; CHECK-LABEL: add_lshr_not_vec_splat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #43
; CHECK-NEXT:    ssra v1.4s, v0.4s, #31
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %c = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %e = lshr <4 x i32> %c, <i32 31, i32 31, i32 31, i32 31>
  %r = add <4 x i32> %e, <i32 42, i32 42, i32 42, i32 42>
  ret <4 x i32> %r
}

define i32 @sub_lshr_not(i32 %x) {
; CHECK-LABEL: sub_lshr_not:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    bfxil w8, w0, #31, #1
; CHECK-NEXT:    mov w0, w8
; CHECK-NEXT:    ret
  %not = xor i32 %x, -1
  %sh = lshr i32 %not, 31
  %r = sub i32 43, %sh
  ret i32 %r
}

define <4 x i32> @sub_lshr_not_vec_splat(<4 x i32> %x) {
; CHECK-LABEL: sub_lshr_not_vec_splat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #41
; CHECK-NEXT:    usra v1.4s, v0.4s, #31
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %c = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %e = lshr <4 x i32> %c, <i32 31, i32 31, i32 31, i32 31>
  %r = sub <4 x i32> <i32 42, i32 42, i32 42, i32 42>, %e
  ret <4 x i32> %r
}

define i32 @sub_lshr(i32 %x, i32 %y) {
; CHECK-LABEL: sub_lshr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w0, w1, w0, asr #31
; CHECK-NEXT:    ret
  %sh = lshr i32 %x, 31
  %r = sub i32 %y, %sh
  ret i32 %r
}

define <4 x i32> @sub_lshr_vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: sub_lshr_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra v1.4s, v0.4s, #31
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %sh = lshr <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %r = sub <4 x i32> %y, %sh
  ret <4 x i32> %r
}

define i32 @sub_const_op_lshr(i32 %x) {
; CHECK-LABEL: sub_const_op_lshr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr w8, w0, #31
; CHECK-NEXT:    add w0, w8, #43
; CHECK-NEXT:    ret
  %sh = lshr i32 %x, 31
  %r = sub i32 43, %sh
  ret i32 %r
}

define <4 x i32> @sub_const_op_lshr_vec(<4 x i32> %x) {
; CHECK-LABEL: sub_const_op_lshr_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #42
; CHECK-NEXT:    ssra v1.4s, v0.4s, #31
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %sh = lshr <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %r = sub <4 x i32> <i32 42, i32 42, i32 42, i32 42>, %sh
  ret <4 x i32> %r
}

