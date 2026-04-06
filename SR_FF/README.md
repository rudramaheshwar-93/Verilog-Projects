# SR Flip-Flop

A Verilog implementation of an SR Flip-Flop with handling for the forbidden state (S=1, R=1).

## Inputs / Outputs
- Inputs: S, R, CLK, RST
- Outputs: Q, Q_bar

## Files
- `sr_ff.v` — RTL design
- `sr_ff_tb.v` — Testbench

## Simulation
Simulated using Xilinx Vivado. All input combinations including the forbidden state are tested and documented in waveforms.