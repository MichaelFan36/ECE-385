module IR(
				input logic 	[15:0] Instruction,
				input logic 	LD_IR, Clk, Reset,
				output logic	[15:0] IR);
				
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			IR <= 16'b0000000000000000;
		end
		if (LD_IR) begin
			IR <= Instruction;
		end
		else begin
			IR <= IR;
		end
		
	end

endmodule
	

