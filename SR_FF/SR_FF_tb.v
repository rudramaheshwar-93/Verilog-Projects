`timescale 1ns / 1ps
module SR_FF_tb;
reg s,r,en;
wire out;

SR_FF uut( .s(s), .r(r), .en(en), .out(out));
initial begin
    en <= 1;
    s <=0;r<=1;
    #10 s <= 1; r<=0;
    
    #5 en <=0;
    #5 s = 0; r=1; #10 en <=1;
    
    #10 s <= 0; r<=1;
    #10 s <= 1; r<=0;
    #10 s<= 1; r<= 1;
    #20 $finish;
end
endmodule
