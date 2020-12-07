module draw (
					input logic [9:0] X_pos, Y_pos,
					input logic [9:0] DrawX, DrawY,
					input logic [9:0] Size_X, Size_Y,
					output logic is_this
				);
	
	int DistX, DistY;
	assign DistX = DrawX - X_pos;
	assign DistY = DrawY - Y_pos;
	always_comb begin
		if (((DrawX >= X_pos) && (DrawY >= Y_pos)) && ((DistX < Size_X) && (DistY < Size_Y)))
			is_this = 1'b1;
		else
			is_this = 1'b0;
	end

endmodule
