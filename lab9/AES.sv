module AddRoundKey(
					input logic[127:0] State, 
					input logic[1407:0] KeySchedule, 
					input logic[3:0] loop_num, 
					output logic[127:0] ark_out
				);

always_comb


begin
	unique case (loop_num)
		4'b0000: 
			ark_out = State ^ KeySchedule[127:0];
		4'b0001: 
			ark_out = State ^ KeySchedule[255:128];
		4'b0010: 
			ark_out = State ^ KeySchedule[383:256];
		4'b0011: 
			ark_out = State ^ KeySchedule[511:384];
		4'b0100: 
			ark_out = State ^ KeySchedule[639:512];
		4'b0101: 
			ark_out = State ^ KeySchedule[767:640];
		4'b0110: 
			ark_out = State ^ KeySchedule[895:768];
		4'b0111: 
			ark_out = State ^ KeySchedule[1023:896];
		4'b1000: 
			ark_out = State ^ KeySchedule[1151:1024];
		4'b1001: 
			ark_out = State ^ KeySchedule[1279:1152];
		4'b1010: 
			ark_out = State ^ KeySchedule[1407:1280];
	endcase
end

endmodule

module InvSubAll(
				input logic CLK,
				input  logic [127:0] State,
				output logic [127:0] OUT
);

	InvSubBytes isb1(.clk(CLK), .in(State[7:0]), .out(OUT[7:0])); 
	InvSubBytes isb2(.clk(CLK), .in(State[15:8]), .out(OUT[15:8])); 
	InvSubBytes isb3(.clk(CLK), .in(State[23:16]), .out(OUT[23:16])); 
	InvSubBytes isb4(.clk(CLK), .in(State[31:24]), .out(OUT[31:24])); 
	InvSubBytes isb5(.clk(CLK), .in(State[39:32]), .out(OUT[39:32])); 
	InvSubBytes isb6(.clk(CLK), .in(State[47:40]), .out(OUT[47:40])); 
	InvSubBytes isb7(.clk(CLK), .in(State[55:48]), .out(OUT[55:48])); 
	InvSubBytes isb8(.clk(CLK), .in(State[63:56]), .out(OUT[63:56])); 
	InvSubBytes isb9(.clk(CLK), .in(State[71:64]), .out(OUT[71:64])); 
	InvSubBytes isb10(.clk(CLK), .in(State[79:72]), .out(OUT[79:72])); 
	InvSubBytes isb11(.clk(CLK), .in(State[87:80]), .out(OUT[87:80])); 
	InvSubBytes isb12(.clk(CLK), .in(State[95:88]), .out(OUT[95:88])); 
	InvSubBytes isb13(.clk(CLK), .in(State[103:96]), .out(OUT[103:96])); 
	InvSubBytes isb14(.clk(CLK), .in(State[111:104]), .out(OUT[111:104])); 
	InvSubBytes isb15(.clk(CLK), .in(State[119:112]), .out(OUT[119:112])); 
	InvSubBytes isb16(.clk(CLK), .in(State[127:120]), .out(OUT[127:120])); 

endmodule


module decript_states(
					input logic CLK,RESET,
					input logic AES_START,
					input logic [1407:0] KeySchedule, 
					output logic [3:0] cur_state, 
					output logic [3:0] loop_num,
					output logic [1:0] col_num,
					output logic AES_DONE
				);

enum logic [7:0] {
	    
		start,real_start,finish,

		ARK0,ARK1,ARK2,ARK3,ARK4,ARK5,ARK6,ARK7,ARK8,ARK9,ARK10,

		IS1,IS2,IS3,IS4,IS5,IS6,IS7,IS8,IS9,IS10,

		ISub1,ISub2,ISub3,ISub4,ISub5,ISub6,ISub7,ISub8,ISub9,ISub10,
		
