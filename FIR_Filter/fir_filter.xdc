# ============================================================
# Xilinx Vivado Constraints File (.xdc)
# Project: 16-Tap FIR Low-Pass Filter
# Target Board: Digilent Basys3 (XC7A35T-1CPG236C)
# Clock: 100 MHz onboard oscillator
# ============================================================

# -------------------------------------------------------
# PRIMARY CLOCK CONSTRAINT
# 100 MHz → Period = 10.000 ns
# -------------------------------------------------------
create_clock -period 10.000 -name sys_clk_pin \
    -waveform {0.000 5.000} \
    [get_ports clk]

# -------------------------------------------------------
# Clock Source Pin (Basys3 onboard 100 MHz oscillator)
# -------------------------------------------------------
set_property -dict { PACKAGE_PIN W5    IOSTANDARD LVCMOS33 } [get_ports clk]

# -------------------------------------------------------
# Reset Button (Center button on Basys3)
# -------------------------------------------------------
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports rst_n]

# -------------------------------------------------------
# Input: valid_in → SW0
# -------------------------------------------------------
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports valid_in]

# -------------------------------------------------------
# Input Data [15:0] → Switches SW15..SW0
# -------------------------------------------------------
set_property -dict { PACKAGE_PIN V2    IOSTANDARD LVCMOS33 } [get_ports {data_in[0]}]
set_property -dict { PACKAGE_PIN U2    IOSTANDARD LVCMOS33 } [get_ports {data_in[1]}]
set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports {data_in[2]}]
set_property -dict { PACKAGE_PIN T2    IOSTANDARD LVCMOS33 } [get_ports {data_in[3]}]
set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports {data_in[4]}]
set_property -dict { PACKAGE_PIN W2    IOSTANDARD LVCMOS33 } [get_ports {data_in[5]}]
set_property -dict { PACKAGE_PIN U1    IOSTANDARD LVCMOS33 } [get_ports {data_in[6]}]
set_property -dict { PACKAGE_PIN T1    IOSTANDARD LVCMOS33 } [get_ports {data_in[7]}]
set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports {data_in[8]}]
set_property -dict { PACKAGE_PIN R1    IOSTANDARD LVCMOS33 } [get_ports {data_in[9]}]
set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports {data_in[10]}]
set_property -dict { PACKAGE_PIN P4    IOSTANDARD LVCMOS33 } [get_ports {data_in[11]}]
set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports {data_in[12]}]
set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports {data_in[13]}]
set_property -dict { PACKAGE_PIN N1    IOSTANDARD LVCMOS33 } [get_ports {data_in[14]}]
set_property -dict { PACKAGE_PIN M1    IOSTANDARD LVCMOS33 } [get_ports {data_in[15]}]

# -------------------------------------------------------
# Output: valid_out → LED
# -------------------------------------------------------
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports valid_out]

# -------------------------------------------------------
# Output Data [7:0] → LEDs
# -------------------------------------------------------
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {data_out[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {data_out[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {data_out[3]}]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {data_out[4]}]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {data_out[5]}]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {data_out[6]}]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {data_out[7]}]

# -------------------------------------------------------
# Input/Output Timing Constraints
# -------------------------------------------------------
set_input_delay  -clock sys_clk_pin -max 2.0 [get_ports data_in]
set_input_delay  -clock sys_clk_pin -min 0.5 [get_ports data_in]
set_input_delay  -clock sys_clk_pin -max 2.0 [get_ports valid_in]
set_input_delay  -clock sys_clk_pin -min 0.5 [get_ports valid_in]

set_output_delay -clock sys_clk_pin -max 2.0 [get_ports data_out]
set_output_delay -clock sys_clk_pin -min 0.5 [get_ports data_out]
set_output_delay -clock sys_clk_pin -max 2.0 [get_ports valid_out]
set_output_delay -clock sys_clk_pin -min 0.5 [get_ports valid_out]

# -------------------------------------------------------
# False Paths
# -------------------------------------------------------
set_false_path -from [get_ports rst_n]

# -------------------------------------------------------
# Bitstream Settings
# -------------------------------------------------------
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]