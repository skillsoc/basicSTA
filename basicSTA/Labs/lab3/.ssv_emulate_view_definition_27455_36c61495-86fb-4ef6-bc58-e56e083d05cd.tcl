create_library_set -name default_emulate_libset_max -timing [list ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib ../../libs/MACRO/LIBERTY/pllclk.lib ../../libs/MACRO/LIBERTY/ram_256x16A.lib ../../libs/MACRO/LIBERTY/rom_512x16A.lib]
create_library_set -name default_emulate_libset_min -timing [list ../../libs/liberty/FreePDK45_lib_v1.0_worst.lib ../../libs/MACRO/LIBERTY/pllclk.lib ../../libs/MACRO/LIBERTY/ram_256x16A.lib ../../libs/MACRO/LIBERTY/rom_512x16A.lib]
create_constraint_mode -name default_emulate_constraint_mode -sdc_files [list /dev/null]
create_timing_condition -name default_mapping_tc_2 -library_sets [list default_emulate_libset_min]
create_timing_condition -name default_mapping_tc_1 -library_sets [list default_emulate_libset_max]
create_rc_corner -name default_emulate_early_rc_corner 
create_rc_corner -name default_emulate_late_rc_corner 
create_rc_corner -name default_emulate_rc_corner 
create_delay_corner -name default_emulate_delay_corner -early_timing_condition {default_mapping_tc_2} -late_timing_condition {default_mapping_tc_1} -rc_corner default_emulate_rc_corner
create_delay_corner -name default_emulate_delay_corner_max -timing_condition {default_mapping_tc_1} -rc_corner default_emulate_rc_corner
create_delay_corner -name default_emulate_delay_corner_min -timing_condition {default_mapping_tc_2} -rc_corner default_emulate_rc_corner
create_analysis_view -name default_emulate_view -constraint_mode default_emulate_constraint_mode -delay_corner default_emulate_delay_corner
set_analysis_view -setup [list default_emulate_view] -hold [list default_emulate_view]
