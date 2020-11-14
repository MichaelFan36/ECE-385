module MDR (
                input logic Clk, 
                input logic Reset, 
                input logic [15:0] Data_to_CPU,
				input logic [15:0] In,
				input logic LD_MDR, 
                input logic MIO_EN, 

				output logic [15:0] MDR
				);
				
				always_ff @ (posedge Clk)
				begin
				
					if (Reset) 
						MDR <= 16'd0;
					
					if (LD_MDR) begin
						if (MIO_EN) 
							MDR <= Data_to_CPU;
						else 
							MDR <= In;
					end
					else 
						MDR <= MDR;
                        
					
				end
				
endmodule
