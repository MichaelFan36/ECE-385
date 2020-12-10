module  Life ( 
                input logic Reset, 
                input logic Clk,
                input logic frame_clk,
                input logic [9:0] DrawX, DrawY,
                input logic [8:0] dead_times,


                output logic [7:0]  Red1, Green1, Blue1,
                output logic [7:0]  Red2, Green2, Blue2,
                output logic  [7:0]  Red3, Green3, Blue3,
                inout logic  is_life1, is_life2, is_life3
               );
    
    
    logic [9:0] life_X_Pos1, life_Y_Pos1, life_X_Size, life_Y_Size;
    logic [9:0] life_X_Pos2, life_Y_Pos2;
    logic [9:0] life_X_Pos3, life_Y_Pos3;
	 logic [9:0] life_Y_Pos_in, life_X_Pos_in, life_X_Motion_in, life_Y_Motion_in;
    logic [18:0] LifeReadAdd1, LifeReadAdd2, LifeReadAdd3;

    parameter [9:0] life_X_Home_1 = 0;  // Center position on the X axis 400
    parameter [9:0] life_X_Home_2 = 15;  // Center position on the X axis 400
    parameter [9:0] life_X_Home_3 = 30;  // Center position on the X axis 400
    parameter [9:0] life_Y_Home= 20;  // Center position on the Y axis 270
    parameter [9:0] life_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] life_X_Max=0;     // Rightmost point on the X axis
    parameter [9:0] life_Y_Min=10;       // Topmost point on the Y axis
    parameter [9:0] life_Y_Max=400;     // Bottommost point on the Y axis
    parameter [9:0] life_X_Step=4;      // Step size on the X axis
    parameter [9:0] life_Y_Step=4;      // Step size on the Y axis
    parameter [1:0] initial_counter = 3;

    assign life_X_Size = 15;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign life_Y_Size = 14;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"

    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_life
        life_Y_Pos1 <= life_Y_Home;
        life_X_Pos1 <= life_X_Home_3;
        life_Y_Pos2 <= life_Y_Home;
        life_X_Pos2 <= life_X_Home_2;
        life_Y_Pos3 <= life_Y_Home;
        life_X_Pos3 <= life_X_Home_1;
    end
       

    int DistX1, DistY1, DistX2, DistY2, DistX3, DistY3;
	assign DistX1 = DrawX - life_X_Pos1;
	assign DistY1 = DrawY - life_Y_Pos1;
    assign DistX2 = DrawX - life_X_Pos2;
	assign DistY2 = DrawY - life_Y_Pos2;
    assign DistX3 = DrawX - life_X_Pos3;
	assign DistY3 = DrawY - life_Y_Pos3;
	always_comb begin
		if (((DrawX >= life_X_Pos1) && (DrawY >= life_Y_Pos1)) && ((DistX1 < life_X_Size) && (DistY1 < life_Y_Size)) && (dead_times < 250)) // 292
			is_life1 = 1'b1;
		else
			is_life1 = 1'b0;

        if (((DrawX >= life_X_Pos2) && (DrawY >= life_Y_Pos2)) && ((DistX2 < life_X_Size) && (DistY2 < life_Y_Size)) && (dead_times < 60)) // 292
			is_life2 = 1'b1;
		else
			is_life2 = 1'b0;

        if (((DrawX >= life_X_Pos3) && (DrawY >= life_Y_Pos3)) && ((DistX3 < life_X_Size) && (DistY3 < life_Y_Size)) && (dead_times < 10)) // 292
			is_life3 = 1'b1;
		else
			is_life3 = 1'b0;
	end

    int enlarge_DrawX1, enlarge_DrawY1, enlarge_DrawX2, enlarge_DrawY2, enlarge_DrawX3, enlarge_DrawY3;
	assign enlarge_DrawX1 = DrawX - life_X_Pos1;
    assign enlarge_DrawY1 = DrawY - life_Y_Pos1;
    assign enlarge_DrawX2 = DrawX - life_X_Pos2;
    assign enlarge_DrawY2 = DrawY - life_Y_Pos2;
    assign enlarge_DrawX3 = DrawX - life_X_Pos3;
    assign enlarge_DrawY3 = DrawY - life_Y_Pos3;

    always_comb 
    begin
		LifeReadAdd1 = 18'b0;
        LifeReadAdd2 = 18'b0;
        LifeReadAdd3 = 18'b0;
		if (is_life1) begin
            LifeReadAdd1 = enlarge_DrawX1 + enlarge_DrawY1 * 188;
        end
        if (is_life2) begin
            LifeReadAdd2 = enlarge_DrawX2 + enlarge_DrawY2 * 188;
        end
        if (is_life3) begin
            LifeReadAdd3 = enlarge_DrawX3 + enlarge_DrawY3 * 188;
        end
    end
       
    logic [3:0] data_sprite1, data_sprite2, data_sprite3;

