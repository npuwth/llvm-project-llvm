; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Can't get smaller than this.

define <2 x i1> @trunc(<2 x i64> %a) {
; CHECK-LABEL: @trunc(
; CHECK-NEXT:    [[T:%.*]] = trunc <2 x i64> [[A:%.*]] to <2 x i1>
; CHECK-NEXT:    ret <2 x i1> [[T]]
;
  %t = trunc <2 x i64> %a to <2 x i1>
  ret <2 x i1> %t
}

; This is trunc.

define <2 x i1> @and_cmp_is_trunc(<2 x i64> %a) {
; CHECK-LABEL: @and_cmp_is_trunc(
; CHECK-NEXT:    [[R:%.*]] = trunc <2 x i64> [[A:%.*]] to <2 x i1>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %t = and <2 x i64> %a, <i64 1, i64 1>
  %r = icmp ne <2 x i64> %t, zeroinitializer
  ret <2 x i1> %r
}

; This is trunc.

define <2 x i1> @and_cmp_is_trunc_even_with_undef_elt(<2 x i64> %a) {
; CHECK-LABEL: @and_cmp_is_trunc_even_with_undef_elt(
; CHECK-NEXT:    [[R:%.*]] = trunc <2 x i64> [[A:%.*]] to <2 x i1>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %t = and <2 x i64> %a, <i64 undef, i64 1>
  %r = icmp ne <2 x i64> %t, zeroinitializer
  ret <2 x i1> %r
}

; TODO: This could be just 1 instruction (trunc), but our undef matching is incomplete.

define <2 x i1> @and_cmp_is_trunc_even_with_undef_elts(<2 x i64> %a) {
; CHECK-LABEL: @and_cmp_is_trunc_even_with_undef_elts(
; CHECK-NEXT:    [[T:%.*]] = and <2 x i64> [[A:%.*]], <i64 undef, i64 1>
; CHECK-NEXT:    [[R:%.*]] = icmp ne <2 x i64> [[T]], <i64 undef, i64 0>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %t = and <2 x i64> %a, <i64 undef, i64 1>
  %r = icmp ne <2 x i64> %t, <i64 undef, i64 0>
  ret <2 x i1> %r
}

; The ashr turns into an lshr.
define <2 x i64> @test2(<2 x i64> %a) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[B:%.*]] = lshr <2 x i64> [[A:%.*]], <i64 1, i64 1>
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i64> [[B]], <i64 32767, i64 32767>
; CHECK-NEXT:    ret <2 x i64> [[TMP1]]
;
  %b = and <2 x i64> %a, <i64 65535, i64 65535>
  %t = ashr <2 x i64> %b, <i64 1, i64 1>
  ret <2 x i64> %t
}

define <2 x i64> @test3(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord <4 x float> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = sext <4 x i1> [[TMP1]] to <4 x i32>
; CHECK-NEXT:    [[CONV:%.*]] = bitcast <4 x i32> [[AND]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[CONV]]
;
  %cmp = fcmp ord <4 x float> %a, zeroinitializer
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp4 = fcmp ord <4 x float> %b, zeroinitializer
  %sext5 = sext <4 x i1> %cmp4 to <4 x i32>
  %and = and <4 x i32> %sext, %sext5
  %conv = bitcast <4 x i32> %and to <2 x i64>
  ret <2 x i64> %conv
}

define <2 x i64> @test4(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uno <4 x float> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = sext <4 x i1> [[TMP1]] to <4 x i32>
; CHECK-NEXT:    [[CONV:%.*]] = bitcast <4 x i32> [[OR]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[CONV]]
;
  %cmp = fcmp uno <4 x float> %a, zeroinitializer
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp4 = fcmp uno <4 x float> %b, zeroinitializer
  %sext5 = sext <4 x i1> %cmp4 to <4 x i32>
  %or = or <4 x i32> %sext, %sext5
  %conv = bitcast <4 x i32> %or to <2 x i64>
  ret <2 x i64> %conv
}

; rdar://7434900
define <2 x i64> @test5(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ult <4 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    [[CMP4:%.*]] = fcmp ult <4 x float> [[B:%.*]], zeroinitializer
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i1> [[CMP]], [[CMP4]]
; CHECK-NEXT:    [[AND:%.*]] = sext <4 x i1> [[AND1]] to <4 x i32>
; CHECK-NEXT:    [[CONV:%.*]] = bitcast <4 x i32> [[AND]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[CONV]]
;
  %cmp = fcmp ult <4 x float> %a, zeroinitializer
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp4 = fcmp ult <4 x float> %b, zeroinitializer
  %sext5 = sext <4 x i1> %cmp4 to <4 x i32>
  %and = and <4 x i32> %sext, %sext5
  %conv = bitcast <4 x i32> %and to <2 x i64>
  ret <2 x i64> %conv
}

define <2 x i64> @test6(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ult <4 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    [[CMP4:%.*]] = fcmp ult <4 x float> [[B:%.*]], zeroinitializer
; CHECK-NEXT:    [[AND1:%.*]] = or <4 x i1> [[CMP]], [[CMP4]]
; CHECK-NEXT:    [[AND:%.*]] = sext <4 x i1> [[AND1]] to <4 x i32>
; CHECK-NEXT:    [[CONV:%.*]] = bitcast <4 x i32> [[AND]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[CONV]]
;
  %cmp = fcmp ult <4 x float> %a, zeroinitializer
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp4 = fcmp ult <4 x float> %b, zeroinitializer
  %sext5 = sext <4 x i1> %cmp4 to <4 x i32>
  %and = or <4 x i32> %sext, %sext5
  %conv = bitcast <4 x i32> %and to <2 x i64>
  ret <2 x i64> %conv
}

define <2 x i64> @test7(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ult <4 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    [[CMP4:%.*]] = fcmp ult <4 x float> [[B:%.*]], zeroinitializer
; CHECK-NEXT:    [[AND1:%.*]] = xor <4 x i1> [[CMP]], [[CMP4]]
; CHECK-NEXT:    [[AND:%.*]] = sext <4 x i1> [[AND1]] to <4 x i32>
; CHECK-NEXT:    [[CONV:%.*]] = bitcast <4 x i32> [[AND]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[CONV]]
;
  %cmp = fcmp ult <4 x float> %a, zeroinitializer
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp4 = fcmp ult <4 x float> %b, zeroinitializer
  %sext5 = sext <4 x i1> %cmp4 to <4 x i32>
  %and = xor <4 x i32> %sext, %sext5
  %conv = bitcast <4 x i32> %and to <2 x i64>
  ret <2 x i64> %conv
}

define void @convert(<2 x i32>* %dst.addr, <2 x i64> %src) {
; CHECK-LABEL: @convert(
; CHECK-NEXT:    [[VAL:%.*]] = trunc <2 x i64> [[SRC:%.*]] to <2 x i32>
; CHECK-NEXT:    [[ADD:%.*]] = add <2 x i32> [[VAL]], <i32 1, i32 1>
; CHECK-NEXT:    store <2 x i32> [[ADD]], <2 x i32>* [[DST_ADDR:%.*]], align 8
; CHECK-NEXT:    ret void
;
  %val = trunc <2 x i64> %src to <2 x i32>
  %add = add <2 x i32> %val, <i32 1, i32 1>
  store <2 x i32> %add, <2 x i32>* %dst.addr
  ret void
}

define <2 x i65> @foo(<2 x i64> %t) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[A_MASK:%.*]] = and <2 x i64> [[T:%.*]], <i64 4294967295, i64 4294967295>
; CHECK-NEXT:    [[B:%.*]] = zext <2 x i64> [[A_MASK]] to <2 x i65>
; CHECK-NEXT:    ret <2 x i65> [[B]]
;
  %a = trunc <2 x i64> %t to <2 x i32>
  %b = zext <2 x i32> %a to <2 x i65>
  ret <2 x i65> %b
}

define <2 x i64> @bar(<2 x i65> %t) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <2 x i65> [[T:%.*]] to <2 x i64>
; CHECK-NEXT:    [[B:%.*]] = and <2 x i64> [[TMP1]], <i64 4294967295, i64 4294967295>
; CHECK-NEXT:    ret <2 x i64> [[B]]
;
  %a = trunc <2 x i65> %t to <2 x i32>
  %b = zext <2 x i32> %a to <2 x i64>
  ret <2 x i64> %b
}

