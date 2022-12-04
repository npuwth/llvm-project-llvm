; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 < %s | FileCheck -check-prefix=GCN %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 < %s | FileCheck -check-prefix=GFX10 %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1100 -amdgpu-enable-delay-alu=0 < %s | FileCheck -check-prefix=GFX10 %s

define float @v_constained_fma_f32_fpexcept_strict(float %x, float %y, float %z) #0 {
; GCN-LABEL: v_constained_fma_f32_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, v0, v1, v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fma_f32_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call float @llvm.experimental.constrained.fma.f32(float %x, float %y, float %z, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define <2 x float> @v_constained_fma_v2f32_fpexcept_strict(<2 x float> %x, <2 x float> %y, <2 x float> %z) #0 {
; GCN-LABEL: v_constained_fma_v2f32_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, v0, v2, v4
; GCN-NEXT:    v_fma_f32 v1, v1, v3, v5
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fma_v2f32_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v0, v2, v4
; GFX10-NEXT:    v_fma_f32 v1, v1, v3, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x float> @llvm.experimental.constrained.fma.v2f32(<2 x float> %x, <2 x float> %y, <2 x float> %z, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %val
}

define <3 x float> @v_constained_fma_v3f32_fpexcept_strict(<3 x float> %x, <3 x float> %y, <3 x float> %z) #0 {
; GCN-LABEL: v_constained_fma_v3f32_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, v0, v3, v6
; GCN-NEXT:    v_fma_f32 v1, v1, v4, v7
; GCN-NEXT:    v_fma_f32 v2, v2, v5, v8
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fma_v3f32_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v0, v3, v6
; GFX10-NEXT:    v_fma_f32 v1, v1, v4, v7
; GFX10-NEXT:    v_fma_f32 v2, v2, v5, v8
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <3 x float> @llvm.experimental.constrained.fma.v3f32(<3 x float> %x, <3 x float> %y, <3 x float> %z, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <3 x float> %val
}

define <4 x float> @v_constained_fma_v4f32_fpexcept_strict(<4 x float> %x, <4 x float> %y, <4 x float> %z) #0 {
; GCN-LABEL: v_constained_fma_v4f32_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, v0, v4, v8
; GCN-NEXT:    v_fma_f32 v1, v1, v5, v9
; GCN-NEXT:    v_fma_f32 v2, v2, v6, v10
; GCN-NEXT:    v_fma_f32 v3, v3, v7, v11
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fma_v4f32_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v0, v4, v8
; GFX10-NEXT:    v_fma_f32 v1, v1, v5, v9
; GFX10-NEXT:    v_fma_f32 v2, v2, v6, v10
; GFX10-NEXT:    v_fma_f32 v3, v3, v7, v11
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <4 x float> @llvm.experimental.constrained.fma.v4f32(<4 x float> %x, <4 x float> %y, <4 x float> %z, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x float> %val
}

define float @v_constained_fma_f32_fpexcept_strict_fneg(float %x, float %y, float %z) #0 {
; GCN-LABEL: v_constained_fma_f32_fpexcept_strict_fneg:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fma_f32_fpexcept_strict_fneg:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.z = fneg float %z
  %val = call float @llvm.experimental.constrained.fma.f32(float %x, float %y, float %neg.z, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define float @v_constained_fma_f32_fpexcept_strict_fneg_fneg(float %x, float %y, float %z) #0 {
; GCN-LABEL: v_constained_fma_f32_fpexcept_strict_fneg_fneg:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, -v0, -v1, v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fma_f32_fpexcept_strict_fneg_fneg:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, -v0, -v1, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.x = fneg float %x
  %neg.y = fneg float %y
  %val = call float @llvm.experimental.constrained.fma.f32(float %neg.x, float %neg.y, float %z, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define float @v_constained_fma_f32_fpexcept_strict_fabs_fabs(float %x, float %y, float %z) #0 {
; GCN-LABEL: v_constained_fma_f32_fpexcept_strict_fabs_fabs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, |v0|, |v1|, v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fma_f32_fpexcept_strict_fabs_fabs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, |v0|, |v1|, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.x = call float @llvm.fabs.f32(float %x)
  %neg.y = call float @llvm.fabs.f32(float %y)
  %val = call float @llvm.experimental.constrained.fma.f32(float %neg.x, float %neg.y, float %z, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define <2 x float> @v_constained_fma_v2f32_fpexcept_strict_fneg_fneg(<2 x float> %x, <2 x float> %y, <2 x float> %z) #0 {
; GCN-LABEL: v_constained_fma_v2f32_fpexcept_strict_fneg_fneg:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, -v0, -v2, v4
; GCN-NEXT:    v_fma_f32 v1, -v1, -v3, v5
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fma_v2f32_fpexcept_strict_fneg_fneg:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, -v0, -v2, v4
; GFX10-NEXT:    v_fma_f32 v1, -v1, -v3, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.x = fneg <2 x float> %x
  %neg.y = fneg <2 x float> %y
  %val = call <2 x float> @llvm.experimental.constrained.fma.v2f32(<2 x float> %neg.x, <2 x float> %neg.y, <2 x float> %z, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %val
}

declare float @llvm.fabs.f32(float) #1
declare float @llvm.experimental.constrained.fma.f32(float, float, float, metadata, metadata) #1
declare <2 x float> @llvm.experimental.constrained.fma.v2f32(<2 x float>, <2 x float>, <2 x float>, metadata, metadata) #1
declare <3 x float> @llvm.experimental.constrained.fma.v3f32(<3 x float>, <3 x float>, <3 x float>, metadata, metadata) #1
declare <4 x float> @llvm.experimental.constrained.fma.v4f32(<4 x float>, <4 x float>, <4 x float>, metadata, metadata) #1

attributes #0 = { strictfp }
attributes #1 = { inaccessiblememonly nounwind willreturn }
