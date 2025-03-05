create_library_set -name libset_fast\
   -timing\
    [list ../../libs/liberty/FreePDK45_lib_v1.0_typical.lib\
    ../../libs/liberty/FreePDK45_lib_v1.0_typical_LVT.lib\
    ../../libs/MACRO/LIBERTY/pllclk.lib\
    ../../libs/MACRO/LIBERTY/ram_256x16A.lib\
    ../../libs/MACRO/LIBERTY/rom_512x16A.lib]\
   -aocv\
    [list ../../aocv/aocvCorrected_fast.aocv]
create_library_set -name libset_slow\
   -timing\
    [list ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib\
    ../../libs/liberty/FreePDK45_lib_v1.0_worst_LVT.lib\
    ../../libs/MACRO/LIBERTY/pllclk.lib\
    ../../libs/MACRO/LIBERTY/ram_256x16A.lib\
    ../../libs/MACRO/LIBERTY/rom_512x16A.lib]\
   -aocv\
    [list ../../aocv/aocvCorrected_slow.aocv]

create_timing_condition -name slow_tc -library_sets [list libset_slow]
create_timing_condition -name fast_tc -library_sets [list libset_fast]

create_rc_corner -name RCMAX\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0

create_rc_corner -name RCMIN\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0

create_delay_corner -name fast_min -timing_condition {fast_tc} -rc_corner RCMIN 
create_delay_corner -name slow_max -timing_condition {slow_tc} -rc_corner RCMAX

create_constraint_mode -name functional_mode -sdc_files [list ../../design/dtmf_recvr_core/SDC/dtmf_recvr_core.pr.sdc]
create_constraint_mode -name scan_mode -sdc_files [list ../../design/dtmf_recvr_core/SDC/dtmf_recvr_core.scan.sdc]
create_constraint_mode -name test_mode -sdc_files [list ../../design/dtmf_recvr_core/SDC/dtmf_recvr_core.test.sdc]

create_analysis_view -name func_slow_max -constraint_mode functional_mode -delay_corner slow_max
create_analysis_view -name func_fast_min -constraint_mode functional_mode -delay_corner fast_min

create_analysis_view -name scan_fast_min -constraint_mode scan_mode -delay_corner fast_min

create_analysis_view -name test_fast_min -constraint_mode test_mode -delay_corner fast_min

set_analysis_view -setup [list func_slow_max] -hold [list func_fast_min scan_fast_min test_fast_min]

