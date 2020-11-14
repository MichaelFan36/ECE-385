// top level
module multiplier (
					input logic Clk, 
					input logic Reset_Load_Clear_button, 
					input logic Run_button,
					input logic [7:0] switch,
					output logic [6:0] HEX0, HEX1, HEX2, HEX3,
					output logic [7:0] Aval, Bval,
					output logic Xval
					);


					logic Run, M, Shift_enable, Add, Sub, X, ClearA_LoadB, clear_X_en, clear_A_en, Clear_Load; 
					logic [16:0] AB;
					logic [8:0]  adder_out;
							
					assign Aval = AB[15:8];	
					assign Bval = AB[7:0];
					assign Xval = X;
							
						 
				register_unit storing_unit(
											.Clk(Clk), 
											.clear_load(ClearA_LoadB),
											.Shift_En(Shift_enable),
											.clear_A(clear_A_en),
											.load_A(Add | Sub),
											.A_in(adder_out[7:0]),
											.B_in(switch),
											.X(X),

											.M(M),
											.AB_out(AB)
										);		 
						 
				
				control control_unit(
											.Clk(Clk),  
											.ClearA_LoadB(ClearA_LoadB), 
											.Run(Run), 
											.M(M),
											
											.Shift_enable(Shift_enable), 
											.Add(Add), 
											.Sub(Sub), 
											.Clear_Load(Clear_Load),
											.clear_X(clear_X_en), 
											.clear_A(clear_A_en) 
									);	
							 
												 
				adder adding_unit(
											.A(switch[7:0]),
											.B(AB[15:8]),
											.cin(1'b0),
											.Sub(Sub),

											.S(adder_out[8:0])
								);
										
										
			   flip_flop x_flip_flop(
											.Clk(Clk),
											.D(adder_out[8]),
											.load(Add | Sub),
											.reset(ClearA_LoadB | clear_X_en),

											.Q(X)
											);
										
										

													
				HexDriver hex_3(
											.In0(AB[15:12]),
											.Out0(HEX3)
								);
									
									
				HexDriver hex_2(
											.In0(AB[11:8]),
											.Out0(HEX2)
								);		
									
				HexDriver hex_1(
											.In0(AB[7:4]),
											.Out0(HEX1)
								);
									
									
				HexDriver hex_0(
											.In0(AB[3:0]),
											.Out0(HEX0)
								);
				sync button_sync[1:0] (Clk, {~Reset_Load_Clear_button, ~Run_button}, {ClearA_LoadB, Run});
				sync Din_sync[7:0] (Clk, switch);
																							 
							 
endmodule

						 