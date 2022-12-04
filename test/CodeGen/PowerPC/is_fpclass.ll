; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr9 -verify-machineinstrs -o - %s | FileCheck %s


define i1 @isnan_float(float %x) nounwind {
; CHECK-LABEL: isnan_float:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fcmpu 0, 1, 1
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    isel 3, 4, 3, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f32(float %x, i32 3)  ; nan
  ret i1 %1
}

define i1 @isnan_double(double %x) nounwind {
; CHECK-LABEL: isnan_double:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fcmpu 0, 1, 1
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    isel 3, 4, 3, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f64(double %x, i32 3)  ; nan
  ret i1 %1
}

define i1 @isnan_ppc_fp128(ppc_fp128 %x) nounwind {
; CHECK-LABEL: isnan_ppc_fp128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fcmpu 0, 1, 1
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    isel 3, 4, 3, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.ppcf128(ppc_fp128 %x, i32 3)  ; nan
  ret i1 %1
}

define i1 @isnan_f128(fp128 %x) nounwind {
; CHECK-LABEL: isnan_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xscmpuqp 0, 2, 2
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    isel 3, 4, 3, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f128(fp128 %x, i32 3)  ; nan
  ret i1 %1
}

define i1 @isnan_float_strictfp(float %x) strictfp nounwind {
; CHECK-LABEL: isnan_float_strictfp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xscvdpspn 0, 1
; CHECK-NEXT:    lis 4, 32640
; CHECK-NEXT:    mffprwz 3, 0
; CHECK-NEXT:    clrlwi 3, 3, 1
; CHECK-NEXT:    cmpw 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    iselgt 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f32(float %x, i32 3)  ; nan
  ret i1 %1
}

define i1 @isnan_double_strictfp(double %x) strictfp nounwind {
; CHECK-LABEL: isnan_double_strictfp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mffprd 3, 1
; CHECK-NEXT:    li 4, 2047
; CHECK-NEXT:    clrldi 3, 3, 1
; CHECK-NEXT:    rldic 4, 4, 52, 1
; CHECK-NEXT:    cmpd 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    iselgt 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f64(double %x, i32 3)  ; nan
  ret i1 %1
}

define i1 @isnan_ppc_fp128_strictfp(ppc_fp128 %x) strictfp nounwind {
; CHECK-LABEL: isnan_ppc_fp128_strictfp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mffprd 3, 1
; CHECK-NEXT:    li 4, 2047
; CHECK-NEXT:    clrldi 3, 3, 1
; CHECK-NEXT:    rldic 4, 4, 52, 1
; CHECK-NEXT:    cmpd 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    iselgt 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.ppcf128(ppc_fp128 %x, i32 3)  ; nan
  ret i1 %1
}

define i1 @isnan_f128_strictfp(fp128 %x) strictfp nounwind {
; CHECK-LABEL: isnan_f128_strictfp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stxv 34, -16(1)
; CHECK-NEXT:    li 5, 32767
; CHECK-NEXT:    ld 4, -8(1)
; CHECK-NEXT:    ld 3, -16(1)
; CHECK-NEXT:    rldic 5, 5, 48, 1
; CHECK-NEXT:    clrldi 4, 4, 1
; CHECK-NEXT:    cmpld 4, 5
; CHECK-NEXT:    cmpd 1, 4, 5
; CHECK-NEXT:    crandc 20, 5, 2
; CHECK-NEXT:    cmpdi 1, 3, 0
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    crandc 21, 2, 6
; CHECK-NEXT:    crnor 20, 21, 20
; CHECK-NEXT:    isel 3, 0, 3, 20
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f128(fp128 %x, i32 3)  ; nan
  ret i1 %1
}

define i1 @isinf_float(float %x) nounwind {
; CHECK-LABEL: isinf_float:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xscvdpspn 0, 1
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    mffprwz 3, 0
; CHECK-NEXT:    clrlwi 3, 3, 1
; CHECK-NEXT:    xoris 3, 3, 32640
; CHECK-NEXT:    cmplwi 3, 0
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    iseleq 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f32(float %x, i32 516)  ; 0x204 = "inf"
  ret i1 %1
}

define i1 @isinf_ppc_fp128(ppc_fp128 %x) nounwind {
; CHECK-LABEL: isinf_ppc_fp128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mffprd 3, 1
; CHECK-NEXT:    li 4, 2047
; CHECK-NEXT:    clrldi 3, 3, 1
; CHECK-NEXT:    rldic 4, 4, 52, 1
; CHECK-NEXT:    cmpd 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    iseleq 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.ppcf128(ppc_fp128 %x, i32 516)  ; 0x204 = "inf"
  ret i1 %1
}

define i1 @isinf_f128(fp128 %x) nounwind {
; CHECK-LABEL: isinf_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stxv 34, -16(1)
; CHECK-NEXT:    li 5, 32767
; CHECK-NEXT:    ld 4, -8(1)
; CHECK-NEXT:    ld 3, -16(1)
; CHECK-NEXT:    rldic 5, 5, 48, 1
; CHECK-NEXT:    clrldi 4, 4, 1
; CHECK-NEXT:    xor 4, 4, 5
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    cntlzd 3, 3
; CHECK-NEXT:    rldicl 3, 3, 58, 63
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f128(fp128 %x, i32 516)  ; 0x204 = "inf"
  ret i1 %1
}

