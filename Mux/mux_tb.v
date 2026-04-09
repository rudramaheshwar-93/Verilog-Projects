/*module mux_tb;
reg a,b,c,d;
reg [1:0]s;
wire out;
mux uut(
    .a(a),.b(b),.c(c),.d(d),.s(s),.out(out)
);
initial begin
    a = 1;b =0; c=1; d =0;
    s = 2'b00;
    #10 s = 2'b01;
    #10 s = 2'b10;
    #10 s = 2'b11;
    #30 $finish;
end 
endmodule
*/
module mux_tb();
    reg a,sel,b;
    wire out;
    mux uut(
        .a(a), .sel(sel), .b(b), .out(out)
        );
        initial begin 
        sel = 0;
        a= 1;b=1;
        #10 a=0;b=1;
        #10 a= 1;b=0;
        #10 sel =1;
        a= 1;b=1;
        #10 a=0;b=1;
        #10 a= 1;b=0;
        #20 $finish;
        end
endmodule

