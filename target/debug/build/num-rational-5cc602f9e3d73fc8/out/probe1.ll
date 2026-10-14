; ModuleID = 'probe1.54d39e0195e5142c-cgu.0'
source_filename = "probe1.54d39e0195e5142c-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"core::fmt::rt::Argument<'_>" = type { %"core::fmt::rt::ArgumentType<'_>" }
%"core::fmt::rt::ArgumentType<'_>" = type { ptr, [1 x i64] }

@alloc_f3e6d88636bad2504ac07112d74ba259 = private unnamed_addr constant [76 x i8] c"/rustc/b940084d7eb6a299eb4bfeb8e34901bc051e7ac4/library/core/src/ptr/mod.rs\00", align 1, !guid !0
@alloc_6085f673fcdf6f117e8be1ff231fb280 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_f3e6d88636bad2504ac07112d74ba259, [16 x i8] c"K\00\00\00\00\00\00\00)\02\00\00\05\00\00\00" }>, align 8, !guid !1
@alloc_b022f8e3c49dcc4b41e62a7efb81736f = private unnamed_addr constant [77 x i8] c"/rustc/b940084d7eb6a299eb4bfeb8e34901bc051e7ac4/library/alloc/src/vec/mod.rs\00", align 1, !guid !2
@alloc_8cc18e90b3f4fb0b1c417af367f56a76 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_b022f8e3c49dcc4b41e62a7efb81736f, [16 x i8] c"L\00\00\00\00\00\00\00\AA\08\00\00\09\00\00\00" }>, align 8, !guid !3
@alloc_53973d2fe29b4adba8bb7390b5678745 = private unnamed_addr constant [8 x i8] zeroinitializer, align 8, !guid !4
@alloc_0c812808379efded5a4fb82d2790b556 = private unnamed_addr constant [2 x i8] c"\C0\00", align 1, !guid !5
@alloc_fad0cd83b7d1858a846a172eb260e593 = private unnamed_addr constant [42 x i8] c"is_aligned_to: align is not a power-of-two", align 1, !guid !6
@alloc_d80be71c932fbcc0c32dfee0e64c24fe = private unnamed_addr constant [82 x i8] c"/rustc/b940084d7eb6a299eb4bfeb8e34901bc051e7ac4/library/core/src/ptr/const_ptr.rs\00", align 1, !guid !7
@alloc_70b952c9892b9c196e1aafa566669edd = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_d80be71c932fbcc0c32dfee0e64c24fe, [16 x i8] c"Q\00\00\00\00\00\00\00M\05\00\00\0D\00\00\00" }>, align 8, !guid !8
@alloc_c781a4cd159c9b9c4d2ca17c50fa6ddb = private unnamed_addr constant [81 x i8] c"/rustc/b940084d7eb6a299eb4bfeb8e34901bc051e7ac4/library/alloc/src/raw_vec/mod.rs\00", align 1, !guid !9
@alloc_37236f5e2d50b072885611161a5a9ffc = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_c781a4cd159c9b9c4d2ca17c50fa6ddb, [16 x i8] c"P\00\00\00\00\00\00\00\B7\01\00\00\15\00\00\00" }>, align 8, !guid !10
@alloc_ec238397f38719b153f5e4b6080e1ac2 = private unnamed_addr constant [76 x i8] c"/rustc/b940084d7eb6a299eb4bfeb8e34901bc051e7ac4/library/core/src/fmt/mod.rs\00", align 1, !guid !11
@alloc_2613159de3ddde3cd77c65c9866ce5d4 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_ec238397f38719b153f5e4b6080e1ac2, [16 x i8] c"K\00\00\00\00\00\00\00q\03\00\00*\00\00\00" }>, align 8, !guid !12
@anon.bd98587c01d61877380a7407c891b2d1.0 = private unnamed_addr constant <{ [8 x i8], [8 x i8] }> <{ [8 x i8] zeroinitializer, [8 x i8] undef }>, align 8, !guid !13
@alloc_57d70e9d94c65ecfc15225d29a5ed72b = private unnamed_addr constant [198 x i8] c"unsafe precondition(s) violated: Vec::set_len requires that new_len <= capacity()\0A\0AThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety.", align 1, !guid !14
@alloc_bd3468a7b96187f70c1ce98a3e7a63bf = private unnamed_addr constant [283 x i8] c"unsafe precondition(s) violated: ptr::copy_nonoverlapping requires that both pointer arguments are aligned and non-null and the specified memory ranges do not overlap\0A\0AThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety.", align 1, !guid !15
@alloc_64e308ef4babfeb8b6220184de794a17 = private unnamed_addr constant [221 x i8] c"unsafe precondition(s) violated: hint::assert_unchecked must never be called when the condition is false\0A\0AThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety.", align 1, !guid !16
@alloc_763310d78c99c2c1ad3f8a9821e942f3 = private unnamed_addr constant [61 x i8] c"is_nonoverlapping: `size_of::<T>() * count` overflows a usize", align 1, !guid !17
@alloc_a28e8c8fd5088943a8b5d44af697ff83 = private unnamed_addr constant [279 x i8] c"unsafe precondition(s) violated: slice::from_raw_parts requires the pointer to be aligned and non-null, and the total size of the slice not to exceed `isize::MAX`\0A\0AThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety.", align 1, !guid !18