define <2 x i64> @bars(<2 x i65> %t) {
; CHECK-LABEL: @bars(
; CHECK-NEXT:    [[A:%.*]] = trunc <2 x i65> [[T:%.*]] to <2 x i32>
; CHECK-NEXT:    [[B:%.*]] = sext <2 x i32> [[A]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[B]]
;
  %a = trunc <2 x i65> %t to <2 x i32>
  %b = sext <2 x i32> %a to <2 x i64>
  ret <2 x i64> %b
}

define <2 x i64> @quxs(<2 x i64> %t) {
; CHECK-LABEL: @quxs(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i64> [[T:%.*]], <i64 32, i64 32>
; CHECK-NEXT:    [[B:%.*]] = ashr exact <2 x i64> [[TMP1]], <i64 32, i64 32>
; CHECK-NEXT:    ret <2 x i64> [[B]]
;
  %a = trunc <2 x i64> %t to <2 x i32>
  %b = sext <2 x i32> %a to <2 x i64>
  ret <2 x i64> %b
}

define <2 x i64> @quxt(<2 x i64> %t) {
; CHECK-LABEL: @quxt(
; CHECK-NEXT:    [[A:%.*]] = shl <2 x i64> [[T:%.*]], <i64 32, i64 32>
; CHECK-NEXT:    [[B:%.*]] = ashr exact <2 x i64> [[A]], <i64 32, i64 32>
; CHECK-NEXT:    ret <2 x i64> [[B]]
;
  %a = shl <2 x i64> %t, <i64 32, i64 32>
  %b = ashr <2 x i64> %a, <i64 32, i64 32>
  ret <2 x i64> %b
}

define <2 x double> @fa(<2 x double> %t) {
; CHECK-LABEL: @fa(
; CHECK-NEXT:    [[A:%.*]] = fptrunc <2 x double> [[T:%.*]] to <2 x float>
; CHECK-NEXT:    [[B:%.*]] = fpext <2 x float> [[A]] to <2 x double>
; CHECK-NEXT:    ret <2 x double> [[B]]
;
  %a = fptrunc <2 x double> %t to <2 x float>
  %b = fpext <2 x float> %a to <2 x double>
  ret <2 x double> %b
}

define <2 x double> @fb(<2 x double> %t) {
; CHECK-LABEL: @fb(
; CHECK-NEXT:    [[A:%.*]] = fptoui <2 x double> [[T:%.*]] to <2 x i64>
; CHECK-NEXT:    [[B:%.*]] = uitofp <2 x i64> [[A]] to <2 x double>
; CHECK-NEXT:    ret <2 x double> [[B]]
;
  %a = fptoui <2 x double> %t to <2 x i64>
  %b = uitofp <2 x i64> %a to <2 x double>
  ret <2 x double> %b
}

define <2 x double> @fc(<2 x double> %t) {
; CHECK-LABEL: @fc(
; CHECK-NEXT:    [[A:%.*]] = fptosi <2 x double> [[T:%.*]] to <2 x i64>
; CHECK-NEXT:    [[B:%.*]] = sitofp <2 x i64> [[A]] to <2 x double>
; CHECK-NEXT:    ret <2 x double> [[B]]
;
  %a = fptosi <2 x double> %t to <2 x i64>
  %b = sitofp <2 x i64> %a to <2 x double>
  ret <2 x double> %b
}

; PR9228
define <4 x float> @f(i32 %a) {
; CHECK-LABEL: @f(
; CHECK-NEXT:    ret <4 x float> undef
;
  %dim = insertelement <4 x i32> poison, i32 %a, i32 0
  %dim30 = insertelement <4 x i32> %dim, i32 %a, i32 1
  %dim31 = insertelement <4 x i32> %dim30, i32 %a, i32 2
  %dim32 = insertelement <4 x i32> %dim31, i32 %a, i32 3

  %offset_ptr = getelementptr <4 x float>, <4 x float>* null, i32 1
  %offset_int = ptrtoint <4 x float>* %offset_ptr to i64
  %sizeof32 = trunc i64 %offset_int to i32

  %smearinsert33 = insertelement <4 x i32> poison, i32 %sizeof32, i32 0
  %smearinsert34 = insertelement <4 x i32> %smearinsert33, i32 %sizeof32, i32 1
  %smearinsert35 = insertelement <4 x i32> %smearinsert34, i32 %sizeof32, i32 2
  %smearinsert36 = insertelement <4 x i32> %smearinsert35, i32 %sizeof32, i32 3

  %delta_scale = mul <4 x i32> %dim32, %smearinsert36
  %offset_delta = add <4 x i32> zeroinitializer, %delta_scale

  %offset_varying_delta = add <4 x i32> %offset_delta, undef

  ret <4 x float> undef
}

define <8 x i32> @pr24458(<8 x float> %n) {
; CHECK-LABEL: @pr24458(
; CHECK-NEXT:    ret <8 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
;
  %notequal_b_load_.i = fcmp une <8 x float> %n, zeroinitializer
  %equal_a_load72_.i = fcmp ueq <8 x float> %n, zeroinitializer
  %notequal_b_load__to_boolvec.i = sext <8 x i1> %notequal_b_load_.i to <8 x i32>
  %equal_a_load72__to_boolvec.i = sext <8 x i1> %equal_a_load72_.i to <8 x i32>
  %wrong = or <8 x i32> %notequal_b_load__to_boolvec.i, %equal_a_load72__to_boolvec.i
  ret <8 x i32> %wrong
}

; Hoist a trunc to a scalar if we're inserting into an undef vector.
; trunc (inselt undef, X, Index) --> inselt undef, (trunc X), Index

define <3 x i16> @trunc_inselt_undef(i32 %x) {
; CHECK-LABEL: @trunc_inselt_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[X:%.*]] to i16
; CHECK-NEXT:    [[TRUNC:%.*]] = insertelement <3 x i16> undef, i16 [[TMP1]], i64 1
; CHECK-NEXT:    ret <3 x i16> [[TRUNC]]
;
  %vec = insertelement <3 x i32> poison, i32 %x, i32 1
  %trunc = trunc <3 x i32> %vec to <3 x i16>
  ret <3 x i16> %trunc
}

; Hoist a trunc to a scalar if we're inserting into an undef vector.
; trunc (inselt undef, X, Index) --> inselt undef, (trunc X), Index

define <2 x float> @fptrunc_inselt_undef(double %x, i32 %index) {
; CHECK-LABEL: @fptrunc_inselt_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc double [[X:%.*]] to float
; CHECK-NEXT:    [[TRUNC:%.*]] = insertelement <2 x float> undef, float [[TMP1]], i32 [[INDEX:%.*]]
; CHECK-NEXT:    ret <2 x float> [[TRUNC]]
;
  %vec = insertelement <2 x double> <double undef, double undef>, double %x, i32 %index
  %trunc = fptrunc <2 x double> %vec to <2 x float>
  ret <2 x float> %trunc
}

; TODO: Strengthen the backend, so we can have this canonicalization.
; Insert a scalar int into a constant vector and truncate:
; trunc (inselt C, X, Index) --> inselt C, (trunc X), Index

define <3 x i16> @trunc_inselt1(i32 %x) {
; CHECK-LABEL: @trunc_inselt1(
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <3 x i32> <i32 3, i32 poison, i32 65536>, i32 [[X:%.*]], i64 1
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc <3 x i32> [[VEC]] to <3 x i16>
; CHECK-NEXT:    ret <3 x i16> [[TRUNC]]
;
  %vec = insertelement <3 x i32> <i32 3, i32 -2, i32 65536>, i32 %x, i32 1
  %trunc = trunc <3 x i32> %vec to <3 x i16>
  ret <3 x i16> %trunc
}

; TODO: Strengthen the backend, so we can have this canonicalization.
; Insert a scalar FP into a constant vector and FP truncate:
; fptrunc (inselt C, X, Index) --> inselt C, (fptrunc X), Index

define <2 x float> @fptrunc_inselt1(double %x, i32 %index) {
; CHECK-LABEL: @fptrunc_inselt1(
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <2 x double> <double undef, double 3.000000e+00>, double [[X:%.*]], i32 [[INDEX:%.*]]
; CHECK-NEXT:    [[TRUNC:%.*]] = fptrunc <2 x double> [[VEC]] to <2 x float>
; CHECK-NEXT:    ret <2 x float> [[TRUNC]]
;
  %vec = insertelement <2 x double> <double undef, double 3.0>, double %x, i32 %index
  %trunc = fptrunc <2 x double> %vec to <2 x float>
  ret <2 x float> %trunc
}

; TODO: Strengthen the backend, so we can have this canonicalization.
; Insert a scalar int constant into a vector and truncate:
; trunc (inselt X, C, Index) --> inselt (trunc X), C', Index

define <8 x i16> @trunc_inselt2(<8 x i32> %x, i32 %index) {
; CHECK-LABEL: @trunc_inselt2(
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <8 x i32> [[X:%.*]], i32 1048576, i32 [[INDEX:%.*]]
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc <8 x i32> [[VEC]] to <8 x i16>
; CHECK-NEXT:    ret <8 x i16> [[TRUNC]]
;
  %vec = insertelement <8 x i32> %x, i32 1048576, i32 %index
  %trunc = trunc <8 x i32> %vec to <8 x i16>
  ret <8 x i16> %trunc
}

; TODO: Strengthen the backend, so we can have this canonicalization.
; Insert a scalar FP constant into a vector and FP truncate:
; fptrunc (inselt X, C, Index) --> inselt (fptrunc X), C', Index

define <3 x float> @fptrunc_inselt2(<3 x double> %x) {
; CHECK-LABEL: @fptrunc_inselt2(
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <3 x double> [[X:%.*]], double 4.000000e+00, i64 2
; CHECK-NEXT:    [[TRUNC:%.*]] = fptrunc <3 x double> [[VEC]] to <3 x float>
; CHECK-NEXT:    ret <3 x float> [[TRUNC]]
;
  %vec = insertelement <3 x double> %x, double 4.0, i32 2
  %trunc = fptrunc <3 x double> %vec to <3 x float>
  ret <3 x float> %trunc
}

; Converting to a wide type might reduce instruction count,
; but we can not do that unless the backend can recover from
; the creation of a potentially illegal op (like a 64-bit vmul).
; PR40032 - https://bugs.llvm.org/show_bug.cgi?id=40032

define <2 x i64> @sext_less_casting_with_wideop(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: @sext_less_casting_with_wideop(
; CHECK-NEXT:    [[XNARROW:%.*]] = trunc <2 x i64> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[YNARROW:%.*]] = trunc <2 x i64> [[Y:%.*]] to <2 x i32>
; CHECK-NEXT:    [[MUL:%.*]] = mul <2 x i32> [[XNARROW]], [[YNARROW]]
; CHECK-NEXT:    [[R:%.*]] = sext <2 x i32> [[MUL]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %xnarrow = trunc <2 x i64> %x to <2 x i32>
  %ynarrow = trunc <2 x i64> %y to <2 x i32>
  %mul = mul <2 x i32> %xnarrow, %ynarrow
  %r = sext <2 x i32> %mul to <2 x i64>
  ret <2 x i64> %r
}

define <2 x i64> @zext_less_casting_with_wideop(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: @zext_less_casting_with_wideop(
; CHECK-NEXT:    [[XNARROW:%.*]] = trunc <2 x i64> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[YNARROW:%.*]] = trunc <2 x i64> [[Y:%.*]] to <2 x i32>
; CHECK-NEXT:    [[MUL:%.*]] = mul <2 x i32> [[XNARROW]], [[YNARROW]]
; CHECK-NEXT:    [[R:%.*]] = zext <2 x i32> [[MUL]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %xnarrow = trunc <2 x i64> %x to <2 x i32>
  %ynarrow = trunc <2 x i64> %y to <2 x i32>
  %mul = mul <2 x i32> %xnarrow, %ynarrow
  %r = zext <2 x i32> %mul to <2 x i64>
  ret <2 x i64> %r
}

