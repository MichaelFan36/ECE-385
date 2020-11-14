module testbench();

timeunit 10ns;

timeprecision 1ns;

logic Clk;

logic [9:0] SW;

logic Run, Continue;

logic [9:0] LED;

logic [6:0] HEX0, HEX1, HEX2, HEX3;

logic [6:0] HEX0_, HEX1_, HEX2_, HEX3_;

integer ErrorCnt = 0;



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
SW = 10'b000000000;

#2 Run = 0;
#2 Continue = 0;
#20 Run = 1;
#20 Continue = 1;

SW = 10'b0001011010;
	HEX0_ = 7'b1111001;
	HEX1_ = 7'b1000000;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //01
	
#2 Run = 0;//triger Run
#2 Run = 1;

#1000 SW = 10'b0000000010;

#2 Continue = 1'b0;

#2 Continue = 1'b1;

#30000 SW = 10'b0000000011;
 
#2 Continue = 1'b0;
#2 Continue = 1'b1;//start displaying

#600 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#200 Continue = 1'b0;
#2 Continue = 1'b1;//1
	HEX0_ = 7'b0110000;
	HEX1_ = 7'b1000000;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //03

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//2
	HEX0_ = 7'b1111000;
	HEX1_ = 7'b1000000;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //07

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//3
	HEX0_ = 7'b0100001;
	HEX1_ = 7'b1000000;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //0d

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//4
	HEX0_ = 7'b0000011;
	HEX1_ = 7'b1111001;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //1b

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//5
	HEX0_ = 7'b0001110;
	HEX1_ = 7'b1111001;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //1f

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//6
	HEX0_ = 7'b0000010;
	HEX1_ = 7'b0011001;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //46

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//7
	HEX0_ = 7'b1111000;
	HEX1_ = 7'b0011001; 
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //47

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//8
	HEX0_ = 7'b0000110;
	HEX1_ = 7'b0011001;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //4e

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//9
	HEX0_ = 7'b0000011;
	HEX1_ = 7'b0000010;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //6b

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//10
	HEX0_ = 7'b1000110;
	HEX1_ = 7'b0000000;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //8c

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//11
	HEX0_ = 7'b0000000;
	HEX1_ = 7'b0000011;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //b8

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//12
	HEX0_ = 7'b0000011;
	HEX1_ = 7'b0100001;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //db

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//13
	HEX0_ = 7'b0001110;
	HEX1_ = 7'b0000110;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //ef

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//14
	HEX0_ = 7'b0000000;
	HEX1_ = 7'b0001110;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //f8

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//15
	HEX0_ = 7'b0001000;
	HEX1_ = 7'b0001110;
	HEX2_ = 7'b1000000;
	HEX3_ = 7'b1000000; //fa

#300 if(HEX0_ != HEX0 | HEX1_ != HEX1 | HEX2_ != HEX2 | HEX3_ != HEX3)
			ErrorCnt++;
#2 Continue = 1'b0;
#2 Continue = 1'b1;//16

if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected.", ErrorCnt);
end
endmodule