; <core::option::Option<&str>>::map_or_else::<alloc::string::String, alloc::fmt::format::{closure#0}, <str as alloc::borrow::ToOwned>::to_owned>
; Function Attrs: inlinehint nonlazybind uwtable
define void @_RINvMNtCsevLNFiNqfJP_4core6optionINtB3_6OptionReE11map_or_elseNtNtCs1C1lLj4PWSY_5alloc6string6StringNCNvNtB12_3fmt6format0NvYeNtNtB12_6borrow7ToOwned8to_ownedECs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr %0, i64 %1, ptr align 8 %default) unnamed_addr #0 personality ptr @rust_eh_personality !guid !23 {
start:
  %_10 = alloca [1 x i8], align 1
  %_9 = alloca [1 x i8], align 1
  %self = alloca [16 x i8], align 8
  store ptr %0, ptr %self, align 8
  %2 = getelementptr inbounds i8, ptr %self, i64 8
  store i64 %1, ptr %2, align 8
  store i8 1, ptr %_10, align 1
  store i8 1, ptr %_9, align 1
  %3 = load ptr, ptr %self, align 8
  %4 = getelementptr inbounds i8, ptr %self, i64 8
  %5 = load i64, ptr %4, align 8
  %6 = ptrtoint ptr %3 to i64
  %7 = icmp eq i64 %6, 0
  %_4 = select i1 %7, i64 0, i64 1
  %8 = trunc nuw i64 %_4 to i1
  br i1 %8, label %bb3, label %bb2

bb3:                                              ; preds = %start
  %t.0 = load ptr, ptr %self, align 8
  %9 = getelementptr inbounds i8, ptr %self, i64 8
  %t.1 = load i64, ptr %9, align 8
  store i8 0, ptr %_9, align 1
; call <<str as alloc::borrow::ToOwned>::to_owned as core::ops::function::FnOnce<(&str,)>>::call_once
  call void @_RNvYNvYeNtNtCs1C1lLj4PWSY_5alloc6borrow7ToOwned8to_ownedINtNtNtCsevLNFiNqfJP_4core3ops8function6FnOnceTReEE9call_onceCs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr %t.0, i64 %t.1) #11
  br label %bb4

bb2:                                              ; preds = %start
  store i8 0, ptr %_10, align 1
; call alloc::fmt::format::{closure#0}
  call void @_RNCNvNtCs1C1lLj4PWSY_5alloc3fmt6format0Cs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr align 8 %default) #11
  br label %bb5

bb5:                                              ; preds = %bb2
  br label %bb6

bb6:                                              ; preds = %bb4, %bb5
  ret void

bb4:                                              ; preds = %bb3
  br label %bb6

bb1:                                              ; No predecessors!
  unreachable

bb7:                                              ; No predecessors!
  unreachable

bb8:                                              ; No predecessors!
  unreachable

bb9:                                              ; No predecessors!
  unreachable

bb10:                                             ; No predecessors!
  unreachable

bb11:                                             ; No predecessors!
  unreachable
}

; <core::fmt::rt::Argument>::new_lower_exp::<isize>
; Function Attrs: inlinehint nonlazybind uwtable
define void @_RINvMNtNtCsevLNFiNqfJP_4core3fmt2rtNtB3_8Argument13new_lower_expiECs7hwRVSyXqTE_6probe1(ptr sret([16 x i8]) align 8 %_0, ptr align 8 %x) unnamed_addr #0 !guid !24 {
start:
  %_2 = alloca [16 x i8], align 8
  store ptr %x, ptr %_2, align 8
  %0 = getelementptr inbounds i8, ptr %_2, i64 8
  store ptr @_RNvXsD_NtNtNtCsevLNFiNqfJP_4core3fmt3num3impiNtB9_8LowerExp3fmt, ptr %0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %_0, ptr align 8 %_2, i64 16, i1 false)
  ret void
}

; <core::fmt::Arguments>::new::<2, 1>
; Function Attrs: inlinehint nonlazybind uwtable
define { ptr, ptr } @_RINvMs2_NtCsevLNFiNqfJP_4core3fmtNtB6_9Arguments3newKj2_Kj1_ECs7hwRVSyXqTE_6probe1(ptr %template, ptr align 8 %args) unnamed_addr #0 !guid !25 {
start:
  %0 = insertvalue { ptr, ptr } poison, ptr %template, 0
  %1 = insertvalue { ptr, ptr } %0, ptr %args, 1
  ret { ptr, ptr } %1
}

; core::ptr::drop_glue::<alloc::vec::Vec<u8>>
; Function Attrs: nonlazybind uwtable
define void @_RINvNtCsevLNFiNqfJP_4core3ptr9drop_glueINtNtCs1C1lLj4PWSY_5alloc3vec3VechEECs7hwRVSyXqTE_6probe1(ptr align 8 %_1) unnamed_addr #1 personality ptr @rust_eh_personality !guid !26 {
start:
  %0 = alloca [16 x i8], align 8
; invoke <alloc::vec::Vec<u8> as core::ops::drop::Drop>::drop
  invoke void @_RNvXsp_NtCs1C1lLj4PWSY_5alloc3vecINtB5_3VechENtNtNtCsevLNFiNqfJP_4core3ops4drop4Drop4dropCsiK12aF3ve0B_5gimli(ptr align 8 %_1)
          to label %bb4 unwind label %cleanup

bb3:                                              ; preds = %cleanup
; invoke core::ptr::drop_glue::<alloc::raw_vec::RawVec<u8>>
  invoke void @_RINvNtCsevLNFiNqfJP_4core3ptr9drop_glueINtNtCs1C1lLj4PWSY_5alloc7raw_vec6RawVechEECs7hwRVSyXqTE_6probe1(ptr align 8 %_1) #12
          to label %bb2 unwind label %terminate

cleanup:                                          ; preds = %start
  %1 = landingpad { ptr, i32 }
          cleanup
  %2 = extractvalue { ptr, i32 } %1, 0
  %3 = extractvalue { ptr, i32 } %1, 1
  store ptr %2, ptr %0, align 8
  %4 = getelementptr inbounds i8, ptr %0, i64 8
  store i32 %3, ptr %4, align 8
  br label %bb3