mario_frameRAM _life_frameRAM1(.read_address(LifeReadAdd1), .data_Out(data_sprite1), .*);
mario_frameRAM _life_frameRAM2(.read_address(LifeReadAdd2), .data_Out(data_sprite2), .*);
mario_frameRAM _life_frameRAM3(.read_address(LifeReadAdd3), .data_Out(data_sprite3), .*);

always_comb
begin
    Red1 = 8'hff;
    Green1 = 8'h00;
    Blue1 = 8'h00;

    Red2 = 8'hff;
    Green2 = 8'h00;
    Blue2 = 8'h00;

    Red3 = 8'hff;
    Green3 = 8'h00;
    Blue3 = 8'h00;
    if (is_life1) begin
        if (data_sprite1 == 4'd1) begin
            Red1 = 8'hff;
            Green1 = 8'hfd;
            Blue1 = 8'hfb;
        end
        if (data_sprite1 == 4'd2) begin
            Red1 = 8'hb5;
            Green1 = 8'h31;
            Blue1 = 8'h21; 
        end
        if (data_sprite1 == 4'd3) begin
            Red1 = 8'hf8;
            Green1 = 8'h38;
            Blue1 = 8'h00;
        end
        if (data_sprite1 == 4'd4) begin
            Red1 = 8'he1;
            Green1 = 8'h83;
            Blue1 = 8'h00;
        end
        if (data_sprite1 == 4'd5) begin
            Red1 = 8'h1d;
            Green1 = 8'h7b;
            Blue1 = 8'h01;
        end
        if (data_sprite1 == 4'd6) begin
            Red1 = 8'hac;
            Green1 = 8'h7c;
            Blue1 = 8'h00;
        end
        if (data_sprite1 == 4'd7) begin
            Red1 = 8'hd4;
            Green1 = 8'he7;
            Blue1 = 8'hc7;
        end
        if (data_sprite1 == 4'd8) begin
            Red1 = 8'h05;
            Green1 = 8'h79;
            Blue1 = 8'h87;
        end
        if (data_sprite1 == 4'd9) begin
            Red1 = 8'h00;
            Green1 = 8'h00;
            Blue1 = 8'h00;
        end
    end

    if (is_life2) begin
        if (data_sprite2 == 4'd1) begin
            Red2 = 8'hff;
            Green2 = 8'hfd;
            Blue2 = 8'hfb;
        end
        if (data_sprite2 == 4'd2) begin
            Red2 = 8'hb5;
            Green2 = 8'h31;
            Blue2 = 8'h21; 
        end
        if (data_sprite2 == 4'd3) begin
            Red2 = 8'hf8;
            Green2 = 8'h38;
            Blue2 = 8'h00;
        end
        if (data_sprite2 == 4'd4) begin
            Red2 = 8'he1;
            Green2 = 8'h83;
            Blue2 = 8'h00;
        end
        if (data_sprite2 == 4'd5) begin
            Red2 = 8'h1d;
            Green2 = 8'h7b;
            Blue2 = 8'h01;
        end
        if (data_sprite2 == 4'd6) begin
            Red2 = 8'hac;
            Green2 = 8'h7c;
            Blue2 = 8'h00;
        end
        if (data_sprite2 == 4'd7) begin
            Red2 = 8'hd4;
            Green2 = 8'he7;
            Blue2 = 8'hc7;
        end
        if (data_sprite2 == 4'd8) begin
            Red2 = 8'h05;
            Green2 = 8'h79;
            Blue2 = 8'h87;
        end
        if (data_sprite2 == 4'd9) begin
            Red2 = 8'h00;
            Green2 = 8'h00;
            Blue2 = 8'h00;
        end
    end

    if (is_life3) begin
        if (data_sprite3 == 4'd1) begin
            Red3 = 8'hff;
            Green3 = 8'hfd;
            Blue3 = 8'hfb;
        end
        if (data_sprite3 == 4'd2) begin
            Red3 = 8'hb5;
            Green3 = 8'h31;
            Blue3 = 8'h21; 
        end
        if (data_sprite3 == 4'd3) begin
            Red3 = 8'hf8;
            Green3 = 8'h38;
            Blue3 = 8'h00;
        end
        if (data_sprite3 == 4'd4) begin
            Red3 = 8'he1;
            Green3 = 8'h83;
            Blue3 = 8'h00;
        end
        if (data_sprite3 == 4'd5) begin
            Red3 = 8'h1d;
            Green3 = 8'h7b;
            Blue3 = 8'h01;
        end
        if (data_sprite3 == 4'd6) begin
            Red3 = 8'hac;
            Green3 = 8'h7c;
            Blue3 = 8'h00;
        end
        if (data_sprite3 == 4'd7) begin
            Red3 = 8'hd4;
            Green3 = 8'he7;
            Blue3 = 8'hc7;
        end
        if (data_sprite3 == 4'd8) begin
            Red3 = 8'h05;
            Green3 = 8'h79;
            Blue3 = 8'h87;
        end
        if (data_sprite3 == 4'd9) begin
            Red3 = 8'h00;
            Green3 = 8'h00;
            Blue3 = 8'h00;
        end
    end
end

endmodule
