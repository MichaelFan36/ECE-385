module MDR (input logic [15:0] Data_to_CPU,
				input logic [15:0] Global_Bus,
				input logic LD_MDR, MIO_EN, Clk, Reset, 
				output logic [15:0] Data_out
				);
				
//				logic [15:0] internal_data;
				
				always_ff @ (posedge Clk)
				begin
				
					if (Reset) begin
						Data_out <= 16'b0000000000000000;
					end
				
					
					if (LD_MDR) begin
						if (MIO_EN) begin
							Data_out <= Data_to_CPU;
						end
						
						else begin
							Data_out <= Global_Bus;
						end
					end
					
					else begin
						Data_out <= Data_out;
					end
				end
				
endmodule
