/*
module mux(
    input wire [3:0]a,[1:0] s,
     output reg y
    );
    always @(*)
    begin
    case(s)
    2'b00 : y <=a[0];
    2'b01 : y <=a[1];
    2'b10 : y <=a[2];
    2'b11 : y <=a[3];
    endcase
    end
    //assign y = (a[0]&(~s[0])&(~s[1]))|(a[1]&s[0]&(~s[1])) | (a[2]&s[1]&(~s[0]))| (a[3]&s[1]&s[0]);
endmodule

module mux(
    input wire a,b,c,d,
    input wire [1:0]s,
    output reg out
);
always @(a or b or c or d or s)
begin
    case(s)
    2'b00 : out <= a;
    2'b01 : out <= b;
    2'b10 : out <= c;
    2'b11 : out <= d;
    default : out <= 1'bx;
    endcase
end
endmodule
*/
module mux(
    input a,b,sel,
    output out
);
  wire x,y,z;
  not(x,sel);
  and(y,x,a);
  and(z,sel,b);
  or(out,y,z);
endmodule