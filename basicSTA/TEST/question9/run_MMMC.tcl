set_distribute_host -local
set_multi_cpu_usage -local_cpu 2



#read_mmmc ../scripts/MCMM_setup.tcl
read_mmmc ./MCMM_setup_correctAocv.tcl

read_netlist "../../design/dtmf_recvr_core/dtmf_recvr_core.v.gz" ; # 8269 instances
init_design

read_spef -rc_corner RCMAX "../../design/dtmf_recvr_core/SPEF/corner_worst_RCMAX.spef.gz"
read_spef -rc_corner RCMIN "../../design/dtmf_recvr_core/SPEF/corner_worst_RCMIN.spef.gz"

update_timing

report_timing -split_delay -fields {instance cell annotation aocv_derate delay incr_delay total_derate}
set_db timing_analysis_aocv true

set_db timing_analysis_type ocv
set_db timing_analysis_cppr both

set_db delaycal_enable_si true
set_db si_glitch_enable_report true 
set_db si_delay_separate_on_data true
set_db si_delay_enable_double_clocking_check true
set_db si_delay_enable_report true


report_timing -split_delay -fields {instance cell annotation aocv_derate delay incr_delay total_derate}
report_timing  -retime path_slew_propagation

check_design -type timing -out_file    check_design.rpt
check_timing -verbose > check_timing.rpt
report_annotated_parasitics         > annotated.rpt
report_analysis_coverage            > coverage.rpt

#####################
# Reports that describe constraints
#####################
report_clocks                       > clocks.rpt
report_case_analysis                > case_analysis.rpt
report_inactive_arcs                > inactive_arcs.rpt
 
#####################
# Reports that describe timing health
#####################
report_constraint -all_violators                                > allviol.rpt
report_analysis_summary                                         > analysis_summary.rpt

#####################
# GBA Reports that show detailed timing
#####################
report_timing -late   -max_paths 50 -nworst 1 -path_type full_clock -net  > worst_max_path.rpt
report_timing -early  -max_paths 50 -nworst 1 -path_type full_clock -net  > worst_min_path.rpt
report_timing -late   -max_slack 0 -max_paths 100                         > setup_100.rpt.gz
report_timing -early  -max_slack 0 -max_paths 100                         > hold_100.rpt.gz

#####################
# PBA Reports that show detailed timing
#####################
report_timing -retime path_slew_propagation -max_paths 50 -nworst 1 -path_type full_clock    > pba_50_paths.rpt


#for {set i 0} {$i < 7} {incr i} {
#eco_add_repeater -pins TDSP_CORE_INST/PROG_BUS_MACH_INST/data_out_reg[1]/D -cells BUF_X1
#}

