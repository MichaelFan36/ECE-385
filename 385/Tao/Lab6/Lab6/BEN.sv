module NZP_logic(
            input logic [15:0]  BUS,
            output logic        N_in, Z_in, P_in
);
always_comb begin
    N_in = 1'b0;
    Z_in = 1'b0;
    P_in = 1'b0;
    if (BUS[15])
        N_in = 1'b1;
    else if (BUS == 16'b0)
        Z_in = 1'b1;
    else
        P_in = 1'b1;
end

endmodule

module BEN_logic(
                input logic N, Z, P,
                input logic [2:0] Cond,
                output logic BEN_In
);
always_comb begin
    BEN_In = 1'b0;
    if((N & Cond[2]) | (Z & Cond[1]) | (P & Cond[0]))
        BEN_In = 1'b1;
end

endmodule