module tb_mult;

    reg         clk;
    reg         rst_n;
    reg  [3:0]  a, b;
    wire [7:0]  p;

    integer     i, j;
    integer     vectors;
    integer     errors;
    reg  [7:0]  expected;

    mult_array dut (
        .clk   (clk),
        .rst_n (rst_n),
        .a     (a),
        .b     (b),
        .p     (p)
    );

    // 10 ns clock period
    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("mult.vcd");
        $dumpvars(0, tb_mult);

        vectors = 0;
        errors  = 0;
        a       = 4'd0;
        b       = 4'd0;

        // Hold reset low for the first 2 clock cycles
        rst_n = 1'b0;
        @(posedge clk);
        @(posedge clk);
        rst_n = 1'b1;

        // Exhaustive 256-vector test: a = 0..15, b = 0..15
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a        = i[3:0];
                b        = j[3:0];
                expected = i * j;   // `*` used only here, to build the reference value

                // 2-cycle latency: edge 1 registers a/b, edge 2 registers p
                @(posedge clk);
                @(posedge clk);

                vectors = vectors + 1;
                if (p !== expected) begin
                    errors = errors + 1;
                    $display("MISMATCH: a=%0d b=%0d expected=%0d got=%0d", i, j, expected, p);
                end
            end
        end

        if (errors == 0)
            $display("PASS: %0d vectors checked, %0d errors", vectors, errors);
        else
            $display("FAIL: %0d vectors checked, %0d errors", vectors, errors);

        $finish;
    end

endmodule
