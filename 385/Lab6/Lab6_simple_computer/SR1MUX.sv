module SR1MUX (
						input logic [15:0] IR,
						input logic SR1MUX_sel,
						output logic [2:0] SR1MUX_out);
						
						logic [2:0] IR_8_6, IR_11_9;
						assign IR_8_6 = IR[8:6];
						assign IR_11_9 = IR[11:9];
						
						always_comb
						begin
							if (SR1MUX_sel) begin
								SR1MUX_out = IR_8_6;
							end
							
							else begin
								SR1MUX_out = IR_11_9;
							end
						end
endmodule