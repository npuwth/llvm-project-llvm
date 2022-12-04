; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc i32 @build_v2i_v2i1_1() {
; CHECK-LABEL: build_v2i_v2i1_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #65535
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v2i1(<2 x i1> <i1 1, i1 1>)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_v2i_v2i1_0() {
; CHECK-LABEL: build_v2i_v2i1_0:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v2i1(<2 x i1> <i1 0, i1 0>)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_v2i_v2i1_5() {
; CHECK-LABEL: build_v2i_v2i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    mov.w r0, #65280
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v2i1(<2 x i1> <i1 0, i1 1>)
  ret i32 %r
}

define arm_aapcs_vfpcc i32 @build_v2i_v4i1_1() {
; CHECK-LABEL: build_v2i_v4i1_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #65535
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1> <i1 1, i1 1, i1 1, i1 1>)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_v2i_v4i1_0() {
; CHECK-LABEL: build_v2i_v4i1_0:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1> <i1 0, i1 0, i1 0, i1 0>)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_v2i_v4i1_5() {
; CHECK-LABEL: build_v2i_v4i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1> <i1 0, i1 1, i1 0, i1 1>)
  ret i32 %r
}

define arm_aapcs_vfpcc i32 @build_v2i_v8i1_1() {
; CHECK-LABEL: build_v2i_v8i1_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #65535
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> <i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1>)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_v2i_v8i1_0() {
; CHECK-LABEL: build_v2i_v8i1_0:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> <i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0>)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_v2i_v8i1_5() {
; CHECK-LABEL: build_v2i_v8i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #52428
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  ret i32 %r
}

define arm_aapcs_vfpcc i32 @build_v2i_v16i1_1() {
; CHECK-LABEL: build_v2i_v16i1_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #65535
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1> <i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1>)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_v2i_v16i1_0() {
; CHECK-LABEL: build_v2i_v16i1_0:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1> <i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0>)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_v2i_v16i1_5() {
; CHECK-LABEL: build_v2i_v16i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #43690
; CHECK-NEXT:    bx lr
  %r = call i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  ret i32 %r
}



define arm_aapcs_vfpcc <2 x i64> @build_i2v_v2i1_1() {
; CHECK-LABEL: build_i2v_v2i1_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #65535
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 65535)
  %r = select <2 x i1> %c, <2 x i64> <i64 18446744073709551615, i64 18446744073709551615>, <2 x i64> <i64 0, i64 0>
  ret <2 x i64> %r
}
define arm_aapcs_vfpcc <2 x i64> @build_i2v_v2i1_0() {
; CHECK-LABEL: build_i2v_v2i1_0:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 0)
  %r = select <2 x i1> %c, <2 x i64> <i64 18446744073709551615, i64 18446744073709551615>, <2 x i64> <i64 0, i64 0>
  ret <2 x i64> %r
}
define arm_aapcs_vfpcc <2 x i64> @build_i2v_v2i1_5() {
; CHECK-LABEL: build_i2v_v2i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 61680)
  %r = select <2 x i1> %c, <2 x i64> <i64 18446744073709551615, i64 18446744073709551615>, <2 x i64> <i64 0, i64 0>
  ret <2 x i64> %r
}

define arm_aapcs_vfpcc <4 x i32> @build_i2v_v4i1_1() {
; CHECK-LABEL: build_i2v_v4i1_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #65535
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 65535)
  %r = select <4 x i1> %c, <4 x i32> <i32 4294967295, i32 4294967295, i32 4294967295, i32 4294967295>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %r
}
define arm_aapcs_vfpcc <4 x i32> @build_i2v_v4i1_0() {
; CHECK-LABEL: build_i2v_v4i1_0:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 0)
  %r = select <4 x i1> %c, <4 x i32> <i32 4294967295, i32 4294967295, i32 4294967295, i32 4294967295>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %r
}
define arm_aapcs_vfpcc <4 x i32> @build_i2v_v4i1_5() {
; CHECK-LABEL: build_i2v_v4i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 61680)
  %r = select <4 x i1> %c, <4 x i32> <i32 4294967295, i32 4294967295, i32 4294967295, i32 4294967295>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %r
}

define arm_aapcs_vfpcc <8 x i16> @build_i2v_v8i1_1() {
; CHECK-LABEL: build_i2v_v8i1_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #65535
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 65535)
  %r = select <8 x i1> %c, <8 x i16> <i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535>, <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <8 x i16> %r
}
define arm_aapcs_vfpcc <8 x i16> @build_i2v_v8i1_0() {
; CHECK-LABEL: build_i2v_v8i1_0:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 0)
  %r = select <8 x i1> %c, <8 x i16> <i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535>, <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <8 x i16> %r
}
define arm_aapcs_vfpcc <8 x i16> @build_i2v_v8i1_5() {
; CHECK-LABEL: build_i2v_v8i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #52428
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 52428)
  %r = select <8 x i1> %c, <8 x i16> <i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535>, <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <8 x i16> %r
}

define arm_aapcs_vfpcc <16 x i8> @build_i2v_v16i1_1() {
; CHECK-LABEL: build_i2v_v16i1_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #65535
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 65535)
  %r = select <16 x i1> %c, <16 x i8> <i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255>, <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
  ret <16 x i8> %r
}
define arm_aapcs_vfpcc <16 x i8> @build_i2v_v16i1_0() {
; CHECK-LABEL: build_i2v_v16i1_0:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 0)
  %r = select <16 x i1> %c, <16 x i8> <i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255>, <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
  ret <16 x i8> %r
}
define arm_aapcs_vfpcc <16 x i8> @build_i2v_v16i1_5() {
; CHECK-LABEL: build_i2v_v16i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #43690
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %c = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 43690)
  %r = select <16 x i1> %c, <16 x i8> <i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255>, <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
  ret <16 x i8> %r
}


