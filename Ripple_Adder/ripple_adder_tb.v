module ripple_adder_tb;
reg [3:0] a;
reg [3:0] b;
reg c_in;
wire [3:0] sum;
wire c_out;
ripple_adder uut(.a(a), .b(b), .c_in(c_in), .sum(sum), .c_out(c_out));
initial begin 
    c_in = 0; a = 4'b1010; b = 4'b0101;
    #10 a=4'b0011; b = 4'b1101;
    #10 c_in = 1;
    a=4'b1001; b = 4'b1100;
    #10 a=4'b0100; b = 4'b1011;
    #30 $finish;
end 
endmodule