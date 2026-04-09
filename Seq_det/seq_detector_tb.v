module seq_detector_tb;
reg in,clk,rst;
wire out;
seq_detector uut(
    .in(in), .clk(clk), .rst(rst), .out(out)
    );
always #5 clk <=~clk;
initial begin 
    clk <= 1; rst <=1;
    in <= 1; 
    #10 rst <= 0; #8 in <= 0;
    #10 in <= 1; #10 in <= 1;
    #10 in <= 0; #10 in <= 1; #10 in <= 1; #10 in <= 1;
    #10 in <= 0; #10 in <= 1; #10 in <= 1;
    #10 $finish; 
end
endmodule
