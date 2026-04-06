# JK Flip-Flop

A Verilog implementation of a JK Flip-Flop with all four input combinations (00, 01, 10, 11) verified through simulation.

## Inputs / Outputs
- Inputs: J, K, CLK, RST
- Outputs: Q, Q_bar

## Files
- `jk_ff.v` — RTL design
- `jk_ff_tb.v` — Testbench

## Simulation
Simulated using Xilinx Vivado. Waveforms verify hold, reset, set, and toggle behaviour.