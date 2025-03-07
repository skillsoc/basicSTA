#######################################################
#                                                     
#  Tempus Timing Solution Command Logging File                     
#  Created on Fri Mar  7 08:52:04 2025                
#                                                     
#######################################################

#@(#)CDS: Tempus Timing Solution v23.14-e038_1 (64bit) 12/19/2024 15:29 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 23.14-e038_1 NR241213-1435/23_14-UB (database version 18.20.656) {superthreading v2.20}
#@(#)CDS: AAE 23.14-e008 (64bit) 12/19/2024 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 23.14-s015_1 () Dec 18 2024 01:07:05 ( )
#@(#)CDS: SYNTECH 23.14-s004_1 () Dec 13 2024 08:04:15 ( )
#@(#)CDS: CPE v23.14-s032

gvim run_MMMC.tcl 
set_distribute_host -local
set_multi_cpu_usage -local_cpu 2
read_mmmc ./MCMM_setup_correctAocv.tcl
#@ Begin verbose source (pre): 
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
create_rc_corner -name RCMAXDRV\
   -pre_route_res 1.5\
   -post_route_res 1.5\
   -pre_route_cap 1.5\
   -post_route_cap 1.5\
   -post_route_cross_cap 1.5\
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
create_delay_corner -name DRV_max -timing_condition {slow_tc} -rc_corner RCMAXDRV
create_constraint_mode -name functional_mode -sdc_files [list ../../design/dtmf_recvr_core/SDC/dtmf_recvr_core.pr.sdc]
create_constraint_mode -name scan_mode -sdc_files [list ../../design/dtmf_recvr_core/SDC/dtmf_recvr_core.scan.sdc]
create_constraint_mode -name test_mode -sdc_files [list ../../design/dtmf_recvr_core/SDC/dtmf_recvr_core.test.sdc]
create_analysis_view -name func_slow_max -constraint_mode functional_mode -delay_corner slow_max
create_analysis_view -name func_slow_max_DRV -constraint_mode functional_mode -delay_corner DRV_max
create_analysis_view -name func_fast_min -constraint_mode functional_mode -delay_corner fast_min
create_analysis_view -name scan_fast_min -constraint_mode scan_mode -delay_corner fast_min
create_analysis_view -name test_fast_min -constraint_mode test_mode -delay_corner fast_min
set_analysis_view -setup [list func_slow_max] -hold [list func_fast_min scan_fast_min test_fast_min] -drv [list func_slow_max_DRV]
#@ End verbose source: ./MCMM_setup_correctAocv.tcl
read_netlist "../../design/dtmf_recvr_core/dtmf_recvr_core.v.gz" ;
init_design
read_spef -rc_corner RCMAX "../../design/dtmf_recvr_core/SPEF/corner_worst_RCMAX.spef.gz"
read_spef -rc_corner RCMIN "../../design/dtmf_recvr_core/SPEF/corner_worst_RCMIN.spef.gz"
update_timing
report_annotated_parasitics
exit