define arm_aapcs_vfpcc i32 @build_i2v2i_v2i1_5() {
; CHECK-LABEL: build_i2v2i_v2i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    bx lr
  %c = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 61680)
  %r = call i32 @llvm.arm.mve.pred.v2i.v2i1(<2 x i1> %c)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_i2v2i_v4i1_5() {
; CHECK-LABEL: build_i2v2i_v4i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    bx lr
  %c = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 61680)
  %r = call i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1> %c)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_i2v2i_v8i1_5() {
; CHECK-LABEL: build_i2v2i_v8i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #52428
; CHECK-NEXT:    bx lr
  %c = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 52428)
  %r = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> %c)
  ret i32 %r
}
define arm_aapcs_vfpcc i32 @build_i2v2i_v16i1_5() {
; CHECK-LABEL: build_i2v2i_v16i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #43690
; CHECK-NEXT:    bx lr
  %c = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 43690)
  %r = call i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1> %c)
  ret i32 %r
}


define arm_aapcs_vfpcc <2 x i64> @build_v2i2v_v4i1_v2i1_5() {
; CHECK-LABEL: build_v2i2v_v4i1_v2i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1> <i1 0, i1 1, i1 0, i1 1>)
  %c = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 %b)
  %r = select <2 x i1> %c, <2 x i64> <i64 -1, i64 -1>, <2 x i64> zeroinitializer
  ret <2 x i64> %r
}
define arm_aapcs_vfpcc <2 x i64> @build_v2i2v_v8i1_v2i1_5() {
; CHECK-LABEL: build_v2i2v_v8i1_v2i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #52428
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  %c = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 %b)
  %r = select <2 x i1> %c, <2 x i64> <i64 -1, i64 -1>, <2 x i64> zeroinitializer
  ret <2 x i64> %r
}
define arm_aapcs_vfpcc <2 x i64> @build_v2i2v_v16i1_v2i1_5() {
; CHECK-LABEL: build_v2i2v_v16i1_v2i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #43690
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  %c = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 %b)
  %r = select <2 x i1> %c, <2 x i64> <i64 -1, i64 -1>, <2 x i64> zeroinitializer
  ret <2 x i64> %r
}

define arm_aapcs_vfpcc <4 x i32> @build_v2i2v_v4i1_v4i1_5() {
; CHECK-LABEL: build_v2i2v_v4i1_v4i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1> <i1 0, i1 1, i1 0, i1 1>)
  %c = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %b)
  %r = select <4 x i1> %c, <4 x i32> <i32 4294967295, i32 4294967295, i32 4294967295, i32 4294967295>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %r
}
define arm_aapcs_vfpcc <4 x i32> @build_v2i2v_v8i1_v4i1_5() {
; CHECK-LABEL: build_v2i2v_v8i1_v4i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #52428
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  %c = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %b)
  %r = select <4 x i1> %c, <4 x i32> <i32 4294967295, i32 4294967295, i32 4294967295, i32 4294967295>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %r
}
define arm_aapcs_vfpcc <4 x i32> @build_v2i2v_v16i1_v4i1_5() {
; CHECK-LABEL: build_v2i2v_v16i1_v4i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #43690
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  %c = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %b)
  %r = select <4 x i1> %c, <4 x i32> <i32 4294967295, i32 4294967295, i32 4294967295, i32 4294967295>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %r
}

define arm_aapcs_vfpcc <8 x i16> @build_v2i2v_v4i1_v8i1_5() {
; CHECK-LABEL: build_v2i2v_v4i1_v8i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1> <i1 0, i1 1, i1 0, i1 1>)
  %c = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %b)
  %r = select <8 x i1> %c, <8 x i16> <i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535>, <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <8 x i16> %r
}
define arm_aapcs_vfpcc <8 x i16> @build_v2i2v_v8i1_v8i1_5() {
; CHECK-LABEL: build_v2i2v_v8i1_v8i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #52428
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  %c = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %b)
  %r = select <8 x i1> %c, <8 x i16> <i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535>, <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <8 x i16> %r
}
define arm_aapcs_vfpcc <8 x i16> @build_v2i2v_v16i1_v8i1_5() {
; CHECK-LABEL: build_v2i2v_v16i1_v8i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #43690
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  %c = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %b)
  %r = select <8 x i1> %c, <8 x i16> <i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535, i16 65535>, <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <8 x i16> %r
}

define arm_aapcs_vfpcc <16 x i8> @build_v2i2v_v4i1_v16i1_5() {
; CHECK-LABEL: build_v2i2v_v4i1_v16i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #61680
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1> <i1 0, i1 1, i1 0, i1 1>)
  %c = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %b)
  %r = select <16 x i1> %c, <16 x i8> <i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255>, <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
  ret <16 x i8> %r
}
define arm_aapcs_vfpcc <16 x i8> @build_v2i2v_v8i1_v16i1_5() {
; CHECK-LABEL: build_v2i2v_v8i1_v16i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #52428
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  %c = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %b)
  %r = select <16 x i1> %c, <16 x i8> <i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255>, <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
  ret <16 x i8> %r
}
define arm_aapcs_vfpcc <16 x i8> @build_v2i2v_v16i1_v16i1_5() {
; CHECK-LABEL: build_v2i2v_v16i1_v16i1_5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #43690
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    bx lr
  %b = call i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1> <i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0, i1 1>)
  %c = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %b)
  %r = select <16 x i1> %c, <16 x i8> <i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255>, <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
  ret <16 x i8> %r
}

declare i32 @llvm.arm.mve.pred.v2i.v2i1(<2 x i1>)
declare i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1>)
declare i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1>)
declare i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1>)

declare <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32)
declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)
declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32)
