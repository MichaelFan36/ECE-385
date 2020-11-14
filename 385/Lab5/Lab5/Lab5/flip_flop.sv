module flip_flop(
						input logic Clk,
						input logic D,
						input logic load,
						input logic reset,
						output logic Q
);

	logic out;
	always_ff @ (posedge Clk)
	begin
		Q = out;
	end

	always_comb begin
		if(reset)
			out = 1'b0;
		else if(load)
			out = D;
		else
			out = Q;
	end 

				


endmodule
