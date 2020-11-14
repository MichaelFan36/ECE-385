module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */ 
	  
	  logic c4,c8,c12;
	  
	  four_bit_adder ss0(.x(A[3:0]), .y(B[3:0]), .cin(cin), .s(S[3:0]), .cout(c4));
	  select_strcut ss1(.x(A[7:4]), .y(B[7:4]), .cin(c4), .s(S[7:4]), .cout(c8));
	  select_strcut ss2(.x(A[11:8]), .y(B[11:8]), .cin(c8), .s(S[11:8]), .cout(c12));
	  select_strcut ss3(.x(A[15:12]), .y(B[15:12]), .cin(c12), .s(S[15:12]), .cout(cout));

endmodule

module select_strcut(
							input  [3:0]x,
							input  [3:0]y,
							input 	 cin, 
							output logic [3:0]s,
							output 	cout

);

	logic [3:0] s_for_0;
	logic [3:0] s_for_1;
	logic cout_for_0;
	logic cout_for_1;

	four_bit_adder for_0(.x(x[3:0]), .y(y[3:0]), .cin(0), .s(s_for_0[3:0]), .cout(cout_for_0));
	four_bit_adder for_1(.x(x[3:0]), .y(y[3:0]), .cin(1), .s(s_for_1[3:0]), .cout(cout_for_1));

	always_comb
	begin
		if (cin == 1'b0)
			begin
				 s[0] = s_for_0[0];
				 s[1] = s_for_0[1];
				 s[2] = s_for_0[2];
				 s[3] = s_for_0[3];
			end
		else
			begin
				 s[0] = s_for_1[0];
				 s[1] = s_for_1[1];
				 s[2] = s_for_1[2];
				 s[3] = s_for_1[3]; 
			end
	end
		
	assign cout = (cin & cout_for_1) | cout_for_0;

 
endmodule



module four_bit_adder(	
								input [3:0]x,
								input [3:0]y,
								input 	cin,
								output [3:0]s,
								output 	cout
);

	logic c0,c1,c2;
	select_FA fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .c(c0));
	select_FA fa1(.x(x[1]), .y(y[1]), .cin(c0), .s(s[1]), .c(c1));
	select_FA fa2(.x(x[2]), .y(y[2]), .cin(c1), .s(s[2]), .c(c2));
	select_FA fa3(.x(x[3]), .y(y[3]), .cin(c2), .s(s[3]), .c(cout));


endmodule


module select_FA(
	input x, y, cin,
	output s, c);
	
		assign s = x^y^cin;
		assign c = (x&y)|(y&cin)|(x&cin);
		
endmodule