module Read_Address(input 	is_mario,
						  input 	[9:0]  DrawX, DrawY,
						  input 	[9:0]  X_Pos, Y_Pos,
						  input 	[31:0] x_offset, y_offset,x_jump_offset,y_jump_offset, keycode,
						  output  [18:0] read_address,
                    inout   [4:0] marioX_counter, marioY_counter);

    // int DistX, DistY;
	// assign DistX = DrawX - X_pos;
	// assign DistY = DrawY - Y_pos;
	 int enlarge_DrawX, enlarge_DrawY;
	 assign enlarge_DrawX = (DrawX - X_Pos)/ 2;
    assign enlarge_DrawY = (DrawY - Y_Pos)/2;
	assign up_on = (keycode[31:24] == 8'h1A | keycode[23:16] == 8'h1A | keycode[15: 8] == 8'h1A | keycode[ 7: 0] == 8'h1A);
    assign down_on = (keycode[31:24] == 8'h16 | keycode[23:16] == 8'h16 | keycode[15: 8] == 8'h16 | keycode[ 7: 0] == 8'h16);
    assign left_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
    assign right_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);
    always_comb 
    begin
		read_address = 18'b0;
		if (is_mario) begin
			if ((x_jump_offset == 100 && y_jump_offset == 0 && up_on) || (x_jump_offset == 100 && y_jump_offset == 20 && up_on))
					read_address = (enlarge_DrawX + x_jump_offset) + (enlarge_DrawY + y_jump_offset) * 188;
			else
				read_address = (enlarge_DrawX + x_offset) + (enlarge_DrawY + y_offset) * 188;
        end
    end
endmodule
