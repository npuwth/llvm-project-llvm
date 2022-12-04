; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

@dst = global i32 0             ; <ptr> [#uses=1]
@ptr = global ptr null         ; <ptr> [#uses=1]

define void @test() {
; CHECK-LABEL: test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $dst, ptr
; CHECK-NEXT:    retl
        store ptr @dst, ptr @ptr
        ret void
}

