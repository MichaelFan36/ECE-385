module ALU(
				input logic [15:0] Input_A, 
                input logic [15:0] Input_B,
				input logic [1:0] ALUK,
				output logic [15:0] ALU_out
			);
							
	always_comb
	begin
		case (ALUK)
			2'b00: 
                ALU_out = Input_A + Input_B;
			2'b01: 
                ALU_out = Input_A & Input_B;
			2'b10: 
                ALU_out = ~Input_A;
			2'b11: 
                ALU_out = Input_A;
		endcase
	end
endmodule