bb4:                                              ; preds = %start
; call core::ptr::drop_glue::<alloc::raw_vec::RawVec<u8>>
  call void @_RINvNtCsevLNFiNqfJP_4core3ptr9drop_glueINtNtCs1C1lLj4PWSY_5alloc7raw_vec6RawVechEECs7hwRVSyXqTE_6probe1(ptr align 8 %_1)
  ret void

terminate:                                        ; preds = %bb3
  %5 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking16panic_in_cleanup() #13
  unreachable

bb2:                                              ; preds = %bb3
  %6 = load ptr, ptr %0, align 8
  %7 = getelementptr inbounds i8, ptr %0, i64 8
  %8 = load i32, ptr %7, align 8
  %9 = insertvalue { ptr, i32 } poison, ptr %6, 0
  %10 = insertvalue { ptr, i32 } %9, i32 %8, 1
  resume { ptr, i32 } %10
}

; core::ptr::drop_glue::<alloc::raw_vec::RawVec<u8>>
; Function Attrs: nonlazybind uwtable
define void @_RINvNtCsevLNFiNqfJP_4core3ptr9drop_glueINtNtCs1C1lLj4PWSY_5alloc7raw_vec6RawVechEECs7hwRVSyXqTE_6probe1(ptr align 8 %_1) unnamed_addr #1 !guid !27 {
start:
; call <alloc::raw_vec::RawVec<u8> as core::ops::drop::Drop>::drop
  call void @_RNvXs1_NtCs1C1lLj4PWSY_5alloc7raw_vecINtB5_6RawVechENtNtNtCsevLNFiNqfJP_4core3ops4drop4Drop4dropCsiK12aF3ve0B_5gimli(ptr align 8 %_1)
  ret void
}

; core::ptr::drop_glue::<alloc::string::String>
; Function Attrs: nonlazybind uwtable
define void @_RINvNtCsevLNFiNqfJP_4core3ptr9drop_glueNtNtCs1C1lLj4PWSY_5alloc6string6StringECs7hwRVSyXqTE_6probe1(ptr align 8 %_1) unnamed_addr #1 !guid !28 {
start:
; call core::ptr::drop_glue::<alloc::vec::Vec<u8>>
  call void @_RINvNtCsevLNFiNqfJP_4core3ptr9drop_glueINtNtCs1C1lLj4PWSY_5alloc3vec3VechEECs7hwRVSyXqTE_6probe1(ptr align 8 %_1)
  ret void
}

; <u8 as <[_]>::to_vec_in::ConvertVec>::to_vec::<alloc::alloc::Global>
; Function Attrs: inlinehint nonlazybind uwtable
define void @_RINvXs_NvMNtCs1C1lLj4PWSY_5alloc5sliceSp9to_vec_inhNtB5_10ConvertVec6to_vecNtNtBa_5alloc6GlobalECs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %v, ptr %s.0, i64 %s.1) unnamed_addr #0 !guid !29 {
start:
  %_17 = alloca [8 x i8], align 8
; call <alloc::raw_vec::RawVecInner>::with_capacity_in
  %0 = call { i64, ptr } @_RNvMs5_NtCs1C1lLj4PWSY_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs7hwRVSyXqTE_6probe1(i64 %s.1, i64 1, i64 1) #11
  %_10.0 = extractvalue { i64, ptr } %0, 0
  %_10.1 = extractvalue { i64, ptr } %0, 1
  store i64 %_10.0, ptr %v, align 8
  %1 = getelementptr inbounds i8, ptr %v, i64 8
  store ptr %_10.1, ptr %1, align 8
  %2 = getelementptr inbounds i8, ptr %v, i64 16
  store i64 0, ptr %2, align 8
  %_4 = icmp ugt i64 %s.1, 0
  br i1 %_4, label %bb1, label %bb2

bb2:                                              ; preds = %bb9, %start
  ret void

bb1:                                              ; preds = %start
  %3 = getelementptr inbounds i8, ptr %v, i64 8
  %_12 = load ptr, ptr %3, align 8
  br label %bb4

bb4:                                              ; preds = %bb1
; call core::ptr::copy_nonoverlapping::precondition_check
  call void @_RNvNvNtCsevLNFiNqfJP_4core3ptr19copy_nonoverlapping18precondition_checkCs7hwRVSyXqTE_6probe1(ptr %s.0, ptr %_12, i64 1, i64 1, i64 %s.1, ptr align 8 @alloc_6085f673fcdf6f117e8be1ff231fb280) #14
  br label %bb6

bb6:                                              ; preds = %bb4
  %4 = mul nuw nsw i64 %s.1, 1
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %_12, ptr align 1 %s.0, i64 %4, i1 false)
  br label %bb7

bb7:                                              ; preds = %bb6
  br label %bb12

bb12:                                             ; preds = %bb7
  %self = load i64, ptr %v, align 8
  store i64 %self, ptr %_17, align 8
  br label %bb10

bb10:                                             ; preds = %bb12
  %5 = load i64, ptr %_17, align 8
; call <alloc::vec::Vec<_, _>>::set_len::precondition_check
  call void @_RNvNvMs_NtCs1C1lLj4PWSY_5alloc3vecINtB6_3VecppE7set_len18precondition_checkCs7hwRVSyXqTE_6probe1(i64 %s.1, i64 %5, ptr align 8 @alloc_8cc18e90b3f4fb0b1c417af367f56a76) #14
  br label %bb9

bb9:                                              ; preds = %bb10
  %6 = getelementptr inbounds i8, ptr %v, i64 16
  store i64 %s.1, ptr %6, align 8
  br label %bb2

bb11:                                             ; No predecessors!
  unreachable
}

