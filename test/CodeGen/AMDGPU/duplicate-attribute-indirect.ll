; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -amdgpu-annotate-kernel-features  %s | FileCheck -check-prefix=AKF_GCN %s
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -amdgpu-attributor %s | FileCheck -check-prefix=ATTRIBUTOR_GCN %s

define internal void @indirect() {
; AKF_GCN-LABEL: define {{[^@]+}}@indirect() {
; AKF_GCN-NEXT:    ret void
;
; ATTRIBUTOR_GCN-LABEL: define {{[^@]+}}@indirect
; ATTRIBUTOR_GCN-SAME: () #[[ATTR0:[0-9]+]] {
; ATTRIBUTOR_GCN-NEXT:    ret void
;
  ret void
}

define amdgpu_kernel void @test_simple_indirect_call() #0 {
; AKF_GCN-LABEL: define {{[^@]+}}@test_simple_indirect_call
; AKF_GCN-SAME: () #[[ATTR0:[0-9]+]] {
; AKF_GCN-NEXT:    [[FPTR:%.*]] = alloca void ()*, align 8
; AKF_GCN-NEXT:    store void ()* @indirect, void ()** [[FPTR]], align 8
; AKF_GCN-NEXT:    [[FP:%.*]] = load void ()*, void ()** [[FPTR]], align 8
; AKF_GCN-NEXT:    call void [[FP]]()
; AKF_GCN-NEXT:    ret void
;
; ATTRIBUTOR_GCN-LABEL: define {{[^@]+}}@test_simple_indirect_call
; ATTRIBUTOR_GCN-SAME: () #[[ATTR1:[0-9]+]] {
; ATTRIBUTOR_GCN-NEXT:    [[FPTR:%.*]] = alloca void ()*, align 8
; ATTRIBUTOR_GCN-NEXT:    store void ()* @indirect, void ()** [[FPTR]], align 8
; ATTRIBUTOR_GCN-NEXT:    [[FP:%.*]] = load void ()*, void ()** [[FPTR]], align 8
; ATTRIBUTOR_GCN-NEXT:    call void [[FP]]()
; ATTRIBUTOR_GCN-NEXT:    ret void
;
  %fptr = alloca void()*
  store void()* @indirect, void()** %fptr
  %fp = load void()*, void()** %fptr
  call void %fp()
  ret void
}

attributes #0 = { "amdgpu-no-dispatch-id" }

;.
; AKF_GCN: attributes #[[ATTR0]] = { "amdgpu-calls" "amdgpu-no-dispatch-id" "amdgpu-stack-objects" }
;.
; ATTRIBUTOR_GCN: attributes #[[ATTR0]] = { "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_GCN: attributes #[[ATTR1]] = { "amdgpu-no-dispatch-id" "uniform-work-group-size"="false" }
;.
