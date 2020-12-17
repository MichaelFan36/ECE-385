module slowClock_5HZ_fire ( Clk, Reset, Clk_5Hz);

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

module  Fire ( 
                input logic Reset, 
                input logic Clk,
                input logic frame_clk,
				input logic [31:0] keycode,
                input logic [9:0] DrawX, DrawY,
                input logic [8:0] BG_step,
                input logic [9:0] MarioX, MarioY, MarioS_X, MarioS_Y,
                inout logic [8:0] dead_times,


                output logic [7:0]  Red, Green, Blue,
                output logic [9:0]  FireX, FireY, FireS_X, FireS_Y,
                inout logic is_fire, dead_reset
               );
    
    
    logic [9:0] fire_X_Pos, fire_X_Motion, fire_Y_Pos, fire_Y_Motion, fire_Size,fire_X_Size,fire_Y_Size;
	 logic [9:0] fire_Y_Pos_in, fire_X_Pos_in, fire_X_Motion_in, fire_Y_Motion_in;
    logic [18:0] FireReadAdd;

    parameter [9:0] fire_X_Home= 340;  // Center position on the X axis 400
    parameter [9:0] fire_Y_Home= 320;  // Center position on the Y axis 270
    parameter [9:0] fire_X_Home_space = 1000;  // Center position on the X axis 400
    parameter [9:0] fire_Y_Home_space = 1000;  // Center position on the Y axis 270
    parameter [9:0] fire_X_Min= 0;       // Leftmost point on the X axis
    parameter [9:0] fire_X_Max= 0;     // Rightmost point on the X axis
    parameter [9:0] fire_Y_Min= 10;       // Topmost point on the Y axis
    parameter [9:0] fire_Y_Max= 400;     // Bottommost point on the Y axis
    parameter [9:0] fire_X_Step= 4;      // Step size on the X axis
    parameter [9:0] fire_Y_Step= 4;      // Step size on the Y axis
    parameter [8:0] initial_dead_times = 0;


    
    parameter [9:0] jump_Step_forward=2;  // fire_step + 12 = 4 + 12
    parameter [9:0] jump_Step_downward=20;
    parameter [9:0] jump_Step_downward1=20; 
    parameter [9:0] jump_Step_downward2=25; 
    parameter [9:0] jump_Step_downward3=38; 
    parameter [9:0] jump_Step_downward4=45; 
    parameter [9:0] counter_background=8;
    parameter [8:0] dead_offset = 10;

    assign fire_X_Size = 48;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign fire_Y_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
    enum logic [1:0] {stand, move1, move2, ready} State, Next_state;
    logic is_on;

    logic [8:0] dead_times_in, dead_times_motion;
    assign up_on = (keycode[31:24] == 8'h1A | keycode[23:16] == 8'h1A | keycode[15: 8] == 8'h1A | keycode[ 7: 0] == 8'h1A);
    assign down_on = (keycode[31:24] == 8'h16 | keycode[23:16] == 8'h16 | keycode[15: 8] == 8'h16 | keycode[ 7: 0] == 8'h16);
    assign left_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
    assign right_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);
    assign space_on = (keycode[31:24] == 8'h2C | keycode[23:16] == 8'h2C | keycode[15: 8] == 8'h2C | keycode[ 7: 0] == 8'h2C);

    logic Clk_5Hz;

    slowClock_5HZ_fire Clock_5Hz_fire(.Clk(Clk), .Reset(Reset), .Clk_5Hz(Clk_5Hz));

   always_comb
	begin 
		Next_state = State;
		
		unique case (State)
            stand: 
				if (BG_step > 292 && BG_step < 360)  // 292 
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

    always_comb
    begin
            if (State == ready )
            begin
                dead_times_in = dead_times;
                dead_reset = 1'b0;
                if ((MarioX + MarioS_X) <= (fire_X_Pos + ((~jump_Step_forward) + 1'b1) ))
				fire_X_Motion_in = ((~jump_Step_forward) + 1'b1);
                else
                fire_X_Motion_in = 10'b0;

                if ((MarioY) >= (fire_Y_Pos + jump_Step_forward))
				fire_Y_Motion_in = jump_Step_forward;
                else
                fire_Y_Motion_in = 10'b0;
            end	 

            else if(State == move1)
            begin
                dead_times_in = dead_times;
                dead_reset = 1'b0;
                if ((MarioX + MarioS_X) <= (fire_X_Pos + ((~jump_Step_forward) + 1'b1) ))
                begin 
				fire_X_Motion_in = ((~jump_Step_forward) + 1'b1);

                if (left_on)
                begin
                fire_X_Motion_in = counter_background + (~(jump_Step_forward) + 1'b1);
                end
                
                if (right_on)
                begin
                fire_X_Motion_in = (~(jump_Step_forward + counter_background) + 1'b1);
                end 
                end
                
                else
                begin
                fire_X_Motion_in = 10'b0;

                if (left_on)
                begin
                fire_X_Motion_in = counter_background;
                end
                
                if (right_on)
                begin
                fire_X_Motion_in = (~(counter_background) + 1'b1);
                end 
                if ((MarioY) == (fire_Y_Pos + jump_Step_forward))
                    begin
                    dead_times_in = dead_times + dead_offset;
                    dead_reset = 1'b1;
                    end
                end

                if ((MarioY) > (fire_Y_Pos + jump_Step_forward))
				fire_Y_Motion_in = jump_Step_forward;
                else if ((MarioY) < (fire_Y_Pos + jump_Step_forward))
                fire_Y_Motion_in = ((~jump_Step_forward) + 1'b1);
                else
                fire_Y_Motion_in = 10'b0; 

            end	

            else if(State == move2)
            begin
                dead_times_in = dead_times;
                dead_reset = 1'b0;
                if ((MarioX + MarioS_X) <= (fire_X_Pos + ((~jump_Step_forward) + 1'b1) ))
                begin 

				fire_X_Motion_in = ((~jump_Step_forward) + 1'b1);
                if (left_on)
                begin
                fire_X_Motion_in = counter_background + (~(jump_Step_forward) + 1'b1);
                end
                if (right_on)
                begin
                fire_X_Motion_in = (~(jump_Step_forward + counter_background) + 1'b1);
                end 
                end
                
                else
                begin
                    
                fire_X_Motion_in = 10'b0;
                if (left_on)
                begin
                fire_X_Motion_in = counter_background;
                end
                if (right_on)
                begin
                fire_X_Motion_in = (~(counter_background) + 1'b1);
                end 
                if ((MarioY) == (fire_Y_Pos + jump_Step_forward))
                    begin
                    dead_times_in = dead_times + dead_offset;
                    dead_reset = 1'b1;
                    end
                end

                if ((MarioY) > (fire_Y_Pos + jump_Step_forward))
				fire_Y_Motion_in = jump_Step_forward;
                else if ((MarioY) < (fire_Y_Pos + jump_Step_forward))
                fire_Y_Motion_in = ((~jump_Step_forward) + 1'b1);
                else
                fire_Y_Motion_in = 10'b0; 

            end

            else
            begin
				fire_Y_Motion_in = 10'b0;
                fire_X_Motion_in = 10'b0;
                dead_times_in = dead_times;
                dead_reset = 1'b0;
            end
        fire_X_Pos_in = (fire_X_Pos + fire_X_Motion);
        fire_Y_Pos_in = (fire_Y_Pos + fire_Y_Motion);
    end
       
    always_ff @ (posedge Reset or posedge Clk_5Hz or posedge dead_reset or posedge space_on)
    begin: Move_fire
        if (Reset)  // Asynchronous Reset
        begin 
            fire_Y_Motion <= 10'b0; //fire_Y_Step;
            fire_X_Motion <= 10'b0; //fire_X_Step;
            fire_Y_Pos <= fire_Y_Home;
            fire_X_Pos <= fire_X_Home;
            State <= stand;
            dead_times <= initial_dead_times;
        end
        else if (dead_reset)
		  begin
            fire_Y_Motion <= 10'b0; //fire_Y_Step;
            fire_X_Motion <= 10'b0; //fire_X_Step;
            fire_Y_Pos <= fire_Y_Home;
            fire_X_Pos <= fire_X_Home;
            State <= stand;
            dead_times <= dead_times_in;
		  end
        else if (space_on)
            begin
            fire_Y_Motion <= 10'b0; //fire_Y_Step;
            fire_X_Motion <= 10'b0; //fire_X_Step;
            fire_Y_Pos <= fire_Y_Home_space;
            fire_X_Pos <= fire_X_Home_space;
            State <= stand;
            dead_times <= initial_dead_times;
            end
        else
        begin  
            fire_X_Pos <= fire_X_Pos_in;
            fire_Y_Pos <= fire_Y_Pos_in;
            fire_Y_Motion <= fire_Y_Motion_in;
            fire_X_Motion <= fire_X_Motion_in;
            State <= Next_state;
            dead_times <= dead_times_in;
        end

    end

    int DistX, DistY;
	assign DistX = DrawX - fire_X_Pos;
	assign DistY = DrawY - fire_Y_Pos;
	always_comb begin
		if (((DrawX >= fire_X_Pos) && (DrawY >= fire_Y_Pos)) && ((DistX < fire_X_Size) && (DistY < fire_Y_Size)) && is_on) // 292
			is_fire = 1'b1;
		else
			is_fire = 1'b0;
	end

    int enlarge_DrawX, enlarge_DrawY;
	assign enlarge_DrawX = (DrawX - fire_X_Pos)/ 2;
    assign enlarge_DrawY = (DrawY - fire_Y_Pos)/2;
    always_comb 
    begin
		FireReadAdd = 18'b0;
		if (is_fire) begin
            FireReadAdd = (enlarge_DrawX + 112) + (enlarge_DrawY+99) * 188;
        end
    end
       
    logic [3:0] data_sprite;

mario_frameRAM _fire_frameRAM(.read_address(FireReadAdd), .data_Out(data_sprite), .*);

always_comb
begin
    Red = 8'hff;
    Green = 8'h00;
    Blue = 8'h00;
    if (is_fire) begin
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
