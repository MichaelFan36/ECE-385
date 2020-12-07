module pacman_animation (	input logic Clk, Reset, 
							input logic [2:0] direction, 
							output logic [3:0] ani_type_with_dir
						);
						
	enum logic [3:0] {up_1, up_2, up_3, 
							down_1, down_2, down_3, 
							left_1, left_2, left_3, 
							right_1, right_2, right_3,
							hold
							} state, next_state;
		
	logic [2:0] cur_direction;
	logic Clk_5Hz;
	logic [3:0] next_type;
	
	slowClock_5HZ Clock_5Hz(.*);
	
	initial begin
		state <= hold;
		cur_direction <= 3'b000;
		ani_type_with_dir <= 4'b0000;
	end
	
	always_ff @ (posedge Clk_5Hz) begin
		if (Reset) begin
			state <= hold;
			cur_direction <= 3'b000;
			ani_type_with_dir <= 4'b0000;
		end
		else begin
			state <= next_state;
			cur_direction <= direction;
			ani_type_with_dir <= next_type;
		end
	end
	
	always_comb begin
		next_state = state;
		next_type = ani_type_with_dir;
		
		if (direction != cur_direction) begin
			case (direction)
				// hold
				3'b000 : begin
						next_state = hold;
						next_type = ani_type_with_dir;
					end
				// up
				3'b001 : begin
						next_state = up_1;
						next_type = 4'b0000;
					end
				// down
				3'b010 : begin
						next_state = down_1;
						next_type = 4'b0010;
					end
				// left
				3'b011 : begin
						next_state = left_1;
						next_type = 4'b0100;
					end
				// right
				3'b100 : begin
						next_state = right_1;
						next_type = 4'b0110;
					end
				default : ;
			endcase
		end
		else begin
			unique case (state)
				// continue up
				up_1 : begin
						next_state = up_2;
						next_type = 4'b0001;
					end
				up_2 : begin
						next_state = up_3;
						next_type = 4'b1111;
					end
				up_3 : begin
						next_state = up_1;
						next_type = 4'b0000;
					end
				// continue down
				down_1 : begin
						next_state = down_2;
						next_type = 4'b0011;
					end
				down_2 : begin
						next_state = down_3;
						next_type = 4'b1111;
					end
				down_3 : begin
						next_state = down_1;
						next_type = 4'b0010;
					end
				// continue left
				left_1 : begin
						next_state = left_2;
						next_type = 4'b0101;
					end
				left_2 : begin
						next_state = left_3;
						next_type = 4'b1111;
					end
				left_3 : begin
						next_state = left_1;
						next_type = 4'b0100;
					end
				// continue right
				right_1 : begin
						next_state = right_2;
						next_type = 4'b0111;
					end
				right_2 : begin
						next_state = right_3;
						next_type = 4'b1111;
					end
				right_3 : begin
						next_state = right_1;
						next_type = 4'b0110;
					end
					
				default : begin
						next_state = hold;
						next_type = ani_type_with_dir;
					end
			endcase
		end
	end
endmodule
