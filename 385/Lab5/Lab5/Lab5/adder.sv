module adder
(
		input   logic[7:0]     A,
		input   logic[7:0]     B,
		input	  logic 		     cin,
		input   logic          Sub,
		output  logic[8:0]     S
);

 
	logic c0, c1,c2,c3,c4,c5,c6,c7, cout;

	logic [7:0] real_A;
	
	assign real_A = A ^ {8{Sub}};
	  
	full_adder FA0 (.x (real_A[0]), .y (B[0]), .z (0), .s (S[0]), .c (c0));
	
	full_adder FA1 (.x (real_A[1]), .y (B[1]), .z (c0), .s (S[1]), .c (c1));
	
	full_adder FA2 (.x (real_A[2]), .y (B[2]), .z (c1), .s (S[2]), .c (c2));
	
	full_adder FA3 (.x (real_A[3]), .y (B[3]), .z (c2), .s (S[3]), .c (c3));
	
	full_adder FA4 (.x (real_A[4]), .y (B[4]), .z (c3), .s (S[4]), .c (c4));
	
	full_adder FA5 (.x (real_A[5]), .y (B[5]), .z (c4), .s (S[5]), .c (c5));
	
	full_adder FA6 (.x (real_A[6]), .y (B[6]), .z (c5), .s (S[6]), .c (c6));
	
	full_adder FA7 (.x (real_A[7]), .y (B[7]), .z (c6), .s (S[7]), .c (c7));
	
	full_adder FA8 (.x (real_A[7]), .y (B[7]), .z (c7), .s (S[8]), .c (cout));
		
     
endmodule


module full_adder (input x, y, z,
	output s, c);
	
		assign s = x^y^z;
		assign c = (x&y)|(y&z)|(x&z);
		
endmodule
