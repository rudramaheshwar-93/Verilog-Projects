`timescale 1ns / 1ps
module SR_FF(
    input s, r,en,
    output reg out
    );
    reg q;
    always @(en or s or r) begin 
        if(en)
        begin
           case({s,r})
           2'b00: out = q;
           2'b01: out = 1'b0;
           2'b10: out = 1'b1;
           2'b11: out = 1'bx;
           default: out = 1'b0;
           endcase
           q = out;
        end    
        else
            out = q;
    end 
endmodule