		IC1,IC2,IC3,IC4,IC5,IC6,IC7,IC8,IC9,IC10,IC11,IC12,IC13,IC14,IC15,IC16,IC17,IC18,IC19,IC20,IC21,IC22,IC23,IC24,IC25,IC26,IC27,IC28,IC29,IC30,IC31,IC32,IC33,IC34,IC35,IC36
		
		} state, next_state;

	always_ff @(posedge CLK ) 
	begin 
		if (RESET) 	
			state<= start;
	 	else 
			state <= next_state;
		
	end

	always_comb
	begin

		next_state = state;
		case (state)
			start:
			begin
			if (AES_START)
				next_state = real_start;
			else 
				next_state = start;
			end 

		real_start:
			next_state = ARK0;
		
		ARK0: next_state = IS1; 
		IS1: next_state = ISub1;
		ISub1: next_state = ARK1;
		ARK1: next_state = IC1;
		IC1: next_state = IC2;
		IC2: next_state = IC3;
		IC3: next_state = IC4;
		IC4: next_state = IS2;
		IS2: next_state = ISub2;
		ISub2: next_state = ARK2;
		ARK2: next_state = IC5;
		IC5: next_state = IC6;
		IC6: next_state = IC7;
		IC7: next_state = IC8;
		IC8: next_state = IS3;
		IS3: next_state = ISub3;
		ISub3: next_state = ARK3;
		ARK3: next_state = IC9;
		IC9: next_state = IC10;
		IC10: next_state = IC11;
		IC11: next_state = IC12;
		IC12: next_state = IS4;
		IS4: next_state = ISub4;
		ISub4: next_state = ARK4;
		ARK4: next_state = IC13;
		IC13: next_state = IC14;
		IC14: next_state = IC15;
		IC15: next_state = IC16;
		IC16: next_state = IS5;
		IS5: next_state = ISub5;
		ISub5: next_state = ARK5;
		ARK5: next_state = IC17;
		IC17: next_state = IC18;
		IC18: next_state = IC19;
		IC19: next_state = IC20;
		IC20: next_state = IS6;
		IS6: next_state = ISub6;
		ISub6: next_state = ARK6;
		ARK6: next_state = IC21;
		IC21: next_state = IC22;
		IC22: next_state = IC23;
		IC23: next_state = IC24;
		IC24: next_state = IS7;
		IS7: next_state = ISub7;
		ISub7: next_state = ARK7;
		ARK7: next_state = IC25;
		IC25: next_state = IC26;
		IC26: next_state = IC27;
		IC27: next_state = IC28;
		IC28: next_state = IS8;
		IS8: next_state = ISub8;
		ISub8: next_state = ARK8;
		ARK8: next_state = IC29;
		IC29: next_state = IC30;
		IC30: next_state = IC31;
		IC31: next_state = IC32;
		IC32: next_state = IS9;
		IS9: next_state = ISub9;
		ISub9: next_state = ARK9;
		ARK9: next_state = IC33;
		IC33: next_state = IC34;
		IC34: next_state = IC35;
		IC35: next_state = IC36;
		IC36: next_state = IS10;
		IS10: next_state = ISub10;
		ISub10: next_state = ARK10;
		ARK10: next_state = finish;

		finish:
		if(AES_START)
			next_state = finish;
		else
			next_state = start;


	endcase 

end



