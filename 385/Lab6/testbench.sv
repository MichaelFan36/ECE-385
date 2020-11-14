module testbench();

timeunit 10ns;

timeprecision 1ns;

logic Clk;

logic [9:0] SW;

logic Run, Continue;

logic [9:0] LED;

logic [6:0] HEX0, HEX1, HEX2, HEX3;

logic [15:0] sram;


slc3_testtop tp(.*);
	

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
Run = 1'b1; 
Continue = 1'b1;
SW = 10'd1;

#2 Run = 0;
#2 Continue = 0;
#20 Run = 1;
#20 Continue = 1;

#2 Run = 0;//triger Run
#2 Run = 1;

#20 Continue = 1'b0;
#2 Continue = 1'b1;

#20 Continue = 1'b0;
#2 Continue = 1'b1;

#20 Continue = 1'b0;
#2 Continue = 1'b1;

end
endmodule
