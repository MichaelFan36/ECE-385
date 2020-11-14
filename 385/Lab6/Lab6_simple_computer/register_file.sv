module register_file (
								input logic [15:0] Data_in,IR,
								input logic [2:0] DRMUX_out, SR1MUX_out,
								input logic LD_REG, Clk, Reset,
								output logic [15:0] SR1_out, SR2_out);
								
								logic LD_R0, LD_R1, LD_R2, LD_R3, LD_R4, LD_R5, LD_R6, LD_R7;
								logic [15:0] R0_val, R1_val, R2_val, R3_val, R4_val, R5_val, R6_val, R7_val;
								logic [2:0] SR2_sel;
								assign SR2_sel = IR[2:0];
								
									//Load data into the registers
									always_comb
									begin
										case (DRMUX_out) 
											3'b000: begin
													  LD_R0 = LD_REG;
													  LD_R1 = 1'b0;
													  LD_R2 = 1'b0;
													  LD_R3 = 1'b0;
													  LD_R4 = 1'b0;
													  LD_R5 = 1'b0;
													  LD_R6 = 1'b0;
													  LD_R7 = 1'b0;
											end
													  
											3'b001: begin
													  LD_R0 = 1'b0;
													  LD_R1 = LD_REG;
													  LD_R2 = 1'b0;
													  LD_R3 = 1'b0;
													  LD_R4 = 1'b0;
													  LD_R5 = 1'b0;
													  LD_R6 = 1'b0;
													  LD_R7 = 1'b0;
											end
													  
											3'b010: begin
													  LD_R0 = 1'b0;
													  LD_R1 = 1'b0;
													  LD_R2 = LD_REG;
													  LD_R3 = 1'b0;
													  LD_R4 = 1'b0;
													  LD_R5 = 1'b0;
													  LD_R6 = 1'b0;
													  LD_R7 = 1'b0;
											end
											
											3'b011: begin
													  LD_R0 = 1'b0;
													  LD_R1 = 1'b0;
													  LD_R2 = 1'b0;
													  LD_R3 = LD_REG;
													  LD_R4 = 1'b0;
													  LD_R5 = 1'b0;
													  LD_R6 = 1'b0;
													  LD_R7 = 1'b0;
											end
											
											3'b100: begin
													  LD_R0 = 1'b0;
													  LD_R1 = 1'b0;
													  LD_R2 = 1'b0;
													  LD_R3 = 1'b0;
													  LD_R4 = LD_REG;
													  LD_R5 = 1'b0;
													  LD_R6 = 1'b0;
													  LD_R7 = 1'b0;
											end
											
											3'b101: begin
											        LD_R0 = 1'b0;
													  LD_R1 = 1'b0;
													  LD_R2 = 1'b0;
													  LD_R3 = 1'b0;
													  LD_R4 = 1'b0;
													  LD_R5 = LD_REG;
													  LD_R6 = 1'b0;
													  LD_R7 = 1'b0;
											end
											
											3'b110: begin
													  LD_R0 = 1'b0;
													  LD_R1 = 1'b0;
													  LD_R2 = 1'b0;
													  LD_R3 = 1'b0;
													  LD_R4 = 1'b0;
													  LD_R5 = 1'b0;
													  LD_R6 = LD_REG;
													  LD_R7 = 1'b0;
											end
											
											3'b111: begin
													  LD_R0 = 1'b0;
													  LD_R1 = 1'b0;
													  LD_R2 = 1'b0;
													  LD_R3 = 1'b0;
													  LD_R4 = 1'b0;
													  LD_R5 = 1'b0;
													  LD_R6 = 1'b0;
													  LD_R7 = LD_REG;
											end
										endcase
									end
									
									R0 r0(.LD_R0, .Reset, .Clk, .Data_in, .R0_val);
									R1 r1(.LD_R1, .Reset, .Clk, .Data_in, .R1_val);
									R2 r2(.LD_R2, .Reset, .Clk, .Data_in, .R2_val);
									R3 r3(.LD_R3, .Reset, .Clk, .Data_in, .R3_val);
									R4 r4(.LD_R4, .Reset, .Clk, .Data_in, .R4_val);
									R5 r5(.LD_R5, .Reset, .Clk, .Data_in, .R5_val);
									R6 r6(.LD_R6, .Reset, .Clk, .Data_in, .R6_val);
									R7 r7(.LD_R7, .Reset, .Clk, .Data_in, .R7_val);
									
									//Get data from the registers
									always_comb
									begin
										case (SR1MUX_out)
											3'b000: SR1_out = R0_val;
											3'b001: SR1_out = R1_val;
											3'b010: SR1_out = R2_val;
											3'b011: SR1_out = R3_val;
											3'b100: SR1_out = R4_val;
											3'b101: SR1_out = R5_val;
											3'b110: SR1_out = R6_val;
											3'b111: SR1_out = R7_val;
										endcase
									end
									
									always_comb
									begin
										case (SR2_sel)
											3'b000: SR2_out = R0_val;
											3'b001: SR2_out = R1_val;
											3'b010: SR2_out = R2_val;
											3'b011: SR2_out = R3_val;
											3'b100: SR2_out = R4_val;
											3'b101: SR2_out = R5_val;
											3'b110: SR2_out = R6_val;
											3'b111: SR2_out = R7_val;
										endcase
									end
endmodule
