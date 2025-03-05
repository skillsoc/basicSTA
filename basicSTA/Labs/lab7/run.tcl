set_multi_cpu_usage -local_cpu 2
set_table_style -no_frame_fix_width -nosplit

read_lib   -max_libs  ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib
#read_lib   ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib
read_lib   -min_libs  ../../libs/liberty/FreePDK45_lib_v1.0_typical.lib
read_lib     ../../libs/MACRO/LIBERTY/pllclk.lib
read_lib     ../../libs/MACRO/LIBERTY/ram_256x16A.lib   ../../libs/MACRO/LIBERTY/rom_512x16A.lib

read_netlist "../../design/aes/aes.v"
init_design

read_sdc ../../design/aes/aes.sdc

update_timing -full

