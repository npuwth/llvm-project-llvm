; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O2                   -S -mattr=avx < %s | FileCheck %s
; RUN: opt -passes="default<O2>" -S -mattr=avx < %s | FileCheck %s

target triple = "x86_64--"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Eliminate redundant shuffles

define <2 x i64> @shuffle_32_add_16_shuffle_32_masks_are_eq(<2 x i64> %v) {
; CHECK-LABEL: @shuffle_32_add_16_shuffle_32_masks_are_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[V:%.*]] to <8 x i16>
; CHECK-NEXT:    [[TMP2:%.*]] = shl <8 x i16> [[TMP1]], <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
; CHECK-NEXT:    [[BC5:%.*]] = bitcast <8 x i16> [[TMP2]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[BC5]]
;
  %bc0 = bitcast <2 x i64> %v to <4 x i32>
  %shuffle = shufflevector <4 x i32> %bc0, <4 x i32> zeroinitializer, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %bc1 = bitcast <4 x i32> %shuffle to <2 x i64>
  %bc2 = bitcast <2 x i64> %bc1 to <8 x i16>
  %add.i = add <8 x i16> %bc2, %bc2
  %bc3 = bitcast <8 x i16> %add.i to <2 x i64>
  %bc4 = bitcast <2 x i64> %bc3 to <4 x i32>
  %shuffle4 = shufflevector <4 x i32> %bc4, <4 x i32> zeroinitializer, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %bc5 = bitcast <4 x i32> %shuffle4 to <2 x i64>
  ret <2 x i64> %bc5
}

; Eliminate redundant shuffles

define <2 x i64> @shuffle_32_add_8_shuffle_32_masks_are_eq(<2 x i64> %v) {
; CHECK-LABEL: @shuffle_32_add_8_shuffle_32_masks_are_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[V:%.*]] to <16 x i8>
; CHECK-NEXT:    [[TMP2:%.*]] = shl <16 x i8> [[TMP1]], <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
; CHECK-NEXT:    [[BC5:%.*]] = bitcast <16 x i8> [[TMP2]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[BC5]]
;
  %bc0 = bitcast <2 x i64> %v to <4 x i32>
  %shuffle = shufflevector <4 x i32> %bc0, <4 x i32> zeroinitializer, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %bc1 = bitcast <4 x i32> %shuffle to <2 x i64>
  %bc2 = bitcast <2 x i64> %bc1 to <16 x i8>
  %add.i = add <16 x i8> %bc2, %bc2
  %bc3 = bitcast <16 x i8> %add.i to <2 x i64>
  %bc4 = bitcast <2 x i64> %bc3 to <4 x i32>
  %shuffle4 = shufflevector <4 x i32> %bc4, <4 x i32> zeroinitializer, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %bc5 = bitcast <4 x i32> %shuffle4 to <2 x i64>
  ret <2 x i64> %bc5
}

; Eliminate redundant shuffles

define <2 x i64> @shuffle_8_add_32_shuffle_8_masks_are_eq(<2 x i64> %v) {
; CHECK-LABEL: @shuffle_8_add_32_shuffle_8_masks_are_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[V:%.*]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = shl <4 x i32> [[TMP1]], <i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[BC5:%.*]] = bitcast <4 x i32> [[TMP2]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[BC5]]
;
  %bc0 = bitcast <2 x i64> %v to <16 x i8>
  %shuffle = shufflevector <16 x i8> %bc0, <16 x i8> zeroinitializer, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %bc1 = bitcast <16 x i8> %shuffle to <2 x i64>
  %bc2 = bitcast <2 x i64> %bc1 to <4 x i32>
  %add.i = add <4 x i32> %bc2, %bc2
  %bc3 = bitcast <4 x i32> %add.i to <2 x i64>
  %bc4 = bitcast <2 x i64> %bc3 to <16 x i8>
  %shuffle4 = shufflevector <16 x i8> %bc4, <16 x i8> zeroinitializer, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %bc5 = bitcast <16 x i8> %shuffle4 to <2 x i64>
  ret <2 x i64> %bc5
}

; Single shuffle should sink.

define <8 x i16> @shuffle_32_add_16_masks_are_eq(<4 x i32> %v1, <4 x i32> %v2) {
; CHECK-LABEL: @shuffle_32_add_16_masks_are_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i32> [[V1:%.*]] to <8 x i16>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <4 x i32> [[V2:%.*]] to <8 x i16>
; CHECK-NEXT:    [[TMP3:%.*]] = add <8 x i16> [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[ADD:%.*]] = shufflevector <8 x i16> [[TMP3]], <8 x i16> poison, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    ret <8 x i16> [[ADD]]
;
  %shuffle1 = shufflevector <4 x i32> %v1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %shuffle2 = shufflevector <4 x i32> %v2, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %bc1 = bitcast <4 x i32> %shuffle1 to <8 x i16>
  %bc2 = bitcast <4 x i32> %shuffle2 to <8 x i16>
  %add = add <8 x i16> %bc1, %bc2
  ret <8 x i16> %add
}

