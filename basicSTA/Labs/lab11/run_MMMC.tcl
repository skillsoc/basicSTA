set_multi_cpu_usage -local_cpu 2


#read_mmmc ../scripts/MCMM_setup.tcl
read_mmmc ./single_setup_correctAocv.tcl

read_netlist "../../design/dtmf_recvr_core/dtmf_recvr_core.v.gz" ; # 8269 instances
init_design

read_spef -rc_corner RCMAX "../../design/dtmf_recvr_core/SPEF/corner_worst_RCMAX.spef.gz"

update_timing

report_timing -split_delay -fields {instance cell annotation aocv_derate delay incr_delay total_derate}
set_db timing_analysis_aocv true
report_timing -split_delay -fields {instance cell annotation aocv_derate delay incr_delay total_derate}


#read_def aa.dreport_timing -split_delay -fields {ef
#read_power_intent
