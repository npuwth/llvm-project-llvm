; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=skx | FileCheck %s

define i8 @mask8(i8 %x) {
; CHECK-LABEL: mask8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    notb %al
; CHECK-NEXT:    ## kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %m0 = bitcast i8 %x to <8 x i1>
  %m1 = xor <8 x i1> %m0, <i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1>
  %ret = bitcast <8 x i1> %m1 to i8
  ret i8 %ret
}

define void @mask8_mem(ptr %ptr) {
; CHECK-LABEL: mask8_mem:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovb (%rdi), %k0
; CHECK-NEXT:    knotb %k0, %k0
; CHECK-NEXT:    kmovb %k0, (%rdi)
; CHECK-NEXT:    retq
  %x = load i8, ptr %ptr, align 4
  %m0 = bitcast i8 %x to <8 x i1>
  %m1 = xor <8 x i1> %m0, <i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1>
  %ret = bitcast <8 x i1> %m1 to i8
  store i8 %ret, ptr %ptr, align 4
  ret void
}

define i8 @mand8(i8 %x, i8 %y) {
; CHECK-LABEL: mand8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andb %sil, %al
; CHECK-NEXT:    xorb %sil, %dil
; CHECK-NEXT:    orb %dil, %al
; CHECK-NEXT:    retq
  %ma = bitcast i8 %x to <8 x i1>
  %mb = bitcast i8 %y to <8 x i1>
  %mc = and <8 x i1> %ma, %mb
  %md = xor <8 x i1> %ma, %mb
  %me = or <8 x i1> %mc, %md
  %ret = bitcast <8 x i1> %me to i8
  ret i8 %ret
}

define i8 @mand8_mem(ptr %x, ptr %y) {
; CHECK-LABEL: mand8_mem:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovb (%rdi), %k0
; CHECK-NEXT:    kmovb (%rsi), %k1
; CHECK-NEXT:    kandb %k1, %k0, %k2
; CHECK-NEXT:    kxorb %k1, %k0, %k0
; CHECK-NEXT:    korb %k0, %k2, %k0
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    ## kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %ma = load <8 x i1>, ptr %x
  %mb = load <8 x i1>, ptr %y
  %mc = and <8 x i1> %ma, %mb
  %md = xor <8 x i1> %ma, %mb
  %me = or <8 x i1> %mc, %md
  %ret = bitcast <8 x i1> %me to i8
  ret i8 %ret
}
