`timescale 1ns / 1ps
module counter(
    input wire rst,clk,
    output reg [3:0]q
    );
    always @(posedge clk) begin 
        if(rst)
            q <= 4'b0000;
        else if(q < 4'b1111)  
            q <= q+1;
        else 
            q <= 4'b0000;
    end
endmodule
/* 
Level 3: FSM (Core Digital Design Skill)

Traffic Light Controller (FSM)

States: Red → Yellow → Green

Outputs: signals for each light

Testbench: verify state transitions

Vending Machine FSM

Inputs: coin (1/2/5), select

Outputs: dispense, change

This is gold for interviews

Sequence Detector (FSM)

Detect pattern like 1011

Output goes high when pattern seen

🔵 Level 4: Mini "Real" Projects (Resume Worthy)

Password Lock System

Inputs: keypad bits

FSM for states: idle, verify, unlocked, alarm

Output: unlock, buzzer

UART Transmitter (Simple)

Send 8-bit data serially

Great intro to communication protocols

Simple ALU (8-bit)

Operations: add, sub, and, or, xor

Select via opcode

Testbench with random testsv */