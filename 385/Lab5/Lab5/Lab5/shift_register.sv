module register_unit (
						input  logic Clk, 
						input  logic clear_load, 
						input  logic Shift_En,
						input  logic clear_A,
						input  logic load_A,
						input  logic [7:0]  A_in,
						input  logic [7:0]  B_in,
						input  logic X, 
						output logic M,
						output logic [15:0]  AB_out);

	logic A_out_bit, B_out;

   shift_register  reg_A (.Clk(Clk), .Reset(clear_A | clear_load), .Load(load_A), .Shift_in(X), .Shift_enable(Shift_En), .Data_In(A_in[7:0]), .Shift_out(A_out_bit), .Data_Out(AB_out[15:8]));
	 
   shift_register  reg_B (.Clk(Clk), .Reset(1'b0), .Load(clear_load), .Shift_in(A_out_bit), .Shift_enable(Shift_En), .Data_In(B_in[7:0]), .Shift_out(B_out), .Data_Out(AB_out[7:0]));

	assign M = AB_out[0];

endmodule



module shift_register (
						input Clk, 
						input Reset, 
						input Load, 
						input Shift_in, 
						input Shift_enable,
						input  [7:0]  Data_In,
						
						output Shift_out,
						output [7:0]  Data_Out
					);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) 
			  Data_Out <= 8'h0;  
		 else if (Load)
			  Data_Out <= Data_In;
		 else if (Shift_enable)
		 begin
			  Data_Out <= { Shift_in, Data_Out[7:1] };
	    end
    end

    assign Shift_out = Data_Out[0];

endmodule
