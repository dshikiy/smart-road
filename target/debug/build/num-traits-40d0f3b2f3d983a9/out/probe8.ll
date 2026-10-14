; ModuleID = 'probe8.1ee6ba3a5a8a4ecf-cgu.0'
source_filename = "probe8.1ee6ba3a5a8a4ecf-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; probe8::probe
; Function Attrs: nonlazybind uwtable
define void @_RNvCs2EubcajJr1r_6probe85probe() unnamed_addr #0 !guid !4 {
start:
  %0 = alloca [8 x i8], align 8
  %_1 = alloca [8 x i8], align 1
; call <f64>::to_ne_bytes
  %1 = call i64 @_RNvMNtCsevLNFiNqfJP_4core3f64d11to_ne_bytesCs2EubcajJr1r_6probe8(double 3.140000e+00) #3
  store i64 %1, ptr %0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %_1, ptr align 8 %0, i64 8, i1 false)
  ret void
}

; <f64>::to_ne_bytes
; Function Attrs: inlinehint nonlazybind uwtable
define internal i64 @_RNvMNtCsevLNFiNqfJP_4core3f64d11to_ne_bytesCs2EubcajJr1r_6probe8(double %self) unnamed_addr #1 !guid !5 {
start:
  %_0 = alloca [8 x i8], align 1
  store double %self, ptr %_0, align 1
  %0 = load i64, ptr %_0, align 1
  ret i64 %0
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #2

attributes #0 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { inlinehint nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { inlinehint }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!4 = !{i64 -7831440490054409541}
!5 = !{i64 8190620000372683666}
