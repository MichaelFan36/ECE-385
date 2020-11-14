module reg_file (
                input logic [15:0]  BUS,
                input logic [2:0]   DR, SR1, SR2,
                input logic         LD, Clk, Reset,
                output logic [15:0] SR1_OUT, SR2_OUT
);

logic D0, D1, D2, D3, D4, D5, D6, D7;
logic W0, W1, W2, W3, W4, W5, W6, W7;
logic [15:0] O0, O1, O2, O3, O4, O5, O6, O7;

assign W0 = D0 & LD;
assign W1 = D1 & LD;
assign W2 = D2 & LD;
assign W3 = D3 & LD;
assign W4 = D4 & LD;
assign W5 = D5 & LD;
assign W6 = D6 & LD;
assign W7 = D7 & LD;

always_comb begin
    D0 = 1'b0;
    D1 = 1'b0;
    D2 = 1'b0;
    D3 = 1'b0;
    D4 = 1'b0;
    D5 = 1'b0;
    D6 = 1'b0;
    D7 = 1'b0;
    case(DR)
        3'b000: D0 = 1'b1;
        3'b001: D1 = 1'b1;
        3'b010: D2 = 1'b1;
        3'b011: D3 = 1'b1;
        3'b100: D4 = 1'b1;
        3'b101: D5 = 1'b1;
        3'b110: D6 = 1'b1;
        3'b111: D7 = 1'b1;
    endcase
end

register R0 (.In(BUS),
        .W(W0),
        .Clk, .Reset,
        .Out(O0));

register R1 (.In(BUS),
        .W(W1),
        .Clk, .Reset,
        .Out(O1));

register R2 (.In(BUS),
        .W(W2),
        .Clk, .Reset,
        .Out(O2));

register R3 (.In(BUS),
        .W(W3),
        .Clk, .Reset,
        .Out(O3));

register R4 (.In(BUS),
        .W(W4),
        .Clk, .Reset,
        .Out(O4));

register R5 (.In(BUS),
        .W(W5),
        .Clk, .Reset,
        .Out(O5));

register R6 (.In(BUS),
        .W(W6),
        .Clk, .Reset,
        .Out(O6));

register R7 (.In(BUS),
        .W(W7),
        .Clk, .Reset,
        .Out(O7));

MUX_8_1 SR1_Pick (
                .d0(O0),
                .d1(O1),
                .d2(O2),
                .d3(O3),
                .d4(O4),
                .d5(O5),
                .d6(O6),
                .d7(O7),
                .s(SR1),
                .y(SR1_OUT)
);

MUX_8_1 SR2_Pick (
                .d0(O0),
                .d1(O1),
                .d2(O2),
                .d3(O3),
                .d4(O4),
                .d5(O5),
                .d6(O6),
                .d7(O7),
                .s(SR2),
                .y(SR2_OUT)
);

endmodule

module register(
            input logic [15:0]  In,
            input logic         W, Clk, Reset,
            output logic [15:0] Out
);

always_ff @(posedge Clk) begin
    if (Reset)
        Out <= 16'b0;
    else if (W)
        Out <= In;
end

endmodule