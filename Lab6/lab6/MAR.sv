module MAR(
                input logic  Clk,
                input logic  Reset,
				input logic  [15:0] In,
				input logic  LD_MAR,

				output logic [15:0] MAR
				);
				
	always_ff @ (posedge Clk) begin
		if (Reset) 
			MAR <= 16'd0;
		if (LD_MAR) 
			MAR <= In;
		
	end
	
endmodule