define i1 @isfinite_float(float %x) nounwind {
; CHECK-LABEL: isfinite_float:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xscvdpspn 0, 1
; CHECK-NEXT:    lis 4, 32640
; CHECK-NEXT:    mffprwz 3, 0
; CHECK-NEXT:    clrlwi 3, 3, 1
; CHECK-NEXT:    cmpw 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    isellt 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f32(float %x, i32 504)  ; 0x1f8 = "finite"
  ret i1 %1
}

define i1 @isfinite_f128(fp128 %x) nounwind {
; CHECK-LABEL: isfinite_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stxv 34, -16(1)
; CHECK-NEXT:    li 4, 32767
; CHECK-NEXT:    ld 3, -8(1)
; CHECK-NEXT:    rldic 4, 4, 48, 1
; CHECK-NEXT:    clrldi 3, 3, 1
; CHECK-NEXT:    cmpd 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    isellt 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f128(fp128 %x, i32 504)  ; 0x1f8 = "finite"
  ret i1 %1
}

define i1 @isnormal_float(float %x) nounwind {
; CHECK-LABEL: isnormal_float:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xscvdpspn 0, 1
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    mffprwz 3, 0
; CHECK-NEXT:    clrlwi 3, 3, 1
; CHECK-NEXT:    addis 3, 3, -128
; CHECK-NEXT:    srwi 3, 3, 24
; CHECK-NEXT:    cmplwi 3, 127
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    isellt 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f32(float %x, i32 264)  ; 0x108 = "normal"
  ret i1 %1
}

define i1 @isnormal_f128(fp128 %x) nounwind {
; CHECK-LABEL: isnormal_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stxv 34, -16(1)
; CHECK-NEXT:    li 4, -1
; CHECK-NEXT:    ld 3, -8(1)
; CHECK-NEXT:    rldic 4, 4, 48, 0
; CHECK-NEXT:    clrldi 3, 3, 1
; CHECK-NEXT:    add 3, 3, 4
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    rldicl 3, 3, 15, 49
; CHECK-NEXT:    cmpldi 3, 16383
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    isellt 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f128(fp128 %x, i32 264)  ; 0x108 = "normal"
  ret i1 %1
}

define i1 @issubnormal_float(float %x) nounwind {
; CHECK-LABEL: issubnormal_float:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xscvdpspn 0, 1
; CHECK-NEXT:    lis 4, 127
; CHECK-NEXT:    ori 4, 4, 65535
; CHECK-NEXT:    mffprwz 3, 0
; CHECK-NEXT:    clrlwi 3, 3, 1
; CHECK-NEXT:    addi 3, 3, -1
; CHECK-NEXT:    cmplw 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    isellt 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f32(float %x, i32 144)  ; 0x90 = "subnormal"
  ret i1 %1
}

define i1 @issubnormal_f128(fp128 %x) nounwind {
; CHECK-LABEL: issubnormal_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stxv 34, -16(1)
; CHECK-NEXT:    li 5, -1
; CHECK-NEXT:    ld 4, -8(1)
; CHECK-NEXT:    ld 3, -16(1)
; CHECK-NEXT:    rldic 5, 5, 0, 16
; CHECK-NEXT:    clrldi 4, 4, 1
; CHECK-NEXT:    addic 3, 3, -1
; CHECK-NEXT:    addme 4, 4
; CHECK-NEXT:    cmpdi 1, 3, -1
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    cmpld 4, 5
; CHECK-NEXT:    crandc 20, 0, 2
; CHECK-NEXT:    crandc 21, 2, 6
; CHECK-NEXT:    crnor 20, 21, 20
; CHECK-NEXT:    isel 3, 0, 3, 20
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f128(fp128 %x, i32 144)  ; 0x90 = "subnormal"
  ret i1 %1
}

define i1 @iszero_float(float %x) nounwind {
; CHECK-LABEL: iszero_float:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xxlxor 0, 0, 0
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    fcmpu 0, 1, 0
; CHECK-NEXT:    iseleq 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f32(float %x, i32 96)  ; 0x60 = "zero"
  ret i1 %1
}

define i1 @iszero_f128(fp128 %x) nounwind {
; CHECK-LABEL: iszero_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addis 3, 2, .LCPI18_0@toc@ha
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    addi 3, 3, .LCPI18_0@toc@l
; CHECK-NEXT:    lxv 35, 0(3)
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    xscmpuqp 0, 2, 3
; CHECK-NEXT:    iseleq 3, 4, 3
; CHECK-NEXT:    blr
  %1 = call i1 @llvm.is.fpclass.f128(fp128 %x, i32 96)  ; 0x60 = "zero"
  ret i1 %1
}

declare i1 @llvm.is.fpclass.f32(float, i32)
declare i1 @llvm.is.fpclass.f64(double, i32)
declare i1 @llvm.is.fpclass.ppcf128(ppc_fp128, i32)
declare i1 @llvm.is.fpclass.f128(fp128, i32)