; alloc::fmt::format::{closure#0}
; Function Attrs: inlinehint nonlazybind uwtable
define void @_RNCNvNtCs1C1lLj4PWSY_5alloc3fmt6format0Cs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr align 8 %_1) unnamed_addr #0 !guid !30 {
start:
  %_2.0 = load ptr, ptr %_1, align 8
  %0 = getelementptr inbounds i8, ptr %_1, i64 8
  %_2.1 = load ptr, ptr %0, align 8
; call alloc::fmt::format::format_inner
  call void @_RNvNvNtCs1C1lLj4PWSY_5alloc3fmt6format12format_inner(ptr sret([24 x i8]) align 8 %_0, ptr %_2.0, ptr %_2.1)
  ret void
}

; probe1::probe
; Function Attrs: nonlazybind uwtable
define void @_RNvCs7hwRVSyXqTE_6probe15probe() unnamed_addr #1 !guid !31 {
start:
  %_7 = alloca [16 x i8], align 8
  %args = alloca [16 x i8], align 8
  %_2 = alloca [24 x i8], align 8
  %_1 = alloca [24 x i8], align 8
; call <core::fmt::rt::Argument>::new_lower_exp::<isize>
  call void @_RINvMNtNtCsevLNFiNqfJP_4core3fmt2rtNtB3_8Argument13new_lower_expiECs7hwRVSyXqTE_6probe1(ptr sret([16 x i8]) align 8 %_7, ptr align 8 @alloc_53973d2fe29b4adba8bb7390b5678745) #11
  %0 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args, i64 0
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %0, ptr align 8 %_7, i64 16, i1 false)
; call <core::fmt::Arguments>::new::<2, 1>
  %1 = call { ptr, ptr } @_RINvMs2_NtCsevLNFiNqfJP_4core3fmtNtB6_9Arguments3newKj2_Kj1_ECs7hwRVSyXqTE_6probe1(ptr @alloc_0c812808379efded5a4fb82d2790b556, ptr align 8 %args) #11
  %_3.0 = extractvalue { ptr, ptr } %1, 0
  %_3.1 = extractvalue { ptr, ptr } %1, 1
; call alloc::fmt::format
  call void @_RNvNtCs1C1lLj4PWSY_5alloc3fmt6formatCs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_2, ptr %_3.0, ptr %_3.1) #11
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %_1, ptr align 8 %_2, i64 24, i1 false)
; call core::ptr::drop_glue::<alloc::string::String>
  call void @_RINvNtCsevLNFiNqfJP_4core3ptr9drop_glueNtNtCs1C1lLj4PWSY_5alloc6string6StringECs7hwRVSyXqTE_6probe1(ptr align 8 %_1)
  ret void
}

; <*const ()>::is_aligned_to
; Function Attrs: inlinehint nonlazybind uwtable
define zeroext i1 @_RNvMNtNtCsevLNFiNqfJP_4core3ptr9const_ptrPu13is_aligned_toCs7hwRVSyXqTE_6probe1(ptr %self, i64 %align) unnamed_addr #0 !guid !32 {
start:
  %0 = call i64 @llvm.ctpop.i64(i64 %align)
  %_9 = trunc i64 %0 to i32
  %_3 = icmp eq i32 %_9, 1
  br i1 %_3, label %bb1, label %bb2

bb2:                                              ; preds = %start
; call core::panicking::panic_fmt
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking9panic_fmt(ptr @alloc_fad0cd83b7d1858a846a172eb260e593, ptr inttoptr (i64 85 to ptr), ptr align 8 @alloc_70b952c9892b9c196e1aafa566669edd) #15
  unreachable

bb1:                                              ; preds = %start
  %_7 = ptrtoint ptr %self to i64
  %_8 = sub i64 %align, 1
  %_6 = and i64 %_7, %_8
  %_0 = icmp eq i64 %_6, 0
  ret i1 %_0
}

; <alloc::raw_vec::RawVecInner>::with_capacity_in
; Function Attrs: inlinehint nonlazybind uwtable
define { i64, ptr } @_RNvMs5_NtCs1C1lLj4PWSY_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs7hwRVSyXqTE_6probe1(i64 %capacity, i64 %elem_layout.0, i64 %elem_layout.1) unnamed_addr #0 !guid !33 {
start:
  %self = alloca [8 x i8], align 8
  %_4 = alloca [24 x i8], align 8
; call <alloc::raw_vec::RawVecInner>::try_allocate_in
  call void @_RNvMs5_NtCs1C1lLj4PWSY_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsiK12aF3ve0B_5gimli(ptr sret([24 x i8]) align 8 %_4, i64 %capacity, i1 zeroext false, i64 %elem_layout.0, i64 %elem_layout.1)
  %_5 = load i64, ptr %_4, align 8
  %0 = trunc nuw i64 %_5 to i1
  br i1 %0, label %bb3, label %bb4

bb3:                                              ; preds = %start
  %1 = getelementptr inbounds i8, ptr %_4, i64 8
  %err.0 = load i64, ptr %1, align 8
  %2 = getelementptr inbounds i8, ptr %1, i64 8
  %err.1 = load i64, ptr %2, align 8
; call alloc::raw_vec::handle_error
  call void @_RNvNtCs1C1lLj4PWSY_5alloc7raw_vec12handle_error(i64 %err.0, i64 %err.1) #16
  unreachable

bb4:                                              ; preds = %start
  %3 = getelementptr inbounds i8, ptr %_4, i64 8
  %this.0 = load i64, ptr %3, align 8
  %4 = getelementptr inbounds i8, ptr %3, i64 8
  %this.1 = load ptr, ptr %4, align 8
  %5 = icmp eq i64 %elem_layout.1, 0
  br i1 %5, label %bb6, label %bb7

bb6:                                              ; preds = %bb4
  store i64 -1, ptr %self, align 8
  br label %bb5

bb7:                                              ; preds = %bb4
  store i64 %this.0, ptr %self, align 8
  br label %bb5

