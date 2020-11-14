module ADDR1MUX (
							input logic [15:0] PC_out, SR1_out,
							input logic ADDR1MUX_sel,
							output logic ADDR1MUX_out);
							
							always_comb
							begin
								if (ADDR1MUX_sel) begin
									ADDR1MUX_out = PC_out;
								end
								
								else begin
									ADDR1MUX_out = SR1_out;
								end
							end
endmodule