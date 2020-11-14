module SR2MUX (
						input logic [15:0] IR, SR2_out, 
						input logic SR2MUX_sel,
						output logic [15:0] ALU_B);
						
						
						always_comb
						begin
							if (SR2MUX_sel) begin
								ALU_B = {{11{IR[4]}},IR[4:0]};
							end
							
							else begin
								ALU_B = SR2_out;
							end
						end
endmodule