; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -S | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@b = common global [4 x i32] zeroinitializer, align 16
@c = common global [4 x i32] zeroinitializer, align 16
@d = common global [4 x i32] zeroinitializer, align 16
@e = common global [4 x i32] zeroinitializer, align 16
@a = common global [4 x i32] zeroinitializer, align 16
@fb = common global [4 x float] zeroinitializer, align 16
@fc = common global [4 x float] zeroinitializer, align 16
@fa = common global [4 x float] zeroinitializer, align 16
@fd = common global [4 x float] zeroinitializer, align 16

; Function Attrs: nounwind uwtable
define void @addsub() #0 {
; CHECK-LABEL: @addsub(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([4 x i32]* @b to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([4 x i32]* @c to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = add nsw <4 x i32> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([4 x i32]* @d to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([4 x i32]* @e to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <4 x i32> [[TMP3]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = add nsw <4 x i32> [[TMP2]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = sub nsw <4 x i32> [[TMP2]], [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <4 x i32> [[TMP6]], <4 x i32> [[TMP7]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    store <4 x i32> [[TMP8]], <4 x i32>* bitcast ([4 x i32]* @a to <4 x i32>*), align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i32 0, i64 0), align 4
  %1 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @c, i32 0, i64 0), align 4
  %add = add nsw i32 %0, %1
  %2 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @d, i32 0, i64 0), align 4
  %3 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @e, i32 0, i64 0), align 4
  %add1 = add nsw i32 %2, %3
  %add2 = add nsw i32 %add, %add1
  store i32 %add2, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i32 0, i64 0), align 4
  %4 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i32 0, i64 1), align 4
  %5 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @c, i32 0, i64 1), align 4
  %add3 = add nsw i32 %4, %5
  %6 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @d, i32 0, i64 1), align 4
  %7 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @e, i32 0, i64 1), align 4
  %add4 = add nsw i32 %6, %7
  %sub = sub nsw i32 %add3, %add4
  store i32 %sub, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i32 0, i64 1), align 4
  %8 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i32 0, i64 2), align 4
  %9 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @c, i32 0, i64 2), align 4
  %add5 = add nsw i32 %8, %9
  %10 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @d, i32 0, i64 2), align 4
  %11 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @e, i32 0, i64 2), align 4
  %add6 = add nsw i32 %10, %11
  %add7 = add nsw i32 %add5, %add6
  store i32 %add7, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i32 0, i64 2), align 4
  %12 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i32 0, i64 3), align 4
  %13 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @c, i32 0, i64 3), align 4
  %add8 = add nsw i32 %12, %13
  %14 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @d, i32 0, i64 3), align 4
  %15 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @e, i32 0, i64 3), align 4
  %add9 = add nsw i32 %14, %15
  %sub10 = sub nsw i32 %add8, %add9
  store i32 %sub10, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i32 0, i64 3), align 4
  ret void
}

; Function Attrs: nounwind uwtable
define void @subadd() #0 {
; CHECK-LABEL: @subadd(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([4 x i32]* @b to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([4 x i32]* @c to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = add nsw <4 x i32> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([4 x i32]* @d to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([4 x i32]* @e to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <4 x i32> [[TMP3]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = sub nsw <4 x i32> [[TMP2]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = add nsw <4 x i32> [[TMP2]], [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <4 x i32> [[TMP6]], <4 x i32> [[TMP7]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    store <4 x i32> [[TMP8]], <4 x i32>* bitcast ([4 x i32]* @a to <4 x i32>*), align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i32 0, i64 0), align 4
  %1 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @c, i32 0, i64 0), align 4
  %add = add nsw i32 %0, %1
  %2 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @d, i32 0, i64 0), align 4
  %3 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @e, i32 0, i64 0), align 4
  %add1 = add nsw i32 %2, %3
  %sub = sub nsw i32 %add, %add1
  store i32 %sub, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i32 0, i64 0), align 4
  %4 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i32 0, i64 1), align 4
  %5 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @c, i32 0, i64 1), align 4
  %add2 = add nsw i32 %4, %5
  %6 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @d, i32 0, i64 1), align 4
  %7 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @e, i32 0, i64 1), align 4
  %add3 = add nsw i32 %6, %7
  %add4 = add nsw i32 %add2, %add3
  store i32 %add4, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i32 0, i64 1), align 4
  %8 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i32 0, i64 2), align 4
  %9 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @c, i32 0, i64 2), align 4
  %add5 = add nsw i32 %8, %9
  %10 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @d, i32 0, i64 2), align 4
  %11 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @e, i32 0, i64 2), align 4
  %add6 = add nsw i32 %10, %11
  %sub7 = sub nsw i32 %add5, %add6
  store i32 %sub7, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i32 0, i64 2), align 4
  %12 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i32 0, i64 3), align 4
  %13 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @c, i32 0, i64 3), align 4
  %add8 = add nsw i32 %12, %13
  %14 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @d, i32 0, i64 3), align 4
  %15 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @e, i32 0, i64 3), align 4
  %add9 = add nsw i32 %14, %15
  %add10 = add nsw i32 %add8, %add9
  store i32 %add10, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i32 0, i64 3), align 4
  ret void
}

