module MUX_2_1 #(parameter width = 16)
(
                input logic [width-1:0]      d0, d1,
                input logic             s,
                output logic [width-1:0]     y
);
always_comb begin
    if (s)
        y = d1;
    else
        y = d0;
end
endmodule

module MUX_4_1 #(parameter width = 16)
(
                input logic [width-1:0]     d0, d1, d2, d3,
                input logic [1:0]           s,
                output logic [width-1:0]    y
);
always_comb begin
    if (s == 2'b00)
        y = d0;
    else if (s == 2'b01)
        y = d1;
    else if (s == 2'b10)
        y = d2;
    else
        y = d3;
end
endmodule

module MUX_8_1 
(
                input logic [15:0]      d0, d1, d2, d3, d4, d5, d6, d7,
                input logic [2:0]       s,
                output logic [15:0]     y
);
always_comb begin
    case(s)
        3'b000:
            y = d0;
        3'b001:
            y = d1;
        3'b010:
            y = d2;
        3'b011:
            y = d3;
        3'b100:
            y = d4;
        3'b101:
            y = d5;
        3'b110:
            y = d6;
        3'b111:
            y = d7;
    endcase
end
endmodule