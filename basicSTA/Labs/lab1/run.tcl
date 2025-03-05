

set_multi_cpu_usage -local_cpu 2
set_table_style -no_frame_fix_width -nosplit
read_lib   ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib
read_lib     ../../libs/MACRO/LIBERTY/pllclk.lib
read_lib     ../../libs/MACRO/LIBERTY/ram_256x16A.lib   ../../libs/MACRO/LIBERTY/rom_512x16A.lib

read_netlist "../../design/dtmf_recvr_core/dtmf_recvr_core.v.gz" 
init_design

read_sdc ../../design/dtmf_recvr_core/dtmf_recvr_core.sdc

update_timing -full

###################################
# Run reports
###################################
report_timing -split_delay -fields {instance cell arc transition load delay incr_delay }
report_timing -split_delay -fields {instance cell arc transition load delay incr_delay arrival}


set reportDir reports
file mkdir $reportDir


check_design -type all                        > ${reportDir}/check_design.rpt
check_timing -verbose > ${reportDir}/check_timing.rpt
report_annotated_parasitics         > ${reportDir}/annotated.rpt
report_analysis_coverage            > ${reportDir}/coverage.rpt

#####################
# Reports that describe constraints
#####################
report_clocks                       > ${reportDir}/clocks.rpt
report_case_analysis                > ${reportDir}/case_analysis.rpt
 
#####################
# Reports that describe timing health
#####################
report_constraint -all_violators                                > ${reportDir}/allviol.rpt
report_analysis_summary                                         > ${reportDir}/analysis_summary.rpt

#####################
# GBA Reports that show detailed timing
#####################
report_timing -late   -max_paths 50 -nworst 1 -path_type full_clock -net  > ${reportDir}/worst_max_path.rpt
report_timing -early  -max_paths 50 -nworst 1 -path_type full_clock -net  > ${reportDir}/worst_min_path.rpt
report_timing -late   -max_slack 0 -max_paths 100                         > ${reportDir}/setup_100.rpt.gz
report_timing -early  -max_slack 0 -max_paths 100                         > ${reportDir}/hold_100.rpt.gz

#####################
# PBA Reports that show detailed timing
#####################
report_timing -retime path_slew_propagation -max_paths 50 -nworst 1 -path_type full_clock    > ${reportDir}/pba_50_paths.rpt


