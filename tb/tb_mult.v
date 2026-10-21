`timescale 1ns/1ps

module tb_mult;

    // DUT signals
    reg        clk;
    reg        rst_n;
    reg  [3:0] a;
    reg  [3:0] b;
    wire [7:0] p;

    // Instantiate DUT
    mult_array dut (
        .clk   (clk),
        .rst_n (rst_n),
        .a     (a),
        .b     (b),
        .p     (p)
    );

    // Clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("mult.vcd");
        $dumpvars(0, tb_mult);
    end

    // Variables
    integer ai, bi;
    integer errors;
    reg [7:0] expected;

    initial begin
        // Initialise
        errors = 0;
        a      = 0;
        b      = 0;
        rst_n  = 0;

        // Hold reset for 2 clock cycles
        @(posedge clk); #1;
        @(posedge clk); #1;
        rst_n = 1;

        // Apply all 256 combinations
        for (ai = 0; ai < 16; ai = ai + 1) begin
            for (bi = 0; bi < 16; bi = bi + 1) begin

                // Apply inputs
                a = ai[3:0];
                b = bi[3:0];

                // Wait 2 clock cycles for latency
                @(posedge clk); #1;
                @(posedge clk); #1;

                // Check result
                expected = ai * bi;
                if (p !== expected) begin
                    $display("MISMATCH: a=%0d b=%0d expected=%0d got=%0d",
                              ai, bi, expected, p);
                    errors = errors + 1;
                end
            end
        end

        // Summary line — exact format required
        if (errors == 0)
            $display("PASS: 256 vectors checked, 0 errors");
        else
            $display("FAIL: 256 vectors checked, %0d errors", errors);

        $finish;
    end

endmodule
