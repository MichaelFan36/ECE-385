module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

logic p4,p8,p12,p16,g4,g8,g12,g16,p,g,c0,c4,c8,c12;
	  four_bit_CLA cla0 (.x(A[3:0]), .y(B[3:0]), .g_1(0), .p(p4), .g(g4));
	  four_bit_CLA cla1 (.x(A[7:4]), .y(B[7:4]), .g_1(0), .p(p8), .g(g8));
	  four_bit_CLA cla2 (.x(A[11:8]), .y(B[11:8]), .g_1(0), .p(p12), .g(g12));
	  four_bit_CLA cla3 (.x(A[15:12]), .y(B[15:12]), .g_1(0), .p(p16), .g(g16));
	 
	  four_bit_CLU cal_c(.p0(p4), .p1(p8), .p2(p12), .p3(p16), .g0(g4), .g1(g8), .g2(g12), .g3(g16), .cin(0), .c0(c0), .c1(c4), .c2(c8), .c3(c12), .Pg(p), .Gg(g));
	  
	  four_bit_CLA cla4 (.x(A[3:0]), .y(B[3:0]), .g_1(0), .s(S[3:0]));
	  four_bit_CLA cla5 (.x(A[7:4]), .y(B[7:4]), .g_1(c4), .s(S[7:4]));
	  four_bit_CLA cla6 (.x(A[11:8]), .y(B[11:8]), .g_1(c8), .s(S[11:8]));
	  four_bit_CLA cla7 (.x(A[15:12]), .y(B[15:12]), .g_1(c12), .s(S[15:12]));
	 
	  assign cout = (cin&p4&p8&p12&p16) | (g4&p8&p12&p16) | (g8&p12&p16) | (g12&p16) | g16; 
	  
endmodule

module four_bit_CLA(
							input  [3:0] x,
							input  [3:0] y,
							input  g_1,
							output [3:0] s,
							output p,
							output g
);
	  logic p0,p1,p2,p3,g0,g1,g2,g3,c0,c1,c2,c3;
	  assign p0 = x[0]^y[0];
	  assign g0 = x[0]&y[0];
	  assign p1 = x[1]^y[1];
	  assign g1 = x[1]&y[1];
	  assign p2 = x[2]^y[2];
	  assign g2 = x[2]&y[2];
	  assign p3 = x[3]^y[3];
	  assign g3 = x[3]&y[3];
	  
	  four_bit_CLU cal_c(.p0(p0), .p1(p1), .p2(p2), .p3(p3), .g0(g0), .g1(g1), .g2(g2), .g3(g3), .cin(g_1), .c0(c0), .c1(c1), .c2(c2), .c3(c3), .Pg(p), .Gg(g));
	  
	  assign s[0] = x[0]^y[0]^c0;
	  assign s[1] = x[1]^y[1]^c1;
	  assign s[2] = x[2]^y[2]^c2;
	  assign s[3] = x[3]^y[3]^c3;

endmodule

module four_bit_CLU(
							input p0,
							input p1,
							input p2,
							input p3,
							input g0,
							input g1,
							input g2,
							input g3,
							input cin,
							output c0,
							output c1,
							output c2,
							output c3,
							output Pg,
							output Gg
);

	assign c0 = cin;
	assign c1 = (cin & p0) | g0;
	assign c2 = (cin & p0 & p1) | (g0 & p1) | g1;
	assign c3 = (cin & p0 & p1 & p2) | (g0 & p1 & p2) | (g1 & p2) | g2;
	assign Pg = p0&p1&p2&p3; 
	assign Gg = g3|g2&p3|g1&p3&p2|g0&p3&p2&p1;

endmodule

