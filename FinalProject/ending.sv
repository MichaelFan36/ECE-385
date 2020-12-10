module slowClock_5HZ_ending ( Clk, Reset, Clk_5Hz);

input Clk, Reset;
output Clk_5Hz;

reg Clk_5Hz = 1'b0;
reg [28:0] counter;

always@(posedge Reset or posedge Clk)
begin
if (Reset == 1'b1) 
begin
	Clk_5Hz <= 0;
	counter <= 0;
end
else
begin
counter <= counter+1;
if (counter == 3_000_000)
begin
counter <= 0;
Clk_5Hz <= ~Clk_5Hz;
end
end
end
endmodule

module  ending ( 
                input Reset, 
                input Clk,
                input frame_clk,
				input [31:0] keycode,
                input [9:0] DrawX, DrawY,
                input [8:0] BG_step,


                output [7:0]  Red, Green, Blue,
                inout is_ending
               );
    
    
    logic [9:0] ending_X_Pos, ending_X_Motion, ending_Y_Pos, ending_Y_Motion, ending_Size,ending_X_Size,ending_Y_Size;
	 logic [9:0] ending_Y_Pos_in, ending_X_Pos_in, ending_X_Motion_in, ending_Y_Motion_in;
    logic [18:0] endingReadAdd;

    parameter [9:0] ending_X_Home= 305;  // Center position on the X axis 400
    parameter [9:0] ending_Y_Home= 243;  // Center position on the Y axis 270
    // parameter [9:0] ending_X_Min=0;       // Leftmost point on the X axis
    // parameter [9:0] ending_X_Max=0;     // Rightmost point on the X axis
    // parameter [9:0] ending_Y_Min=10;       // Topmost point on the Y axis
    // parameter [9:0] ending_Y_Max=400;     // Bottommost point on the Y axis
    // parameter [9:0] ending_X_Step=4;      // Step size on the X axis
    // parameter [9:0] ending_Y_Step=4;      // Step size on the Y axis

    
    parameter [9:0] ground_pos = 420;

    assign ending_X_Size = 26;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign ending_Y_Size = 46;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
    // enum logic [3:0] {ready, fall, disappear} State, Next_state;
    logic is_on;

    // assign up_on = (keycode[31:24] == 8'h1A | keycode[23:16] == 8'h1A | keycode[15: 8] == 8'h1A | keycode[ 7: 0] == 8'h1A);
    // assign down_on = (keycode[31:24] == 8'h16 | keycode[23:16] == 8'h16 | keycode[15: 8] == 8'h16 | keycode[ 7: 0] == 8'h16);
    // assign left_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
    // assign right_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);

    logic Clk_5Hz;

    slowClock_5HZ_ending Clock_5Hz_ending(.Clk(Clk), .Reset(Reset), .Clk_5Hz(Clk_5Hz));

    // always_comb
    // begin 
    //     if (BG_step >= 300)
    //         is_on = 1'b0;
    //     else
    //         is_on = 1'b1;
    // end

//    always_comb
// 	begin 
// 		Next_state = State;
		
// 		unique case (State)
//             ready: 
// 				if (BG_step >= 45 && BG_step<=65 && is_mario_up)   
//                     begin
// 					Next_state = fall;
//                     is_on = 1'b1;
//                     ending_eaten = 0;
//                     end
//                 else
//                     begin
//                     Next_state = ready;
//                     is_on = 1'b0;
//                     // is_on = 1'b1;
//                     ending_eaten = 0;
//                     end
// 			fall: 
//             begin
//                 if (can_down)
//                 begin
//                     Next_state = disappear;
//                     is_on = 1'b1;
//                     ending_eaten = 0;
//                 end
//                 else
//                 begin
//                     Next_state = fall;
//                     // is_on = 1'b0;
//                     is_on = 1'b1;
// 						  ending_eaten = 0;
//                 end
//             end

//             disappear:
//             begin
//                 Next_state = disappear;
//                 is_on = 1'b0;
//                     // is_on = 1'b1;
//                     ending_eaten = 1;
//             end
              

// 			default : 
//                 begin
//                     Next_state = ready;
//                     is_on = 1'b0;
//                     ending_eaten = 0;
//                 end
// 		endcase
// 	end



//     always_comb
//     begin
//         if (State == fall && can_down == 1)
//             begin
//                 ending_Y_Motion_in = (ground_pos - ending_X_Pos);
//             end
//         else
//             begin
//                 ending_Y_Motion_in = 10'd0;
//             end
   
//         // ending_X_Pos_in = (ending_X_Pos + ending_X_Motion);
//         ending_Y_Pos_in = (ending_Y_Pos + ending_Y_Motion);
//     end
       
    always_ff @ (posedge Reset or posedge Clk_5Hz )
    begin: Move_ending
        if (Reset)  // Asynchronous Reset
        begin 
            ending_Y_Pos <= ending_Y_Home;
            ending_X_Pos <= ending_X_Home;
            if (BG_step >= 300)
                is_on = 1'b0;
            else
                is_on = 1'b1;
        end
        else
        begin  
            ending_Y_Pos <= ending_Y_Home;
            ending_X_Pos <= ending_X_Home;
            if (BG_step >= 300)
                is_on = 1'b0;
            else
                is_on = 1'b1;
        end

    end

    int DistX, DistY;
	assign DistX = DrawX - ending_X_Pos;
	assign DistY = DrawY - ending_Y_Pos;
	always_comb begin
		if (((DrawX >= ending_X_Pos) && (DrawY >= ending_Y_Pos)) && ((DistX < ending_X_Size) && (DistY < ending_Y_Size)) && is_on) // 292
			is_ending = 1'b1;
		else
			is_ending = 1'b0;
	end

    int enlarge_DrawX, enlarge_DrawY;
	assign enlarge_DrawX = (DrawX - ending_X_Pos)/2;
    assign enlarge_DrawY = (DrawY - ending_Y_Pos)/2;
    always_comb 
    begin
		endingReadAdd = 18'b0;
		if (is_ending) begin
            endingReadAdd = (enlarge_DrawX + 43) + (enlarge_DrawY + 114) * 188;
        end
    end
       
    logic [3:0] data_sprite;

mario_frameRAM _ending_frameRAM(.read_address(endingReadAdd), .data_Out(data_sprite), .*);

always_comb
begin
    Red = 8'hff;
    Green = 8'h00;
    Blue = 8'h00;
    if (is_ending) begin
        if (data_sprite == 4'd1) begin
            Red = 8'hff;
            Green = 8'hfd;
            Blue = 8'hfb;
        end
        if (data_sprite == 4'd2) begin
            Red = 8'hb5;
            Green = 8'h31;
            Blue = 8'h21; 
        end
        if (data_sprite == 4'd3) begin
            Red = 8'hf8;
            Green = 8'h38;
            Blue = 8'h00;
        end
        if (data_sprite == 4'd4) begin
            Red = 8'he1;
            Green = 8'h83;
            Blue = 8'h00;
        end
        if (data_sprite == 4'd5) begin
            Red = 8'h1d;
            Green = 8'h7b;
            Blue = 8'h01;
        end
        if (data_sprite == 4'd6) begin
            Red = 8'hac;
            Green = 8'h7c;
            Blue = 8'h00;
        end
        if (data_sprite == 4'd7) begin
            Red = 8'hd4;
            Green = 8'he7;
            Blue = 8'hc7;
        end
        if (data_sprite == 4'd8) begin
            Red = 8'h05;
            Green = 8'h79;
            Blue = 8'h87;
        end
        if (data_sprite == 4'd9) begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
    end
end

endmodule
