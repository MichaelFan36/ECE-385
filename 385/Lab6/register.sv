module R0 (
					input logic Clk,
					input logic Reset,
					input logic LD_R0, 
					input logic [15:0] In,

					output logic [15:0] R0
		);
					
					always_ff @ (posedge Clk)
					begin

						if (Reset) 
							R0 = 4'd0;
						else if (LD_R0) 
							R0 = In;
						else 
							R0 = R0;
						
					end
endmodule

module R1 (
					input logic Clk,
					input logic Reset,
					input logic LD_R1, 
					input logic [15:0] In,

					output logic [15:0] R1
		);
					
					always_ff @ (posedge Clk)
					begin

						if (Reset) 
							R1 = 4'd0;
						else if (LD_R1) 
							R1 = In;
						else 
							R1 = R1;
						
					end
endmodule

module R2 (
					input logic Clk,
					input logic Reset,
					input logic LD_R2, 
					input logic [15:0] In,

					output logic [15:0] R2
		);
					
					always_ff @ (posedge Clk)
					begin

						if (Reset) 
							R2 = 4'd0;
						else if (LD_R2) 
							R2 = In;
						else 
							R2 = R2;
						
					end
endmodule

module R3 (
					input logic Clk,
					input logic Reset,
					input logic LD_R3, 
					input logic [15:0] In,

					output logic [15:0] R3
		);
					
					always_ff @ (posedge Clk)
					begin

						if (Reset) 
							R3 = 4'd0;
						else if (LD_R3) 
							R3 = In;
						else 
							R3 = R3;
						
					end
endmodule

module R4 (
					input logic Clk,
					input logic Reset,
					input logic LD_R4, 
					input logic [15:0] In,

					output logic [15:0] R4
		);
					
					always_ff @ (posedge Clk)
					begin

						if (Reset) 
							R4 = 4'd0;
						else if (LD_R4) 
							R4 = In;
						else 
							R4 = R4;
						
					end
endmodule

module R5 (
					input logic Clk,
					input logic Reset,
					input logic LD_R5, 
					input logic [15:0] In,

					output logic [15:0] R5
		);
					
					always_ff @ (posedge Clk)
					begin

						if (Reset) 
							R5 = 4'd0;
						else if (LD_R5) 
							R5 = In;
						else 
							R5 = R5;
						
					end
endmodule

module R6 (
					input logic Clk,
					input logic Reset,
					input logic LD_R6, 
					input logic [15:0] In,

					output logic [15:0] R6
		);
					
					always_ff @ (posedge Clk)
					begin

						if (Reset) 
							R6 = 4'd0;
						else if (LD_R6) 
							R6 = In;
						else 
							R6 = R6;
						
					end
endmodule

module R7 (
					input logic Clk,
					input logic Reset,
					input logic LD_R7, 
					input logic [15:0] In,

					output logic [15:0] R7
		);
					
					always_ff @ (posedge Clk)
					begin

						if (Reset) 
							R7 = 4'd0;
						else if (LD_R7) 
							R7 = In;
						else 
							R7 = R7;
						
					end
endmodule

module eight_registers (
							input logic Clk,
							input logic Reset,
							input logic Ld_REG,
							input logic [15:0] In,
							input logic [15:0] IR,
							input logic [2:0] DRMUX, 
							input logic [2:0] SR1MUX,

							output logic [15:0] SR1, 
							output logic [15:0] SR2
						);
								
						logic LD_R0, LD_R1, LD_R2, LD_R3, LD_R4, LD_R5, LD_R6, LD_R7;
						logic [15:0] Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7;

						R0 r0(.*, .R0(Reg0));
						R1 r1(.*, .R1(Reg1));
						R2 r2(.*, .R2(Reg2));
						R3 r3(.*, .R3(Reg3));
						R4 r4(.*, .R4(Reg4));
						R5 r5(.*, .R5(Reg5));
						R6 r6(.*, .R6(Reg6));
						R7 r7(.*, .R7(Reg7));
								
						// get flag
						always_comb
						begin
							// unable all 
							LD_R0 = 1'b0;
							LD_R1 = 1'b0;
							LD_R2 = 1'b0;
							LD_R3 = 1'b0;
							LD_R4 = 1'b0;
							LD_R5 = 1'b0;
							LD_R6 = 1'b0;
							LD_R7 = 1'b0;

							case (DRMUX) 
								3'b000: 
								begin
									LD_R0 = Ld_REG;
								end
											
								3'b001:
								begin
									LD_R1 = Ld_REG;
								end
											
								3'b010: 
								begin
									LD_R2 = Ld_REG;
								end
								
								3'b011: 
								begin
									LD_R3 = Ld_REG;
								end
								
								3'b100: 
								begin
									LD_R4 = Ld_REG;
								end
								
								3'b101:
								begin
									LD_R5 = Ld_REG;
								end
								
								3'b110: 
								begin
									LD_R6 = Ld_REG;
								end
								
								3'b111: 
								begin
									LD_R7 = Ld_REG;
								end
							endcase
						end
						
						
						// read from register
						always_comb
						begin
							case (SR1MUX)
								3'b000: 
									SR1 = Reg0;
								3'b001: 
									SR1 = Reg1;
								3'b010: 
									SR1 = Reg2;
								3'b011: 
									SR1 = Reg3;
								3'b100: 
									SR1 = Reg4;
								3'b101: 
									SR1 = Reg5;
								3'b110: 
									SR1 = Reg6;
								3'b111: 
									SR1 = Reg7;
							endcase
						end
						
						always_comb
						begin
							case (IR[2:0])
								3'b000: 
									SR2 = Reg0;
								3'b001: 
									SR2 = Reg1;
								3'b010: 
									SR2 = Reg2;
								3'b011: 
									SR2 = Reg3;
								3'b100: 
									SR2 = Reg4;
								3'b101: 
									SR2 = Reg5;
								3'b110: 
									SR2 = Reg6;
								3'b111: 
									SR2 = Reg7;
							endcase
						end
endmodule
