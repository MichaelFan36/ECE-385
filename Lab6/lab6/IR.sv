module IR(
                input logic  Clk,
                input logic  Reset,
				input logic  [15:0] In,
				input logic  LD_IR,
				output logic [15:0] IR
        );
				
	always_ff @ (posedge Clk) begin
		if (Reset) 
			IR <= 16'd0;

		if (LD_IR) 
			IR <= In;
		
		else 
			IR <= IR;

	end

endmodule
	

