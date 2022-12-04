; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+v,+zfh,+experimental-zvfh < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+m,+v,+zfh,+experimental-zvfh < %s | FileCheck %s

declare <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i7(<vscale x 2 x i7>, <vscale x 2 x i1>, i32)

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i7(<vscale x 2 x i7> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vadd.vv v8, v8, v8
; CHECK-NEXT:    vsra.vi v9, v8, 1
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vfwcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i7(<vscale x 2 x i7> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x half> %v
}

declare <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i8(<vscale x 2 x i8>, <vscale x 2 x i1>, i32)

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vfwcvt.f.x.v v9, v8, v0.t
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x half> %v
}

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i8_unmasked(<vscale x 2 x i8> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i8_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vfwcvt.f.x.v v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x half> %v
}

declare <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i16(<vscale x 2 x i16>, <vscale x 2 x i1>, i32)

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x half> %v
}

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i16_unmasked(<vscale x 2 x i16> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x half> %v
}

declare <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i1>, i32)

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfncvt.f.x.w v9, v8, v0.t
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x half> %v
}

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i32_unmasked(<vscale x 2 x i32> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfncvt.f.x.w v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x half> %v
}

declare <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i1>, i32)

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfncvt.f.x.w v10, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vfncvt.f.f.w v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x half> %v
}

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i64_unmasked(<vscale x 2 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfncvt.f.x.w v10, v8
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vfncvt.f.f.w v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x half> %v
}

declare <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i8(<vscale x 2 x i8>, <vscale x 2 x i1>, i32)

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8, v0.t
; CHECK-NEXT:    vfwcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x float> %v
}

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i8_unmasked(<vscale x 2 x i8> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i8_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    vfwcvt.f.x.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x float> %v
}

declare <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i16(<vscale x 2 x i16>, <vscale x 2 x i1>, i32)

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfwcvt.f.x.v v9, v8, v0.t
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x float> %v
}

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i16_unmasked(<vscale x 2 x i16> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfwcvt.f.x.v v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x float> %v
}

declare <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i1>, i32)

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x float> %v
}

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i32_unmasked(<vscale x 2 x i32> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x float> %v
}

declare <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i1>, i32)

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfncvt.f.x.w v10, v8, v0.t
; CHECK-NEXT:    vmv.v.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x float> %v
}

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i64_unmasked(<vscale x 2 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfncvt.f.x.w v10, v8
; CHECK-NEXT:    vmv.v.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x float> %v
}

declare <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i8(<vscale x 2 x i8>, <vscale x 2 x i1>, i32)

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vsext.vf4 v10, v8, v0.t
; CHECK-NEXT:    vfwcvt.f.x.v v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x double> %v
}

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i8_unmasked(<vscale x 2 x i8> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i8_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vsext.vf4 v10, v8
; CHECK-NEXT:    vfwcvt.f.x.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x double> %v
}

declare <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i16(<vscale x 2 x i16>, <vscale x 2 x i1>, i32)

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vsext.vf2 v10, v8, v0.t
; CHECK-NEXT:    vfwcvt.f.x.v v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x double> %v
}

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i16_unmasked(<vscale x 2 x i16> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vsext.vf2 v10, v8
; CHECK-NEXT:    vfwcvt.f.x.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x double> %v
}

declare <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i1>, i32)

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfwcvt.f.x.v v10, v8, v0.t
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x double> %v
}

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i32_unmasked(<vscale x 2 x i32> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfwcvt.f.x.v v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x double> %v
}

declare <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i1>, i32)

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x double> %v
}

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i64_unmasked(<vscale x 2 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x double> %v
}

declare <vscale x 32 x float> @llvm.vp.sitofp.nxv32f32.nxv32i32(<vscale x 32 x i32>, <vscale x 32 x i1>, i32)

define <vscale x 32 x float> @vsitofp_nxv32f32_nxv32i32(<vscale x 32 x i32> %va, <vscale x 32 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv32f32_nxv32i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v24, v0
; CHECK-NEXT:    li a2, 0
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    srli a4, a1, 2
; CHECK-NEXT:    vsetvli a3, zero, e8, mf2, ta, mu
; CHECK-NEXT:    slli a1, a1, 1
; CHECK-NEXT:    sub a3, a0, a1
; CHECK-NEXT:    vslidedown.vx v0, v0, a4
; CHECK-NEXT:    bltu a0, a3, .LBB25_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a2, a3
; CHECK-NEXT:  .LBB25_2:
; CHECK-NEXT:    vsetvli zero, a2, e32, m8, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    bltu a0, a1, .LBB25_4
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:  .LBB25_4:
; CHECK-NEXT:    vsetvli zero, a0, e32, m8, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v24
; CHECK-NEXT:    vfcvt.f.x.v v8, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 32 x float> @llvm.vp.sitofp.nxv32f32.nxv32i32(<vscale x 32 x i32> %va, <vscale x 32 x i1> %m, i32 %evl)
  ret <vscale x 32 x float> %v
}

define <vscale x 32 x float> @vsitofp_nxv32f32_nxv32i32_unmasked(<vscale x 32 x i32> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv32f32_nxv32i32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    slli a1, a1, 1
; CHECK-NEXT:    mv a2, a0
; CHECK-NEXT:    bltu a0, a1, .LBB26_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a2, a1
; CHECK-NEXT:  .LBB26_2:
; CHECK-NEXT:    li a3, 0
; CHECK-NEXT:    vsetvli zero, a2, e32, m8, ta, mu
; CHECK-NEXT:    sub a1, a0, a1
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    bltu a0, a1, .LBB26_4
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    mv a3, a1
; CHECK-NEXT:  .LBB26_4:
; CHECK-NEXT:    vsetvli zero, a3, e32, m8, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v16, v16
; CHECK-NEXT:    ret
  %v = call <vscale x 32 x float> @llvm.vp.sitofp.nxv32f32.nxv32i32(<vscale x 32 x i32> %va, <vscale x 32 x i1> shufflevector (<vscale x 32 x i1> insertelement (<vscale x 32 x i1> undef, i1 true, i32 0), <vscale x 32 x i1> undef, <vscale x 32 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 32 x float> %v
}
