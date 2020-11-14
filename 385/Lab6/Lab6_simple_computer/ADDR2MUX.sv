module ADDR2MUX (
							input [15:0] IR,
							input logic [1:0] ADDR2MUX,
							output logic [15:0] ADDR2MUX_out);
							
							logic [15:0] offset6, offset9, offset11;
							assign offset11 = {{5{IR[10]}}, IR[10:0]};
							assign offset9 = {{7{IR[8]}}, IR[8:0]};
							assign offset6 = {{10{IR[5]}}, IR[5:0]};
							
							always_comb
							begin
								case (ADDR2MUX)
									2'b00: ADDR2MUX_out = 4'h0;
									2'b01: ADDR2MUX_out = offset6;
									2'b10: ADDR2MUX_out = offset9;
									2'b11: ADDR2MUX_out = offset11;
								endcase
							end
endmodule
							