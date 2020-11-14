module testbench();

timeunit 10ns;

timeprecision 1ns;
logic Clk = 0;
logic Reset, ClearA_LoadB, Execute;
logic X;
logic [7:0] SW;
logic [7:0] Aval,
		 				Bval;
logic [6:0] AhexL,
		  			AhexU,
		  			BhexL,
		  			BhexU;
logic [15:0] sum;

integer ErrorCnt = 0;




multiplier multiplier0(.*);


always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end


initial begin: TEST_VECTORS
Reset = 0;		// Toggle Rest
ClearA_LoadB = 1;
Execute = 1;
SW = 8'b11000101;

#2 Reset = 1;

#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;

#2 SW = 8'b00000111;

#2 Execute = 0;	// our first calculation -59*7

#40 Execute = 1; // togle Execute

if(Aval != 8'b11111110)
begin
ErrorCnt++;
$display("-59*7 Aval error ");
end
if(Bval != 8'b01100011)
begin
ErrorCnt++;
$display("-59*7 Bval error ");
end




#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 SW = 8'b11000101;
#2 Execute = 0;//our second calculation 7*-59
#40 Execute = 1; // togle Execute

if(Aval != 8'b11111110)
begin
ErrorCnt++;
$display("7*-59 Aval error ");
end
if(Bval != 8'b01100011)
begin
ErrorCnt++;
$display("7*-59 Bval error ");
end

#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 SW = 8'b11111001;

#2 Execute = 0;	//  our third calculation -59*-7
#40 Execute = 1; // togle Execute


if(Aval != 8'b00000001)
begin
ErrorCnt++;
$display("-59*-7 Aval error ");
end
if(Bval != 8'b10011101)
begin
ErrorCnt++;
$display("-59*-7 Bval error ");
end


#2 SW = 8'b00000111;

#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 SW = 8'b00111011;
#2 Execute = 0; // our fourth computation 7*59
#40 Execute =1;

if(Aval != 8'b00000001)
begin
ErrorCnt++;
$display("7*59 Aval error ");
end
if(Bval != 8'b10011101)
begin
ErrorCnt++;
$display("7*59 Bval error ");
end

if(ErrorCnt == 0)
$display("success!");

else
$display("%d errors(s) detected ", ErrorCnt);







end
endmodule
