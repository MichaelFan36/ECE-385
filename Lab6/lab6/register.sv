module register(
						input logic Clk,
						input logic Reset,
						input logic [15:0]In,
						output logic [15:0]Out
					);

					
always_ff @(posedge Clk) begin
    if (Reset)
        Out <= 16'b0;
    else
        Out <= In;
end

					
					
endmodule
