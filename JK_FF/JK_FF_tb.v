`timescale 1ns / 1ps
module JK_FF_tb;
reg j,k,rst,clk;
wire q;
JK_FF uut(.j(j), .k(k), .rst(rst), .clk(clk), .q(q));
always
    #5 clk = ~clk;
initial begin 
    clk =1;
    rst = 1;
    #10 rst = 0; j=1;k=1;
    #10 j=0;k=1;
    #10 j=1;k=0;
    rst = 1;#10 rst <= 0;
    #5 j<=1;k=0;
    #20 $finish;
end
endmodule
