/*`timescale 1ns / 1ps
module ripple_adder(
    input wire[3:0] a, wire [3:0] b,
    output reg [4:0] sum,
    output reg carry
    );
    always @(a or b) begin 
    {carry,sum} = a + b;
    end
endmodule
*/
module ripple_adder(
    input wire[3:0] a,wire [3:0] b,
    input wire c_in,
    output wire [3:0] sum,
    output wire c_out
);
    wire [2:0] c;
    FA FA0(.a(a[0]), .b(b[0]), .c(c_in), .sum(sum[0]), .carry(c[0]));
    FA FA1(.a(a[1]), .b(b[1]), .c(c[0]), .sum(sum[1]), .carry(c[1]));
    FA FA2(.a(a[2]), .b(b[2]), .c(c[1]), .sum(sum[2]), .carry(c[2]));
    FA FA3(.a(a[3]), .b(b[3]), .c(c[2]), .sum(sum[3]), .carry(c_out));
endmodule
module FA(
    input wire a,b,c,
    output reg sum,carry);
    always @(a or b or c) begin 
        sum = a^b^c;
        carry = (a&b) | (b&c) | (c&a);
    end
endmodule