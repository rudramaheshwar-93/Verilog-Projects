`timescale 1ns / 1ps

module half_adder_tb();

    reg a;
    reg b;
    wire sum;
    wire carry;

    // Instantiate the DUT (Device Under Test)
    half_adder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        // Optional: print values in console
        $display(" time | a b | sum carry");
        $monitor("%4t | %b %b |  %b    %b", $time, a, b, sum, carry);

        // Apply test vectors
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        #10;
        $finish;
    end

endmodule
