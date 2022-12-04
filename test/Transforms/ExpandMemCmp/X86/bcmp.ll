; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -expandmemcmp -memcmp-num-loads-per-block=1 -mtriple=x86_64-unknown-unknown -data-layout=e-m:o-i64:64-f80:128-n8:16:32:64-S128         < %s | FileCheck %s --check-prefix=X64

declare i32 @bcmp(i8* nocapture, i8* nocapture, i64)

define i32 @bcmp8(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X64-LABEL: @bcmp8(
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]], align 1
; X64-NEXT:    [[TMP4:%.*]] = load i64, i64* [[TMP2]], align 1
; X64-NEXT:    [[TMP5:%.*]] = icmp ne i64 [[TMP3]], [[TMP4]]
; X64-NEXT:    [[TMP6:%.*]] = zext i1 [[TMP5]] to i32
; X64-NEXT:    ret i32 [[TMP6]]
;
  %call = tail call i32 @bcmp(i8* %x, i8* %y, i64 8)
  ret i32 %call
}

