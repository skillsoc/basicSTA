if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name default_emulate_libset_max\
   -timing\
    [list ${::IMEX::libVar}/mmmc/FreePDK45_lib_v1.0_worst.lib\
    ${::IMEX::libVar}/mmmc/pllclk.lib\
    ${::IMEX::libVar}/mmmc/ram_256x16A.lib\
    ${::IMEX::libVar}/mmmc/rom_512x16A.lib]
create_library_set -name default_emulate_libset_min\
   -timing\
    [list ${::IMEX::libVar}/mmmc/FreePDK45_lib_v1.0_typical.lib\
    ${::IMEX::libVar}/mmmc/pllclk.lib\
    ${::IMEX::libVar}/mmmc/ram_256x16A.lib\
    ${::IMEX::libVar}/mmmc/rom_512x16A.lib]
create_timing_condition -name default_mapping_tc_2\
   -library_sets [list default_emulate_libset_min]
create_timing_condition -name default_mapping_tc_1\
   -library_sets [list default_emulate_libset_max]
create_rc_corner -name default_emulate_early_rc_corner\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 25
create_rc_corner -name default_emulate_late_rc_corner\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 25
create_rc_corner -name default_emulate_rc_corner\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 25
create_delay_corner -name default_emulate_delay_corner\
   -early_timing_condition {default_mapping_tc_2}\
   -late_timing_condition {default_mapping_tc_1}\
   -rc_corner default_emulate_rc_corner
create_delay_corner -name default_emulate_delay_corner_max\
   -timing_condition {default_mapping_tc_1}\
   -rc_corner default_emulate_rc_corner
create_delay_corner -name default_emulate_delay_corner_min\
   -timing_condition {default_mapping_tc_2}\
   -rc_corner default_emulate_rc_corner
create_constraint_mode -name default_emulate_constraint_mode\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name default_emulate_view -constraint_mode default_emulate_constraint_mode -delay_corner default_emulate_delay_corner
set_analysis_view -setup [list default_emulate_view] -hold [list default_emulate_view]
catch {set_interactive_constraint_mode [list default_emulate_constraint_mode] } 