; Function Attrs: nounwind uwtable
define void @faddfsub() #0 {
; CHECK-LABEL: @faddfsub(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fb to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fc to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = fadd <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fsub <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x float> [[TMP2]], <4 x float> [[TMP3]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    store <4 x float> [[TMP4]], <4 x float>* bitcast ([4 x float]* @fa to <4 x float>*), align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 0), align 4
  %1 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 0), align 4
  %add = fadd float %0, %1
  store float %add, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 0), align 4
  %2 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 1), align 4
  %3 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 1), align 4
  %sub = fsub float %2, %3
  store float %sub, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 1), align 4
  %4 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 2), align 4
  %5 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 2), align 4
  %add1 = fadd float %4, %5
  store float %add1, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 2), align 4
  %6 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 3), align 4
  %7 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 3), align 4
  %sub2 = fsub float %6, %7
  store float %sub2, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 3), align 4
  ret void
}

; Function Attrs: nounwind uwtable
define void @fsubfadd() #0 {
; CHECK-LABEL: @fsubfadd(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fb to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fc to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = fsub <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x float> [[TMP2]], <4 x float> [[TMP3]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    store <4 x float> [[TMP4]], <4 x float>* bitcast ([4 x float]* @fa to <4 x float>*), align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 0), align 4
  %1 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 0), align 4
  %sub = fsub float %0, %1
  store float %sub, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 0), align 4
  %2 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 1), align 4
  %3 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 1), align 4
  %add = fadd float %2, %3
  store float %add, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 1), align 4
  %4 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 2), align 4
  %5 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 2), align 4
  %sub1 = fsub float %4, %5
  store float %sub1, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 2), align 4
  %6 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 3), align 4
  %7 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 3), align 4
  %add2 = fadd float %6, %7
  store float %add2, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 3), align 4
  ret void
}

; Function Attrs: nounwind uwtable
define void @faddfsub_select() #0 {
; CHECK-LABEL: @faddfsub_select(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fb to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fc to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = fadd <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fsub <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x float> [[TMP2]], <4 x float> [[TMP3]], <4 x i32> <i32 0, i32 1, i32 2, i32 7>
; CHECK-NEXT:    store <4 x float> [[TMP4]], <4 x float>* bitcast ([4 x float]* @fa to <4 x float>*), align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 0), align 4
  %1 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 0), align 4
  %add = fadd float %0, %1
  store float %add, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 0), align 4
  %2 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 1), align 4
  %3 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 1), align 4
  %add1 = fadd float %2, %3
  store float %add1, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 1), align 4
  %4 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 2), align 4
  %5 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 2), align 4
  %add2 = fadd float %4, %5
  store float %add2, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 2), align 4
  %6 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 3), align 4
  %7 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 3), align 4
  %sub = fsub float %6, %7
  store float %sub, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 3), align 4
  ret void
}

; Check vectorization of following code for float data type-
;  fc[0] = fb[0]+fa[0]; //swapped fb and fa
;  fc[1] = fa[1]-fb[1];
;  fc[2] = fa[2]+fb[2];
;  fc[3] = fa[3]-fb[3];

define void @reorder_alt() #0 {
; CHECK-LABEL: @reorder_alt(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fa to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fb to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <4 x float> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fsub <4 x float> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <4 x float> [[TMP3]], <4 x float> [[TMP4]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    store <4 x float> [[TMP5]], <4 x float>* bitcast ([4 x float]* @fc to <4 x float>*), align 4
; CHECK-NEXT:    ret void
;
  %1 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 0), align 4
  %2 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 0), align 4
  %3 = fadd float %1, %2
  store float %3, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 0), align 4
  %4 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 1), align 4
  %5 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 1), align 4
  %6 = fsub float %4, %5
  store float %6, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 1), align 4
  %7 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 2), align 4
  %8 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 2), align 4
  %9 = fadd float %7, %8
  store float %9, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 2), align 4
  %10 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 3), align 4
  %11 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 3), align 4
  %12 = fsub float %10, %11
  store float %12, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 3), align 4
  ret void
}

; Check vectorization of following code for float data type-
;  fc[0] = fa[0]+(fb[0]-fd[0]);
;  fc[1] = fa[1]-(fb[1]+fd[1]);
;  fc[2] = fa[2]+(fb[2]-fd[2]);
;  fc[3] = fa[3]-(fd[3]+fb[3]); //swapped fd and fb

