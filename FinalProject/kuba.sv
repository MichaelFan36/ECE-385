module slowClock_5HZ_cuba ( Clk, Reset, Clk_5Hz);

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


module  Kuba ( 
                input Reset, 
                input Clk,
                input frame_clk,
				input [31:0] keycode,
                input [9:0] DrawX, DrawY,
                input [8:0] BG_step,
                // input [9:0] MarioX, MarioY, MarioS_X, MarioS_Y,


                output [7:0]  Red_kuba, Green_kuba, Blue_kuba,
                // output [7:0]  Red_fire, Green_fire, Blue_fire,
                inout is_kuba
                // inout is_fire
               );
    
    logic [9:0] kuba_X_Pos, kuba_X_Motion, kuba_Y_Pos, kuba_Y_Motion, kuba_Size,kuba_X_Size,kuba_Y_Size;
    // logic [9:0] fire_X_Pos, fire_X_Motion, fire_Y_Pos, fire_Y_Motion, fire_Size,fire_X_Size,fire_Y_Size;

	logic [9:0] kuba_Y_Pos_in, kuba_X_Pos_in, kuba_X_Motion_in, kuba_Y_Motion_in;
    // logic [9:0] fire_Y_Pos_in, fire_X_Pos_in, fire_X_Motion_in, fire_Y_Motion_in;
    logic is_on;
    logic [18:0] KubaReadAdd, FireReadAdd;

    parameter [9:0] kuba_X_Home= 420;  // Center position on the X axis 400
    parameter [9:0] kuba_Y_Home= 206;  // Center position on the Y axis 270
    parameter [9:0] kuba_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] kuba_X_Max=0;     // Rightmost point on the X axis
    parameter [9:0] kuba_Y_Min=10;       // Topmost point on the Y axis
    parameter [9:0] kuba_Y_Max=400;     // Bottommost point on the Y axis
    parameter [9:0] kuba_X_Step=4;      // Step size on the X axis
    parameter [9:0] kuba_Y_Step=4;      // Step size on the Y axis

    // parameter [9:0] fire_X_Home= 340;  // Center position on the X axis 400
    // parameter [9:0] fire_Y_Home= 320;  // Center position on the Y axis 270
    // parameter [9:0] fire_X_Min=0;       // Leftmost point on the X axis
    // parameter [9:0] fire_X_Max=0;     // Rightmost point on the X axis
    // parameter [9:0] fire_Y_Min=10;       // Topmost point on the Y axis
    // parameter [9:0] fire_Y_Max=400;     // Bottommost point on the Y axis
    // parameter [9:0] fire_X_Step=4;      // Step size on the X axis
    // parameter [9:0] fire_Y_Step=4;      // Step size on the Y axis

    assign kuba_X_Size = 130;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign kuba_Y_Size = 130;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    // assign fire_X_Size = 48;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    // assign fire_Y_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
    enum logic [4:0] {stand, up1, up2, up3, up4, up5, up6, up7, up8, move1, move2, ready} State, Next_state;
    enum logic [4:0] {stand_fire, up1_fire, up2_fire, up3_fire, up4_fire, up5_fire, up6_fire, up7_fire, up8_fire, move1_fire, move2_fire, ready_fire} State_fire, Next_state_fire;

    assign up_on = (keycode[31:24] == 8'h1A | keycode[23:16] == 8'h1A | keycode[15: 8] == 8'h1A | keycode[ 7: 0] == 8'h1A);
    assign down_on = (keycode[31:24] == 8'h16 | keycode[23:16] == 8'h16 | keycode[15: 8] == 8'h16 | keycode[ 7: 0] == 8'h16);
    assign left_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
    assign right_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);

    logic Clk_5Hz;

    slowClock_5HZ_cuba Clock_5Hz_kuba(.Clk(Clk), .Reset(Reset), .Clk_5Hz(Clk_5Hz));
	
   always_comb
	begin 
		Next_state = State;
		
		unique case (State)
            stand: 
				if (BG_step > 292)  // 292 
                    begin
					Next_state = ready;
                    is_on = 1'b1;
                    end
                else
                    begin
                    Next_state = stand;
                    is_on = 1'b0;
                    end
			ready: 
                begin
                Next_state = up1;   
                is_on = 1'b1;
                end        
			up1 : 
                begin
				Next_state = up2;
                is_on = 1'b1;
                end
			up2 : 
                begin
				Next_state = up3;
                is_on = 1'b1;
                end
			up3 : 
                begin
				Next_state = up4;
                is_on = 1'b1;
                end
            up4 : 
                begin
				Next_state = up5;
                is_on = 1'b1;
                end
            up5 : 
                begin
				Next_state = up6;
                is_on = 1'b1;
                end
            up6 : 
                begin
				Next_state = up7;
                is_on = 1'b1;
                end
            up7 : 
                begin
				Next_state = up8;
                is_on = 1'b1;
                end
            up8:    
                begin
                Next_state = move1;
                is_on = 1'b1;
                end
			move1 :
                begin 
                Next_state = move2;
                is_on = 1'b1;
                end
			move2 :
                begin
                Next_state = move1;
                is_on = 1'b1;
                end

			default : 
                begin
				Next_state = stand;
                is_on = 1'b0;
                end


		endcase
	end

    
   

    always_ff @ (posedge Reset or posedge Clk_5Hz )
    begin: Move_kuba
        if (Reset)  // Asynchronous Reset
        begin 
            kuba_Y_Motion <= 10'b0; //kuba_Y_Step;
            kuba_X_Motion <= 10'b0; //kuba_X_Step;
            kuba_Y_Pos <= kuba_Y_Home;
            kuba_X_Pos <= kuba_X_Home;
            // fire_Y_Motion <= 10'b0; //fire_Y_Step;
            // fire_X_Motion <= 10'b0; //fire_X_Step;
            // fire_Y_Pos <= fire_Y_Home;
            // fire_X_Pos <= fire_X_Home;
            State <= stand;

        end
        else
        begin  
            kuba_X_Pos <= kuba_X_Pos_in;
            kuba_Y_Pos <= kuba_Y_Pos_in;
            kuba_Y_Motion <= kuba_Y_Motion_in;
            kuba_X_Motion <= kuba_X_Motion_in;
            // fire_X_Pos <= fire_X_Pos_in;
            // fire_Y_Pos <= fire_Y_Pos_in;
            // fire_Y_Motion <= fire_Y_Motion_in;
            // fire_X_Motion <= fire_X_Motion_in;
            State <= Next_state;
        end

    end

    parameter [9:0] jump_Step_forward=12;  // kuba_step + 12 = 4 + 12
    parameter [9:0] jump_Step_downward=20;
    parameter [9:0] jump_Step_downward1=20; 
    parameter [9:0] jump_Step_downward2=25; 
    parameter [9:0] jump_Step_downward3=38; 
    parameter [9:0] jump_Step_downward4=45; 
    parameter [9:0] counter_background=8;

    always_comb
    begin
            if (State == ready )
            begin
                kuba_Y_Motion_in = ((~jump_Step_downward) + 1'b1);
				kuba_X_Motion_in = 10'b0;
                
            end	  
            else if(State == up1 )
            begin
                kuba_Y_Motion_in = 10'b0;
				kuba_X_Motion_in = 10'b0;
            end	  
            else if(State == up2)
            begin
                kuba_Y_Motion_in = jump_Step_downward;
				kuba_X_Motion_in = 10'b0;
            end	  
            else if(State == up3)
            begin
                kuba_X_Motion_in = (~(jump_Step_forward) + 1'b1);
				kuba_Y_Motion_in = 10'b0;
            end	 
            else if(State == up4 )
            begin
                kuba_Y_Motion_in = jump_Step_downward;
				kuba_X_Motion_in = 10'b0;
            end	  
            else if(State == up5)
            begin
                kuba_X_Motion_in = (~(jump_Step_forward) + 1'b1);
				kuba_Y_Motion_in = 10'b0;
            end	  
            else if(State == up6)
            begin
                kuba_Y_Motion_in = jump_Step_downward1;
				kuba_X_Motion_in = 10'b0;
            end	 
            else if(State == up7)
            begin
               kuba_X_Motion_in = (~(jump_Step_forward) + 1'b1);
				kuba_Y_Motion_in = 10'b0;
            end	 
            else if(State == up8)
            begin
                kuba_Y_Motion_in = jump_Step_downward2;
				kuba_X_Motion_in = 10'b0;
            end	 
            else if(State == move1)
            begin
                kuba_X_Motion_in = (~(jump_Step_forward) + 1'b1);
				kuba_Y_Motion_in = 10'b0;
                if (left_on)
                begin
                kuba_X_Motion_in = counter_background + (~(jump_Step_forward) + 1'b1);
                kuba_Y_Motion_in = 10'b0;
                end
                if (right_on)
                begin
                kuba_X_Motion_in = (~(jump_Step_forward + counter_background) + 1'b1);
                kuba_Y_Motion_in = 10'b0;
                end
            end	  
            else if(State == move2)
            begin
               kuba_X_Motion_in = (jump_Step_forward);
			   kuba_Y_Motion_in = 10'b0;
               if (left_on)
               begin
                kuba_X_Motion_in = counter_background + jump_Step_forward;
                kuba_Y_Motion_in = 10'b0;
               end
                if (right_on)
                begin
                kuba_X_Motion_in = (~(counter_background) + 1'b1) + jump_Step_forward;
                kuba_Y_Motion_in = 10'b0;
                end
            end	  
            else
            begin
				kuba_Y_Motion_in = 10'b0;
                kuba_X_Motion_in = 10'b0;
            end

        kuba_X_Pos_in = (kuba_X_Pos + kuba_X_Motion);
        kuba_Y_Pos_in = (kuba_Y_Pos + kuba_Y_Motion);
        // fire_X_Pos_in = (fire_X_Pos + fire_X_Motion);
        // fire_Y_Pos_in = (fire_Y_Pos + fire_Y_Motion);
    end
       

    int DistX, DistY;
	assign DistX = DrawX - kuba_X_Pos;
	assign DistY = DrawY - kuba_Y_Pos;
	always_comb begin
		if (((DrawX >= kuba_X_Pos) && (DrawY >= kuba_Y_Pos)) && ((DistX < kuba_X_Size) && (DistY < kuba_Y_Size)) && (is_on)) // 292
			is_kuba = 1'b1;
		else
			is_kuba = 1'b0;
	end

    // int DistX_fire, DistY_fire;
	// assign DistX_fire = DrawX - fire_X_Pos;
	// assign DistY_fire = DrawY - fire_Y_Pos;
	// always_comb begin
	// 	if (((DrawX >= fire_X_Pos) && (DrawY >= fire_Y_Pos)) && ((DistX_fire < fire_X_Size) && (DistY_fire < fire_Y_Size)) && (is_on)) // 292
	// 		is_fire = 1'b1;
	// 	else
	// 		is_fire = 1'b0;
	// end

    int enlarge_DrawX, enlarge_DrawY;
	assign enlarge_DrawX = (DrawX - kuba_X_Pos)/ 2;
    assign enlarge_DrawY = (DrawY - kuba_Y_Pos)/2;
    always_comb 
    begin
		KubaReadAdd = 18'b0;
		if (is_kuba) begin
            KubaReadAdd = (enlarge_DrawX + 123) + enlarge_DrawY * 188;
        end
    end

    // int enlarge_DrawX_fire, enlarge_DrawY_fire;
	// assign enlarge_DrawX_fire = (DrawX - fire_X_Pos)/ 2;
    // assign enlarge_DrawY_fire = (DrawY - fire_Y_Pos)/2;
    // always_comb 
    // begin
	// 	FireReadAdd = 18'b0;
	// 	if (is_fire) begin
    //         FireReadAdd = (enlarge_DrawX_fire + 112) + (enlarge_DrawY_fire+99) * 188;
    //     end
    // end
       
    logic [3:0] data_sprite, data_sprite_fire;

mario_frameRAM _kuba_frameRAM(.read_address(KubaReadAdd), .data_Out(data_sprite), .*);
// mario_frameRAM _fire_frameRAM(.read_address(FireReadAdd), .data_Out(data_sprite_fire), .*);

always_comb
begin
    Red_kuba = 8'hff;
    Green_kuba = 8'h00;
    Blue_kuba = 8'h00;
    if (is_kuba) begin
        if (data_sprite == 4'd1) begin
            Red_kuba = 8'hff;
            Green_kuba = 8'hfd;
            Blue_kuba = 8'hfb;
        end
        if (data_sprite == 4'd2) begin
            Red_kuba = 8'hb5;
            Green_kuba = 8'h31;
            Blue_kuba = 8'h21; 
        end
        if (data_sprite == 4'd3) begin
            Red_kuba = 8'hf8;
            Green_kuba = 8'h38;
            Blue_kuba = 8'h00;
        end
        if (data_sprite == 4'd4) begin
            Red_kuba = 8'he1;
            Green_kuba = 8'h83;
            Blue_kuba = 8'h00;
        end
        if (data_sprite == 4'd5) begin
            Red_kuba = 8'h1d;
            Green_kuba = 8'h7b;
            Blue_kuba = 8'h01;
        end
        if (data_sprite == 4'd6) begin
            Red_kuba = 8'hac;
            Green_kuba = 8'h7c;
            Blue_kuba = 8'h00;
        end
        if (data_sprite == 4'd7) begin
            Red_kuba = 8'hd4;
            Green_kuba = 8'he7;
            Blue_kuba = 8'hc7;
        end
        if (data_sprite == 4'd8) begin
            Red_kuba = 8'h05;
            Green_kuba = 8'h79;
            Blue_kuba = 8'h87;
        end
        if (data_sprite == 4'd9) begin
            Red_kuba = 8'h00;
            Green_kuba = 8'h00;
            Blue_kuba = 8'h00;
        end
    end
end
    
// always_comb
// begin
//     Red_fire = 8'hff;
//     Green_fire = 8'h00;
//     Blue_fire = 8'h00;
//     if (is_fire) begin
//         if (data_sprite_fire == 4'd1) begin
//             Red_fire = 8'hff;
//             Green_fire = 8'hfd;
//             Blue_fire = 8'hfb;
//         end
//         if (data_sprite_fire == 4'd2) begin
//             Red_fire = 8'hb5;
//             Green_fire = 8'h31;
//             Blue_fire = 8'h21; 
//         end
//         if (data_sprite_fire == 4'd3) begin
//             Red_fire = 8'hf8;
//             Green_fire = 8'h38;
//             Blue_fire = 8'h00;
//         end
//         if (data_sprite_fire == 4'd4) begin
//             Red_fire = 8'he1;
//             Green_fire = 8'h83;
//             Blue_fire = 8'h00;
//         end
//         if (data_sprite_fire == 4'd5) begin
//             Red_fire = 8'h1d;
//             Green_fire = 8'h7b;
//             Blue_fire = 8'h01;
//         end
//         if (data_sprite_fire == 4'd6) begin
//             Red_fire = 8'hac;
//             Green_fire = 8'h7c;
//             Blue_fire = 8'h00;
//         end
//         if (data_sprite_fire == 4'd7) begin
//             Red_fire = 8'hd4;
//             Green_fire = 8'he7;
//             Blue_fire = 8'hc7;
//         end
//         if (data_sprite_fire == 4'd8) begin
//             Red_fire = 8'h05;
//             Green_fire = 8'h79;
//             Blue_fire = 8'h87;
//         end
//         if (data_sprite_fire == 4'd9) begin
//             Red_fire = 8'h00;
//             Green_fire = 8'h00;
//             Blue_fire = 8'h00;
//         end
//     end
// end

endmodule
