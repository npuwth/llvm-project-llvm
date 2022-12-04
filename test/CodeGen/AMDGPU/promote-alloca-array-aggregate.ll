; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -amdgpu-promote-alloca < %s | FileCheck %s

; Make sure that array alloca loaded and stored as multi-element aggregates are handled correctly
; Strictly the promote-alloca pass shouldn't have to deal with this case as it is non-canonical, but
; the pass should handle it gracefully if it is
; The checks look for lines that previously caused issues in PromoteAlloca (non-canonical). Opt
; should now leave these unchanged

%Block = type { [1 x float], i32 }
%gl_PerVertex = type { <4 x float>, float, [1 x float], [1 x float] }
%struct = type { i32, i32 }

@block = external addrspace(1) global %Block
@pv = external addrspace(1) global %gl_PerVertex

define amdgpu_vs void @promote_1d_aggr() #0 {
; CHECK-LABEL: @promote_1d_aggr(
; CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[F1:%.*]] = alloca [1 x float], align 4
; CHECK-NEXT:    [[FOO:%.*]] = getelementptr [[BLOCK:%.*]], [[BLOCK]] addrspace(1)* @block, i32 0, i32 1
; CHECK-NEXT:    [[FOO1:%.*]] = load i32, i32 addrspace(1)* [[FOO]], align 4
; CHECK-NEXT:    store i32 [[FOO1]], i32* [[I]], align 4
; CHECK-NEXT:    [[FOO2:%.*]] = getelementptr [[BLOCK]], [[BLOCK]] addrspace(1)* @block, i32 0, i32 0
; CHECK-NEXT:    [[FOO3:%.*]] = load [1 x float], [1 x float] addrspace(1)* [[FOO2]], align 4
; CHECK-NEXT:    store [1 x float] [[FOO3]], [1 x float]* [[F1]], align 4
; CHECK-NEXT:    [[FOO4:%.*]] = load i32, i32* [[I]], align 4
; CHECK-NEXT:    [[FOO5:%.*]] = getelementptr [1 x float], [1 x float]* [[F1]], i32 0, i32 [[FOO4]]
; CHECK-NEXT:    [[FOO6:%.*]] = load float, float* [[FOO5]], align 4
; CHECK-NEXT:    [[FOO7:%.*]] = alloca <4 x float>, align 16
; CHECK-NEXT:    [[FOO8:%.*]] = load <4 x float>, <4 x float>* [[FOO7]], align 16
; CHECK-NEXT:    [[FOO9:%.*]] = insertelement <4 x float> [[FOO8]], float [[FOO6]], i32 0
; CHECK-NEXT:    [[FOO10:%.*]] = insertelement <4 x float> [[FOO9]], float [[FOO6]], i32 1
; CHECK-NEXT:    [[FOO11:%.*]] = insertelement <4 x float> [[FOO10]], float [[FOO6]], i32 2
; CHECK-NEXT:    [[FOO12:%.*]] = insertelement <4 x float> [[FOO11]], float [[FOO6]], i32 3
; CHECK-NEXT:    [[FOO13:%.*]] = getelementptr [[GL_PERVERTEX:%.*]], [[GL_PERVERTEX]] addrspace(1)* @pv, i32 0, i32 0
; CHECK-NEXT:    store <4 x float> [[FOO12]], <4 x float> addrspace(1)* [[FOO13]], align 16
; CHECK-NEXT:    ret void
;
  %i = alloca i32
  %f1 = alloca [1 x float]
  %foo = getelementptr %Block, %Block addrspace(1)* @block, i32 0, i32 1
  %foo1 = load i32, i32 addrspace(1)* %foo
  store i32 %foo1, i32* %i
  %foo2 = getelementptr %Block, %Block addrspace(1)* @block, i32 0, i32 0
  %foo3 = load [1 x float], [1 x float] addrspace(1)* %foo2
  store [1 x float] %foo3, [1 x float]* %f1
  %foo4 = load i32, i32* %i
  %foo5 = getelementptr [1 x float], [1 x float]* %f1, i32 0, i32 %foo4
  %foo6 = load float, float* %foo5
  %foo7 = alloca <4 x float>
  %foo8 = load <4 x float>, <4 x float>* %foo7
  %foo9 = insertelement <4 x float> %foo8, float %foo6, i32 0
  %foo10 = insertelement <4 x float> %foo9, float %foo6, i32 1
  %foo11 = insertelement <4 x float> %foo10, float %foo6, i32 2
  %foo12 = insertelement <4 x float> %foo11, float %foo6, i32 3
  %foo13 = getelementptr %gl_PerVertex, %gl_PerVertex addrspace(1)* @pv, i32 0, i32 0
  store <4 x float> %foo12, <4 x float> addrspace(1)* %foo13
  ret void
}

