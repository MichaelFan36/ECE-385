module testbench();

timeunit 10ns;

timeprecision 1ns;

	 logic       Clk;       		// 100MHz clock is only used to get timing estimate data
    logic       Reset;     		// From push-button 0.  Remember the button is active low (0 when pressed)
    logic       Continue;			// From push-button 2
    logic       Run;       		// From push-button 3.
    logic [15:0] S;        			// From slider switches
    
    // all outputs are registered
	 logic [6:0] HEX0;
	 logic [6:0] HEX1;
	 logic [6:0] HEX2;
	 logic [6:0] HEX3;
	 logic [6:0] HEX4;
	 logic [6:0] HEX5;
	 logic [6:0] HEX6;
	 logic [6:0] HEX7;
	 logic [11:0] LED;
	 
	 logic [19:0] ADDR;	 
	 logic CE;
	 logic UB;
	 logic LB;
	 logic OE;
	 logic WE;
    wire  [15:0] Data;
	 
	 logic [15:0] MAR, MDR, IR, PC;
	 logic [3:0] hex3, hex2, hex1, hex0;

	 logic [1:0] PCMUX;
	 
	 lab6_toplevel tp(.*);
	 
	 always begin : CLOCK_GENERATION
	 
	 #1 Clk = ~Clk;
	 
	 end

	 initial begin : CLOCK_INITIAL
			Clk = 0;
	 end
	 

	 
	 initial begin : TEST_VECTORS
	 
	 Reset = 1;
	 Continue = 1;
	 Run = 1;
	 
	 //test case1
	 #2 Reset = 0;
	 #2 Reset = 1;
	 
	 #2 S = 16'h0003; // XOR
	 
	 #2 Run = 0;
	 #2 Run = 1;
	
//	 #70;
//	 #2 S = 16'haaaa;
//	 #2 Continue = 0;
//	 #2 Continue = 1;
//	 #35;
//	 #2 S = 16'h0f0f;
//	 #2 Continue = 0;
//	 #2 Continue = 1;
//	 #170;
//	 #2 Continue = 0;
//	 #2 Continue = 1;
	 
//	 #100;
//	 #2 S = 16'b0000000001110100;
//	 #2 Continue = 0;
//	 #2 Continue = 1;
//	 
//	 #100;
//	 #2 Continue = 0;
//	 #100;
//	 #2 Continue = 1;


	 
	 
//	 #20 Continue = 0;
//	 #2 Continue = 1;
//	 
//	 #20 Continue = 0;
//	 #2 Continue = 1;
//	 
//	 #20 Continue = 0;
//	 #2 Continue = 1;
//	 
//	 #20 Continue = 0;
//	 #2 Continue = 1;
//	 
//	 #20 Continue = 0;
//	 #2 Continue = 1;
//	 
//	 #20 Continue = 0;
//	 #2 Continue = 1;
//	 
//	 #20 Continue = 0;
//	 #2 Continue = 1;
	 


	 end
	 
	 always_comb 
		begin
			MAR 	= tp.my_slc.MAR;
			MDR 	= tp.my_slc.MDR;
			PC 	= tp.my_slc.PC;
			IR 	= tp.my_slc.IR;
			PCMUX = tp.my_slc.PCMUX;
			hex3  = tp.my_slc.hex_4[3];
			hex2	= tp.my_slc.hex_4[2];
			hex1	= tp.my_slc.hex_4[1];
			hex0	= tp.my_slc.hex_4[0];
			
			
			
		end
endmodule
	 