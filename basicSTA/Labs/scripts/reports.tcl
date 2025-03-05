
#####################
# Reports that check design health
#####################
#check_design -type all                        > ${reportDir}/check_design.rpt
check_design -type timing -out_file    ${reportDir}/check_design.rpt
check_timing -verbose > ${reportDir}/check_timing.rpt
report_annotated_parasitics         > ${reportDir}/annotated.rpt
report_analysis_coverage            > ${reportDir}/coverage.rpt

#####################
# Reports that describe constraints
#####################
report_clocks                       > ${reportDir}/clocks.rpt
report_case_analysis                > ${reportDir}/case_analysis.rpt
report_inactive_arcs                > ${reportDir}/inactive_arcs.rpt
 
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