%Block2 = type { i32, [2 x float] }
@block2 = external addrspace(1) global %Block2

define amdgpu_vs void @promote_store_aggr() #0 {
; CHECK-LABEL: @promote_store_aggr(
; CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[F1:%.*]] = alloca [2 x float], align 4
; CHECK-NEXT:    [[FOO:%.*]] = getelementptr [[BLOCK2:%.*]], [[BLOCK2]] addrspace(1)* @block2, i32 0, i32 0
; CHECK-NEXT:    [[FOO1:%.*]] = load i32, i32 addrspace(1)* [[FOO]], align 4
; CHECK-NEXT:    store i32 [[FOO1]], i32* [[I]], align 4
; CHECK-NEXT:    [[FOO2:%.*]] = load i32, i32* [[I]], align 4
; CHECK-NEXT:    [[FOO3:%.*]] = sitofp i32 [[FOO2]] to float
; CHECK-NEXT:    [[FOO4:%.*]] = getelementptr [2 x float], [2 x float]* [[F1]], i32 0, i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast [2 x float]* [[F1]] to <2 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x float>, <2 x float>* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x float> [[TMP2]], float [[FOO3]], i32 0
; CHECK-NEXT:    store <2 x float> [[TMP3]], <2 x float>* [[TMP1]], align 8
; CHECK-NEXT:    [[FOO5:%.*]] = getelementptr [2 x float], [2 x float]* [[F1]], i32 0, i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast [2 x float]* [[F1]] to <2 x float>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x float>, <2 x float>* [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x float> [[TMP5]], float 2.000000e+00, i64 1
; CHECK-NEXT:    store <2 x float> [[TMP6]], <2 x float>* [[TMP4]], align 8
; CHECK-NEXT:    [[FOO6:%.*]] = load [2 x float], [2 x float]* [[F1]], align 4
; CHECK-NEXT:    [[FOO7:%.*]] = getelementptr [[BLOCK2]], [[BLOCK2]] addrspace(1)* @block2, i32 0, i32 1
; CHECK-NEXT:    store [2 x float] [[FOO6]], [2 x float] addrspace(1)* [[FOO7]], align 4
; CHECK-NEXT:    [[FOO8:%.*]] = getelementptr [[GL_PERVERTEX:%.*]], [[GL_PERVERTEX]] addrspace(1)* @pv, i32 0, i32 0
; CHECK-NEXT:    store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, <4 x float> addrspace(1)* [[FOO8]], align 16
; CHECK-NEXT:    ret void
;
  %i = alloca i32
  %f1 = alloca [2 x float]
  %foo = getelementptr %Block2, %Block2 addrspace(1)* @block2, i32 0, i32 0
  %foo1 = load i32, i32 addrspace(1)* %foo
  store i32 %foo1, i32* %i
  %foo2 = load i32, i32* %i
  %foo3 = sitofp i32 %foo2 to float
  %foo4 = getelementptr [2 x float], [2 x float]* %f1, i32 0, i32 0
  store float %foo3, float* %foo4
  %foo5 = getelementptr [2 x float], [2 x float]* %f1, i32 0, i32 1
  store float 2.000000e+00, float* %foo5
  %foo6 = load [2 x float], [2 x float]* %f1
  %foo7 = getelementptr %Block2, %Block2 addrspace(1)* @block2, i32 0, i32 1
  store [2 x float] %foo6, [2 x float] addrspace(1)* %foo7
  %foo8 = getelementptr %gl_PerVertex, %gl_PerVertex addrspace(1)* @pv, i32 0, i32 0
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, <4 x float> addrspace(1)* %foo8
  ret void
}

