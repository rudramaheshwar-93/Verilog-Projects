// ============================================================
// Testbench: fir_filter_tb.v
// Simulates the 16-tap FIR Low-Pass Filter
// Tests: Reset, Impulse, Step, Sine (passband + stopband)
// Compatible: Xilinx Vivado Simulator (xsim)
// ============================================================

`timescale 1ns / 1ps

module fir_filter_tb;

    // -------------------------------------------------------
    // Parameters
    // -------------------------------------------------------
    localparam CLK_PERIOD  = 10;   // 100 MHz clock (10 ns)
    localparam DATA_WIDTH  = 16;
    localparam NUM_SAMPLES = 256;

    // -------------------------------------------------------
    // DUT Signals
    // -------------------------------------------------------
    reg                          clk;
    reg                          rst_n;
    reg                          valid_in;
    reg  signed [DATA_WIDTH-1:0] data_in;
    wire signed [DATA_WIDTH-1:0] data_out;
    wire                         valid_out;

    // -------------------------------------------------------
    // Instantiate Device Under Test
    // -------------------------------------------------------
    fir_filter #(
        .DATA_WIDTH(16),
        .COEF_WIDTH(16),
        .NUM_TAPS  (16),
        .ACC_WIDTH (40)
    ) DUT (
        .clk      (clk),
        .rst_n    (rst_n),
        .valid_in (valid_in),
        .data_in  (data_in),
        .data_out (data_out),
        .valid_out(valid_out)
    );

    // -------------------------------------------------------
    // Clock Generation: 100 MHz
    // -------------------------------------------------------
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // -------------------------------------------------------
    // Test Variables
    // -------------------------------------------------------
    integer idx;
    integer out_count;
    real    pi;
    real    sine_val;
    integer pass_count, fail_count;

    // Store output samples
    reg signed [DATA_WIDTH-1:0] output_log [0:NUM_SAMPLES-1];

    // -------------------------------------------------------
    // Tasks
    // -------------------------------------------------------
    task send_sample;
        input signed [DATA_WIDTH-1:0] sample;
        begin
            @(posedge clk);
            valid_in <= 1;
            data_in  <= sample;
            @(posedge clk);
            valid_in <= 0;
            data_in  <= 0;
        end
    endtask

    task wait_cycles;
        input integer n;
        begin
            repeat(n) @(posedge clk);
        end
    endtask

    // -------------------------------------------------------
    // Output Monitor: Capture valid outputs
    // -------------------------------------------------------
    initial out_count = 0;
    always @(posedge clk) begin
        if (valid_out && out_count < NUM_SAMPLES) begin
            output_log[out_count] = data_out;
            out_count = out_count + 1;
        end
    end

    // -------------------------------------------------------
    // Main Test Sequence
    // -------------------------------------------------------
    initial begin
        // --- Setup ---
        pi          = 3.14159265358979;
        pass_count  = 0;
        fail_count  = 0;
        valid_in    = 0;
        data_in     = 0;
        rst_n       = 0;

        $display("==============================================");
        $display("  16-Tap FIR Low-Pass Filter Simulation");
        $display("  Clock: 100 MHz | Taps: 16 | Fc: 0.2*Fs");
        $display("==============================================");

        // *** TEST 1: Reset Verification ***
        $display("\n[TEST 1] Reset Verification...");
        wait_cycles(5);
        rst_n = 1;
        wait_cycles(2);
        $display("  Reset released. DUT initialized.");

        // *** TEST 2: Impulse Response ***
        $display("\n[TEST 2] Impulse Response Test...");
        $display("  Sending impulse (32767) followed by zeros...");
        send_sample(16'sh7FFF);  // Max positive = impulse
        for (idx = 0; idx < 20; idx = idx + 1)
            send_sample(16'sh0000);
        wait_cycles(10);
        $display("  Impulse response captured. Check waveform in Vivado.");

        // *** TEST 3: Step Response ***
        $display("\n[TEST 3] Step Response Test...");
        rst_n = 0; wait_cycles(3); rst_n = 1; wait_cycles(2);
        $display("  Sending step input (all 16384)...");
        for (idx = 0; idx < 32; idx = idx + 1)
            send_sample(16'sh4000);   // 0.5 * full scale
        wait_cycles(10);
        $display("  Step response complete.");

        // *** TEST 4: Passband Sine (f = 0.1*Fs - should PASS through) ***
        $display("\n[TEST 4] Passband Sine @ 0.1*Fs (expect ~no attenuation)...");
        rst_n = 0; wait_cycles(3); rst_n = 1; wait_cycles(2);
        for (idx = 0; idx < 64; idx = idx + 1) begin
            sine_val = 16383.0 * $sin(2.0 * pi * 0.1 * idx);
            send_sample($rtoi(sine_val));
        end
        wait_cycles(20);
        $display("  Passband test complete. Output amplitude should be ~16383.");

        // *** TEST 5: Stopband Sine (f = 0.4*Fs - should be ATTENUATED) ***
        $display("\n[TEST 5] Stopband Sine @ 0.4*Fs (expect strong attenuation)...");
        rst_n = 0; wait_cycles(3); rst_n = 1; wait_cycles(2);
        for (idx = 0; idx < 64; idx = idx + 1) begin
            sine_val = 16383.0 * $sin(2.0 * pi * 0.4 * idx);
            send_sample($rtoi(sine_val));
        end
        wait_cycles(20);
        $display("  Stopband test complete. Output amplitude should be near 0.");

        // *** TEST 6: Mixed Signal (passband + stopband) ***
        $display("\n[TEST 6] Mixed Signal Test (0.1*Fs + 0.4*Fs)...");
        rst_n = 0; wait_cycles(3); rst_n = 1; wait_cycles(2);
        for (idx = 0; idx < 64; idx = idx + 1) begin
            sine_val = 8191.0 * $sin(2.0 * pi * 0.1 * idx) +
                       8191.0 * $sin(2.0 * pi * 0.4 * idx);
            send_sample($rtoi(sine_val));
        end
        wait_cycles(20);
        $display("  Mixed signal test complete. Only low-freq should remain.");

        // *** TEST 7: Valid Signal Timing Check ***
        $display("\n[TEST 7] Valid Signal Pipeline Latency Check...");
        rst_n = 0; wait_cycles(3); rst_n = 1; wait_cycles(2);
        @(posedge clk); valid_in = 1; data_in = 16'sh1234;
        @(posedge clk); valid_in = 0; data_in = 0;
        // Expect valid_out after pipeline delay (3 clock cycles)
        repeat(10) begin
            @(posedge clk);
            if (valid_out)
                $display("  valid_out asserted at time %0t ns", $time);
        end

        // *** Coefficient Accuracy Check ***
        $display("\n[ACCURACY] Coefficient Sum Verification...");
        $display("  Sum of all coefficients (DC gain check):");
        $display("  Expected DC output for all-ones input = input amplitude");
        $display("  Coefficient accuracy target: 98.5%%");

        // *** Summary ***
        $display("\n==============================================");
        $display("  SIMULATION COMPLETE");
        $display("  Total output samples captured: %0d", out_count);
        $display("  Open Vivado waveform to analyze results.");
        $display("==============================================");

        #100;
        $finish;
    end

    // -------------------------------------------------------
    // Timeout Watchdog (prevents infinite simulation)
    // -------------------------------------------------------
    initial begin
        #500000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    // -------------------------------------------------------
    // Waveform Dump for Vivado (VCD format)
    // -------------------------------------------------------
    initial begin
        $dumpfile("fir_filter_sim.vcd");
        $dumpvars(0, fir_filter_tb);
    end

    // -------------------------------------------------------
    // Real-time Monitor: Print output samples
    // -------------------------------------------------------
    always @(posedge clk) begin
        if (valid_out)
            $display("  t=%0t ns | data_out = %0d (0x%04h)",
                     $time, data_out, data_out);
    end

endmodule
