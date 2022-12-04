; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp %s -o - -opaque-pointers | FileCheck %s

; VLDRH.16 Qd, [base, offs, uxtw #1]
define arm_aapcs_vfpcc void @scaled_v8i16_i16(i16* %base, <8 x i16>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: scaled_v8i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> %input, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.16 Qd, [base, offs, uxtw #1]
define arm_aapcs_vfpcc void @scaled_v8f16_i16(i16* %base, <8 x i16>* %offptr, <8 x half> %input) {
; CHECK-LABEL: scaled_v8f16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %i16_ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i16*> %i16_ptrs to <8 x half*>
  call void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half> %input, <8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.16 Qd, [base, offs, uxtw #1]
define arm_aapcs_vfpcc void @scaled_v8f16_half(half* %base, <8 x i16>* %offptr, <8 x half> %input) {
; CHECK-LABEL: scaled_v8f16_half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds half, half* %base, <8 x i32> %offs.zext
  call void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half> %input, <8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand - sext offset
define arm_aapcs_vfpcc void @scaled_v8i16_sext(i16* %base, <8 x i16>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: scaled_v8i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vmov.u16 r6, q0[0]
; CHECK-NEXT:    vshl.i32 q1, q1, #1
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vmov r2, r3, d2
; CHECK-NEXT:    vmov r12, lr, d3
; CHECK-NEXT:    vldrh.s32 q1, [r1, #8]
; CHECK-NEXT:    vshl.i32 q1, q1, #1
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmov r4, r5, d3
; CHECK-NEXT:    strh r6, [r2]
; CHECK-NEXT:    vmov.u16 r2, q0[1]
; CHECK-NEXT:    strh r2, [r3]
; CHECK-NEXT:    vmov.u16 r2, q0[2]
; CHECK-NEXT:    strh.w r2, [r12]
; CHECK-NEXT:    vmov.u16 r2, q0[3]
; CHECK-NEXT:    strh.w r2, [lr]
; CHECK-NEXT:    vmov.u16 r2, q0[4]
; CHECK-NEXT:    strh r2, [r0]
; CHECK-NEXT:    vmov.u16 r0, q0[5]
; CHECK-NEXT:    strh r0, [r1]
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    strh r0, [r4]
; CHECK-NEXT:    vmov.u16 r0, q0[7]
; CHECK-NEXT:    strh r0, [r5]
; CHECK-NEXT:    pop {r4, r5, r6, pc}
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.sext = sext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.sext
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> %input, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand - sext offset
define arm_aapcs_vfpcc void @scaled_v8f16_sext(i16* %base, <8 x i16>* %offptr, <8 x half> %input) {
; CHECK-LABEL: scaled_v8f16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vshl.i32 q2, q1, #1
; CHECK-NEXT:    vldrh.s32 q1, [r1, #8]
; CHECK-NEXT:    vadd.i32 q2, q2, r0
; CHECK-NEXT:    vmov r1, r2, d4
; CHECK-NEXT:    vshl.i32 q1, q1, #1
; CHECK-NEXT:    vstr.16 s0, [r1]
; CHECK-NEXT:    vmovx.f16 s0, s0
; CHECK-NEXT:    vstr.16 s0, [r2]
; CHECK-NEXT:    vmov r1, r2, d5
; CHECK-NEXT:    vmovx.f16 s0, s1
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vstr.16 s1, [r1]
; CHECK-NEXT:    vstr.16 s0, [r2]
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmovx.f16 s0, s2
; CHECK-NEXT:    vstr.16 s2, [r0]
; CHECK-NEXT:    vstr.16 s0, [r1]
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmovx.f16 s0, s3
; CHECK-NEXT:    vstr.16 s3, [r0]
; CHECK-NEXT:    vstr.16 s0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.sext = sext <8 x i16> %offs to <8 x i32>
  %i16_ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.sext
  %ptrs = bitcast <8 x i16*> %i16_ptrs to <8 x half*>
  call void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half> %input, <8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.16 Qd, [base, zext(offs), uxtw #1]
define arm_aapcs_vfpcc void @unsigned_scaled_v8i16_i8(i16* %base, <8 x i8>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: unsigned_scaled_v8i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> %input, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.16 Qd, [base, zext(offs), uxtw #1]
define arm_aapcs_vfpcc void @unsigned_scaled_v8f16_i8(i16* %base, <8 x i8>* %offptr, <8 x half> %input) {
; CHECK-LABEL: unsigned_scaled_v8f16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %i16_ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i16*> %i16_ptrs to <8 x half*>
  call void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half> %input, <8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define arm_aapcs_vfpcc void @scaled_v8i16_i16_passthru_icmp0(i16* %base, <8 x i16>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: scaled_v8i16_i16_passthru_icmp0:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vpt.s16 gt, q1, zr
; CHECK-NEXT:    vstrht.16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %mask = icmp sgt <8 x i16> %offs, zeroinitializer
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> %input, <8 x i16*> %ptrs, i32 2, <8 x i1> %mask)
  ret void
}

define arm_aapcs_vfpcc void @scaled_v8i16_i16_2gep(i16* %base, <8 x i16>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: scaled_v8i16_i16_2gep:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    mov.w r12, #40
; CHECK-NEXT:    vmov.u16 r6, q0[0]
; CHECK-NEXT:    vshl.i32 q1, q1, #1
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vadd.i32 q1, q1, r12
; CHECK-NEXT:    vmov r3, r2, d2
; CHECK-NEXT:    vmov lr, r5, d3
; CHECK-NEXT:    vldrh.s32 q1, [r1, #8]
; CHECK-NEXT:    vshl.i32 q1, q1, #1
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vadd.i32 q1, q1, r12
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmov r4, r12, d3
; CHECK-NEXT:    strh r6, [r3]
; CHECK-NEXT:    vmov.u16 r3, q0[1]
; CHECK-NEXT:    strh r3, [r2]
; CHECK-NEXT:    vmov.u16 r2, q0[2]
; CHECK-NEXT:    strh.w r2, [lr]
; CHECK-NEXT:    vmov.u16 r2, q0[3]
; CHECK-NEXT:    strh r2, [r5]
; CHECK-NEXT:    vmov.u16 r2, q0[4]
; CHECK-NEXT:    strh r2, [r0]
; CHECK-NEXT:    vmov.u16 r0, q0[5]
; CHECK-NEXT:    strh r0, [r1]
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    strh r0, [r4]
; CHECK-NEXT:    vmov.u16 r0, q0[7]
; CHECK-NEXT:    strh.w r0, [r12]
; CHECK-NEXT:    pop {r4, r5, r6, pc}
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i16> %offs
  %ptrs2 = getelementptr inbounds i16, <8 x i16*> %ptrs, i16 20
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> %input, <8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define arm_aapcs_vfpcc void @scaled_v8i16_i16_2gep2(i16* %base, <8 x i16>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: scaled_v8i16_i16_2gep2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r1, .LCPI9_0
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1]
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI9_0:
; CHECK-NEXT:    .short 40 @ 0x28
; CHECK-NEXT:    .short 46 @ 0x2e
; CHECK-NEXT:    .short 52 @ 0x34
; CHECK-NEXT:    .short 58 @ 0x3a
; CHECK-NEXT:    .short 64 @ 0x40
; CHECK-NEXT:    .short 70 @ 0x46
; CHECK-NEXT:    .short 76 @ 0x4c
; CHECK-NEXT:    .short 82 @ 0x52
entry:
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i16> <i16 0, i16 3, i16 6, i16 9, i16 12, i16 15, i16 18, i16 21>
  %ptrs2 = getelementptr inbounds i16, <8 x i16*> %ptrs, i16 20
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> %input, <8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

declare void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16>, <8 x i16*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half>, <8 x half*>, i32, <8 x i1>)