%Block3 = type { [2 x float], i32 }
@block3 = external addrspace(1) global %Block3

define amdgpu_vs void @promote_load_from_store_aggr() #0 {
; CHECK-LABEL: @promote_load_from_store_aggr(
; CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[F1:%.*]] = alloca [2 x float], align 4
; CHECK-NEXT:    [[FOO:%.*]] = getelementptr [[BLOCK3:%.*]], [[BLOCK3]] addrspace(1)* @block3, i32 0, i32 1
; CHECK-NEXT:    [[FOO1:%.*]] = load i32, i32 addrspace(1)* [[FOO]], align 4
; CHECK-NEXT:    store i32 [[FOO1]], i32* [[I]], align 4
; CHECK-NEXT:    [[FOO2:%.*]] = getelementptr [[BLOCK3]], [[BLOCK3]] addrspace(1)* @block3, i32 0, i32 0
; CHECK-NEXT:    [[FOO3:%.*]] = load [2 x float], [2 x float] addrspace(1)* [[FOO2]], align 4
; CHECK-NEXT:    store [2 x float] [[FOO3]], [2 x float]* [[F1]], align 4
; CHECK-NEXT:    [[FOO4:%.*]] = load i32, i32* [[I]], align 4
; CHECK-NEXT:    [[FOO5:%.*]] = getelementptr [2 x float], [2 x float]* [[F1]], i32 0, i32 [[FOO4]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast [2 x float]* [[F1]] to <2 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x float>, <2 x float>* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x float> [[TMP2]], i32 [[FOO4]]
; CHECK-NEXT:    [[FOO7:%.*]] = alloca <4 x float>, align 16
; CHECK-NEXT:    [[FOO8:%.*]] = load <4 x float>, <4 x float>* [[FOO7]], align 16
; CHECK-NEXT:    [[FOO9:%.*]] = insertelement <4 x float> [[FOO8]], float [[TMP3]], i32 0
; CHECK-NEXT:    [[FOO10:%.*]] = insertelement <4 x float> [[FOO9]], float [[TMP3]], i32 1
; CHECK-NEXT:    [[FOO11:%.*]] = insertelement <4 x float> [[FOO10]], float [[TMP3]], i32 2
; CHECK-NEXT:    [[FOO12:%.*]] = insertelement <4 x float> [[FOO11]], float [[TMP3]], i32 3
; CHECK-NEXT:    [[FOO13:%.*]] = getelementptr [[GL_PERVERTEX:%.*]], [[GL_PERVERTEX]] addrspace(1)* @pv, i32 0, i32 0
; CHECK-NEXT:    store <4 x float> [[FOO12]], <4 x float> addrspace(1)* [[FOO13]], align 16
; CHECK-NEXT:    ret void
;
  %i = alloca i32
  %f1 = alloca [2 x float]
  %foo = getelementptr %Block3, %Block3 addrspace(1)* @block3, i32 0, i32 1
  %foo1 = load i32, i32 addrspace(1)* %foo
  store i32 %foo1, i32* %i
  %foo2 = getelementptr %Block3, %Block3 addrspace(1)* @block3, i32 0, i32 0
  %foo3 = load [2 x float], [2 x float] addrspace(1)* %foo2
  store [2 x float] %foo3, [2 x float]* %f1
  %foo4 = load i32, i32* %i
  %foo5 = getelementptr [2 x float], [2 x float]* %f1, i32 0, i32 %foo4
  %foo6 = load float, float* %foo5
  %foo7 = alloca <4 x float>
  %foo8 = load <4 x float>, <4 x float>* %foo7
  %foo9 = insertelement <4 x float> %foo8, float %foo6, i32 0
  %foo10 = insertelement <4 x float> %foo9, float %foo6, i32 1
  %foo11 = insertelement <4 x float> %foo10, float %foo6, i32 2
  %foo12 = insertelement <4 x float> %foo11, float %foo6, i32 3
  %foo13 = getelementptr %gl_PerVertex, %gl_PerVertex addrspace(1)* @pv, i32 0, i32 0
  store <4 x float> %foo12, <4 x float> addrspace(1)* %foo13
  ret void
}

@tmp_g = external addrspace(1) global { [4 x double], <2 x double>, <3 x double>, <4 x double> }
@frag_color = external addrspace(1) global <4 x float>

