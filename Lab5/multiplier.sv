// Top Level Code for 8-bit Multiplier

module multiplier (input logic  Clk,            // Internal
                                ClearA_LoadB,   // Push button 2
                                Execute,        // Push button 3
                  input  logic [7:0]  SW,
                  output logic  X,
                  output logic [7:0]  Aval,
                                      Bval,
                  output logic [15:0] sum,
                  output logic [6:0] HEX0, HEX1, HEX2, HEX3);

	 //local logic variables go here
	 logic ClearA_LoadB_SH, Execute_SH;
	 logic opA, opB, Shift_En, Add, Sub, Clr_Ld, Clear;
	 logic [7:0] A, B, SW_S;
   logic [8:0] result;


	 //We can use the "assign" statement to do simple combinational logic
	 assign M = opB;
	 assign Aval = A;
	 assign Bval = B;
	 assign sum = {A, B};

	 //Instantiation of the double register module
	register_unit    reg_unit (
                        .Clk(Clk),
                        .Reset_A(ClearA_LoadB_SH | Clear),
                        .Reset_B(ClearA_LoadB_SH),
                        .Ld_A(Add),
                        .Ld_B(Clr_Ld),
                        .Shift_En,
                        .D_A(result[7:0]),
                        .D_B(SW),
                        .A_In(X),
                        .B_In(opA),
                        .A_out(opA),
                        .B_out(opB),
                        .A(A),
                        .B(B) );

   sign_extend_adder    adder_unit(.Fn(Sub), .A , .B(SW), .s(result));

	control          control_unit (.Clk(Clk),
                                  .Reset(ClearA_LoadB_SH),
                                  .ClA_LdB(ClearA_LoadB_SH),
                                  .Execute(Execute_SH),
											 .M(M),

                                  .Shift_En,
                                  .Add,
                                  .Sub,
                                  .Clr_Ld,
                                  .Clear);

   xfp              x_Flip_Flop(.Clk(Clk),
                              .Load(Add),
                              .Clear(ClearA_LoadB_SH | Clear),
                              .D(result[8]),
                              .Q(X));

				HexDriver hex_3(
											.In0(sum[15:12]),
											.Out0(HEX3)
								);
									
									
				HexDriver hex_2(
											.In0(sum[11:8]),
											.Out0(HEX2)
								);		
									
				HexDriver hex_1(
											.In0(sum[7:4]),
											.Out0(HEX1)
								);
									
									
				HexDriver hex_0(
											.In0(sum[3:0]),
											.Out0(HEX0)
								);

	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[1:0] (Clk, {~ClearA_LoadB, ~Execute}, {ClearA_LoadB_SH, Execute_SH});
	  sync Din_sync[7:0] (Clk, SW);

endmodule
