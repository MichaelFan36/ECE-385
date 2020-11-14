module datapath(
                input logic [15:0]  PC, 
                                    adder_out, 
                                    ALU_OUT,
                                    MDR,         
				input logic         GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
                output logic [15:0] BUS
);
logic [3:0] SELECT;

assign SELECT = {GatePC, GateMDR, GateALU, GateMARMUX};
always_comb begin
    unique case (SELECT)
        4'b1000:
            BUS = PC;
        4'b0100:
            BUS = MDR;
        4'b0010:
            BUS = ALU_OUT;
        4'b0001:
            BUS = adder_out;
        default:
            BUS = 16'bX;
    endcase
end


endmodule
