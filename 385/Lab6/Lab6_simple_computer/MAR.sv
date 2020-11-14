module MAR(
				input logic  [15:0] Din,
				input logic  LD_MAR, Clk, Reset,
				output logic [15:0] Dout
				);
				
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			Dout <= 16'b0;
		end
		if (LD_MAR) begin
			Dout[15:0] <= Din[15:0];
		end
	end
	
endmodule
