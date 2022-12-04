; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=x86_64-unknown-linux < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=i386-unknown-linux < %s | FileCheck %s --check-prefix=CHECK-32BIT

; Check CSR split can work properly for tests below.

@a = common dso_local local_unnamed_addr global i32 0, align 4

define dso_local signext i32 @test1(ptr %b) local_unnamed_addr  {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movslq a(%rip), %rax
; CHECK-NEXT:    cmpq %rdi, %rax
; CHECK-NEXT:    je .LBB0_2
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_2: # %if.then
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movq %rdi, %rbx
; CHECK-NEXT:    callq callVoid@PLT
; CHECK-NEXT:    movq %rbx, %rdi
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    jmp callNonVoid@PLT # TAILCALL
;
; CHECK-32BIT-LABEL: test1:
; CHECK-32BIT:       # %bb.0: # %entry
; CHECK-32BIT-NEXT:    subl $12, %esp
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 16
; CHECK-32BIT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32BIT-NEXT:    cmpl %eax, a
; CHECK-32BIT-NEXT:    je .LBB0_2
; CHECK-32BIT-NEXT:  # %bb.1: # %if.end
; CHECK-32BIT-NEXT:    addl $12, %esp
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 4
; CHECK-32BIT-NEXT:    retl
; CHECK-32BIT-NEXT:  .LBB0_2: # %if.then
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 16
; CHECK-32BIT-NEXT:    calll callVoid@PLT
; CHECK-32BIT-NEXT:    addl $12, %esp
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 4
; CHECK-32BIT-NEXT:    jmp callNonVoid@PLT # TAILCALL
entry:
  %0 = load i32, ptr @a, align 4, !tbaa !2
  %conv = sext i32 %0 to i64
  %1 = inttoptr i64 %conv to ptr
  %cmp = icmp eq ptr %1, %b
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = tail call signext i32 @callVoid()
  %call2 = tail call signext i32 @callNonVoid(ptr %b)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %retval.0 = phi i32 [ %call2, %if.then ], [ undef, %entry ]
  ret i32 %retval.0
}

declare signext i32 @callVoid(...) local_unnamed_addr

declare signext i32 @callNonVoid(ptr) local_unnamed_addr

define dso_local signext i32 @test2(ptr %p1) local_unnamed_addr  {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    testq %rdi, %rdi
; CHECK-NEXT:    je .LBB1_2
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    movq %rdi, %rbx
; CHECK-NEXT:    movslq a(%rip), %rax
; CHECK-NEXT:    cmpq %rdi, %rax
; CHECK-NEXT:    je .LBB1_3
; CHECK-NEXT:  .LBB1_2: # %return
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB1_3: # %if.then2
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq callVoid@PLT
; CHECK-NEXT:    movq %rbx, %rdi
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    jmp callNonVoid@PLT # TAILCALL
;
; CHECK-32BIT-LABEL: test2:
; CHECK-32BIT:       # %bb.0: # %entry
; CHECK-32BIT-NEXT:    subl $12, %esp
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 16
; CHECK-32BIT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32BIT-NEXT:    testl %eax, %eax
; CHECK-32BIT-NEXT:    je .LBB1_2
; CHECK-32BIT-NEXT:  # %bb.1: # %if.end
; CHECK-32BIT-NEXT:    cmpl %eax, a
; CHECK-32BIT-NEXT:    je .LBB1_3
; CHECK-32BIT-NEXT:  .LBB1_2: # %return
; CHECK-32BIT-NEXT:    xorl %eax, %eax
; CHECK-32BIT-NEXT:    addl $12, %esp
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 4
; CHECK-32BIT-NEXT:    retl
; CHECK-32BIT-NEXT:  .LBB1_3: # %if.then2
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 16
; CHECK-32BIT-NEXT:    calll callVoid@PLT
; CHECK-32BIT-NEXT:    addl $12, %esp
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 4
; CHECK-32BIT-NEXT:    jmp callNonVoid@PLT # TAILCALL
entry:
  %tobool = icmp eq ptr %p1, null
  br i1 %tobool, label %return, label %if.end

if.end:                                           ; preds = %entry
  %0 = load i32, ptr @a, align 4, !tbaa !2
  %conv = sext i32 %0 to i64
  %1 = inttoptr i64 %conv to ptr
  %cmp = icmp eq ptr %1, %p1
  br i1 %cmp, label %if.then2, label %return

if.then2:                                         ; preds = %if.end
  %call = tail call signext i32 @callVoid()
  %call3 = tail call signext i32 @callNonVoid(ptr nonnull %p1)
  br label %return

return:                                           ; preds = %if.end, %entry, %if.then2
  %retval.0 = phi i32 [ %call3, %if.then2 ], [ 0, %entry ], [ 0, %if.end ]
  ret i32 %retval.0
}


