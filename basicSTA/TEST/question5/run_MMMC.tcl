set_distribute_host -local
set_multi_cpu_usage -local_cpu 2


#read_mmmc ../scripts/MCMM_setup.tcl
read_mmmc ./MCMM_setup_correctAocv.tcl

read_netlist "./design/dtmf_recvr_core.v.gz" ; # 8269 instances
init_design

read_spef -rc_corner RCMAX "./design/corner_worst_RCMAX.spef.gz"

update_timing

report_timing -split_delay -fields {instance cell annotation aocv_derate delay incr_delay total_derate}
set_db timing_analysis_aocv true
report_timing -split_delay -fields {instance cell annotation aocv_derate delay incr_delay total_derate}
report_timing  -retime path_slew_propagation

