module condition_code (
									input logic [15:0] Global_Bus,
									input logic			 LD_CC, Clk,
									
									output logic		 N, Z, P);
									
						logic MSB;
						assign MSB = Global_Bus[15];
						
						always_ff @ (posedge Clk) begin
							if (LD_CC) begin
								if (MSB) begin
									N <= 1'b1;
									Z <= 1'b0;
									P <= 1'b0;
								end
								
								else if (Global_Bus == 16'b0) begin
									N <= 1'b0;
									Z <= 1'b1;
									P <= 1'b0;
								end
								
								else begin
									N <= 1'b0;
									Z <= 1'b0;
									P <= 1'b1;
								end
							end
                     else begin
                        N <= N;
                        P <= P;
                        Z <= Z;
                     end
						end
endmodule
