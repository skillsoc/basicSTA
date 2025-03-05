

################################
# Setup threading and client counts
################################
set_multi_cpu_usage -local_cpu 2

################################
# Setup some global variables or report settings
################################
set_table_style -no_frame_fix_width -nosplit

################################
# Read the libraries
################################
read_lib   -max_libs  ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib
#read_lib   ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib
read_lib   -min_libs  ../../libs/liberty/FreePDK45_lib_v1.0_typical.lib
read_lib     ../../libs/MACRO/LIBERTY/pllclk.lib
read_lib     ../../libs/MACRO/LIBERTY/ram_256x16A.lib   ../../libs/MACRO/LIBERTY/rom_512x16A.lib

################################
# Read the netlist in a gzipped format
################################
read_netlist "../../design/ECO_INIT_11_optSetup.enc.dat/dtmf_recvr_core.v.gz" ; # 8269 instances
init_design

################################
# Link the design
################################
#set_top_module dtmf_recvr_core -ignore_undefined_cell

################################
# Check the size of the testcase
################################
#set cellCnt [sizeof_collection [get_cells -hier *]]
#puts "Your design has: $cellCnt instances"

################################
# Load netlist parasitics
################################
read_spef  ../../design/SPEF/corner_worst_CMAX.spef.gz

################################
# Add constraints
################################
read_sdc ../../design/dtmf_recvr_core.pr.sdc

set_db timing_analysis_type ocv
set_db timing_analysis_cppr both

################################
# Turn on SI
################################
set_db delaycal_enable_si true
set_db si_glitch_enable_report true 
set_db si_delay_separate_on_data true
set_db si_delay_enable_double_clocking_check true
set_db si_delay_enable_report true

###################################
# Run timing
###################################
update_timing -full

###################################
# Run reports
###################################
report_timing -split_delay -fields {instance cell arc transition load delay incr_delay }
report_timing -split_delay -fields {instance cell arc transition load delay incr_delay arrival}
###################################
# Run a whole list of common reports
###################################
set reportDir reports4
file mkdir $reportDir
source ../scripts/reports.tcl



puts "All done"