always_comb
begin
	AES_DONE = 1'b0;
	
	case(state)
	
	start:
	begin
		cur_state = 4'b1111;
		loop_num = 4'b1111;
		col_num = 2'd4;
	end
	
	real_start:
	begin
		cur_state = 4'b1001;
		loop_num = 4'b1111;
		col_num = 2'd4;
	end

	finish:
	begin
		AES_DONE = 1'b1;
		cur_state = 4'b0000;
		loop_num = 4'b1111;
		col_num = 2'd4;
	end


	ARK0:
	begin
		cur_state = 4'b1000;
		loop_num = 4'd0;
		col_num = 2'd4;
	end

	ARK1:
	begin
		cur_state = 4'b1000;
		loop_num = 4'd1;
		col_num = 2'd4;
	end

	ARK2:
	begin
		cur_state = 4'b1000;
		loop_num = 4'd2;
		col_num = 2'd4;
	end

	ARK3:
	begin
		cur_state = 4'b1000;
		loop_num = 4'd3;
		col_num = 2'd4;
	end

	ARK4:
	begin
		cur_state = 4'b1000;
		loop_num = 4'd4;
		col_num = 2'd4;
	end

	ARK5:
	begin	
		cur_state = 4'b1000;
		loop_num = 4'd5;
		col_num = 2'd4;
	end

	ARK6:
	begin
		cur_state = 4'b1000;
		loop_num = 4'd6;
		col_num = 2'd4;
	end

	ARK7:
	begin	
		cur_state = 4'b1000;
		loop_num = 4'd7;
		col_num = 2'd4;
	end
	ARK8:
	begin
		cur_state = 4'b1000;
		loop_num = 4'd8;
		col_num = 2'd4;
	end

	ARK9:
	begin
		cur_state = 4'b1000;
		loop_num = 4'd9;
		col_num = 2'd4;
	end

	ARK10:
	begin
		cur_state = 4'b1000;	
		loop_num = 4'd10;
		col_num = 2'd4;
	end


	ISub1:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd1;
		col_num = 2'd4;
		end
		
	ISub2:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd2;
		col_num = 2'd4;
		end
		
	ISub3:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd3;
		col_num = 2'd4;
		end
		
	ISub4:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd4;
		col_num = 2'd4;
		end
		
	ISub5:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd5;
		col_num = 2'd4;
		end

		
	ISub6:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd6;
		col_num = 2'd4;
		end
		
	ISub7:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd7;
		col_num = 2'd4;
		end
		
	ISub8:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd8;
		col_num = 2'd4;
		end
		
	ISub9:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd9;
		col_num = 2'd4;
		end
		
	ISub10:
		begin
		cur_state = 4'b0100;
		loop_num = 4'd10;
		col_num = 2'd4;
		end

	IC1:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd1;
		col_num = 2'd0;
	end
	IC2:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd1;
		col_num = 2'd1;
	end
	IC3:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd1;
		col_num = 2'd2;
	end
	IC4:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd1;
		col_num = 2'd3;
	end
	
	IC5:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd2;
		col_num = 2'd0;
	end
	IC6:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd2;
		col_num = 2'd1;
	end
	IC7:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd2;
		col_num = 2'd2;
	end
	IC8:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd2;
		col_num = 2'd3;
	end
	
	
	IC9:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd3;
		col_num = 2'd0;
	end
	IC10:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd3;
		col_num = 2'd1;
	end
	IC11:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd3;
		col_num = 2'd2;
	end
	IC12:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd3;
		col_num = 2'd3;
	end
	
	
	
	IC13:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd4;
		col_num = 2'd0;
	end
	IC14:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd4;
		col_num = 2'd1;
	end
	IC15:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd4;
		col_num = 2'd2;
	end
	IC16:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd4;
		col_num = 2'd3;
	end
	
	IC17:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd5;
		col_num = 2'd0;
	end
	IC18:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd5;
		col_num = 2'd1;
	end
	IC19:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd5;
		col_num = 2'd2;
	end
	IC20:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd5;
		col_num = 2'd3;
	end

	IC21:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd6;
		col_num = 2'd0;
	end
	IC22:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd6;
		col_num = 2'd1;
	end
	IC23:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd6;
		col_num = 2'd2;
	end
	IC24:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd6;
		col_num = 2'd3;
	end

	IC25:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd7;
		col_num = 2'd0;
	end
	IC26:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd7;
		col_num = 2'd1;
	end
	IC27:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd7;
		col_num = 2'd2;
	end
	IC28:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd7;
		col_num = 2'd3;
	end
	
	IC29:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd8;
		col_num = 2'd0;
	end
	IC30:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd8;
		col_num = 2'd1;
	end
	IC31:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd8;
		col_num = 2'd2;
	end
	IC32:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd8;
		col_num = 2'd3;
	end
	
	IC33:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd9;
		col_num = 2'd0;
	end
	IC34:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd9;
		col_num = 2'd1;
	end
	IC35:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd9;
		col_num = 2'd2;
	end
	IC36:
	begin
		cur_state = 4'b0001;
		loop_num = 4'd9;
		col_num = 2'd3;
	end


	IS1:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd1;
		col_num = 2'd4;
		end
		
	IS2:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd2;
		col_num = 2'd4;
		end
		
	IS3:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd3;
		col_num = 2'd4;
		end
		
	IS4:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd4;
		col_num = 2'd4;
		end
		
	IS5:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd5;
		col_num = 2'd4;
		end
		
	IS6:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd6;
		col_num = 2'd4;
		end
		
	IS7:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd7;
		col_num = 2'd4;
		end
		
	IS8:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd8;
		col_num = 2'd4;
		end
		
	IS9:
	begin
		cur_state = 4'b0010;
		loop_num = 4'd9;
		col_num = 2'd4;
		end

	IS10:
		begin
		cur_state = 4'b0010;
		loop_num = 4'd10;
		col_num = 2'd4;
		end
	
	endcase 

