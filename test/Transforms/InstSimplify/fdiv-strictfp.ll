; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

define float @fdiv_constant_fold() #0 {
; CHECK-LABEL: @fdiv_constant_fold(
; CHECK-NEXT:    ret float 1.500000e+00
;
  %f = call float @llvm.experimental.constrained.fdiv.f32(float 3.0, float 2.0, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0

  ret float %f
}

define float @fdiv_constant_fold_strict() #0 {
; CHECK-LABEL: @fdiv_constant_fold_strict(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.experimental.constrained.fdiv.f32(float 3.000000e+00, float 2.000000e+00, metadata !"round.tonearest", metadata !"fpexcept.strict") #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    ret float 1.500000e+00
;
  %f = call float @llvm.experimental.constrained.fdiv.f32(float 3.0, float 2.0, metadata !"round.tonearest", metadata !"fpexcept.strict") #0

  ret float %f
}

define float @fdiv_constant_fold_strict2() #0 {
; CHECK-LABEL: @fdiv_constant_fold_strict2(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.experimental.constrained.fdiv.f32(float 2.000000e+00, float 3.000000e+00, metadata !"round.tonearest", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret float [[F]]
;
  %f = call float @llvm.experimental.constrained.fdiv.f32(float 2.0, float 3.0, metadata !"round.tonearest", metadata !"fpexcept.strict") #0

  ret float %f
}

define float @frem_constant_fold() #0 {
; CHECK-LABEL: @frem_constant_fold(
; CHECK-NEXT:    ret float 1.000000e+00
;
  %f = call float @llvm.experimental.constrained.frem.f32(float 3.0, float 2.0, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret float %f
}

define float @frem_constant_fold_strict() #0 {
; CHECK-LABEL: @frem_constant_fold_strict(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.experimental.constrained.frem.f32(float 3.000000e+00, float 2.000000e+00, metadata !"round.tonearest", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret float 1.000000e+00
;
  %f = call float @llvm.experimental.constrained.frem.f32(float 3.0, float 2.0, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  ret float %f
}

define double @fmul_fdiv_common_operand(double %x, double %y) #0 {
; CHECK-LABEL: @fmul_fdiv_common_operand(
; CHECK-NEXT:    [[M:%.*]] = call double @llvm.experimental.constrained.fmul.f64(double [[X:%.*]], double [[Y:%.*]], metadata !"round.tonearest", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    [[D:%.*]] = call reassoc nnan double @llvm.experimental.constrained.fdiv.f64(double [[M]], double [[Y]], metadata !"round.tonearest", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    ret double [[D]]
;
  %m = call double @llvm.experimental.constrained.fmul.f64(double %x, double %y, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  %d = call reassoc nnan double @llvm.experimental.constrained.fdiv.f64(double %m, double %y, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret double %d
}

; Negative test - the fdiv must be reassociative and not allow NaNs.

define double @fmul_fdiv_common_operand_too_strict(double %x, double %y) #0 {
; CHECK-LABEL: @fmul_fdiv_common_operand_too_strict(
; CHECK-NEXT:    [[M:%.*]] = call fast double @llvm.experimental.constrained.fmul.f64(double [[X:%.*]], double [[Y:%.*]], metadata !"round.tonearest", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    [[D:%.*]] = call reassoc double @llvm.experimental.constrained.fdiv.f64(double [[M]], double [[Y]], metadata !"round.tonearest", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    ret double [[D]]
;
  %m = call fast double @llvm.experimental.constrained.fmul.f64(double %x, double %y, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  %d = call reassoc double @llvm.experimental.constrained.fdiv.f64(double %m, double %y, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret double %d
}

; Commute the fmul operands. Use a vector type to verify that works too.

define <2 x float> @fmul_fdiv_common_operand_commute_vec(<2 x float> %x, <2 x float> %y) #0 {
; CHECK-LABEL: @fmul_fdiv_common_operand_commute_vec(
; CHECK-NEXT:    [[M:%.*]] = call <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float> [[Y:%.*]], <2 x float> [[X:%.*]], metadata !"round.tonearest", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    [[D:%.*]] = call fast <2 x float> @llvm.experimental.constrained.fdiv.v2f32(<2 x float> [[M]], <2 x float> [[Y]], metadata !"round.tonearest", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    ret <2 x float> [[D]]
;
  %m = call <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float> %y, <2 x float> %x, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  %d = call fast <2 x float> @llvm.experimental.constrained.fdiv.v2f32(<2 x float> %m, <2 x float> %y, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret <2 x float> %d
}

declare double @llvm.experimental.constrained.fmul.f64(double, double, metadata, metadata) #0
declare <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float>, <2 x float>, metadata, metadata) #0

declare float @llvm.experimental.constrained.fdiv.f32(float, float, metadata, metadata) #0
declare double @llvm.experimental.constrained.fdiv.f64(double, double, metadata, metadata) #0
declare <2 x float> @llvm.experimental.constrained.fdiv.v2f32(<2 x float>, <2 x float>, metadata, metadata) #0

declare float @llvm.experimental.constrained.frem.f32(float, float, metadata, metadata) #0

attributes #0 = { strictfp }

