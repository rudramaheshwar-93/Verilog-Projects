# 16-Tap FIR Low-Pass Filter (FPGA)

## Overview
Pipelined FIR low-pass filter implemented in Verilog HDL on Xilinx Vivado.

## Specs
- Taps: 16 | Window: Hamming | Cutoff: 0.2 × Fs
- Clock: 100 MHz | Pipeline latency: 3 cycles
- LUT savings: 25% via symmetric coefficient optimization
- Coefficient accuracy: 98.5% (Q1.15 fixed-point)

## Files
| File | Description |
|------|-------------|
| `fir_filter.v` | RTL Design (Verilog 2001) |
| `fir_filter_tb.v` | Simulation Testbench |
| `fir_filter.xdc` | Timing & Pin Constraints (Basys3) |
| `fir_filter_matlab_testbench.m` | MATLAB coefficient validation |

## Tools
- Xilinx Vivado 2025.2
- MATLAB (coefficient generation)
- Target Board: Digilent Basys3 (XC7A35T)
