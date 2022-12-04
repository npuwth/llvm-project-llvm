; RUN: opt < %s -passes=sroa -S | FileCheck %s
;
; Make sure the llvm.access.group meta-data is preserved
; when a load/store is replaced with another load/store by sroa
;
; class Complex {
; private:
;  float real_;
;  float imaginary_;
;
; public:
;   Complex() : real_(0), imaginary_(0) { }
;   Complex(float real, float imaginary) : real_(real), imaginary_(imaginary) { }
;   Complex(const Complex &rhs) : real_(rhs.real()), imaginary_(rhs.imaginary()) { }
; 
;   inline float real() const { return real_; }
;   inline float imaginary() const { return imaginary_; }
; 
;   Complex operator+(const Complex& rhs) const
;   {
;     return Complex(real_ + rhs.real_, imaginary_ + rhs.imaginary_);
;   }
; };
; 
; void test(Complex *out, long size)
; {
;     #pragma clang loop vectorize(assume_safety)
;     for (long offset = 0; offset < size; ++offset) {
;       Complex t0 = out[offset];
;       out[offset] = t0 + t0;
;     }
; }

; CHECK: for.body:
; CHECK-NOT:  store i32 %{{.*}}, ptr %{{.*}}, align 4
; CHECK: store i32 %{{.*}}, ptr %{{.*}}, align 4, !llvm.access.group !1
; CHECK-NOT:  store i32 %{{.*}}, ptr %{{.*}}, align 4
; CHECK: store i32 %{{.*}}, ptr %{{.*}}, align 4, !llvm.access.group !1
; CHECK-NOT:  store i32 %{{.*}}, ptr %{{.*}}, align 4
; CHECK: br label

; ModuleID = '<stdin>'
source_filename = "mem-par-metadata-sroa1.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%class.Complex = type { float, float }

; Function Attrs: norecurse nounwind uwtable
define void @_Z4testP7Complexl(ptr nocapture %out, i64 %size) local_unnamed_addr #0 {
entry:
  %t0 = alloca %class.Complex, align 4
  %ref.tmp = alloca i64, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %offset.0 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i64 %offset.0, %size
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %arrayidx = getelementptr inbounds %class.Complex, ptr %out, i64 %offset.0
  %0 = load float, ptr %arrayidx, align 4, !llvm.access.group !11
  store float %0, ptr %t0, align 4, !llvm.access.group !11
  %imaginary_.i = getelementptr inbounds %class.Complex, ptr %t0, i64 0, i32 1
  %imaginary_.i.i = getelementptr inbounds %class.Complex, ptr %arrayidx, i64 0, i32 1
  %1 = load float, ptr %imaginary_.i.i, align 4, !llvm.access.group !11
  store float %1, ptr %imaginary_.i, align 4, !llvm.access.group !11
  %arrayidx1 = getelementptr inbounds %class.Complex, ptr %out, i64 %offset.0
  %2 = load float, ptr %t0, align 4, !noalias !3, !llvm.access.group !11
  %3 = load float, ptr %t0, align 4, !noalias !3, !llvm.access.group !11
  %add.i = fadd float %2, %3
  %imaginary_.i2 = getelementptr inbounds %class.Complex, ptr %t0, i64 0, i32 1
  %4 = load float, ptr %imaginary_.i2, align 4, !noalias !3, !llvm.access.group !11
  %imaginary_3.i = getelementptr inbounds %class.Complex, ptr %t0, i64 0, i32 1
  %5 = load float, ptr %imaginary_3.i, align 4, !noalias !3, !llvm.access.group !11
  %add4.i = fadd float %4, %5
  store float %add.i, ptr %ref.tmp, align 4, !alias.scope !3, !llvm.access.group !11
  %imaginary_.i.i4 = getelementptr inbounds %class.Complex, ptr %ref.tmp, i64 0, i32 1
  store float %add4.i, ptr %imaginary_.i.i4, align 4, !alias.scope !3, !llvm.access.group !11
  %6 = load i64, ptr %ref.tmp, align 8, !llvm.access.group !11
  store i64 %6, ptr %arrayidx1, align 4, !llvm.access.group !11
  %inc = add nsw i64 %offset.0, 1
  br label %for.cond, !llvm.loop !1

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0.p0.i64(ptr nocapture writeonly, ptr nocapture readonly, i64, i1) #1

attributes #0 = { norecurse nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.0 (cfe/trunk 277751)"}
!1 = distinct !{!1, !2, !{!"llvm.loop.parallel_accesses", !11}}
!2 = !{!"llvm.loop.vectorize.enable", i1 true}
!3 = !{!4}
!4 = distinct !{!4, !5, !"_ZNK7ComplexplERKS_: %agg.result"}
!5 = distinct !{!5, !"_ZNK7ComplexplERKS_"}
!11 = distinct !{}