define amdgpu_ps void @promote_double_aggr() #0 {
; CHECK-LABEL: @promote_double_aggr(
; CHECK-NEXT:    [[S:%.*]] = alloca [2 x double], align 8
; CHECK-NEXT:    [[FOO:%.*]] = getelementptr { [4 x double], <2 x double>, <3 x double>, <4 x double> }, { [4 x double], <2 x double>, <3 x double>, <4 x double> } addrspace(1)* @tmp_g, i32 0, i32 0, i32 0
; CHECK-NEXT:    [[FOO1:%.*]] = load double, double addrspace(1)* [[FOO]], align 8
; CHECK-NEXT:    [[FOO2:%.*]] = getelementptr { [4 x double], <2 x double>, <3 x double>, <4 x double> }, { [4 x double], <2 x double>, <3 x double>, <4 x double> } addrspace(1)* @tmp_g, i32 0, i32 0, i32 1
; CHECK-NEXT:    [[FOO3:%.*]] = load double, double addrspace(1)* [[FOO2]], align 8
; CHECK-NEXT:    [[FOO4:%.*]] = insertvalue [2 x double] undef, double [[FOO1]], 0
; CHECK-NEXT:    [[FOO5:%.*]] = insertvalue [2 x double] [[FOO4]], double [[FOO3]], 1
; CHECK-NEXT:    store [2 x double] [[FOO5]], [2 x double]* [[S]], align 8
; CHECK-NEXT:    [[FOO6:%.*]] = getelementptr [2 x double], [2 x double]* [[S]], i32 0, i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast [2 x double]* [[S]] to <2 x double>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x double>, <2 x double>* [[TMP1]], align 16
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x double> [[TMP2]], i64 1
; CHECK-NEXT:    [[FOO8:%.*]] = getelementptr [2 x double], [2 x double]* [[S]], i32 0, i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast [2 x double]* [[S]] to <2 x double>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x double>, <2 x double>* [[TMP4]], align 16
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x double> [[TMP5]], i64 1
; CHECK-NEXT:    [[FOO10:%.*]] = fadd double [[TMP3]], [[TMP6]]
; CHECK-NEXT:    [[FOO11:%.*]] = getelementptr [2 x double], [2 x double]* [[S]], i32 0, i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast [2 x double]* [[S]] to <2 x double>*
; CHECK-NEXT:    [[TMP8:%.*]] = load <2 x double>, <2 x double>* [[TMP7]], align 16
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <2 x double> [[TMP8]], double [[FOO10]], i32 0
; CHECK-NEXT:    store <2 x double> [[TMP9]], <2 x double>* [[TMP7]], align 16
; CHECK-NEXT:    [[FOO12:%.*]] = getelementptr [2 x double], [2 x double]* [[S]], i32 0, i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast [2 x double]* [[S]] to <2 x double>*
; CHECK-NEXT:    [[TMP11:%.*]] = load <2 x double>, <2 x double>* [[TMP10]], align 16
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double> [[TMP11]], i32 0
; CHECK-NEXT:    [[FOO14:%.*]] = getelementptr [2 x double], [2 x double]* [[S]], i32 0, i32 1
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast [2 x double]* [[S]] to <2 x double>*
; CHECK-NEXT:    [[TMP14:%.*]] = load <2 x double>, <2 x double>* [[TMP13]], align 16
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x double> [[TMP14]], i64 1
; CHECK-NEXT:    [[FOO16:%.*]] = fadd double [[TMP12]], [[TMP15]]
; CHECK-NEXT:    [[FOO17:%.*]] = fptrunc double [[FOO16]] to float
; CHECK-NEXT:    [[FOO18:%.*]] = insertelement <4 x float> undef, float [[FOO17]], i32 0
; CHECK-NEXT:    [[FOO19:%.*]] = insertelement <4 x float> [[FOO18]], float [[FOO17]], i32 1
; CHECK-NEXT:    [[FOO20:%.*]] = insertelement <4 x float> [[FOO19]], float [[FOO17]], i32 2
; CHECK-NEXT:    [[FOO21:%.*]] = insertelement <4 x float> [[FOO20]], float [[FOO17]], i32 3
; CHECK-NEXT:    store <4 x float> [[FOO21]], <4 x float> addrspace(1)* @frag_color, align 16
; CHECK-NEXT:    ret void
;
  %s = alloca [2 x double]
  %foo = getelementptr { [4 x double], <2 x double>, <3 x double>, <4 x double> }, { [4 x double], <2 x double>, <3 x double>, <4 x double> } addrspace(1)* @tmp_g, i32 0, i32 0, i32 0
  %foo1 = load double, double addrspace(1)* %foo
  %foo2 = getelementptr { [4 x double], <2 x double>, <3 x double>, <4 x double> }, { [4 x double], <2 x double>, <3 x double>, <4 x double> } addrspace(1)* @tmp_g, i32 0, i32 0, i32 1
  %foo3 = load double, double addrspace(1)* %foo2
  %foo4 = insertvalue [2 x double] undef, double %foo1, 0
  %foo5 = insertvalue [2 x double] %foo4, double %foo3, 1
  store [2 x double] %foo5, [2 x double]* %s
  %foo6 = getelementptr [2 x double], [2 x double]* %s, i32 0, i32 1
  %foo7 = load double, double* %foo6
  %foo8 = getelementptr [2 x double], [2 x double]* %s, i32 0, i32 1
  %foo9 = load double, double* %foo8
  %foo10 = fadd double %foo7, %foo9
  %foo11 = getelementptr [2 x double], [2 x double]* %s, i32 0, i32 0
  store double %foo10, double* %foo11
  %foo12 = getelementptr [2 x double], [2 x double]* %s, i32 0, i32 0
  %foo13 = load double, double* %foo12
  %foo14 = getelementptr [2 x double], [2 x double]* %s, i32 0, i32 1
  %foo15 = load double, double* %foo14
  %foo16 = fadd double %foo13, %foo15
  %foo17 = fptrunc double %foo16 to float
  %foo18 = insertelement <4 x float> undef, float %foo17, i32 0
  %foo19 = insertelement <4 x float> %foo18, float %foo17, i32 1
  %foo20 = insertelement <4 x float> %foo19, float %foo17, i32 2
  %foo21 = insertelement <4 x float> %foo20, float %foo17, i32 3
  store <4 x float> %foo21, <4 x float> addrspace(1)* @frag_color
  ret void
}

