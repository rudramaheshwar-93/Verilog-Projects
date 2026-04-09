# Sequence Detector (FPGA)

## Overview
FSM-based sequence detector for 101/1010/1011 patterns with overlapping detection in Verilog HDL on Xilinx Vivado.

## Specs
- Patterns: 101, 1010, 1011 (parameterizable)
- Detection modes: Overlapping/Non-overlapping
- Clock: 100 MHz | States: 6-state Moore FSM
- Latency: 1 clock cycle detection delay

## Files
| File | Description |
|------|-------------|
| seq_detector.v | RTL Design (Verilog 2001) - One-hot encoded 6-state FSM |
| seq_detector_tb.v | Simulation Testbench - Random bit streams + known sequences |
| seq_detector.xdc | Timing & Pin Constraints (Basys3) - UART RX pin mapping |
| state_diagram.svg | FSM state transition diagram |

## Tools
- Xilinx Vivado 2025.2
- Target Board: Digilent Basys3 (XC7A35T)
