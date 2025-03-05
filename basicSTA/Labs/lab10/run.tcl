set_multi_cpu_usage -local_cpu 2
set_table_style -no_frame_fix_width -nosplit

read_lib   -max_libs  ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib
#read_lib   ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib
read_lib   -min_libs  ../../libs/liberty/FreePDK45_lib_v1.0_typical.lib
read_lib     ../../libs/MACRO/LIBERTY/pllclk.lib
read_lib     ../../libs/MACRO/LIBERTY/ram_256x16A.lib   ../../libs/MACRO/LIBERTY/rom_512x16A.lib

read_netlist "../../design/dtmf_recvr_core/dtmf_recvr_core.v"
init_design

read_sdc ../../design/dtmf_recvr_core/dtmf_recvr_core.sdc
read_spef  ../../design/dtmf_recvr_core/SPEF/corner_worst_CMAX.spef.gz

update_timing -full
report_timing -split_delay -fields {instance cell arc transition load delay incr_delay arrival}

set_db delaycal_enable_si true
set_db si_glitch_enable_report true 
set_db si_delay_separate_on_data true
set_db si_delay_enable_report true
report_timing -split_delay -fields {instance cell arc transition load delay incr_delay arrival}
report_noise -out_file noise.rpt

update_timing -full

