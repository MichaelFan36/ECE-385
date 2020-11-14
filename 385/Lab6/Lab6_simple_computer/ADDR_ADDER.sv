module ADDR_ADDER (
							input logic [15:0] ADDR1, ADDR2,
							output logic [15:0] ADDR);
							
							always_comb
							begin
								ADDR = ADDR1 + ADDR2;
							end
endmodule