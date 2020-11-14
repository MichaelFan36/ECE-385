module DRMUX (
						input logic [15:0] IR, 
						input logic DRMUX_sel,
						output logic [2:0] DRMUX_out);
						
						logic [2:0] IR_11_9;
						assign IR_11_9 = IR[11:9];
						
						always_comb
						begin
							if (DRMUX_sel) begin
								DRMUX_out = 3'b111;
							end
							
							else begin
								DRMUX_out = IR_11_9;
							end
						end
endmodule