define dso_local ptr @test3(ptr nocapture %p1, i8 zeroext %p2) local_unnamed_addr  {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset %rbx, -24
; CHECK-NEXT:    .cfi_offset %r14, -16
; CHECK-NEXT:    movq (%rdi), %rbx
; CHECK-NEXT:    testq %rbx, %rbx
; CHECK-NEXT:    je .LBB2_2
; CHECK-NEXT:  # %bb.1: # %land.rhs
; CHECK-NEXT:    movq %rdi, %r14
; CHECK-NEXT:    movzbl %sil, %esi
; CHECK-NEXT:    movq %rbx, %rdi
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    movq %rax, (%r14)
; CHECK-NEXT:  .LBB2_2: # %land.end
; CHECK-NEXT:    movq %rbx, %rax
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
;
; CHECK-32BIT-LABEL: test3:
; CHECK-32BIT:       # %bb.0: # %entry
; CHECK-32BIT-NEXT:    pushl %edi
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 8
; CHECK-32BIT-NEXT:    pushl %esi
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 12
; CHECK-32BIT-NEXT:    pushl %eax
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 16
; CHECK-32BIT-NEXT:    .cfi_offset %esi, -12
; CHECK-32BIT-NEXT:    .cfi_offset %edi, -8
; CHECK-32BIT-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK-32BIT-NEXT:    movl (%edi), %esi
; CHECK-32BIT-NEXT:    testl %esi, %esi
; CHECK-32BIT-NEXT:    je .LBB2_2
; CHECK-32BIT-NEXT:  # %bb.1: # %land.rhs
; CHECK-32BIT-NEXT:    subl $8, %esp
; CHECK-32BIT-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK-32BIT-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; CHECK-32BIT-NEXT:    pushl %eax
; CHECK-32BIT-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK-32BIT-NEXT:    pushl %esi
; CHECK-32BIT-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK-32BIT-NEXT:    calll bar@PLT
; CHECK-32BIT-NEXT:    addl $16, %esp
; CHECK-32BIT-NEXT:    .cfi_adjust_cfa_offset -16
; CHECK-32BIT-NEXT:    movl %eax, (%edi)
; CHECK-32BIT-NEXT:  .LBB2_2: # %land.end
; CHECK-32BIT-NEXT:    movl %esi, %eax
; CHECK-32BIT-NEXT:    addl $4, %esp
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 12
; CHECK-32BIT-NEXT:    popl %esi
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 8
; CHECK-32BIT-NEXT:    popl %edi
; CHECK-32BIT-NEXT:    .cfi_def_cfa_offset 4
; CHECK-32BIT-NEXT:    retl
entry:
  %0 = load ptr, ptr %p1, align 8, !tbaa !6
  %tobool = icmp eq ptr %0, null
  br i1 %tobool, label %land.end, label %land.rhs

land.rhs:                                         ; preds = %entry
  %call = tail call ptr @bar(ptr nonnull %0, i8 zeroext %p2)
  store ptr %call, ptr %p1, align 8, !tbaa !6
  br label %land.end

land.end:                                         ; preds = %entry, %land.rhs
  ret ptr %0
}

declare ptr @bar(ptr, i8 zeroext) local_unnamed_addr


!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0 (trunk 367381) (llvm/trunk 367388)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !7, i64 0}
!7 = !{!"any pointer", !4, i64 0}
