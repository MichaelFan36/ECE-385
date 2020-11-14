module testbench();

timeunit 10ns;

timeprecision 1ns;

logic Clk;
logic Reset_Clear;
logic Run_Accumulate;
logic [9:0] SW;
logic [9:0] LED;
logic CO; 
logic [6:0] HEX0; 
logic [6:0] HEX1;
logic [6:0] HEX2;
logic [6:0] HEX3; 
logic [6:0] HEX4;
logic [6:0] HEX5;
										 
										 
										 
										 
always begin : CLOCK_GENERATION

#1 Clk = ~Clk;

end


initial begin : CLK_INITIALIZATION

Clk = 0;

end



adder2 tp(
.Clk(Clk),
.Reset_Clear(Reset_Clear),
.Run_Accumulate(Run_Accumulate),
.SW(SW[9:0]),
.LED(LED[9:0]),
.CO(CO),
.HEX0(HEX0[6:0]), 
.HEX1(HEX1[6:0]), 
.HEX2(HEX2[6:0]), 
.HEX3(HEX3[6:0]), 
.HEX4(HEX4[6:0]), 
.HEX5(HEX5[6:0])
);

initial begin: TEST_VECTORS

Reset_Clear = 0;
Run_Accumulate = 1;


//test case1

#2 Reset_Clear = 0;
	SW = 10'b0000000001;
	
#2 Reset_Clear = 1;
	SW = 10'b0000000010;
	
#2 Run_Accumulate = 0;

#2 Run_Accumulate = 1;

#2 Run_Accumulate = 0;

#20;

end

endmodule





