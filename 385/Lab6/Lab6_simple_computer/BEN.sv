module BEN (
						input logic Din, 
						input logic LD_BEN, Clk, 
						
						output logic BEN_out);
						
						
				always_ff @ (posedge Clk) begin
					if (LD_BEN) begin
						BEN_out <= Din;
					end
					
					else begin
						BEN_out <= BEN_out;
					end
				end
				
endmodule
