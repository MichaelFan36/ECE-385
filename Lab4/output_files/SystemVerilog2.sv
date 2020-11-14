module ripple_adder (input [15:0] A, B,
	input c_in,
	output [15:0] S,	
	output c_out);
	// Internal carries in the 2-bit adder
		logic c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15;
		full_adder CA0 (.x (A[0]), .y (B[0]), .z (c_in), .s (S[0]), .c (c1));
		
		full_adder CA1 (.x (A[1]), .y (B[1]), .z (c1), .s (S[1]), .c (c2));
		
		full_adder CA2 (.x (A[2]), .y (B[2]), .z (c2), .s (S[2]), .c (c3));
		
		full_adder CA3 (.x (A[3]), .y (B[3]), .z (c3), .s (S[3]), .c (c4));
		
		full_adder CA4 (.x (A[4]), .y (B[4]), .z (c4), .s (S[4]), .c (c5));
		
		full_adder CA5 (.x (A[5]), .y (B[5]), .z (c5), .s (S[5]), .c (c6));
		
		full_adder CA6 (.x (A[6]), .y (B[6]), .z (c6), .s (S[6]), .c (c7));
		
		full_adder CA7 (.x (A[7]), .y (B[7]), .z (c7), .s (S[7]), .c (c8));
		
		full_adder CA8 (.x (A[8]), .y (B[8]), .z (c8), .s (S[8]), .c (c9));
		
		full_adder CA9 (.x (A[9]), .y (B[9]), .z (c9), .s (S[9]), .c (c10));
		
		full_adder CA10 (.x (A[10]), .y (B[10]), .z (c10), .s (S[10]), .c (c11));
		
		full_adder CA11 (.x (A[11]), .y (B[11]), .z (c11), .s (S[11]), .c (c12));
		
		full_adder CA12 (.x (A[12]), .y (B[12]), .z (c12), .s (S[12]), .c (c13));
		
		full_adder CA13 (.x (A[13]), .y (B[13]), .z (c13), .s (S[13]), .c (c14));
		
		full_adder CA14 (.x (A[14]), .y (B[14]), .z (c14), .s (S[14]), .c (c15));
		
		full_adder CA15 (.x (A[15]), .y (B[15]), .z (c15), .s (S[15]), .c (c_out));
endmodule