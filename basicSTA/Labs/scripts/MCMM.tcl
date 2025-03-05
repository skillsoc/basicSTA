
set_distribute_host -local
set_multi_cpu_usage -local_cpu 2
set timing_disable_invalid_clock_check true


create_library_set -name libset_slow\
   -timing\
    [list ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib\
          ../../libs/MACRO/LIBERTY/pllclk.lib\
          ../../libs/MACRO/LIBERTY/ram_256x16A.lib\
          ../../libs/MACRO/LIBERTY/rom_512x16A.lib] \
   -aocv \
   [list ../../aocv/aocv_setup_slow_pd0.aocv \
         ../../aocv/aocv_hold_slow.aocv \
         ] 


create_library_set -name libset_fast\
   -timing\
    [list ../../libs/liberty/FreePDK45_lib_v1.0_typical.lib\
          ../../libs/MACRO/LIBERTY/pllclk.lib\
          ../../libs/MACRO/LIBERTY/ram_256x16A.lib\
          ../../libs/MACRO/LIBERTY/rom_512x16A.lib] \
   -aocv \
   [list ../../aocv/aocv_setup_fast2.aocv \
         ../../aocv/aocv_hold_fast2.aocv \
         ]

create_rc_corner -name corner_worst_RCMAX\

create_rc_corner -name corner_worst_RCMIN\

create_delay_corner -name delay_corner_slow_RCMAX\
   -rc_corner corner_worst_RCMAX\
   -early_library_set libset_fast\
   -late_library_set libset_slow

create_delay_corner -name delay_corner_fast_RCMIN\
   -rc_corner corner_worst_RCMIN\
   -early_library_set libset_fast\
   -late_library_set libset_slow

create_constraint_mode -name functional_mode \
  -sdc_files [list ../../design/SDC/dtmf_recvr_core.pr.sdc]
create_constraint_mode -name scan_mode \
  -sdc_files [list ../../design/SDC/dtmf_recvr_core.scan.sdc]
create_constraint_mode -name test_mode \
  -sdc_files [list ../../design/SDC/dtmf_recvr_core.test.sdc]

create_analysis_view -name func_slow_RCMAX -constraint_mode functional_mode -delay_corner delay_corner_slow_RCMAX
create_analysis_view -name func_fast_RCMIN -constraint_mode functional_mode -delay_corner delay_corner_fast_RCMIN

create_analysis_view -name scan_slow_RCMAX -constraint_mode scan_mode -delay_corner delay_corner_slow_RCMAX
create_analysis_view -name scan_fast_RCMIN -constraint_mode scan_mode -delay_corner delay_corner_fast_RCMIN

create_analysis_view -name test_slow_RCMAX -constraint_mode test_mode -delay_corner delay_corner_slow_RCMAX
create_analysis_view -name test_fast_RCMIN -constraint_mode test_mode -delay_corner delay_corner_fast_RCMIN

set_analysis_view \
  -setup \
  [list  func_slow_RCMAX \
         scan_slow_RCMAX \
         test_slow_RCMAX \
         ] \
  -hold \
   [list \
         func_fast_RCMIN \
         scan_fast_RCMIN \
         test_fast_RCMIN]




################################
# Read the netlist in a gzipped format
################################
read_netlist "../../design/ECO_INIT_11_optSetup.enc.dat/dtmf_recvr_core.v.gz" 
init_design

################################
# Link the design
################################
set_top_module dtmf_recvr_core -ignore_undefined_cell

################################
# Load netlist parasitics
################################
read_spef -rc_corner corner_worst_RCMAX "../../design/SPEF/corner_worst_RCMAX.spef.gz"
read_spef -rc_corner corner_worst_RCMIN "../../design/SPEF/corner_worst_RCMIN.spef.gz"

############################################
# load STA settings and update timing
############################################
update_timing -full