; Sink single shuffle.

define <16 x i8> @shuffle_32_add_8_masks_are_eq(<4 x i32> %v1, <4 x i32> %v2) {
; CHECK-LABEL: @shuffle_32_add_8_masks_are_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i32> [[V1:%.*]] to <16 x i8>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <4 x i32> [[V2:%.*]] to <16 x i8>
; CHECK-NEXT:    [[TMP3:%.*]] = add <16 x i8> [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[ADD:%.*]] = shufflevector <16 x i8> [[TMP3]], <16 x i8> poison, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <16 x i8> [[ADD]]
;
  %shuffle1 = shufflevector <4 x i32> %v1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %shuffle2 = shufflevector <4 x i32> %v2, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %bc1 = bitcast <4 x i32> %shuffle1 to <16 x i8>
  %bc2 = bitcast <4 x i32> %shuffle2 to <16 x i8>
  %add = add <16 x i8> %bc1, %bc2
  ret <16 x i8> %add
}

; Sink single shuffle.

define <16 x i8> @shuffle_16_add_8_masks_are_eq(<8 x i16> %v1, <8 x i16> %v2) {
; CHECK-LABEL: @shuffle_16_add_8_masks_are_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x i16> [[V1:%.*]] to <16 x i8>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <8 x i16> [[V2:%.*]] to <16 x i8>
; CHECK-NEXT:    [[TMP3:%.*]] = add <16 x i8> [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[ADD:%.*]] = shufflevector <16 x i8> [[TMP3]], <16 x i8> poison, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1, i32 8, i32 9, i32 10, i32 11, i32 14, i32 15, i32 12, i32 13>
; CHECK-NEXT:    ret <16 x i8> [[ADD]]
;
  %shuffle1 = shufflevector <8 x i16> %v1, <8 x i16> undef, <8 x i32> <i32 2, i32 3, i32 1, i32 0, i32 4, i32 5, i32 7, i32 6>
  %shuffle2 = shufflevector <8 x i16> %v2, <8 x i16> undef, <8 x i32> <i32 2, i32 3, i32 1, i32 0, i32 4, i32 5, i32 7, i32 6>
  %bc1 = bitcast <8 x i16> %shuffle1 to <16 x i8>
  %bc2 = bitcast <8 x i16> %shuffle2 to <16 x i8>
  %add = add <16 x i8> %bc1, %bc2
  ret <16 x i8> %add
}

; Sink single shuffle.

