module tristate_MUX (input logic GateMARMUX, GatePC, GateMDR, GateALU,
							input logic [15:0] MAR, PC, MDR, ALU,
							output logic [15:0] Data_out);
							
							always_comb
							begin
								if (GateMARMUX) begin
									Data_out = MAR;
								end
								
								else if (GatePC) begin
									Data_out = PC;
								end
								
								else if (GateMDR) begin
									Data_out = MDR;
								end
								
								else if (GateALU) begin
									Data_out = ALU;
								end
								
								else begin
									Data_out = 16'b0000000000000000;
								end
							end
endmodule