bb5:                                              ; preds = %bb7, %bb6
  %6 = load i64, ptr %self, align 8
  %_11 = sub i64 %6, 0
  %_7 = icmp ugt i64 %capacity, %_11
  %cond = xor i1 %_7, true
  br label %bb8

bb8:                                              ; preds = %bb5
; call core::hint::assert_unchecked::precondition_check
  call void @_RNvNvNtCsevLNFiNqfJP_4core4hint16assert_unchecked18precondition_checkCs7hwRVSyXqTE_6probe1(i1 zeroext %cond, ptr align 8 @alloc_37236f5e2d50b072885611161a5a9ffc) #14
  br label %bb9

bb9:                                              ; preds = %bb8
  %7 = insertvalue { i64, ptr } poison, i64 %this.0, 0
  %8 = insertvalue { i64, ptr } %7, ptr %this.1, 1
  ret { i64, ptr } %8

bb2:                                              ; No predecessors!
  unreachable
}

; alloc::fmt::format
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_RNvNtCs1C1lLj4PWSY_5alloc3fmt6formatCs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr %0, ptr %1) unnamed_addr #0 !guid !34 {
start:
  %_2 = alloca [16 x i8], align 8
  %args = alloca [16 x i8], align 8
  store ptr %0, ptr %args, align 8
  %2 = getelementptr inbounds i8, ptr %args, i64 8
  store ptr %1, ptr %2, align 8
  %3 = getelementptr inbounds i8, ptr %args, i64 8
  %_7 = load ptr, ptr %3, align 8
  %bits = ptrtoint ptr %_7 to i64
  %_8 = and i64 %bits, 1
  %4 = icmp eq i64 %_8, 1
  br i1 %4, label %bb2, label %bb3

bb2:                                              ; preds = %start
  %self = load ptr, ptr %args, align 8
  %len = lshr i64 %bits, 1
  br label %bb5

bb3:                                              ; preds = %start
  %5 = load ptr, ptr @anon.bd98587c01d61877380a7407c891b2d1.0, align 8
  %6 = load i64, ptr getelementptr inbounds (i8, ptr @anon.bd98587c01d61877380a7407c891b2d1.0, i64 8), align 8
  store ptr %5, ptr %_2, align 8
  %7 = getelementptr inbounds i8, ptr %_2, i64 8
  store i64 %6, ptr %7, align 8
  br label %bb4

bb5:                                              ; preds = %bb2
; call core::slice::raw::from_raw_parts::precondition_check
  call void @_RNvNvNtNtCsevLNFiNqfJP_4core5slice3raw14from_raw_parts18precondition_checkCs7hwRVSyXqTE_6probe1(ptr %self, i64 1, i64 1, i64 %len, ptr align 8 @alloc_2613159de3ddde3cd77c65c9866ce5d4) #14
  br label %bb7

bb7:                                              ; preds = %bb5
  store ptr %self, ptr %_2, align 8
  %8 = getelementptr inbounds i8, ptr %_2, i64 8
  store i64 %len, ptr %8, align 8
  br label %bb4

bb4:                                              ; preds = %bb3, %bb7
  %9 = load ptr, ptr %_2, align 8
  %10 = getelementptr inbounds i8, ptr %_2, i64 8
  %11 = load i64, ptr %10, align 8
; call <core::option::Option<&str>>::map_or_else::<alloc::string::String, alloc::fmt::format::{closure#0}, <str as alloc::borrow::ToOwned>::to_owned>
  call void @_RINvMNtCsevLNFiNqfJP_4core6optionINtB3_6OptionReE11map_or_elseNtNtCs1C1lLj4PWSY_5alloc6string6StringNCNvNtB12_3fmt6format0NvYeNtNtB12_6borrow7ToOwned8to_ownedECs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr %9, i64 %11, ptr align 8 %args) #11
  ret void
}

; core::intrinsics::cold_path
; Function Attrs: cold nounwind nonlazybind uwtable
define internal void @_RNvNtCsevLNFiNqfJP_4core10intrinsics9cold_pathCs7hwRVSyXqTE_6probe1() unnamed_addr #2 !guid !35 {
start:
  ret void
}

; <alloc::vec::Vec<_, _>>::set_len::precondition_check
; Function Attrs: inlinehint nounwind nonlazybind uwtable
define internal void @_RNvNvMs_NtCs1C1lLj4PWSY_5alloc3vecINtB6_3VecppE7set_len18precondition_checkCs7hwRVSyXqTE_6probe1(i64 %new_len, i64 %capacity, ptr align 8 %0) unnamed_addr #3 !guid !36 {
start:
  %_3 = icmp ule i64 %new_len, %capacity
  br i1 %_3, label %bb1, label %bb2

bb2:                                              ; preds = %start
; call core::panicking::panic_nounwind_fmt
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking18panic_nounwind_fmt(ptr @alloc_57d70e9d94c65ecfc15225d29a5ed72b, ptr inttoptr (i64 397 to ptr), i1 zeroext false, ptr align 8 %0) #17
  unreachable

bb1:                                              ; preds = %start
  ret void
}

; core::ptr::copy_nonoverlapping::precondition_check
; Function Attrs: inlinehint nounwind nonlazybind uwtable
define internal void @_RNvNvNtCsevLNFiNqfJP_4core3ptr19copy_nonoverlapping18precondition_checkCs7hwRVSyXqTE_6probe1(ptr %src, ptr %dst, i64 %size, i64 %align, i64 %count, ptr align 8 %0) unnamed_addr #3 personality ptr @rust_eh_personality !guid !37 {
start:
  %zero_size = alloca [1 x i8], align 1
  %1 = icmp eq i64 %count, 0
  br i1 %1, label %bb1, label %bb2

bb1:                                              ; preds = %start
  store i8 1, ptr %zero_size, align 1
  br label %bb3