; Don't crash on a type that isn't a valid vector element.
define amdgpu_kernel void @alloca_struct() #0 {
; CHECK-LABEL: @alloca_struct(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call noalias nonnull dereferenceable(64) i8 addrspace(4)* @llvm.amdgcn.dispatch.ptr()
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8 addrspace(4)* [[TMP0]] to i32 addrspace(4)*
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32 addrspace(4)* [[TMP1]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32 addrspace(4)* [[TMP2]], align 4, !invariant.load !0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32 addrspace(4)* [[TMP1]], i64 2
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, i32 addrspace(4)* [[TMP4]], align 4, !range [[RNG1:![0-9]+]], !invariant.load !0
; CHECK-NEXT:    [[TMP6:%.*]] = lshr i32 [[TMP3]], 16
; CHECK-NEXT:    [[TMP7:%.*]] = call i32 @llvm.amdgcn.workitem.id.x(), !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    [[TMP8:%.*]] = call i32 @llvm.amdgcn.workitem.id.y(), !range [[RNG2]]
; CHECK-NEXT:    [[TMP9:%.*]] = call i32 @llvm.amdgcn.workitem.id.z(), !range [[RNG2]]
; CHECK-NEXT:    [[TMP10:%.*]] = mul nuw nsw i32 [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP11:%.*]] = mul i32 [[TMP10]], [[TMP7]]
; CHECK-NEXT:    [[TMP12:%.*]] = mul nuw nsw i32 [[TMP8]], [[TMP5]]
; CHECK-NEXT:    [[TMP13:%.*]] = add i32 [[TMP11]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = add i32 [[TMP13]], [[TMP9]]
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [1024 x [2 x %struct]], [1024 x [2 x %struct]] addrspace(3)* @alloca_struct.alloca, i32 0, i32 [[TMP14]]
; CHECK-NEXT:    ret void
;
entry:
  %alloca = alloca [2 x %struct], align 4
  ret void
}
