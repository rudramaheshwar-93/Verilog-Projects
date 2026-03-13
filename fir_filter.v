// ============================================================
// 16-Tap FIR Low-Pass Filter - Pipelined Architecture
// Target: Xilinx Vivado | Clock: 100 MHz
// Language: Pure Verilog (IEEE 1364-2001) - NO SystemVerilog
// ============================================================

module fir_filter #(
    parameter DATA_WIDTH = 16,
    parameter COEF_WIDTH = 16,
    parameter NUM_TAPS   = 16,
    parameter ACC_WIDTH  = 40
)(
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         valid_in,
    input  wire signed [DATA_WIDTH-1:0] data_in,
    output reg  signed [DATA_WIDTH-1:0] data_out,
    output reg                          valid_out
);

    // -------------------------------------------------------
    // FIR Coefficients: Hamming Window, Fc=0.2*Fs, Q1.15
    // In pure Verilog-2001, arrays cannot use '{...} init.
    // Each coefficient is a separate localparam instead.
    // MATLAB: round(fir1(15, 0.2, hamming(16)) * 32768)
    // -------------------------------------------------------
    localparam signed [COEF_WIDTH-1:0] C0 = 16'sh0066; //  102
    localparam signed [COEF_WIDTH-1:0] C1 = 16'sh0106; //  262
    localparam signed [COEF_WIDTH-1:0] C2 = 16'sh031A; //  794
    localparam signed [COEF_WIDTH-1:0] C3 = 16'sh0737; // 1847
    localparam signed [COEF_WIDTH-1:0] C4 = 16'sh0D2A; // 3370
    localparam signed [COEF_WIDTH-1:0] C5 = 16'sh1396; // 5014
    localparam signed [COEF_WIDTH-1:0] C6 = 16'sh183A; // 6202
    localparam signed [COEF_WIDTH-1:0] C7 = 16'sh1A5C; // 6748 (center)
    // Symmetric: C8=C7, C9=C6, C10=C5 ... C15=C0

    // -------------------------------------------------------
    // Stage 1: Shift Register (Sample Delay Line)
    // 16 individual regs - compatible with Verilog-2001
    // -------------------------------------------------------
    reg signed [DATA_WIDTH-1:0] sr0,  sr1,  sr2,  sr3;
    reg signed [DATA_WIDTH-1:0] sr4,  sr5,  sr6,  sr7;
    reg signed [DATA_WIDTH-1:0] sr8,  sr9,  sr10, sr11;
    reg signed [DATA_WIDTH-1:0] sr12, sr13, sr14, sr15;

    reg valid_p0, valid_p1, valid_p2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sr0  <= 0; sr1  <= 0; sr2  <= 0; sr3  <= 0;
            sr4  <= 0; sr5  <= 0; sr6  <= 0; sr7  <= 0;
            sr8  <= 0; sr9  <= 0; sr10 <= 0; sr11 <= 0;
            sr12 <= 0; sr13 <= 0; sr14 <= 0; sr15 <= 0;
            valid_p0 <= 1'b0;
        end else begin
            valid_p0 <= valid_in;
            if (valid_in) begin
                sr0  <= data_in;
                sr1  <= sr0;  sr2  <= sr1;  sr3  <= sr2;
                sr4  <= sr3;  sr5  <= sr4;  sr6  <= sr5;
                sr7  <= sr6;  sr8  <= sr7;  sr9  <= sr8;
                sr10 <= sr9;  sr11 <= sr10; sr12 <= sr11;
                sr13 <= sr12; sr14 <= sr13; sr15 <= sr14;
            end
        end
    end

    // -------------------------------------------------------
    // Stage 2a: Symmetric Pair Sums (registered)
    // ss[k] = sr[k] + sr[15-k]
    // This halves the multiplier count: 16 -> 8
    // -------------------------------------------------------
    reg signed [DATA_WIDTH:0] ss0, ss1, ss2, ss3;
    reg signed [DATA_WIDTH:0] ss4, ss5, ss6, ss7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ss0 <= 0; ss1 <= 0; ss2 <= 0; ss3 <= 0;
            ss4 <= 0; ss5 <= 0; ss6 <= 0; ss7 <= 0;
        end else begin
            ss0 <= {sr0[DATA_WIDTH-1],  sr0}  + {sr15[DATA_WIDTH-1], sr15};
            ss1 <= {sr1[DATA_WIDTH-1],  sr1}  + {sr14[DATA_WIDTH-1], sr14};
            ss2 <= {sr2[DATA_WIDTH-1],  sr2}  + {sr13[DATA_WIDTH-1], sr13};
            ss3 <= {sr3[DATA_WIDTH-1],  sr3}  + {sr12[DATA_WIDTH-1], sr12};
            ss4 <= {sr4[DATA_WIDTH-1],  sr4}  + {sr11[DATA_WIDTH-1], sr11};
            ss5 <= {sr5[DATA_WIDTH-1],  sr5}  + {sr10[DATA_WIDTH-1], sr10};
            ss6 <= {sr6[DATA_WIDTH-1],  sr6}  + {sr9[DATA_WIDTH-1],  sr9};
            ss7 <= {sr7[DATA_WIDTH-1],  sr7}  + {sr8[DATA_WIDTH-1],  sr8};
        end
    end

    // -------------------------------------------------------
    // Stage 2b: Multiply each symmetric sum by coefficient
    // Product width = (DATA_WIDTH+1) + COEF_WIDTH = 33 bits
    // -------------------------------------------------------
    localparam MULT_WIDTH = DATA_WIDTH + COEF_WIDTH + 1; // 33

    reg signed [MULT_WIDTH-1:0] m0, m1, m2, m3;
    reg signed [MULT_WIDTH-1:0] m4, m5, m6, m7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            m0 <= 0; m1 <= 0; m2 <= 0; m3 <= 0;
            m4 <= 0; m5 <= 0; m6 <= 0; m7 <= 0;
            valid_p1 <= 1'b0;
        end else begin
            valid_p1 <= valid_p0;
            m0 <= ss0 * C0;
            m1 <= ss1 * C1;
            m2 <= ss2 * C2;
            m3 <= ss3 * C3;
            m4 <= ss4 * C4;
            m5 <= ss5 * C5;
            m6 <= ss6 * C6;
            m7 <= ss7 * C7;
        end
    end

    // -------------------------------------------------------
    // Stage 3: Pipelined Adder Tree  8 -> 4 -> 2 -> 1
    // Sign-extend products to ACC_WIDTH before adding
    // -------------------------------------------------------
    reg signed [ACC_WIDTH-1:0] a0, a1, a2, a3;
    reg signed [ACC_WIDTH-1:0] b0, b1;
    reg signed [ACC_WIDTH-1:0] acc;

    // Sign-extend helper wires
    wire signed [ACC_WIDTH-1:0] em0, em1, em2, em3;
    wire signed [ACC_WIDTH-1:0] em4, em5, em6, em7;

    assign em0 = {{(ACC_WIDTH-MULT_WIDTH){m0[MULT_WIDTH-1]}}, m0};
    assign em1 = {{(ACC_WIDTH-MULT_WIDTH){m1[MULT_WIDTH-1]}}, m1};
    assign em2 = {{(ACC_WIDTH-MULT_WIDTH){m2[MULT_WIDTH-1]}}, m2};
    assign em3 = {{(ACC_WIDTH-MULT_WIDTH){m3[MULT_WIDTH-1]}}, m3};
    assign em4 = {{(ACC_WIDTH-MULT_WIDTH){m4[MULT_WIDTH-1]}}, m4};
    assign em5 = {{(ACC_WIDTH-MULT_WIDTH){m5[MULT_WIDTH-1]}}, m5};
    assign em6 = {{(ACC_WIDTH-MULT_WIDTH){m6[MULT_WIDTH-1]}}, m6};
    assign em7 = {{(ACC_WIDTH-MULT_WIDTH){m7[MULT_WIDTH-1]}}, m7};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a0 <= 0; a1 <= 0; a2 <= 0; a3 <= 0;
            b0 <= 0; b1 <= 0;
            acc <= 0;
            valid_p2  <= 1'b0;
            data_out  <= 0;
            valid_out <= 1'b0;
        end else begin
            valid_p2 <= valid_p1;

            // Level 1: 8 products -> 4 sums
            a0 <= em0 + em1;
            a1 <= em2 + em3;
            a2 <= em4 + em5;
            a3 <= em6 + em7;

            // Level 2: 4 -> 2
            b0 <= a0 + a1;
            b1 <= a2 + a3;

            // Level 3: 2 -> 1
            acc <= b0 + b1;

            // Truncate Q1.15: drop 15 fractional bits
            // acc[30:15] gives the 16-bit output
            data_out  <= acc[DATA_WIDTH+15-1 : 15];
            valid_out <= valid_p2;
        end
    end

endmodule