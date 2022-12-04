; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686 -mattr=cmov | FileCheck %s --check-prefix=X86

declare  i4  @llvm.sshl.sat.i4   (i4,  i4)
declare  i8  @llvm.sshl.sat.i8   (i8,  i8)
declare  i15 @llvm.sshl.sat.i15  (i15, i15)
declare  i16 @llvm.sshl.sat.i16  (i16, i16)
declare  i18 @llvm.sshl.sat.i18  (i18, i18)
declare  i32 @llvm.sshl.sat.i32  (i32, i32)
declare  i64 @llvm.sshl.sat.i64  (i64, i64)

define i16 @func(i16 %x, i16 %y) nounwind {
; X64-LABEL: func:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %edx
; X64-NEXT:    shll %cl, %edx
; X64-NEXT:    movswl %dx, %esi
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    sarl %cl, %esi
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testw %di, %di
; X64-NEXT:    sets %al
; X64-NEXT:    addl $32767, %eax # imm = 0x7FFF
; X64-NEXT:    cmpw %si, %di
; X64-NEXT:    cmovel %edx, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shll %cl, %esi
; X86-NEXT:    movswl %si, %edi
; X86-NEXT:    sarl %cl, %edi
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testw %dx, %dx
; X86-NEXT:    sets %al
; X86-NEXT:    addl $32767, %eax # imm = 0x7FFF
; X86-NEXT:    cmpw %di, %dx
; X86-NEXT:    cmovel %esi, %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl
  %tmp = call i16 @llvm.sshl.sat.i16(i16 %x, i16 %y)
  ret i16 %tmp
}

define i16 @func2(i8 %x, i8 %y) nounwind {
; X64-LABEL: func2:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movsbl %dil, %eax
; X64-NEXT:    addl %eax, %eax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    testw %ax, %ax
; X64-NEXT:    sets %dl
; X64-NEXT:    addl $32767, %edx # imm = 0x7FFF
; X64-NEXT:    movl %eax, %esi
; X64-NEXT:    shll %cl, %esi
; X64-NEXT:    movswl %si, %edi
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    sarl %cl, %edi
; X64-NEXT:    cmpw %di, %ax
; X64-NEXT:    cmovnel %edx, %esi
; X64-NEXT:    movswl %si, %eax
; X64-NEXT:    shrl %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movsbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    addl %eax, %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shll %cl, %edx
; X86-NEXT:    movswl %dx, %esi
; X86-NEXT:    sarl %cl, %esi
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    testw %ax, %ax
; X86-NEXT:    sets %cl
; X86-NEXT:    addl $32767, %ecx # imm = 0x7FFF
; X86-NEXT:    cmpw %si, %ax
; X86-NEXT:    cmovel %edx, %ecx
; X86-NEXT:    movswl %cx, %eax
; X86-NEXT:    shrl %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %x2 = sext i8 %x to i15
  %y2 = sext i8 %y to i15
  %tmp = call i15 @llvm.sshl.sat.i15(i15 %x2, i15 %y2)
  %tmp2 = sext i15 %tmp to i16
  ret i16 %tmp2
}

define i16 @func3(i15 %x, i8 %y) nounwind {
; X64-LABEL: func3:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    shll $7, %ecx
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll %cl, %eax
; X64-NEXT:    movswl %ax, %edx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    sarl %cl, %edx
; X64-NEXT:    xorl %ecx, %ecx
; X64-NEXT:    testw %di, %di
; X64-NEXT:    sets %cl
; X64-NEXT:    addl $32767, %ecx # imm = 0x7FFF
; X64-NEXT:    cmpw %dx, %di
; X64-NEXT:    cmovel %eax, %ecx
; X64-NEXT:    movswl %cx, %eax
; X64-NEXT:    shrl %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func3:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    shll $7, %ecx
; X86-NEXT:    addl %eax, %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shll %cl, %edx
; X86-NEXT:    movswl %dx, %esi
; X86-NEXT:    # kill: def $cl killed $cl killed $ecx
; X86-NEXT:    sarl %cl, %esi
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    testw %ax, %ax
; X86-NEXT:    sets %cl
; X86-NEXT:    addl $32767, %ecx # imm = 0x7FFF
; X86-NEXT:    cmpw %si, %ax
; X86-NEXT:    cmovel %edx, %ecx
; X86-NEXT:    movswl %cx, %eax
; X86-NEXT:    shrl %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %y2 = sext i8 %y to i15
  %y3 = shl i15 %y2, 7
  %tmp = call i15 @llvm.sshl.sat.i15(i15 %x, i15 %y3)
  %tmp2 = sext i15 %tmp to i16
  ret i16 %tmp2
}

define i4 @func4(i4 %x, i4 %y) nounwind {
; X64-LABEL: func4:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    andb $15, %cl
; X64-NEXT:    shlb $4, %dil
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb %cl, %al
; X64-NEXT:    movzbl %al, %esi
; X64-NEXT:    movl %esi, %edx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    sarb %cl, %dl
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    sets %al
; X64-NEXT:    addl $127, %eax
; X64-NEXT:    cmpb %dl, %dil
; X64-NEXT:    cmovel %esi, %eax
; X64-NEXT:    sarb $4, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func4:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andb $15, %cl
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    shlb $4, %dl
; X86-NEXT:    movb %dl, %ch
; X86-NEXT:    shlb %cl, %ch
; X86-NEXT:    movzbl %ch, %esi
; X86-NEXT:    sarb %cl, %ch
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testb %dl, %dl
; X86-NEXT:    sets %al
; X86-NEXT:    addl $127, %eax
; X86-NEXT:    cmpb %ch, %dl
; X86-NEXT:    cmovel %esi, %eax
; X86-NEXT:    sarb $4, %al
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %tmp = call i4 @llvm.sshl.sat.i4(i4 %x, i4 %y)
  ret i4 %tmp
}