bb2:                                              ; preds = %start
  %2 = icmp eq i64 %size, 0
  %3 = zext i1 %2 to i8
  store i8 %3, ptr %zero_size, align 1
  br label %bb3

bb3:                                              ; preds = %bb2, %bb1
  %4 = load i8, ptr %zero_size, align 1
  %is_zst = trunc nuw i8 %4 to i1
; invoke <*const ()>::is_aligned_to
  %_15 = invoke zeroext i1 @_RNvMNtNtCsevLNFiNqfJP_4core3ptr9const_ptrPu13is_aligned_toCs7hwRVSyXqTE_6probe1(ptr %src, i64 %align)
          to label %bb15 unwind label %terminate

terminate:                                        ; preds = %bb5, %bb4, %bb3
  %5 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_cannot_unwind
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking19panic_cannot_unwind() #13
  unreachable

bb15:                                             ; preds = %bb3
  br i1 %_15, label %bb11, label %bb12

bb12:                                             ; preds = %bb15
  br label %bb7

bb11:                                             ; preds = %bb15
  br i1 %is_zst, label %bb13, label %bb14

bb7:                                              ; preds = %bb14, %bb12
  br label %bb8

bb14:                                             ; preds = %bb11
  %_17 = ptrtoint ptr %src to i64
  %_16 = icmp eq i64 %_17, 0
  %_8 = xor i1 %_16, true
  br i1 %_8, label %bb4, label %bb7

bb13:                                             ; preds = %bb11
  br label %bb4

bb4:                                              ; preds = %bb13, %bb14
; invoke <*const ()>::is_aligned_to
  %_18 = invoke zeroext i1 @_RNvMNtNtCsevLNFiNqfJP_4core3ptr9const_ptrPu13is_aligned_toCs7hwRVSyXqTE_6probe1(ptr %dst, i64 %align)
          to label %bb20 unwind label %terminate

bb8:                                              ; preds = %bb6, %bb7
  br label %bb9

bb20:                                             ; preds = %bb4
  br i1 %_18, label %bb16, label %bb17

bb17:                                             ; preds = %bb20
  br label %bb6

bb16:                                             ; preds = %bb20
  %6 = load i8, ptr %zero_size, align 1
  %7 = trunc nuw i8 %6 to i1
  br i1 %7, label %bb18, label %bb19

bb6:                                              ; preds = %bb19, %bb17
  br label %bb8

bb19:                                             ; preds = %bb16
  %_20 = ptrtoint ptr %dst to i64
  %_19 = icmp eq i64 %_20, 0
  %_10 = xor i1 %_19, true
  br i1 %_10, label %bb5, label %bb6

bb18:                                             ; preds = %bb16
  br label %bb5

bb5:                                              ; preds = %bb18, %bb19
; invoke core::ub_checks::maybe_is_nonoverlapping::runtime
  %_6 = invoke zeroext i1 @_RNvNvNtCsevLNFiNqfJP_4core9ub_checks23maybe_is_nonoverlapping7runtimeCs7hwRVSyXqTE_6probe1(ptr %src, ptr %dst, i64 %size, i64 %count)
          to label %bb21 unwind label %terminate

bb9:                                              ; preds = %bb21, %bb8
; call core::panicking::panic_nounwind_fmt
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking18panic_nounwind_fmt(ptr @alloc_bd3468a7b96187f70c1ce98a3e7a63bf, ptr inttoptr (i64 567 to ptr), i1 zeroext false, ptr align 8 %0) #17
  unreachable

bb21:                                             ; preds = %bb5
  br i1 %_6, label %bb10, label %bb9

bb10:                                             ; preds = %bb21
  ret void
}

; core::hint::assert_unchecked::precondition_check
; Function Attrs: inlinehint nounwind nonlazybind uwtable
define internal void @_RNvNvNtCsevLNFiNqfJP_4core4hint16assert_unchecked18precondition_checkCs7hwRVSyXqTE_6probe1(i1 zeroext %cond, ptr align 8 %0) unnamed_addr #3 !guid !38 {
start:
  br i1 %cond, label %bb2, label %bb1

bb1:                                              ; preds = %start
; call core::panicking::panic_nounwind_fmt
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking18panic_nounwind_fmt(ptr @alloc_64e308ef4babfeb8b6220184de794a17, ptr inttoptr (i64 443 to ptr), i1 zeroext false, ptr align 8 %0) #17
  unreachable

bb2:                                              ; preds = %start
  ret void
}

; core::ub_checks::maybe_is_nonoverlapping::runtime
; Function Attrs: inlinehint nonlazybind uwtable
define internal zeroext i1 @_RNvNvNtCsevLNFiNqfJP_4core9ub_checks23maybe_is_nonoverlapping7runtimeCs7hwRVSyXqTE_6probe1(ptr %src, ptr %dst, i64 %size, i64 %count) unnamed_addr #0 !guid !39 {
start:
  %diff = alloca [8 x i8], align 8
  %_9 = alloca [16 x i8], align 8
  %src_usize = ptrtoint ptr %src to i64
  %dst_usize = ptrtoint ptr %dst to i64
  %0 = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %size, i64 %count)
  %_13.0 = extractvalue { i64, i1 } %0, 0
  %_13.1 = extractvalue { i64, i1 } %0, 1
  br i1 %_13.1, label %bb1, label %bb3

bb3:                                              ; preds = %start
  %1 = getelementptr inbounds i8, ptr %_9, i64 8
  store i64 %_13.0, ptr %1, align 8
  store i64 1, ptr %_9, align 8
  %2 = getelementptr inbounds i8, ptr %_9, i64 8
  %size1 = load i64, ptr %2, align 8
  %_21 = icmp ult i64 %src_usize, %dst_usize
  br i1 %_21, label %bb4, label %bb5