define void @reorder_alt_subTree() #0 {
; CHECK-LABEL: @reorder_alt_subTree(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fa to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fd to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x float>, <4 x float>* bitcast ([4 x float]* @fb to <4 x float>*), align 4
; CHECK-NEXT:    [[TMP4:%.*]] = fsub <4 x float> [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <4 x float> [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <4 x float> [[TMP4]], <4 x float> [[TMP5]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[TMP7:%.*]] = fadd <4 x float> [[TMP1]], [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = fsub <4 x float> [[TMP1]], [[TMP6]]
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x float> [[TMP7]], <4 x float> [[TMP8]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    store <4 x float> [[TMP9]], <4 x float>* bitcast ([4 x float]* @fc to <4 x float>*), align 4
; CHECK-NEXT:    ret void
;
  %1 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 0), align 4
  %2 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 0), align 4
  %3 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fd, i32 0, i64 0), align 4
  %4 = fsub float %2, %3
  %5 = fadd float %1, %4
  store float %5, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 0), align 4
  %6 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 1), align 4
  %7 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 1), align 4
  %8 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fd, i32 0, i64 1), align 4
  %9 = fadd float %7, %8
  %10 = fsub float %6, %9
  store float %10, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 1), align 4
  %11 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 2), align 4
  %12 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 2), align 4
  %13 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fd, i32 0, i64 2), align 4
  %14 = fsub float %12, %13
  %15 = fadd float %11, %14
  store float %15, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 2), align 4
  %16 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 3), align 4
  %17 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fd, i32 0, i64 3), align 4
  %18 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 3), align 4
  %19 = fadd float %17, %18
  %20 = fsub float %16, %19
  store float %20, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 3), align 4
  ret void
}

; Check vectorization of following code for double data type-
;  c[0] = (a[0]+b[0])-d[0];
;  c[1] = d[1]+(a[1]+b[1]); //swapped d[1] and (a[1]+b[1])

define void @reorder_alt_rightsubTree(double* nocapture %c, double* noalias nocapture readonly %a, double* noalias nocapture readonly %b, double* noalias nocapture readonly %d) {
; CHECK-LABEL: @reorder_alt_rightsubTree(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast double* [[D:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x double>, <2 x double>* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast double* [[A:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <2 x double>, <2 x double>* [[TMP3]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[B:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP6:%.*]] = load <2 x double>, <2 x double>* [[TMP5]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = fadd <2 x double> [[TMP4]], [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = fsub <2 x double> [[TMP7]], [[TMP2]]
; CHECK-NEXT:    [[TMP9:%.*]] = fadd <2 x double> [[TMP7]], [[TMP2]]
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <2 x double> [[TMP8]], <2 x double> [[TMP9]], <2 x i32> <i32 0, i32 3>
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast double* [[C:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP10]], <2 x double>* [[TMP11]], align 8
; CHECK-NEXT:    ret void
;
  %1 = load double, double* %a
  %2 = load double, double* %b
  %3 = fadd double %1, %2
  %4 = load double, double* %d
  %5 = fsub double %3, %4
  store double %5, double* %c
  %6 = getelementptr inbounds double, double* %d, i64 1
  %7 = load double, double* %6
  %8 = getelementptr inbounds double, double* %a, i64 1
  %9 = load double, double* %8
  %10 = getelementptr inbounds double, double* %b, i64 1
  %11 = load double, double* %10
  %12 = fadd double %9, %11
  %13 = fadd double %7, %12
  %14 = getelementptr inbounds double, double* %c, i64 1
  store double %13, double* %14
  ret void
}

define void @vec_shuff_reorder() #0 {
; CHECK-LABEL: @vec_shuff_reorder(
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 0), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 0), align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 1), align 4
; CHECK-NEXT:    [[TMP4:%.*]] = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 1), align 4
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x float>, <2 x float>* bitcast (float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 2) to <2 x float>*), align 4
; CHECK-NEXT:    [[TMP6:%.*]] = load <2 x float>, <2 x float>* bitcast (float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 2) to <2 x float>*), align 4
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x float> poison, float [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <4 x float> [[TMP7]], float [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <2 x float> [[TMP5]], <2 x float> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x float> [[TMP8]], <4 x float> [[TMP9]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <4 x float> poison, float [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <4 x float> [[TMP11]], float [[TMP4]], i32 1
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <2 x float> [[TMP6]], <2 x float> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x float> [[TMP12]], <4 x float> [[TMP13]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP15:%.*]] = fadd <4 x float> [[TMP10]], [[TMP14]]
; CHECK-NEXT:    [[TMP16:%.*]] = fsub <4 x float> [[TMP10]], [[TMP14]]
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <4 x float> [[TMP15]], <4 x float> [[TMP16]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    store <4 x float> [[TMP17]], <4 x float>* bitcast ([4 x float]* @fc to <4 x float>*), align 4
; CHECK-NEXT:    ret void
;
  %1 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 0), align 4
  %2 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 0), align 4
  %3 = fadd float %1, %2
  store float %3, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 0), align 4
  %4 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 1), align 4
  %5 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 1), align 4
  %6 = fsub float %4, %5
  store float %6, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 1), align 4
  %7 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 2), align 4
  %8 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 2), align 4
  %9 = fadd float %7, %8
  store float %9, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 2), align 4
  %10 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fb, i32 0, i64 3), align 4
  %11 = load float, float* getelementptr inbounds ([4 x float], [4 x float]* @fa, i32 0, i64 3), align 4
  %12 = fsub float %10, %11
  store float %12, float* getelementptr inbounds ([4 x float], [4 x float]* @fc, i32 0, i64 3), align 4
  ret void
}


attributes #0 = { nounwind }

