`timescale 1ns / 1ps
module counter_tb;
reg rst,clk;
wire [3:0] q; 
counter uut(
      .rst(rst), .clk(clk), .q(q) );

always   #5 clk <= ~clk;
initial begin 
    clk =1; rst <=1;
    #3 rst <= 0; #100 rst <= 1;
    #10 rst <= 0;
    #20 $finish;
end
endmodule
