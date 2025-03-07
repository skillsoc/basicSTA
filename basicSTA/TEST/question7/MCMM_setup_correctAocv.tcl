create_library_set -name libset_slow\
   -timing\
    [list ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib\
    ../../libs/MACRO/LIBERTY/pllclk.lib\
    ../../libs/MACRO/LIBERTY/ram_256x16A.lib\
    ../../libs/MACRO/LIBERTY/rom_512x16A.lib]\
   -aocv\
    [list ../../aocv/aocvCorrected_slow.aocv]

create_timing_condition -name slow_tc -library_sets [list libset_slow]

create_rc_corner -name RCMAX\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0

create_delay_corner -name slow_max -timing_condition {slow_tc} -rc_corner RCMAX

create_constraint_mode -name functional_mode -sdc_files [list ../../design/dtmf_recvr_core/SDC/dtmf_recvr_core.pr.sdc]

create_analysis_view -name func_slow_max -constraint_mode functional_mode -delay_corner slow_max

set_analysis_view -setup [list func_slow_max] -hold [list func_slow_max]

