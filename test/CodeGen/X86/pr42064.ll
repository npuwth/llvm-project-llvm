; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-pc-windows-msvc19.11.0 -mattr=+avx,+cx16 | FileCheck %s

%struct.TestStruct = type { %union.Int128 }
%union.Int128 = type { i128 }
%struct.SomeArrays = type { %struct.SillyArray, %struct.SillyArray, %struct.SillyArray }
%struct.SillyArray = type { ptr, i32, i32 }

declare void @llvm.lifetime.start.p0(i64, ptr)

define void @foo(ptr %arg) align 2 personality ptr @__CxxFrameHandler3 {
; Check that %rbx is being used for a frame pointer
; CHECK-LABEL: foo:
; CHECK:         movq %rsp, %rbx

; Check that %rbx is saved and restored around both lock cmpxchg16b.
; CHECK:         movq %rbx, %r9
; CHECK-NEXT:    movabsq $1393743441367457520, %rcx # imm = 0x135792468ABCDEF0
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    movq %rcx, %rdx
; CHECK-NEXT:    movq %rcx, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%r8)
; CHECK-NEXT:    movq %r9, %rbx

; CHECK:         movq %rbx, %r9
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    movq %rcx, %rdx
; CHECK-NEXT:    movq %rcx, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%r8)
; CHECK-NEXT:    movq %r9, %rbx
bb:
  %i = alloca %struct.SomeArrays, align 8
  %i1 = alloca %struct.SomeArrays, align 8
  %i3 = cmpxchg ptr %arg, i128 25710028567316702934644703134494809840, i128 25710028567316702934644703134494809840 seq_cst seq_cst
  %i4 = extractvalue { i128, i1 } %i3, 0
  %i5 = trunc i128 %i4 to i64
  %i6 = icmp eq i64 %i5, 0
  br i1 %i6, label %bb9, label %bb7

bb7:                                              ; preds = %bb
  %i8 = cmpxchg ptr %arg, i128 25710028567316702934644703134494809840, i128 25710028567316702934644703134494809840 seq_cst seq_cst
  br label %bb9

bb9:                                              ; preds = %bb7, %bb
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %i)
  call void @llvm.memset.p0.i64(ptr nonnull align 8 dereferenceable(48) %i, i8 0, i64 48, i1 false)
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %i1)
  call void @llvm.memset.p0.i64(ptr nonnull align 8 dereferenceable(48) %i1, i8 0, i64 48, i1 false)
  %i13 = invoke nonnull align 8 dereferenceable(48) ptr @"??4SomeArrays@@QEAAAEAU0@$$QEAU0@@Z"(ptr nonnull %i, ptr nonnull align 8 dereferenceable(48) %i1)
          to label %bb14 unwind label %bb45

bb14:                                             ; preds = %bb9
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %i)
  ret void

bb45:                                             ; preds = %bb9
  %i46 = cleanuppad within none []
  %i47 = getelementptr inbounds %struct.SomeArrays, ptr %i1, i64 0, i32 2, i32 0
  %i48 = load ptr, ptr %i47, align 8
  invoke void @"?free@@YAXPEAX@Z"(ptr %i48) [ "funclet"(token %i46) ]
          to label %bb51 unwind label %bb49

bb49:                                             ; preds = %bb45
  %i50 = cleanuppad within %i46 []
  call void @__std_terminate() [ "funclet"(token %i50) ]
  unreachable

bb51:                                             ; preds = %bb45
  %i52 = getelementptr inbounds %struct.SomeArrays, ptr %i1, i64 0, i32 1, i32 0
  %i53 = load ptr, ptr %i52, align 8
  invoke void @"?free@@YAXPEAX@Z"(ptr %i53) [ "funclet"(token %i46) ]
          to label %bb56 unwind label %bb54

bb54:                                             ; preds = %bb51
  %i55 = cleanuppad within %i46 []
  call void @__std_terminate() [ "funclet"(token %i55) ]
  unreachable

bb56:                                             ; preds = %bb51
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %i)
  cleanupret from %i46 unwind to caller
}

declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture)

declare void @llvm.memset.p0.i64(ptr, i8, i64, i1)

declare dso_local i32 @__CxxFrameHandler3(...)

declare nonnull align 8 dereferenceable(48) ptr @"??4SomeArrays@@QEAAAEAU0@$$QEAU0@@Z"(ptr, ptr nonnull align 8 dereferenceable(48)) align 2

declare void @"?free@@YAXPEAX@Z"(ptr)

declare void @__std_terminate()
