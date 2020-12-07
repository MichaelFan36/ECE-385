module  Background ( 
                input Reset, 
                input Clk,
                input frame_clk,
				input [31:0] keycode,
                input [9:0]  DrawX, DrawY,
                input [9:0]  Mario_X_Pos, Mario_Y_Pos,
                inout [8:0] BG_step,
                input is_mario,
                output [7:0]  Red, Green, Blue,
                output is_BG
               );
    
    logic [9:0] BG_X_Pos, BG_X_Motion, BG_Y_Pos, BG_Y_Motion, BG_X_Size, BG_Y_Size;
    logic [18:0] read_address;
    logic [2:0] data_sprite;
    int enlarge_DrawX, enlarge_DrawY;
    logic [9:0] BG_step_in, BG_X_Motion_in;
	 
    parameter [9:0] BG_X_Home=0;  // Center position on the X axis
    parameter [9:0] BG_Y_Home=0;  // Center position on the Y axis
    parameter [9:0] BG_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] BG_X_Max=554;     // 554 Rightmost point on the X axis
    parameter [9:0] BG_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] BG_Y_Max=55;     // 55 Bottommost point on the Y axis
    parameter [9:0] BG_X_Step=1;      // Step size on the X axis
    parameter [9:0] BG_Y_Step=1;      // Step size on the Y axis

    assign BG_X_Size = 555;  // 73 assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign BG_Y_Size = 447;  // 55 assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign BG_X_Pos = 0;
    assign BG_Y_Pos = 0;
    assign enlarge_DrawX = DrawX/8;
    assign enlarge_DrawY = DrawY/8;


    logic can_up, can_down, can_left, can_right;

    wall_detector wall_detector_bg(
    .x_pos(Mario_X_Pos), 
    .y_pos(Mario_Y_Pos),
    .x_size(34), 
    .y_size(32),
    .bg_step(BG_step_in),

    .can_up(can_up), .can_down(can_down), .can_left(can_left), .can_right(can_right)
);


    always_comb begin
		if (((DrawX >= BG_X_Pos) && (DrawY >= BG_Y_Pos)) && ((DrawX < BG_X_Size) && (DrawY < BG_Y_Size)))
			is_BG = 1'b1;
		else
			is_BG = 1'b0;
	end

    always_comb 
    begin
		read_address = 18'b0;
		if (is_BG) begin
            read_address = (enlarge_DrawX - BG_X_Pos + 0) + (enlarge_DrawY - BG_Y_Pos) * 555 + BG_step;
        end
    end

    

    bg_frameRAM _bg_frameRAM(.read_address(read_address), .data_Out(data_sprite), .Clk(Clk));

   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_bg
        if (Reset)  // Asynchronous Reset
        begin 
            BG_step <= BG_X_Home; //Mario_Y_Step;
            BG_X_Motion <= 10'b0;
            
        end
        else
        begin 
        BG_step <= BG_step_in;
        BG_X_Motion <= BG_X_Motion_in;
        end
    end

    assign left_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
    assign right_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);

    always_comb
    begin
           
         
         
            if (right_on && can_right && ((BG_step + 150 + BG_X_Step) < BG_X_Max))
                BG_X_Motion_in = BG_X_Step;
            else if (left_on && can_left && ((BG_step + (~(BG_X_Step) + 1'b1)) > BG_X_Min))
                BG_X_Motion_in = (~(BG_X_Step) + 1'b1);//A
            else
                BG_X_Motion_in = 10'b0;
        

				 
			BG_step_in = (BG_step + BG_X_Motion);

			
		  
    end


    always_comb
begin
    Red = 8'h00;
    Green = 8'h00;
    Blue = 8'h7f - DrawX[9:3];

// '0x800080','0xFEFEFE','0xE75A10','0x007B00','0x008C8C','0x6B8CFF','0x000000'

    if (is_BG) begin
        if (data_sprite == 4'd1) begin
            Red = 8'hfe;
            Green = 8'hfe;
            Blue = 8'hfe;
        end
        if (data_sprite == 4'd2) begin
            Red = 8'he7;
            Green = 8'h5a;
            Blue = 8'h10; 
        end
        if (data_sprite == 4'd3) begin
            Red = 8'h00;
            Green = 8'h7b;
            Blue = 8'h00;
        end
        if (data_sprite == 4'd4) begin
            Red = 8'h00;
            Green = 8'h8c;
            Blue = 8'h8c;
        end
        if (data_sprite == 4'd5) begin
            Red = 8'h6b;
            Green = 8'h8c;
            Blue = 8'hff;
        end
        if (data_sprite == 4'd6) begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
    end
end
       
    

endmodule
