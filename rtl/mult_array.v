module mult_array(
    input            clk,
    input            rst_n,
    input      [3:0] a,
    input      [3:0] b,
    output reg [7:0] p
);

    // Input registers
    reg [3:0] a_reg, b_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 4'b0;
            b_reg <= 4'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Partial products pp_i[j] = a_reg[j] & b_reg[i]
    wire pp_0_0 = a_reg[0] & b_reg[0];
    wire pp_0_1 = a_reg[1] & b_reg[0];
    wire pp_0_2 = a_reg[2] & b_reg[0];
    wire pp_0_3 = a_reg[3] & b_reg[0];

    wire pp_1_0 = a_reg[0] & b_reg[1];
    wire pp_1_1 = a_reg[1] & b_reg[1];
    wire pp_1_2 = a_reg[2] & b_reg[1];
    wire pp_1_3 = a_reg[3] & b_reg[1];

    wire pp_2_0 = a_reg[0] & b_reg[2];
    wire pp_2_1 = a_reg[1] & b_reg[2];
    wire pp_2_2 = a_reg[2] & b_reg[2];
    wire pp_2_3 = a_reg[3] & b_reg[2];

    wire pp_3_0 = a_reg[0] & b_reg[3];
    wire pp_3_1 = a_reg[1] & b_reg[3];
    wire pp_3_2 = a_reg[2] & b_reg[3];
    wire pp_3_3 = a_reg[3] & b_reg[3];

    // Row 0: no adders
    // p[0] = pp_0_0 (final bit, registered at end)
    // r_0 = {1'b0, pp_0_3, pp_0_2, pp_0_1}
    wire [3:0] r_0 = {1'b0, pp_0_3, pp_0_2, pp_0_1};

    // Row 1: 4 full adders
    wire [4:0] c_1;
    wire [3:0] s_1;
    assign c_1[0] = 1'b0;

    full_adder fa_1_0 (.a(pp_1_0), .b(r_0[0]), .cin(c_1[0]), .sum(s_1[0]), .cout(c_1[1]));
    full_adder fa_1_1 (.a(pp_1_1), .b(r_0[1]), .cin(c_1[1]), .sum(s_1[1]), .cout(c_1[2]));
    full_adder fa_1_2 (.a(pp_1_2), .b(r_0[2]), .cin(c_1[2]), .sum(s_1[2]), .cout(c_1[3]));
    full_adder fa_1_3 (.a(pp_1_3), .b(r_0[3]), .cin(c_1[3]), .sum(s_1[3]), .cout(c_1[4]));

    // p[1] = s_1[0] (final bit, registered at end)
    // r_1 = {c_1[4], s_1[3], s_1[2], s_1[1]}
    wire [3:0] r_1 = {c_1[4], s_1[3], s_1[2], s_1[1]};

    // Row 2: 4 full adders
    wire [4:0] c_2;
    wire [3:0] s_2;
    assign c_2[0] = 1'b0;

    full_adder fa_2_0 (.a(pp_2_0), .b(r_1[0]), .cin(c_2[0]), .sum(s_2[0]), .cout(c_2[1]));
    full_adder fa_2_1 (.a(pp_2_1), .b(r_1[1]), .cin(c_2[1]), .sum(s_2[1]), .cout(c_2[2]));
    full_adder fa_2_2 (.a(pp_2_2), .b(r_1[2]), .cin(c_2[2]), .sum(s_2[2]), .cout(c_2[3]));
    full_adder fa_2_3 (.a(pp_2_3), .b(r_1[3]), .cin(c_2[3]), .sum(s_2[3]), .cout(c_2[4]));

    // p[2] = s_2[0] (final bit, registered at end)
    // r_2 = {c_2[4], s_2[3], s_2[2], s_2[1]}
    wire [3:0] r_2 = {c_2[4], s_2[3], s_2[2], s_2[1]};

    // Row 3: 4 full adders
    wire [4:0] c_3;
    wire [3:0] s_3;
    assign c_3[0] = 1'b0;

    full_adder fa_3_0 (.a(pp_3_0), .b(r_2[0]), .cin(c_3[0]), .sum(s_3[0]), .cout(c_3[1]));
    full_adder fa_3_1 (.a(pp_3_1), .b(r_2[1]), .cin(c_3[1]), .sum(s_3[1]), .cout(c_3[2]));
    full_adder fa_3_2 (.a(pp_3_2), .b(r_2[2]), .cin(c_3[2]), .sum(s_3[2]), .cout(c_3[3]));
    full_adder fa_3_3 (.a(pp_3_3), .b(r_2[3]), .cin(c_3[3]), .sum(s_3[3]), .cout(c_3[4]));

    // Combinational result
    wire [7:0] product;
    assign product = {c_3[4], s_3[3], s_3[2], s_3[1], s_3[0],
                      s_2[0], s_1[0], pp_0_0};

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            p <= 8'b0;
        else
            p <= product;
    end

endmodule