define <4 x i32> @shuffle_16_add_32_masks_are_eq_and_can_be_converted_up(<8 x i16> %v1, <8 x i16> %v2) {
; CHECK-LABEL: @shuffle_16_add_32_masks_are_eq_and_can_be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x i16> [[V1:%.*]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <8 x i16> [[V2:%.*]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = add <4 x i32> [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[ADD:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> poison, <4 x i32> <i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    ret <4 x i32> [[ADD]]
;
  %shuffle1 = shufflevector <8 x i16> %v1, <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  %shuffle2 = shufflevector <8 x i16> %v2, <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  %bc1 = bitcast <8 x i16> %shuffle1 to <4 x i32>
  %bc2 = bitcast <8 x i16> %shuffle2 to <4 x i32>
  %add = add <4 x i32> %bc1, %bc2
  ret <4 x i32> %add
}

; Sink single shuffle.

define <4 x i32> @shuffle_8_add_32_masks_are_eq_and_can_be_converted_up(<16 x i8> %v1, <16 x i8> %v2) {
; CHECK-LABEL: @shuffle_8_add_32_masks_are_eq_and_can_be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <16 x i8> [[V1:%.*]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <16 x i8> [[V2:%.*]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = add <4 x i32> [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[ADD:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> poison, <4 x i32> <i32 1, i32 0, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x i32> [[ADD]]
;
  %shuffle1 = shufflevector <16 x i8> %v1, <16 x i8> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %shuffle2 = shufflevector <16 x i8> %v2, <16 x i8> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %bc1 = bitcast <16 x i8> %shuffle1 to <4 x i32>
  %bc2 = bitcast <16 x i8> %shuffle2 to <4 x i32>
  %add = add <4 x i32> %bc1, %bc2
  ret <4 x i32> %add
}

; shuffle<8 x i16>( bitcast<8 x i16>( shuffle<4 x i32>(v)))
; TODO: Squash shuffles and widen type?

define <8 x i16> @shuffle_32_bitcast_16_shuffle_16_can_be_converted_up(<4 x i32> %v1) {
; CHECK-LABEL: @shuffle_32_bitcast_16_shuffle_16_can_be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i32> [[V1:%.*]] to <8 x i16>
; CHECK-NEXT:    [[BC1:%.*]] = shufflevector <8 x i16> [[TMP1]], <8 x i16> poison, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <8 x i16> [[BC1]], <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    ret <8 x i16> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <4 x i32> %v1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %bc1 = bitcast <4 x i32> %shuffle1 to <8 x i16>
  %shuffle2 = shufflevector <8 x i16> %bc1, <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
  ret <8 x i16> %shuffle2
}

; shuffle<8 x i16>( bitcast<8 x i16>( shuffle<4 x i32>(v)))
; TODO: Squash shuffles?

define <8 x i16> @shuffle_32_bitcast_16_shuffle_16_can_not_be_converted_up(<4 x i32> %v1) {
; CHECK-LABEL: @shuffle_32_bitcast_16_shuffle_16_can_not_be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i32> [[V1:%.*]] to <8 x i16>
; CHECK-NEXT:    [[BC1:%.*]] = shufflevector <8 x i16> [[TMP1]], <8 x i16> poison, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <8 x i16> [[BC1]], <8 x i16> undef, <8 x i32> <i32 5, i32 4, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <8 x i16> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <4 x i32> %v1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %bc1 = bitcast <4 x i32> %shuffle1 to <8 x i16>
  %shuffle2 = shufflevector <8 x i16> %bc1, <8 x i16> undef, <8 x i32> <i32 5, i32 4, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  ret <8 x i16> %shuffle2
}

; shuffle<16 x i8>( bitcast<16 x i8>( shuffle<4 x i32>(v)))
; TODO: Squash shuffles and widen type?

define <16 x i8> @shuffle_32_bitcast_8_shuffle_8_can_be_converted_up(<4 x i32> %v1) {
; CHECK-LABEL: @shuffle_32_bitcast_8_shuffle_8_can_be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i32> [[V1:%.*]] to <16 x i8>
; CHECK-NEXT:    [[BC1:%.*]] = shufflevector <16 x i8> [[TMP1]], <16 x i8> poison, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <16 x i8> [[BC1]], <16 x i8> undef, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <16 x i8> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <4 x i32> %v1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %bc1 = bitcast <4 x i32> %shuffle1 to <16 x i8>
  %shuffle2 = shufflevector <16 x i8> %bc1, <16 x i8> undef, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  ret <16 x i8> %shuffle2
}

; shuffle<16 x i8>( bitcast<16 x i8>( shuffle<4 x i32>(v)))
; TODO: Squash shuffles?

define <16 x i8> @shuffle_32_bitcast_8_shuffle_8_can_not_be_converted_up(<4 x i32> %v1) {
; CHECK-LABEL: @shuffle_32_bitcast_8_shuffle_8_can_not_be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i32> [[V1:%.*]] to <16 x i8>
; CHECK-NEXT:    [[BC1:%.*]] = shufflevector <16 x i8> [[TMP1]], <16 x i8> poison, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <16 x i8> [[BC1]], <16 x i8> undef, <16 x i32> <i32 5, i32 4, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    ret <16 x i8> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <4 x i32> %v1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %bc1 = bitcast <4 x i32> %shuffle1 to <16 x i8>
  %shuffle2 = shufflevector <16 x i8> %bc1, <16 x i8> undef, <16 x i32> <i32 5, i32 4, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i8> %shuffle2
}

; shuffle<4 x i32>( bitcast<4 x i32>( shuffle<16 x i8>(v)))
; TODO: squash shuffles?

define <4 x i32> @shuffle_8_bitcast_32_shuffle_32_can_be_converted_up(<16 x i8> %v1) {
; CHECK-LABEL: @shuffle_8_bitcast_32_shuffle_32_can_be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <16 x i8> [[V1:%.*]] to <4 x i32>
; CHECK-NEXT:    [[BC1:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> poison, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <4 x i32> [[BC1]], <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
; CHECK-NEXT:    ret <4 x i32> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <16 x i8> %v1, <16 x i8> undef, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  %bc1 = bitcast <16 x i8> %shuffle1 to <4 x i32>
  %shuffle2 = shufflevector <4 x i32> %bc1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  ret <4 x i32> %shuffle2
}

; shuffle<4 x i32>( bitcast<4 x i32>( shuffle<8 x i16>(v)))
; TODO: squash shuffles?

define <4 x i32> @shuffle_16_bitcast_32_shuffle_32_can_be_converted_up(<8 x i16> %v1) {
; CHECK-LABEL: @shuffle_16_bitcast_32_shuffle_32_can_be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x i16> [[V1:%.*]] to <4 x i32>
; CHECK-NEXT:    [[BC1:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> poison, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <4 x i32> [[BC1]], <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
; CHECK-NEXT:    ret <4 x i32> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <8 x i16> %v1, <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
  %bc1 = bitcast <8 x i16> %shuffle1 to <4 x i32>
  %shuffle2 = shufflevector <4 x i32> %bc1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  ret <4 x i32> %shuffle2
}

; shuffle<4 x i32>( bitcast<4 x i32>( shuffle<16 x i8>(v)))
; TODO: Narrow and squash shuffles?

define <4 x i32> @shuffle_8_bitcast_32_shuffle_32_can_not_be_converted_up(<16 x i8> %v1) {
; CHECK-LABEL: @shuffle_8_bitcast_32_shuffle_32_can_not_be_converted_up(
; CHECK-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <16 x i8> [[V1:%.*]], <16 x i8> undef, <16 x i32> <i32 9, i32 8, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <16 x i8> [[SHUFFLE1]] to <4 x i32>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <4 x i32> [[BC1]], <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
; CHECK-NEXT:    ret <4 x i32> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <16 x i8> %v1, <16 x i8> undef, <16 x i32> <i32 9, i32 8, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  %bc1 = bitcast <16 x i8> %shuffle1 to <4 x i32>
  %shuffle2 = shufflevector <4 x i32> %bc1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  ret <4 x i32> %shuffle2
}

; shuffle<4 x i32>( bitcast<4 x i32>( shuffle<8 x i16>(v)))
; TODO: Narrow and squash shuffles?

define <4 x i32> @shuffle_16_bitcast_32_shuffle_32_can_not_be_converted_up(<8 x i16> %v1) {
; CHECK-LABEL: @shuffle_16_bitcast_32_shuffle_32_can_not_be_converted_up(
; CHECK-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <8 x i16> [[V1:%.*]], <8 x i16> undef, <8 x i32> <i32 5, i32 4, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <8 x i16> [[SHUFFLE1]] to <4 x i32>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <4 x i32> [[BC1]], <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
; CHECK-NEXT:    ret <4 x i32> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <8 x i16> %v1, <8 x i16> undef, <8 x i32> <i32 5, i32 4, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
  %bc1 = bitcast <8 x i16> %shuffle1 to <4 x i32>
  %shuffle2 = shufflevector <4 x i32> %bc1, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  ret <4 x i32> %shuffle2
}

; shuffle<8 x i16>( bitcast<8 x i16>( shuffle<16 x i8>(v)))
; TODO: squash shuffles and widen type?

define <8 x i16> @shuffle_8_bitcast_16_shuffle_16_can__be_converted_up(<16 x i8> %v1) {
; CHECK-LABEL: @shuffle_8_bitcast_16_shuffle_16_can__be_converted_up(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <16 x i8> [[V1:%.*]] to <8 x i16>
; CHECK-NEXT:    [[BC1:%.*]] = shufflevector <8 x i16> [[TMP1]], <8 x i16> poison, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <8 x i16> [[BC1]], <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    ret <8 x i16> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <16 x i8> %v1, <16 x i8> undef, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  %bc1 = bitcast <16 x i8> %shuffle1 to <8 x i16>
  %shuffle2 = shufflevector <8 x i16> %bc1, <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
  ret <8 x i16> %shuffle2
}

; shuffle<8 x i16>( bitcast<8 x i16>( shuffle<16 x i8>(v)))
; TODO: Narrow and squash shuffles?

define <8 x i16> @shuffle_8_bitcast_16_shuffle_16_can_not_be_converted_up(<16 x i8> %v1) {
; CHECK-LABEL: @shuffle_8_bitcast_16_shuffle_16_can_not_be_converted_up(
; CHECK-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <16 x i8> [[V1:%.*]], <16 x i8> undef, <16 x i32> <i32 9, i32 8, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <16 x i8> [[SHUFFLE1]] to <8 x i16>
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <8 x i16> [[BC1]], <8 x i16> undef, <8 x i32> <i32 5, i32 4, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:    ret <8 x i16> [[SHUFFLE2]]
;
  %shuffle1 = shufflevector <16 x i8> %v1, <16 x i8> undef, <16 x i32> <i32 9, i32 8, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  %bc1 = bitcast <16 x i8> %shuffle1 to <8 x i16>
  %shuffle2 = shufflevector <8 x i16> %bc1, <8 x i16> undef, <8 x i32> <i32 5, i32 4, i32 6, i32 7, i32 2, i32 3, i32 0, i32 1>
  ret <8 x i16> %shuffle2
}