define i64 @func5(i64 %x, i64 %y) nounwind {
; X64-LABEL: func5:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testq %rdi, %rdi
; X64-NEXT:    sets %al
; X64-NEXT:    movabsq $9223372036854775807, %rdx # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    addq %rax, %rdx
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shlq %cl, %rax
; X64-NEXT:    movq %rax, %rsi
; X64-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-NEXT:    sarq %cl, %rsi
; X64-NEXT:    cmpq %rsi, %rdi
; X64-NEXT:    cmovneq %rdx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func5:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %edx, %ebx
; X86-NEXT:    shll %cl, %ebx
; X86-NEXT:    movl %eax, %esi
; X86-NEXT:    shldl %cl, %edx, %esi
; X86-NEXT:    xorl %edi, %edi
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    cmovnel %ebx, %esi
; X86-NEXT:    cmovel %ebx, %edi
; X86-NEXT:    movl %esi, %edx
; X86-NEXT:    sarl %cl, %edx
; X86-NEXT:    movl %esi, %ebx
; X86-NEXT:    sarl $31, %ebx
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    cmovel %edx, %ebx
; X86-NEXT:    movl %edi, %ebp
; X86-NEXT:    shrdl %cl, %esi, %ebp
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    cmovnel %edx, %ebp
; X86-NEXT:    xorl %eax, %ebx
; X86-NEXT:    xorl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    sarl $31, %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    xorl $2147483647, %edx # imm = 0x7FFFFFFF
; X86-NEXT:    orl %ebx, %ebp
; X86-NEXT:    notl %eax
; X86-NEXT:    cmovel %edi, %eax
; X86-NEXT:    cmovel %esi, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.sshl.sat.i64(i64 %x, i64 %y)
  ret i64 %tmp
}

define i18 @func6(i16 %x, i16 %y) nounwind {
; X64-LABEL: func6:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movswl %di, %edx
; X64-NEXT:    shll $14, %edx
; X64-NEXT:    movl %edx, %esi
; X64-NEXT:    shll %cl, %esi
; X64-NEXT:    movl %esi, %edi
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    sarl %cl, %edi
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testl %edx, %edx
; X64-NEXT:    sets %al
; X64-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X64-NEXT:    cmpl %edi, %edx
; X64-NEXT:    cmovel %esi, %eax
; X64-NEXT:    sarl $14, %eax
; X64-NEXT:    retq
;
; X86-LABEL: func6:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movswl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    shll $14, %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shll %cl, %esi
; X86-NEXT:    movl %esi, %edi
; X86-NEXT:    sarl %cl, %edi
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testl %edx, %edx
; X86-NEXT:    sets %al
; X86-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X86-NEXT:    cmpl %edi, %edx
; X86-NEXT:    cmovel %esi, %eax
; X86-NEXT:    sarl $14, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl
  %x2 = sext i16 %x to i18
  %y2 = sext i16 %y to i18
  %tmp = call i18 @llvm.sshl.sat.i18(i18 %x2, i18 %y2)
  ret i18 %tmp
}

define i32 @func7(i32 %x, i32 %y) nounwind {
; X64-LABEL: func7:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %edx
; X64-NEXT:    shll %cl, %edx
; X64-NEXT:    movl %edx, %esi
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    sarl %cl, %esi
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    sets %al
; X64-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X64-NEXT:    cmpl %esi, %edi
; X64-NEXT:    cmovel %edx, %eax
; X64-NEXT:    retq
;
; X86-LABEL: func7:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shll %cl, %esi
; X86-NEXT:    movl %esi, %edi
; X86-NEXT:    sarl %cl, %edi
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testl %edx, %edx
; X86-NEXT:    sets %al
; X86-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X86-NEXT:    cmpl %edi, %edx
; X86-NEXT:    cmovel %esi, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl
  %tmp = call i32 @llvm.sshl.sat.i32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i8 @func8(i8 %x, i8 %y) nounwind {
; X64-LABEL: func8:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb %cl, %al
; X64-NEXT:    movzbl %al, %esi
; X64-NEXT:    movl %esi, %edx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    sarb %cl, %dl
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    sets %al
; X64-NEXT:    addl $127, %eax
; X64-NEXT:    cmpb %dl, %dil
; X64-NEXT:    cmovel %esi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func8:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movb %dl, %ch
; X86-NEXT:    shlb %cl, %ch
; X86-NEXT:    movzbl %ch, %esi
; X86-NEXT:    sarb %cl, %ch
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testb %dl, %dl
; X86-NEXT:    sets %al
; X86-NEXT:    addl $127, %eax
; X86-NEXT:    cmpb %ch, %dl
; X86-NEXT:    cmovel %esi, %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %tmp = call i8 @llvm.sshl.sat.i8(i8 %x, i8 %y)
  ret i8 %tmp
}
