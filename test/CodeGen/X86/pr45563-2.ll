; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple=x86_64-linux-generic -mattr=avx < %s | FileCheck %s

; Bug 45563:
; The SplitVecRes_MLOAD method should split a extended value type
; according to the halving of the enveloping type to avoid all sorts
; of inconsistencies downstream. For example for a extended value type
; with VL=14 and enveloping type VL=16 that is split 8/8, the extended
; type should be split 8/6 and not 7/7. This also accounts for hi masked
; load that get zero storage size (and are unused).

define <9 x float> @mload_split9(<9 x i1> %mask, ptr %addr, <9 x float> %dst) {
; CHECK-LABEL: mload_split9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm6[0],xmm4[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1,2],xmm7[0]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],xmm2[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; CHECK-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rdi
; CHECK-NEXT:    vmovd %esi, %xmm2
; CHECK-NEXT:    vpinsrw $1, %edx, %xmm2, %xmm2
; CHECK-NEXT:    vpinsrw $2, %ecx, %xmm2, %xmm2
; CHECK-NEXT:    vpinsrw $3, %r8d, %xmm2, %xmm2
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm3 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
; CHECK-NEXT:    vpslld $31, %xmm3, %xmm3
; CHECK-NEXT:    vpinsrw $4, %r9d, %xmm2, %xmm2
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $5, %ecx, %xmm2, %xmm2
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $6, %ecx, %xmm2, %xmm2
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $7, %ecx, %xmm2, %xmm2
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm2 = xmm2[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm2, %xmm2
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; CHECK-NEXT:    vmaskmovps (%rdi), %ymm2, %ymm3
; CHECK-NEXT:    vblendvps %ymm2, %ymm3, %ymm0, %ymm0
; CHECK-NEXT:    movzbl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vmovd %ecx, %xmm2
; CHECK-NEXT:    vpslld $31, %xmm2, %xmm2
; CHECK-NEXT:    vmaskmovps 32(%rdi), %ymm2, %ymm3
; CHECK-NEXT:    vblendvps %xmm2, %xmm3, %xmm1, %xmm1
; CHECK-NEXT:    vmovss %xmm1, 32(%rax)
; CHECK-NEXT:    vmovaps %ymm0, (%rax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %res = call <9 x float> @llvm.masked.load.v9f32.p0(ptr %addr, i32 4, <9 x i1>%mask, <9 x float> %dst)
  ret <9 x float> %res
}

define <13 x float> @mload_split13(<13 x i1> %mask, ptr %addr, <13 x float> %dst) {
; CHECK-LABEL: mload_split13:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm6[0],xmm4[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1,2],xmm7[0]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],xmm2[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm2
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm0[0,1,2],mem[0]
; CHECK-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rdi
; CHECK-NEXT:    vmovd %esi, %xmm3
; CHECK-NEXT:    vpinsrw $1, %edx, %xmm3, %xmm3
; CHECK-NEXT:    vpinsrw $2, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpinsrw $3, %r8d, %xmm3, %xmm3
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    vpinsrw $4, %r9d, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $5, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $6, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $7, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm3[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm3, %xmm3
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm4, %ymm3
; CHECK-NEXT:    vmaskmovps (%rdi), %ymm3, %ymm4
; CHECK-NEXT:    vblendvps %ymm3, %ymm4, %ymm2, %ymm2
; CHECK-NEXT:    movzbl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vmovd %ecx, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $1, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $2, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $3, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $4, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm3[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm3, %xmm3
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm4, %ymm5
; CHECK-NEXT:    vmaskmovps 32(%rdi), %ymm5, %ymm5
; CHECK-NEXT:    vblendvps %xmm4, %xmm5, %xmm1, %xmm1
; CHECK-NEXT:    vmovaps %xmm1, 32(%rax)
; CHECK-NEXT:    vextractf128 $1, %ymm5, %xmm1
; CHECK-NEXT:    vblendvps %xmm3, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vmovss %xmm0, 48(%rax)
; CHECK-NEXT:    vmovaps %ymm2, (%rax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %res = call <13 x float> @llvm.masked.load.v13f32.p0(ptr %addr, i32 4, <13 x i1>%mask, <13 x float> %dst)
  ret <13 x float> %res
}

define <14 x float> @mload_split14(<14 x i1> %mask, ptr %addr, <14 x float> %dst) {
; CHECK-LABEL: mload_split14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm6[0],xmm4[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1,2],xmm7[0]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],xmm2[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm2
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; CHECK-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rdi
; CHECK-NEXT:    vmovd %esi, %xmm3
; CHECK-NEXT:    vpinsrw $1, %edx, %xmm3, %xmm3
; CHECK-NEXT:    vpinsrw $2, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpinsrw $3, %r8d, %xmm3, %xmm3
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    vpinsrw $4, %r9d, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $5, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $6, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $7, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm3[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm3, %xmm3
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm4, %ymm3
; CHECK-NEXT:    vmaskmovps (%rdi), %ymm3, %ymm4
; CHECK-NEXT:    vblendvps %ymm3, %ymm4, %ymm2, %ymm2
; CHECK-NEXT:    movzbl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vmovd %ecx, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $1, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $2, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $3, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $4, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    vpinsrw $5, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm3[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm3, %xmm3
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm4, %ymm5
; CHECK-NEXT:    vmaskmovps 32(%rdi), %ymm5, %ymm5
; CHECK-NEXT:    vextractf128 $1, %ymm5, %xmm6
; CHECK-NEXT:    vblendvps %xmm3, %xmm6, %xmm1, %xmm1
; CHECK-NEXT:    vmovlps %xmm1, 48(%rax)
; CHECK-NEXT:    vblendvps %xmm4, %xmm5, %xmm0, %xmm0
; CHECK-NEXT:    vmovaps %xmm0, 32(%rax)
; CHECK-NEXT:    vmovaps %ymm2, (%rax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %res = call <14 x float> @llvm.masked.load.v14f32.p0(ptr %addr, i32 4, <14 x i1>%mask, <14 x float> %dst)
  ret <14 x float> %res
}

define <17 x float> @mload_split17(<17 x i1> %mask, ptr %addr, <17 x float> %dst) {
; CHECK-LABEL: mload_split17:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm6[0],xmm4[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1,2],xmm7[0]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],xmm2[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm2
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; CHECK-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm1
; CHECK-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    movzbl {{[0-9]+}}(%rsp), %edi
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %r10
; CHECK-NEXT:    vmovd %esi, %xmm3
; CHECK-NEXT:    vpinsrb $2, %edx, %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $4, %ecx, %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $6, %r8d, %xmm3, %xmm3
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $8, %r9d, %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $10, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $12, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $14, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm3[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm3, %xmm3
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm4, %ymm3
; CHECK-NEXT:    vmaskmovps (%r10), %ymm3, %ymm4
; CHECK-NEXT:    vblendvps %ymm3, %ymm4, %ymm2, %ymm2
; CHECK-NEXT:    vmovd {{.*#+}} xmm3 = mem[0],zero,zero,zero
; CHECK-NEXT:    vpinsrb $2, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $4, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $6, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $8, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $10, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $12, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpinsrb $14, {{[0-9]+}}(%rsp), %xmm3, %xmm3
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm3[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm3, %xmm3
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm4, %ymm3
; CHECK-NEXT:    vmaskmovps 32(%r10), %ymm3, %ymm4
; CHECK-NEXT:    vblendvps %ymm3, %ymm4, %ymm1, %ymm1
; CHECK-NEXT:    vmovd %edi, %xmm3
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
; CHECK-NEXT:    vpslld $31, %xmm3, %xmm3
; CHECK-NEXT:    vmaskmovps 64(%r10), %ymm3, %ymm4
; CHECK-NEXT:    vblendvps %xmm3, %xmm4, %xmm0, %xmm0
; CHECK-NEXT:    vmovss %xmm0, 64(%rax)
; CHECK-NEXT:    vmovaps %ymm1, 32(%rax)
; CHECK-NEXT:    vmovaps %ymm2, (%rax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %res = call <17 x float> @llvm.masked.load.v17f32.p0(ptr %addr, i32 4, <17 x i1>%mask, <17 x float> %dst)
  ret <17 x float> %res
}

define <23 x float> @mload_split23(<23 x i1> %mask, ptr %addr, <23 x float> %dst) {
; CHECK-LABEL: mload_split23:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm6[0],xmm4[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1,2],xmm7[0]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],xmm2[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm3
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; CHECK-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm2
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; CHECK-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; CHECK-NEXT:    movzbl {{[0-9]+}}(%rsp), %edi
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %r10
; CHECK-NEXT:    vmovd %esi, %xmm4
; CHECK-NEXT:    vpinsrb $2, %edx, %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $4, %ecx, %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $6, %r8d, %xmm4, %xmm4
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
; CHECK-NEXT:    vpslld $31, %xmm5, %xmm5
; CHECK-NEXT:    vpinsrb $8, %r9d, %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $10, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $12, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $14, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm4 = xmm4[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm5, %ymm4
; CHECK-NEXT:    vmaskmovps (%r10), %ymm4, %ymm5
; CHECK-NEXT:    vblendvps %ymm4, %ymm5, %ymm3, %ymm3
; CHECK-NEXT:    vmovd {{.*#+}} xmm4 = mem[0],zero,zero,zero
; CHECK-NEXT:    vpinsrb $2, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $4, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $6, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
; CHECK-NEXT:    vpslld $31, %xmm5, %xmm5
; CHECK-NEXT:    vpinsrb $8, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $10, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $12, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $14, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm4 = xmm4[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm5, %ymm4
; CHECK-NEXT:    vmaskmovps 32(%r10), %ymm4, %ymm5
; CHECK-NEXT:    vblendvps %ymm4, %ymm5, %ymm2, %ymm2
; CHECK-NEXT:    vmovd %edi, %xmm4
; CHECK-NEXT:    vpinsrb $2, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $4, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $6, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
; CHECK-NEXT:    vpslld $31, %xmm5, %xmm5
; CHECK-NEXT:    vpinsrb $8, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $10, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpinsrb $12, {{[0-9]+}}(%rsp), %xmm4, %xmm4
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm4 = xmm4[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpslld $31, %xmm4, %xmm4
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm5, %ymm6
; CHECK-NEXT:    vmaskmovps 64(%r10), %ymm6, %ymm6
; CHECK-NEXT:    vmovaps %ymm2, 32(%rax)
; CHECK-NEXT:    vextractf128 $1, %ymm6, %xmm2
; CHECK-NEXT:    vblendvps %xmm4, %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vextractps $2, %xmm1, 88(%rax)
; CHECK-NEXT:    vmovlps %xmm1, 80(%rax)
; CHECK-NEXT:    vblendvps %xmm5, %xmm6, %xmm0, %xmm0
; CHECK-NEXT:    vmovaps %xmm0, 64(%rax)
; CHECK-NEXT:    vmovaps %ymm3, (%rax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %res = call <23 x float> @llvm.masked.load.v23f32.p0(ptr %addr, i32 4, <23 x i1>%mask, <23 x float> %dst)
  ret <23 x float> %res
}

declare <9 x float> @llvm.masked.load.v9f32.p0(ptr %addr, i32 %align, <9 x i1> %mask, <9 x float> %dst)
declare <13 x float> @llvm.masked.load.v13f32.p0(ptr %addr, i32 %align, <13 x i1> %mask, <13 x float> %dst)
declare <14 x float> @llvm.masked.load.v14f32.p0(ptr %addr, i32 %align, <14 x i1> %mask, <14 x float> %dst)
declare <17 x float> @llvm.masked.load.v17f32.p0(ptr %addr, i32 %align, <17 x i1> %mask, <17 x float> %dst)
declare <23 x float> @llvm.masked.load.v23f32.p0(ptr %addr, i32 %align, <23 x i1> %mask, <23 x float> %dst)
