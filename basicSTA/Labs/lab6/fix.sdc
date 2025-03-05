create_clock [get_ports {refclk}]  -add  -name refclk -period 40
create_clock [get_pins {TEST_CONTROL_INST/m_rcc_clk}] -name m_rcc_clk -period 85
create_clock [get_pins {TEST_CONTROL_INST/m_ram_clk}] -name m_ram_clk -period 85
create_clock [get_pins {TEST_CONTROL_INST/m_clk}]  -name m_clk -period 85 
create_clock [get_pins {TEST_CONTROL_INST/m_dsram_clk}] -name m_dsram_clk -period 85
create_clock [get_pins {TEST_CONTROL_INST/m_digit_clk}]  -name m_digit_clk -period 85
create_clock [get_pins {TEST_CONTROL_INST/m_spi_clk}]  -name m_spi_clk -period 85
set_false_path -from [get_clocks refclk] -to [remove_from_collection [get_clocks ] [get_clocks refclk]]
set_case_analysis 1 [get_ports test_mode]

