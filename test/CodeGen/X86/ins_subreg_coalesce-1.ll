; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=-bmi | FileCheck %s

define fastcc i32 @t() nounwind  {
; CHECK-LABEL: t:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movzwl 0, %eax
; CHECK-NEXT:    orl $2, %eax
; CHECK-NEXT:    movw %ax, 0
; CHECK-NEXT:    shrl $3, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    retl
entry:
	br i1 false, label %UnifiedReturnBlock, label %bb4
bb4:		; preds = %entry
	br i1 false, label %bb17, label %bb22
bb17:		; preds = %bb4
	ret i32 1
bb22:		; preds = %bb4
	br i1 true, label %walkExprTree.exit, label %bb4.i
bb4.i:		; preds = %bb22
	ret i32 0
walkExprTree.exit:		; preds = %bb22
	%tmp83 = load i16, ptr null, align 4		; <i16> [#uses=1]
	%tmp84 = or i16 %tmp83, 2		; <i16> [#uses=2]
	store i16 %tmp84, ptr null, align 4
	%tmp98993 = zext i16 %tmp84 to i32		; <i32> [#uses=1]
	%tmp1004 = lshr i32 %tmp98993, 3		; <i32> [#uses=1]
	%tmp100.lobit5 = and i32 %tmp1004, 1		; <i32> [#uses=1]
	ret i32 %tmp100.lobit5
UnifiedReturnBlock:		; preds = %entry
	ret i32 0
}
