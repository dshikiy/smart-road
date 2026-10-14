; ModuleID = 'probe5.26a48f214945f2e1-cgu.0'
source_filename = "probe5.26a48f214945f2e1-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; probe5::probe
; Function Attrs: nonlazybind uwtable
define void @_RNvCs3jH4G4xdjNd_6probe55probe() unnamed_addr #0 !guid !4 {
start:
; call <f64>::copysign
  %_1 = call double @_RNvMNtCsevLNFiNqfJP_4core3f64d8copysignCs3jH4G4xdjNd_6probe5(double 1.000000e+00, double -1.000000e+00) #3
  ret void
}

; <f64>::copysign
; Function Attrs: inlinehint nonlazybind uwtable
define internal double @_RNvMNtCsevLNFiNqfJP_4core3f64d8copysignCs3jH4G4xdjNd_6probe5(double %self, double %sign) unnamed_addr #1 !guid !5 {
start:
  %_0 = call double @llvm.copysign.f64(double %self, double %sign)
  ret double %_0
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.copysign.f64(double, double) #2

attributes #0 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { inlinehint nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { inlinehint }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!4 = !{i64 -3277833089439458529}
!5 = !{i64 -7307106076837000616}
