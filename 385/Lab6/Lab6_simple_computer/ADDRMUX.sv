module ADDRMUX (
						input logic [15:0] PC_out, SR1_out,
						input logic ADDR1MUX_sel, 
						input logic [1:0] ADDR2MUX_sel,
						input [15:0] IR,
						
						output logic [15:0] ADDR);
						
						
		logic [15:0] offset6, offset9, offset11;
		assign offset11 = {{5{IR[10]}}, IR[10:0]};
		assign offset9 = {{7{IR[8]}}, IR[8:0]};
		assign offset6 = {{10{IR[5]}}, IR[5:0]};					
		
		logic [15:0] ADDR1MUX_out, ADDR2MUX_out;

		// ADDR1MUX					
		always_comb
		begin
			if (ADDR1MUX_sel) begin
				ADDR1MUX_out = SR1_out;
			end
			
			else begin
				ADDR1MUX_out = PC_out;
			end
		end
		
		
		// ADDR2MUX			
		always_comb
		begin
			case (ADDR2MUX_sel)
				2'b00: ADDR2MUX_out = 4'h0;
				2'b01: ADDR2MUX_out = offset6;
				2'b10: ADDR2MUX_out = offset9;
				2'b11: ADDR2MUX_out = offset11;
			endcase
		end
		
		// ADDR_ADDER
		always_comb
		begin
			ADDR = ADDR1MUX_out + ADDR2MUX_out;
		end
		
endmodule
		