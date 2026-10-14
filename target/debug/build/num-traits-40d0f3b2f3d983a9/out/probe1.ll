; ModuleID = 'probe1.54d39e0195e5142c-cgu.0'
source_filename = "probe1.54d39e0195e5142c-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; <f64>::to_int_unchecked::<i32>
; Function Attrs: inlinehint nonlazybind uwtable
define i32 @_RINvMNtCsevLNFiNqfJP_4core3f64d16to_int_uncheckedlECs7hwRVSyXqTE_6probe1(double %self) unnamed_addr #0 !guid !4 {
start:
; call <f64 as core::convert::num::FloatToInt<i32>>::to_int_unchecked
  %_0 = call i32 @_RNvXsu_NtNtCsevLNFiNqfJP_4core7convert3numdINtB5_10FloatToIntlE16to_int_uncheckedCs7hwRVSyXqTE_6probe1(double %self) #2
  ret i32 %_0
}

; probe1::probe
; Function Attrs: nonlazybind uwtable
define void @_RNvCs7hwRVSyXqTE_6probe15probe() unnamed_addr #1 !guid !5 {
start:
; call <f64>::to_int_unchecked::<i32>
  %_1 = call i32 @_RINvMNtCsevLNFiNqfJP_4core3f64d16to_int_uncheckedlECs7hwRVSyXqTE_6probe1(double 1.000000e+00) #2
  ret void
}

; <f64 as core::convert::num::FloatToInt<i32>>::to_int_unchecked
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @_RNvXsu_NtNtCsevLNFiNqfJP_4core7convert3numdINtB5_10FloatToIntlE16to_int_uncheckedCs7hwRVSyXqTE_6probe1(double %self) unnamed_addr #0 !guid !6 {
start:
  %_0 = fptosi double %self to i32
  ret i32 %_0
}

attributes #0 = { inlinehint nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { inlinehint }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!4 = !{i64 1300335145454425943}
!5 = !{i64 8101334900759031397}
!6 = !{i64 2335143062770377990}
