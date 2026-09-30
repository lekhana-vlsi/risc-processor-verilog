# ============================================================
# File:    processor_constraints.xdc
# Project: 4-bit 2-Stage Pipelined RISC Processor
# Device:  xc7k70tfdv676-1 (Kintex-7)
# Target:  50MHz clock (20ns period)
# Author:  lekhana
# Date:    07-09-2026
# ============================================================

# ============================================================
# PRIMARY CLOCK CONSTRAINT
# Defines the system clock on port 'clk'
# Period: 20.000 ns = 50 MHz
# All timing paths analyzed relative to this clock
# ============================================================
create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports clk]

# ============================================================
# INPUT DELAY CONSTRAINTS
# How long inputs take to arrive after the clock edge
# reset: simple synchronous input, assumed 4ns delay
# ============================================================
set_input_delay -clock [get_clocks sys_clk] -max 4.000 [get_ports reset]

set_input_delay -clock [get_clocks sys_clk] -min 0.500 [get_ports reset]

# ============================================================
# OUTPUT DELAY CONSTRAINTS
# How long outputs must be valid before next clock edge
# debug_pc[3:0]: 4-bit PC debug output
# debug_result[3:0]: 4-bit ALU result debug output
# ============================================================
set_output_delay -clock [get_clocks sys_clk] -max 4.000 [get_ports {debug_pc[*]}]

set_output_delay -clock [get_clocks sys_clk] -min 0.500 [get_ports {debug_pc[*]}]

set_output_delay -clock [get_clocks sys_clk] -max 4.000 [get_ports {debug_result[*]}]

set_output_delay -clock [get_clocks sys_clk] -min 0.500 [get_ports {debug_result[*]}]

# ============================================================
# TIMING EXCEPTIONS (none for this design)
# False paths would go here if needed
# Multicycle paths would go here if needed
# ============================================================
# (none required for single-clock synchronous design)

# ============================================================
# Software-only project: no physical FPGA board
# Allow unspecified I/O pins and I/O standards
# ============================================================


# ============================================================
# Downgrade I/O-related critical warnings to allow bitstream
# generation without physical pin/voltage assignments
# (justified: software-only project, no physical board)
# ============================================================
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]