; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

	%struct..0anon = type { i32 }
	%struct.binding_level = type { ptr, ptr, ptr, ptr, ptr, ptr, i8, i8, i8, i8, i8, i32, ptr }
	%struct.lang_decl = type opaque
	%struct.rtx_def = type { i16, i8, i8, [1 x %struct..0anon] }
	%struct.tree_decl = type { [12 x i8], ptr, i32, ptr, i32, i8, i8, i8, i8, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, %struct..0anon, { ptr }, ptr, ptr }
	%struct.tree_node = type { %struct.tree_decl }

define fastcc ptr @pushdecl(ptr %x) nounwind  {
; CHECK-LABEL: pushdecl:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movb $1, %al
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %bb17.i
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB0_1: # %bb160
; CHECK-NEXT:    movb $1, %al
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retl
entry:
	%tmp3.i40 = icmp eq ptr null, null		; <i1> [#uses=2]
	br label %bb140
bb140:		; preds = %entry
	br i1 %tmp3.i40, label %bb160, label %bb17.i
bb17.i:		; preds = %bb140
	ret ptr null
bb143:		; preds = %entry
	%tmp8.i43 = load ptr, ptr null, align 4		; <ptr> [#uses=1]
	br i1 %tmp3.i40, label %bb160, label %bb9.i48
bb9.i48:		; preds = %bb143
	ret ptr null
bb160:		; preds = %bb143, %bb140
	%t.0.reg2mem.0 = phi ptr [ null, %bb140 ], [ %tmp8.i43, %bb143 ]		; <ptr> [#uses=1]
	%tmp162 = icmp eq ptr %t.0.reg2mem.0, null		; <i1> [#uses=2]
	br i1 %tmp162, label %bb174, label %bb165
bb165:		; preds = %bb160
	br label %bb174
bb174:		; preds = %bb165, %bb160
	%line.0 = phi i32 [ 0, %bb165 ], [ undef, %bb160 ]		; <i32> [#uses=1]
	%file.0 = phi ptr [ null, %bb165 ], [ undef, %bb160 ]		; <ptr> [#uses=1]
	br i1 %tmp162, label %bb344, label %bb73.i
bb73.i:		; preds = %bb174
	br i1 false, label %bb226.i, label %bb220.i
bb220.i:		; preds = %bb73.i
	ret ptr null
bb226.i:		; preds = %bb73.i
	br i1 false, label %bb260, label %bb273.i
bb273.i:		; preds = %bb226.i
	ret ptr null
bb260:		; preds = %bb226.i
	tail call void (ptr, i32, ...) @pedwarn_with_file_and_line( ptr %file.0, i32 %line.0, ptr null ) nounwind
	ret ptr null
bb344:		; preds = %bb174
	ret ptr null
}

declare void @pedwarn_with_file_and_line(ptr, i32, ...) nounwind