bb1:                                              ; preds = %start
; call core::panicking::panic_nounwind
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking14panic_nounwind(ptr @alloc_763310d78c99c2c1ad3f8a9821e942f3, i64 61) #17
  unreachable

bb5:                                              ; preds = %bb3
  %3 = sub i64 %src_usize, %dst_usize
  store i64 %3, ptr %diff, align 8
  br label %bb6

bb4:                                              ; preds = %bb3
  %4 = sub i64 %dst_usize, %src_usize
  store i64 %4, ptr %diff, align 8
  br label %bb6

bb6:                                              ; preds = %bb4, %bb5
  %5 = load i64, ptr %diff, align 8
  %_0 = icmp uge i64 %5, %size1
  ret i1 %_0
}

; core::slice::raw::from_raw_parts::precondition_check
; Function Attrs: inlinehint nounwind nonlazybind uwtable
define internal void @_RNvNvNtNtCsevLNFiNqfJP_4core5slice3raw14from_raw_parts18precondition_checkCs7hwRVSyXqTE_6probe1(ptr %data, i64 %size, i64 %align, i64 %len, ptr align 8 %0) unnamed_addr #3 personality ptr @rust_eh_personality !guid !40 {
start:
  %max_len = alloca [8 x i8], align 8
; invoke <*const ()>::is_aligned_to
  %_11 = invoke zeroext i1 @_RNvMNtNtCsevLNFiNqfJP_4core3ptr9const_ptrPu13is_aligned_toCs7hwRVSyXqTE_6probe1(ptr %data, i64 %align)
          to label %bb8 unwind label %terminate

terminate:                                        ; preds = %start
  %1 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_cannot_unwind
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking19panic_cannot_unwind() #13
  unreachable

bb8:                                              ; preds = %start
  br i1 %_11, label %bb6, label %bb7

bb7:                                              ; preds = %bb8
  br label %bb4

bb6:                                              ; preds = %bb8
  %_13 = ptrtoint ptr %data to i64
  %_12 = icmp eq i64 %_13, 0
  %_5 = xor i1 %_12, true
  br i1 %_5, label %bb1, label %bb4

bb4:                                              ; preds = %bb6, %bb7
  br label %bb5

bb1:                                              ; preds = %bb6
  %2 = icmp eq i64 %size, 0
  br i1 %2, label %bb9, label %bb10

bb5:                                              ; preds = %bb3, %bb4
; call core::panicking::panic_nounwind_fmt
  call void @_RNvNtCsevLNFiNqfJP_4core9panicking18panic_nounwind_fmt(ptr @alloc_a28e8c8fd5088943a8b5d44af697ff83, ptr inttoptr (i64 559 to ptr), i1 zeroext false, ptr align 8 %0) #17
  unreachable

bb9:                                              ; preds = %bb1
  store i64 -1, ptr %max_len, align 8
  br label %bb11

bb10:                                             ; preds = %bb1
  %3 = udiv i64 9223372036854775807, %size
  store i64 %3, ptr %max_len, align 8
  br label %bb11

bb11:                                             ; preds = %bb10, %bb9
  %4 = load i64, ptr %max_len, align 8
  %_7 = icmp ule i64 %len, %4
  br i1 %_7, label %bb2, label %bb3

bb3:                                              ; preds = %bb11
  br label %bb5

bb2:                                              ; preds = %bb11
  ret void
}

; <str as alloc::borrow::ToOwned>::to_owned
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_RNvXs2_NtCs1C1lLj4PWSY_5alloc3streNtNtB7_6borrow7ToOwned8to_ownedCs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr %self.0, i64 %self.1) unnamed_addr #0 !guid !41 {
start:
  %bytes = alloca [24 x i8], align 8
; call <u8 as <[_]>::to_vec_in::ConvertVec>::to_vec::<alloc::alloc::Global>
  call void @_RINvXs_NvMNtCs1C1lLj4PWSY_5alloc5sliceSp9to_vec_inhNtB5_10ConvertVec6to_vecNtNtBa_5alloc6GlobalECs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %bytes, ptr %self.0, i64 %self.1) #11
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %_0, ptr align 8 %bytes, i64 24, i1 false)
  ret void
}

; <<str as alloc::borrow::ToOwned>::to_owned as core::ops::function::FnOnce<(&str,)>>::call_once
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_RNvYNvYeNtNtCs1C1lLj4PWSY_5alloc6borrow7ToOwned8to_ownedINtNtNtCsevLNFiNqfJP_4core3ops8function6FnOnceTReEE9call_onceCs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr %0, i64 %1) unnamed_addr #0 !guid !42 {
start:
  %_2 = alloca [16 x i8], align 8
  store ptr %0, ptr %_2, align 8
  %2 = getelementptr inbounds i8, ptr %_2, i64 8
  store i64 %1, ptr %2, align 8
  %3 = load ptr, ptr %_2, align 8
  %4 = getelementptr inbounds i8, ptr %_2, i64 8
  %5 = load i64, ptr %4, align 8
; call <str as alloc::borrow::ToOwned>::to_owned
  call void @_RNvXs2_NtCs1C1lLj4PWSY_5alloc3streNtNtB7_6borrow7ToOwned8to_ownedCs7hwRVSyXqTE_6probe1(ptr sret([24 x i8]) align 8 %_0, ptr %3, i64 %5) #11
  ret void
}

; Function Attrs: nounwind nonlazybind uwtable
declare i32 @rust_eh_personality(i32, i32, i64, ptr, ptr) unnamed_addr #4

; <isize as core::fmt::LowerExp>::fmt
; Function Attrs: nonlazybind uwtable
declare zeroext i1 @_RNvXsD_NtNtNtCsevLNFiNqfJP_4core3fmt3num3impiNtB9_8LowerExp3fmt(ptr align 8, ptr align 8) unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #5

