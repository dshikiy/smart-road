; ModuleID = 'probe4.c59863efeeda85c0-cgu.0'
source_filename = "probe4.c59863efeeda85c0-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@alloc_7971f3465817cc18ad816e3dbdd7087a = private unnamed_addr constant [7 x i8] c"<anon>\00", align 1, !guid !0
@alloc_9d40747e106cbf85f7bd532d58745d14 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_7971f3465817cc18ad816e3dbdd7087a, [16 x i8] c"\06\00\00\00\00\00\00\00\01\00\00\00\1F\00\00\00" }>, align 8, !guid !1

; probe4::probe
; Function Attrs: nonlazybind uwtable
define void @_RNvCsgXNi1zWp5ca_6probe45probe() unnamed_addr #0 !guid !6 {
start:
  ret void
}

; core::panicking::panic_const::panic_const_div_by_zero
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_RNvNtNtCsevLNFiNqfJP_4core9panicking11panic_const23panic_const_div_by_zero(ptr align 8) unnamed_addr #1

attributes #0 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { cold noinline noreturn nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }

!llvm.module.flags = !{!2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i64 -8842848959495224207}
!1 = !{i64 -5519750418217637898}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 2, !"RtLibUseGOT", i32 1}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!6 = !{i64 4753489662791588117}