end


endmodule

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic AES_DONE,
	output logic [127:0] AES_MSG_DEC
);

	logic [1:0] col_num;
	logic [127:0] State;
	logic [3:0] cur_state;
	
		
	KeyExpansion ke ( 
						.clk(CLK), 
						.Cipherkey(AES_KEY), 
						.KeySchedule(KeySchedule)
					);

	
	
	decript_states d_state(
						.CLK(CLK),
						.RESET(RESET),
						.AES_START(AES_START),
						.KeySchedule(KeySchedule), 
						.cur_state(cur_state), 
						.loop_num(loop_num),
						.col_num(col_num),
						.AES_DONE(AES_DONE)
				);



	logic [127:0]internal_state;
	logic [127:0] isb_out;	
	
	always_comb
	begin
	internal_state = State;
		unique case(cur_state)

		4'b0001: 
		begin
			unique case(col_num)
			2'b00:
				internal_state[31:0] = mix_c_out;
			2'b01:
				internal_state[63:32] = mix_c_out;
			2'b10:
				internal_state[95:64] = mix_c_out;
			2'b11:
				internal_state[127:96] = mix_c_out;
			endcase
		end

		4'b0010: 
			internal_state = is_out;
		4'b0100: 
			internal_state = isb_out;
		4'b1000: 
			internal_state = ark_out;
		4'b1001:
			internal_state = AES_MSG_ENC; 

		4'b1111: 
			internal_state = 128'd0;

		default: 
			internal_state = State;

		endcase 
	end

	always_ff @ (posedge CLK)
	begin
		if(RESET)
			State <= 128'd0; 
		else 
			State <= internal_state;

	end
	

	assign AES_MSG_DEC = State;
	
	logic [127:0] is_out;


	InvShiftRows isr(
						.data_in(State), 
						.data_out(is_out)
					); 

	
	logic [1407:0] KeySchedule;
	logic [127:0] ark_out;
	logic [3:0] loop_num;

	AddRoundKey ark (
					.State(State), 
					.KeySchedule(KeySchedule), 
					.loop_num(loop_num), 
					.ark_out(ark_out)
				);
	
	
	
	always_comb
	begin
		unique case(col_num)
			2'd0: mix_c = State[31:0];
			2'd1: mix_c = State[63:32];
			2'd2: mix_c = State[95:64];
			2'd3: mix_c = State[127:96];
		endcase
	end

	logic [31:0]mix_c, mix_c_out;

	InvMixColumns imc(.in(mix_c),.out(mix_c_out));
		
	logic [127:0] inv_col_out;

	InvSubAll isa(.CLK(CLK), .State(State), .OUT(isb_out));

	
endmodule

