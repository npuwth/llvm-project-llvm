; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve.fp | FileCheck %s --check-prefix=CHECK-MVE-RECIP
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=thumbv7-apple-ios6.0.0 -mcpu=swift | FileCheck %s --check-prefix=CHECK-NEON-RECIP
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=thumbv8m.base | FileCheck %s --check-prefix=CHECK-THUMB1-RECIP
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=thumbv8m.main | FileCheck %s --check-prefix=CHECK-THUMB2-RECIP
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -cost-kind=code-size -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve.fp | FileCheck %s --check-prefix=CHECK-MVE-SIZE
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -cost-kind=code-size -mtriple=thumbv7-apple-ios6.0.0 -mcpu=swift | FileCheck %s --check-prefix=CHECK-NEON-SIZE
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -cost-kind=code-size -mtriple=thumbv8m.base | FileCheck %s --check-prefix=CHECK-THUMB1-SIZE
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -cost-kind=code-size -mtriple=thumbv8m.main | FileCheck %s --check-prefix=CHECK-THUMB2-SIZE

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"

define void @selects() {
  ; Scalar values
; CHECK-MVE-RECIP-LABEL: 'selects'
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = select i1 undef, i1 undef, i1 undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = select i1 undef, i8 undef, i8 undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2 = select i1 undef, i16 undef, i16 undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v3 = select i1 undef, i32 undef, i32 undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v4 = select i1 undef, i64 undef, i64 undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v5 = select i1 undef, float undef, float undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v6 = select i1 undef, double undef, double undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v8 = select <4 x i1> undef, <4 x i8> undef, <4 x i8> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v9 = select <8 x i1> undef, <8 x i8> undef, <8 x i8> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v10 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v12 = select <4 x i1> undef, <4 x i16> undef, <4 x i16> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v13 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v13b = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v15 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v15b = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v15c = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v18 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v19 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %v20 = select <1 x i1> undef, <1 x i32> undef, <1 x i32> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v21 = select <3 x i1> undef, <3 x float> undef, <3 x float> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v22 = select <5 x i1> undef, <5 x double> undef, <5 x double> undef
; CHECK-MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-NEON-RECIP-LABEL: 'selects'
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = select i1 undef, i1 undef, i1 undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = select i1 undef, i8 undef, i8 undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2 = select i1 undef, i16 undef, i16 undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v3 = select i1 undef, i32 undef, i32 undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v4 = select i1 undef, i64 undef, i64 undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v5 = select i1 undef, float undef, float undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v6 = select i1 undef, double undef, double undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8 = select <4 x i1> undef, <4 x i8> undef, <4 x i8> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v9 = select <8 x i1> undef, <8 x i8> undef, <8 x i8> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v10 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v12 = select <4 x i1> undef, <4 x i16> undef, <4 x i16> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v13b = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v15b = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v15c = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 19 for instruction: %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 50 for instruction: %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 100 for instruction: %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v18 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v19 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v20 = select <1 x i1> undef, <1 x i32> undef, <1 x i32> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v21 = select <3 x i1> undef, <3 x float> undef, <3 x float> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v22 = select <5 x i1> undef, <5 x double> undef, <5 x double> undef
; CHECK-NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-THUMB1-RECIP-LABEL: 'selects'
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = select i1 undef, i1 undef, i1 undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = select i1 undef, i8 undef, i8 undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2 = select i1 undef, i16 undef, i16 undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v3 = select i1 undef, i32 undef, i32 undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v4 = select i1 undef, i64 undef, i64 undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v5 = select i1 undef, float undef, float undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v6 = select i1 undef, double undef, double undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v8 = select <4 x i1> undef, <4 x i8> undef, <4 x i8> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v9 = select <8 x i1> undef, <8 x i8> undef, <8 x i8> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v10 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v12 = select <4 x i1> undef, <4 x i16> undef, <4 x i16> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v13 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v13b = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v15 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v15b = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v15c = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v18 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v19 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v20 = select <1 x i1> undef, <1 x i32> undef, <1 x i32> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v21 = select <3 x i1> undef, <3 x float> undef, <3 x float> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %v22 = select <5 x i1> undef, <5 x double> undef, <5 x double> undef
; CHECK-THUMB1-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-THUMB2-RECIP-LABEL: 'selects'
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = select i1 undef, i1 undef, i1 undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = select i1 undef, i8 undef, i8 undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2 = select i1 undef, i16 undef, i16 undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v3 = select i1 undef, i32 undef, i32 undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v4 = select i1 undef, i64 undef, i64 undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v5 = select i1 undef, float undef, float undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v6 = select i1 undef, double undef, double undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v8 = select <4 x i1> undef, <4 x i8> undef, <4 x i8> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v9 = select <8 x i1> undef, <8 x i8> undef, <8 x i8> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v10 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v12 = select <4 x i1> undef, <4 x i16> undef, <4 x i16> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v13 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v13b = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v15 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v15b = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v15c = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v18 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v19 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v20 = select <1 x i1> undef, <1 x i32> undef, <1 x i32> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v21 = select <3 x i1> undef, <3 x float> undef, <3 x float> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %v22 = select <5 x i1> undef, <5 x double> undef, <5 x double> undef
; CHECK-THUMB2-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-MVE-SIZE-LABEL: 'selects'
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v0 = select i1 undef, i1 undef, i1 undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v1 = select i1 undef, i8 undef, i8 undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2 = select i1 undef, i16 undef, i16 undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3 = select i1 undef, i32 undef, i32 undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4 = select i1 undef, i64 undef, i64 undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v5 = select i1 undef, float undef, float undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v6 = select i1 undef, double undef, double undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8 = select <4 x i1> undef, <4 x i8> undef, <4 x i8> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v9 = select <8 x i1> undef, <8 x i8> undef, <8 x i8> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v10 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v12 = select <4 x i1> undef, <4 x i16> undef, <4 x i16> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13b = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15b = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15c = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v18 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v19 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v20 = select <1 x i1> undef, <1 x i32> undef, <1 x i32> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v21 = select <3 x i1> undef, <3 x float> undef, <3 x float> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v22 = select <5 x i1> undef, <5 x double> undef, <5 x double> undef
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-NEON-SIZE-LABEL: 'selects'
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v0 = select i1 undef, i1 undef, i1 undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v1 = select i1 undef, i8 undef, i8 undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2 = select i1 undef, i16 undef, i16 undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3 = select i1 undef, i32 undef, i32 undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4 = select i1 undef, i64 undef, i64 undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v5 = select i1 undef, float undef, float undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v6 = select i1 undef, double undef, double undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8 = select <4 x i1> undef, <4 x i8> undef, <4 x i8> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v9 = select <8 x i1> undef, <8 x i8> undef, <8 x i8> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v10 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v12 = select <4 x i1> undef, <4 x i16> undef, <4 x i16> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v13b = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v15b = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v15c = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 19 for instruction: %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 50 for instruction: %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 100 for instruction: %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v18 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v19 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v20 = select <1 x i1> undef, <1 x i32> undef, <1 x i32> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v21 = select <3 x i1> undef, <3 x float> undef, <3 x float> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v22 = select <5 x i1> undef, <5 x double> undef, <5 x double> undef
; CHECK-NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-THUMB1-SIZE-LABEL: 'selects'
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v0 = select i1 undef, i1 undef, i1 undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v1 = select i1 undef, i8 undef, i8 undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2 = select i1 undef, i16 undef, i16 undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3 = select i1 undef, i32 undef, i32 undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4 = select i1 undef, i64 undef, i64 undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v5 = select i1 undef, float undef, float undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v6 = select i1 undef, double undef, double undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8 = select <4 x i1> undef, <4 x i8> undef, <4 x i8> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v9 = select <8 x i1> undef, <8 x i8> undef, <8 x i8> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v10 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v12 = select <4 x i1> undef, <4 x i16> undef, <4 x i16> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13b = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15b = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15c = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v18 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v19 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v20 = select <1 x i1> undef, <1 x i32> undef, <1 x i32> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v21 = select <3 x i1> undef, <3 x float> undef, <3 x float> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v22 = select <5 x i1> undef, <5 x double> undef, <5 x double> undef
; CHECK-THUMB1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-THUMB2-SIZE-LABEL: 'selects'
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v0 = select i1 undef, i1 undef, i1 undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v1 = select i1 undef, i8 undef, i8 undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2 = select i1 undef, i16 undef, i16 undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3 = select i1 undef, i32 undef, i32 undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4 = select i1 undef, i64 undef, i64 undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v5 = select i1 undef, float undef, float undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v6 = select i1 undef, double undef, double undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8 = select <4 x i1> undef, <4 x i8> undef, <4 x i8> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v9 = select <8 x i1> undef, <8 x i8> undef, <8 x i8> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v10 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v12 = select <4 x i1> undef, <4 x i16> undef, <4 x i16> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13b = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15b = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15c = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v18 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v19 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v20 = select <1 x i1> undef, <1 x i32> undef, <1 x i32> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v21 = select <3 x i1> undef, <3 x float> undef, <3 x float> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v22 = select <5 x i1> undef, <5 x double> undef, <5 x double> undef
; CHECK-THUMB2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %v0 = select i1 undef, i1 undef, i1 undef
  %v1 = select i1 undef, i8 undef, i8 undef
  %v2 = select i1 undef, i16 undef, i16 undef
  %v3 = select i1 undef, i32 undef, i32 undef
  %v4 = select i1 undef, i64 undef, i64 undef
  %v5 = select i1 undef, float undef, float undef
  %v6 = select i1 undef, double undef, double undef

  ; Vector values
  %v7 = select <2 x i1> undef, <2 x i8> undef, <2 x i8> undef
  %v8 = select <4 x i1>  undef, <4 x i8> undef, <4 x i8> undef
  %v9 = select <8 x i1>  undef, <8 x i8> undef, <8 x i8> undef
  %v10 = select <16 x i1>  undef, <16 x i8> undef, <16 x i8> undef

  %v11 = select <2 x i1> undef, <2 x i16> undef, <2 x i16> undef
  %v12 = select <4 x i1>  undef, <4 x i16> undef, <4 x i16> undef
  %v13 = select <8 x i1>  undef, <8 x i16> undef, <8 x i16> undef
  %v13b = select <16 x i1>  undef, <16 x i16> undef, <16 x i16> undef

  %v14 = select <2 x i1> undef, <2 x i32> undef, <2 x i32> undef
  %v15 = select <4 x i1>  undef, <4 x i32> undef, <4 x i32> undef
  %v15b = select <8 x i1>  undef, <8 x i32> undef, <8 x i32> undef
  %v15c = select <16 x i1>  undef, <16 x i32> undef, <16 x i32> undef

  %v16 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
  %v16a = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
  %v16b = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
  %v16c = select <16 x i1> undef, <16 x i64> undef, <16 x i64> undef

  %v17 = select <2 x i1> undef, <2 x float> undef, <2 x float> undef
  %v18 = select <4 x i1>  undef, <4 x float> undef, <4 x float> undef

  %v19 = select <2 x i1>  undef, <2 x double> undef, <2 x double> undef

  ; odd vectors get legalized and should have similar costs
  %v20 = select <1 x i1>  undef, <1 x i32> undef, <1 x i32> undef
  %v21 = select <3 x i1>  undef, <3 x float> undef, <3 x float> undef
  %v22 = select <5 x i1>  undef, <5 x double> undef, <5 x double> undef

  ret void
}
