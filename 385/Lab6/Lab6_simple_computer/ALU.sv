module ALU(
				input logic [15:0] ALU_A, ALU_B,
				input logic [1:0] ALUK,
				output logic [15:0] ALU_val
				);
							
	always_comb
	begin
		case (ALUK)
			2'b00: ALU_val = ALU_A + ALU_B;
			2'b01: ALU_val = ALU_A & ALU_B;
			2'b10: ALU_val = ~ALU_A;
			2'b11: ALU_val = ALU_A;
		endcase
	end
endmodule
