module sign_extend_adder (input Fn,
                          input [7:0] A,
                          input [7:0] B,
                          output[8:0] s
                         );
logic c0, c1, c2, c3, c4, c5, c6, c7;
logic [7:0] BB;
logic A8, BB8;
logic cout;


assign BB = (B^{8{Fn}});
assign A8 = A[7];
assign BB8 = BB[7];



full_adder FA0(.x(A[0]), .y(BB[0]), .cin(Fn), .s(s[0]), .cout(c0));
full_adder FA1(.x(A[1]), .y(BB[1]), .cin(c0), .s(s[1]), .cout(c1));
full_adder FA2(.x(A[2]), .y(BB[2]), .cin(c1), .s(s[2]), .cout(c2));
full_adder FA3(.x(A[3]), .y(BB[3]), .cin(c2), .s(s[3]), .cout(c3));
full_adder FA4(.x(A[4]), .y(BB[4]), .cin(c3), .s(s[4]), .cout(c4));
full_adder FA5(.x(A[5]), .y(BB[5]), .cin(c4), .s(s[5]), .cout(c5));
full_adder FA6(.x(A[6]), .y(BB[6]), .cin(c5), .s(s[6]), .cout(c6));
full_adder FA7(.x(A[7]), .y(BB[7]), .cin(c6), .s(s[7]), .cout(c7));
full_adder FA8(.x(A8),   .y(BB8),   .cin(c7), .s(s[8]), .cout(cout));

endmodule


module full_adder(
                      input x,
                      input y,
                      input cin,
                      output logic s,
                      output logic cout
                     );
   assign s = x ^ y ^ cin;
   assign cout = (x&y) | (y&cin) | (cin&x);

   endmodule
