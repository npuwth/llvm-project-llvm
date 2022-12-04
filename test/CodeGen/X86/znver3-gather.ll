; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=znver3 | FileCheck %s --check-prefix=X64

define <8 x i32> @simple(ptr %base, <8 x i32> %offsets) {
; X64-LABEL: simple:
; X64:       # %bb.0:
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm2
; X64-NEXT:    vpmovsxdq %xmm0, %ymm0
; X64-NEXT:    vmovq %rdi, %xmm1
; X64-NEXT:    vpbroadcastq %xmm1, %ymm1
; X64-NEXT:    vpmovsxdq %xmm2, %ymm2
; X64-NEXT:    vpsllq $2, %ymm0, %ymm0
; X64-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; X64-NEXT:    vmovq %xmm0, %r8
; X64-NEXT:    vpextrq $1, %xmm0, %r9
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm0
; X64-NEXT:    vpsllq $2, %ymm2, %ymm2
; X64-NEXT:    vpaddq %ymm2, %ymm1, %ymm2
; X64-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64-NEXT:    vpextrq $1, %xmm0, %r10
; X64-NEXT:    vmovq %xmm0, %rsi
; X64-NEXT:    vextracti128 $1, %ymm2, %xmm0
; X64-NEXT:    vmovq %xmm2, %rdi
; X64-NEXT:    vpextrq $1, %xmm2, %rax
; X64-NEXT:    vpinsrd $1, (%r9), %xmm1, %xmm1
; X64-NEXT:    vmovq %xmm0, %rcx
; X64-NEXT:    vpextrq $1, %xmm0, %rdx
; X64-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-NEXT:    vpinsrd $2, (%rsi), %xmm1, %xmm1
; X64-NEXT:    vpinsrd $1, (%rax), %xmm0, %xmm0
; X64-NEXT:    vpinsrd $3, (%r10), %xmm1, %xmm1
; X64-NEXT:    vpinsrd $2, (%rcx), %xmm0, %xmm0
; X64-NEXT:    vpinsrd $3, (%rdx), %xmm0, %xmm0
; X64-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; X64-NEXT:    retq
  %ptrs = getelementptr inbounds i32, ptr %base, <8 x i32> %offsets
  %wide.masked.gather = call <8 x i32> @llvm.masked.gather.v8i32.v8p0(<8 x ptr> %ptrs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)
  ret <8 x i32> %wide.masked.gather
}

define <8 x i32> @optsize(ptr %base, <8 x i32> %offsets) optsize {
; X64-LABEL: optsize:
; X64:       # %bb.0:
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm2
; X64-NEXT:    vpmovsxdq %xmm0, %ymm0
; X64-NEXT:    vmovq %rdi, %xmm1
; X64-NEXT:    vpbroadcastq %xmm1, %ymm1
; X64-NEXT:    vpmovsxdq %xmm2, %ymm2
; X64-NEXT:    vpsllq $2, %ymm0, %ymm0
; X64-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; X64-NEXT:    vmovq %xmm0, %r8
; X64-NEXT:    vpextrq $1, %xmm0, %r9
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm0
; X64-NEXT:    vpsllq $2, %ymm2, %ymm2
; X64-NEXT:    vpaddq %ymm2, %ymm1, %ymm2
; X64-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64-NEXT:    vpextrq $1, %xmm0, %r10
; X64-NEXT:    vmovq %xmm0, %rsi
; X64-NEXT:    vextracti128 $1, %ymm2, %xmm0
; X64-NEXT:    vmovq %xmm2, %rdi
; X64-NEXT:    vpextrq $1, %xmm2, %rax
; X64-NEXT:    vpinsrd $1, (%r9), %xmm1, %xmm1
; X64-NEXT:    vmovq %xmm0, %rcx
; X64-NEXT:    vpextrq $1, %xmm0, %rdx
; X64-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-NEXT:    vpinsrd $2, (%rsi), %xmm1, %xmm1
; X64-NEXT:    vpinsrd $1, (%rax), %xmm0, %xmm0
; X64-NEXT:    vpinsrd $3, (%r10), %xmm1, %xmm1
; X64-NEXT:    vpinsrd $2, (%rcx), %xmm0, %xmm0
; X64-NEXT:    vpinsrd $3, (%rdx), %xmm0, %xmm0
; X64-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; X64-NEXT:    retq
  %ptrs = getelementptr inbounds i32, ptr %base, <8 x i32> %offsets
  %wide.masked.gather = call <8 x i32> @llvm.masked.gather.v8i32.v8p0(<8 x ptr> %ptrs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)
  ret <8 x i32> %wide.masked.gather
}

define <8 x i32> @minsize(ptr %base, <8 x i32> %offsets) minsize {
; X64-LABEL: minsize:
; X64:       # %bb.0:
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm2
; X64-NEXT:    vpmovsxdq %xmm0, %ymm0
; X64-NEXT:    vmovq %rdi, %xmm1
; X64-NEXT:    vpbroadcastq %xmm1, %ymm1
; X64-NEXT:    vpmovsxdq %xmm2, %ymm2
; X64-NEXT:    vpsllq $2, %ymm0, %ymm0
; X64-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; X64-NEXT:    vmovq %xmm0, %r8
; X64-NEXT:    vpextrq $1, %xmm0, %r9
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm0
; X64-NEXT:    vpsllq $2, %ymm2, %ymm2
; X64-NEXT:    vpaddq %ymm2, %ymm1, %ymm2
; X64-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64-NEXT:    vpextrq $1, %xmm0, %r10
; X64-NEXT:    vmovq %xmm0, %rsi
; X64-NEXT:    vextracti128 $1, %ymm2, %xmm0
; X64-NEXT:    vmovq %xmm2, %rdi
; X64-NEXT:    vpextrq $1, %xmm2, %rax
; X64-NEXT:    vpinsrd $1, (%r9), %xmm1, %xmm1
; X64-NEXT:    vmovq %xmm0, %rcx
; X64-NEXT:    vpextrq $1, %xmm0, %rdx
; X64-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-NEXT:    vpinsrd $2, (%rsi), %xmm1, %xmm1
; X64-NEXT:    vpinsrd $1, (%rax), %xmm0, %xmm0
; X64-NEXT:    vpinsrd $3, (%r10), %xmm1, %xmm1
; X64-NEXT:    vpinsrd $2, (%rcx), %xmm0, %xmm0
; X64-NEXT:    vpinsrd $3, (%rdx), %xmm0, %xmm0
; X64-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; X64-NEXT:    retq
  %ptrs = getelementptr inbounds i32, ptr %base, <8 x i32> %offsets
  %wide.masked.gather = call <8 x i32> @llvm.masked.gather.v8i32.v8p0(<8 x ptr> %ptrs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)
  ret <8 x i32> %wide.masked.gather
}

declare <8 x i32> @llvm.masked.gather.v8i32.v8p0(<8 x ptr>, i32 immarg, <8 x i1>, <8 x i32>)