; <alloc::vec::Vec<u8> as core::ops::drop::Drop>::drop
; Function Attrs: nonlazybind uwtable
declare void @_RNvXsp_NtCs1C1lLj4PWSY_5alloc3vecINtB5_3VechENtNtNtCsevLNFiNqfJP_4core3ops4drop4Drop4dropCsiK12aF3ve0B_5gimli(ptr align 8) unnamed_addr #1

; core::panicking::panic_in_cleanup
; Function Attrs: cold minsize noinline noreturn nounwind nonlazybind optsize uwtable
declare void @_RNvNtCsevLNFiNqfJP_4core9panicking16panic_in_cleanup() unnamed_addr #6

; <alloc::raw_vec::RawVec<u8> as core::ops::drop::Drop>::drop
; Function Attrs: nonlazybind uwtable
declare void @_RNvXs1_NtCs1C1lLj4PWSY_5alloc7raw_vecINtB5_6RawVechENtNtNtCsevLNFiNqfJP_4core3ops4drop4Drop4dropCsiK12aF3ve0B_5gimli(ptr align 8) unnamed_addr #1

; alloc::fmt::format::format_inner
; Function Attrs: nonlazybind uwtable
declare void @_RNvNvNtCs1C1lLj4PWSY_5alloc3fmt6format12format_inner(ptr sret([24 x i8]) align 8, ptr, ptr) unnamed_addr #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.ctpop.i64(i64) #7

; core::panicking::panic_fmt
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_RNvNtCsevLNFiNqfJP_4core9panicking9panic_fmt(ptr, ptr, ptr align 8) unnamed_addr #8

; <alloc::raw_vec::RawVecInner>::try_allocate_in
; Function Attrs: nonlazybind uwtable
declare void @_RNvMs5_NtCs1C1lLj4PWSY_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsiK12aF3ve0B_5gimli(ptr sret([24 x i8]) align 8, i64, i1 zeroext, i64, i64) unnamed_addr #1

; alloc::raw_vec::handle_error
; Function Attrs: cold minsize noreturn nonlazybind optsize uwtable
declare void @_RNvNtCs1C1lLj4PWSY_5alloc7raw_vec12handle_error(i64, i64) unnamed_addr #9

; core::panicking::panic_nounwind_fmt
; Function Attrs: cold noinline noreturn nounwind nonlazybind uwtable
declare void @_RNvNtCsevLNFiNqfJP_4core9panicking18panic_nounwind_fmt(ptr, ptr, i1 zeroext, ptr align 8) unnamed_addr #10

; core::panicking::panic_cannot_unwind
; Function Attrs: cold minsize noinline noreturn nounwind nonlazybind optsize uwtable
declare void @_RNvNtCsevLNFiNqfJP_4core9panicking19panic_cannot_unwind() unnamed_addr #6

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #7

; core::panicking::panic_nounwind
; Function Attrs: cold noinline noreturn nounwind nonlazybind uwtable
declare void @_RNvNtCsevLNFiNqfJP_4core9panicking14panic_nounwind(ptr, i64) unnamed_addr #10

attributes #0 = { inlinehint nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { cold nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #3 = { inlinehint nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #4 = { nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { cold minsize noinline noreturn nounwind nonlazybind optsize uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #7 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #8 = { cold noinline noreturn nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #9 = { cold minsize noreturn nonlazybind optsize uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #10 = { cold noinline noreturn nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #11 = { inlinehint }
attributes #12 = { cold }
attributes #13 = { cold noreturn nounwind }
attributes #14 = { inlinehint nounwind }
attributes #15 = { noinline noreturn }
attributes #16 = { noreturn }
attributes #17 = { noinline noreturn nounwind }

!llvm.module.flags = !{!19, !20, !21}
!llvm.ident = !{!22}

!0 = !{i64 -8848330688815136960}
!1 = !{i64 -2150067749961093144}
!2 = !{i64 -1944125407393055913}
!3 = !{i64 -8526095899147546683}
!4 = !{i64 -7311926523649713913}
!5 = !{i64 6286147841290683863}
!6 = !{i64 1478585462064181124}
!7 = !{i64 7038939326488660025}
!8 = !{i64 -1311767460802893294}
!9 = !{i64 -5824203970345264790}
!10 = !{i64 -1487937157881593545}
!11 = !{i64 687099953572287360}
!12 = !{i64 -8628928262116498723}
!13 = !{i64 -2973492827688383722}
!14 = !{i64 -4065885003214322502}
!15 = !{i64 -1404982620257495987}
!16 = !{i64 2139769213790459630}
!17 = !{i64 4416355489191137039}
!18 = !{i64 -1407848767157664960}
!19 = !{i32 8, !"PIC Level", i32 2}
!20 = !{i32 2, !"RtLibUseGOT", i32 1}
!21 = !{i32 7, !"uwtable", i32 2}
!22 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!23 = !{i64 3140067896943756889}
!24 = !{i64 -5583624615934570951}
!25 = !{i64 -6812654044098342542}
!26 = !{i64 -3377145353741069571}
!27 = !{i64 -112503612220189455}
!28 = !{i64 -2281758068177418878}
!29 = !{i64 4464634875355331775}
!30 = !{i64 -287998290203675375}
!31 = !{i64 8101334900759031397}
!32 = !{i64 6709282218721544731}
!33 = !{i64 -8708077551843013964}
!34 = !{i64 3139935260324179688}
!35 = !{i64 2823088339217241135}
!36 = !{i64 1039817912908339086}
!37 = !{i64 -3861329220316959023}
!38 = !{i64 8275768667875331358}
!39 = !{i64 3808842973938038684}
!40 = !{i64 1793043243884732}
!41 = !{i64 2599380788734992961}
!42 = !{i64 -2433918146926661254}
