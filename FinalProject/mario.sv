

module  mario ( 
                input logic Reset, 
                input logic Clk,
                input logic frame_clk,
				input logic [31:0] keycode,
                input logic can_up, can_down, can_left, can_right,
                input logic at_tube1, at_tube2, at_tube3, at_tube4, at_tube5, at_tube6,
                input logic at_brick1,at_brick2,at_brick3, mogu_eaten,
                input logic dead_reset,
                output logic [9:0]  MarioX, MarioY, MarioS_X, MarioS_Y,
                output logic [31:0] x_offset, y_offset, x_jump_offset, y_jump_offset,
                output logic is_mario_up
               );
    
    logic [9:0] Mario_X_Pos, Mario_X_Motion, Mario_Y_Pos, Mario_Y_Motion, Mario_Size,Mario_X_Size,Mario_Y_Size;
	logic [9:0] Mario_Y_Pos_in, Mario_X_Pos_in, Mario_Y_Motion_in, Mario_X_Home, Mario_Y_Home;
    int x_jump_offset_in, y_jump_offset_in;

    parameter [9:0] Mario_X_Home_s=305;  // Center position on the X axis
    parameter [9:0] Mario_Y_Home_s=368;  // Center position on the Y axis
    parameter [9:0] Mario_X_Home_b=305;  // Center position on the X axis
    parameter [9:0] Mario_Y_Home_b=358;  // Center position on the Y axis
    parameter [9:0] Mario_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Mario_X_Max=0;     // Rightmost point on the X axis
    parameter [9:0] Mario_Y_Min=10;       // Topmost point on the Y axis
    parameter [9:0] Mario_Y_Max=400;     // Bottommost point on the Y axis
    parameter [9:0] Mario_X_Step=4;      // Step size on the X axis
    parameter [9:0] Mario_Y_Step=4;      // Step size on the Y axis
    parameter [9:0] jump_Step1=70;      // Step size on the Y axis
    parameter [9:0] jump_Step2=60;      // Step size on the Y axis
    parameter [9:0] jump_Step3=55;      // Step size on the Y axis
    parameter [9:0] jump_Step4=40;      // Step size on the Y axis
    parameter [9:0] jump_Step5=20;      // Step size on the Y axis
    parameter [9:0] jump_down1=10;      // Step size on the Y axis
    parameter [9:0] jump_down2=20;      // Step size on the Y axis
    parameter [9:0] jump_down3=40;      // Step size on the Y axis
    parameter [9:0] jump_down_tube1=305;      // lowest
    parameter [9:0] jump_down_tube2=275;      // medium
    parameter [9:0] jump_down_tube3=240;      // highest
    parameter [9:0] jump_up_brick=308;      
    parameter [31:0] jump_offset = 0;

    always_comb
    begin
        if (mogu_eaten != 1)
        begin
            Mario_X_Home = Mario_X_Home_s;
            Mario_Y_Home = Mario_Y_Home_s;
            Mario_X_Size = 34;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
            Mario_Y_Size = 32;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
        end 
        else
        begin
            // Mario_X_Home = Mario_X_Home_b;
            // Mario_Y_Home = Mario_Y_Home_b;
            Mario_X_Home = Mario_X_Home_s;
            Mario_Y_Home = Mario_Y_Home_s;
            Mario_X_Size = 32;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
            Mario_Y_Size = 64;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
        end 
    end
    // assign Mario_X_Size = 34;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    // assign Mario_Y_Size = 32;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
    enum logic [8:0] {stand, up1, up2, up3, up4, up5, still, down0,down1, down2, down3,down4, ready, fall_ready, fall} State, Next_state;
    enum logic [6:0] {stand_walk, walk1, walk2, walk3, walk4, walk5, walk6, ready_walk} State_walk, Next_state_walk;
    logic right, left,up_on, down_on, left_on, right_on;
    logic Clk_5Hz;

   slowClock_5HZ Clock_5Hz_mario(.Clk(Clk), .Reset(Reset), .Clk_5Hz(Clk_5Hz));

    assign up_on = (keycode[31:24] == 8'h1A | keycode[23:16] == 8'h1A | keycode[15: 8] == 8'h1A | keycode[ 7: 0] == 8'h1A);
    assign down_on = (keycode[31:24] == 8'h16 | keycode[23:16] == 8'h16 | keycode[15: 8] == 8'h16 | keycode[ 7: 0] == 8'h16);
    assign left_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
    assign right_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);


    always_comb
	begin 
		Next_state_walk = State_walk;
		
		unique case (State_walk)
            stand_walk: 
            begin
				if (right_on || left_on) 
                begin
					Next_state_walk = ready_walk;
                    if (mogu_eaten != 1)
                    begin
                        if (!right_on && left_on)
                        begin
                            right = 1'b0;
                            left = 1'b1;
                            x_offset = 19;
                            y_offset = 20;
                        end
                        else
                        begin
                            right = 1'b1;
                            left = 1'b0; 
                            x_offset = 19;
                            y_offset = 0;
                        end
                    end
                    else
                    begin
                        if (!right_on && left_on)
                        begin
                            right = 1'b0;
                            left = 1'b1;
                            x_offset = 61;
                            y_offset = 40;
                        end
                        else
                        begin
                            right = 1'b1;
                            left = 1'b0; 
                            x_offset = 0;
                            y_offset = 40;
                        end
                    end
                end
                else
                    begin
                    if (mogu_eaten != 1)
                    begin
                        Next_state_walk = stand_walk;
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 19;
                        y_offset = 0;
                    end
                    else
                    begin
                        Next_state_walk = stand_walk;
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 0;
                        y_offset = 40;
                    end
                    end
            end
			ready_walk: 
                begin
				Next_state_walk = walk1; 

                if (mogu_eaten != 1)
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 19;
                        y_offset = 20;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 19;
                        y_offset = 0;
                        end  
                end 
                else
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 61;
                        y_offset = 40;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 0;
                        y_offset = 40;
                        end  
                end   
                
                
                end


			walk1 : 
                begin
				Next_state_walk = walk2;

                if (mogu_eaten != 1)
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 39;
                        y_offset = 20;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 39;
                        y_offset = 0;
                        end
                end
                else
                 begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 82;
                        y_offset = 40;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 20;
                        y_offset = 40;
                        end
                end

                end
			walk2 : 
                begin
				Next_state_walk = walk3;

                if (mogu_eaten != 1)
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 39;
                        y_offset = 20;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 39;
                        y_offset = 0;
                        end
                end
                else
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 82;
                        y_offset = 40;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 20;
                        y_offset = 40;
                        end
                end

                end
			walk3 : 
                begin
				Next_state_walk = walk4;

                if (mogu_eaten != 1)
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 58;
                        y_offset = 20;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 58;
                        y_offset = 0;
                        end
                end
                else
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 103;
                        y_offset = 40;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 41;
                        y_offset = 40;
                        end
                end

                end
            walk4 : 
                begin
				Next_state_walk = walk5;

                if (mogu_eaten != 1)
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 58;
                        y_offset = 20;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 58;
                        y_offset = 0;
                        end
                end
                else
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 103;
                        y_offset = 40;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 41;
                        y_offset = 40;
                        end
                end


                end
            walk5 : 
                begin
				Next_state_walk = walk6;

                if (mogu_eaten != 1)
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 77;
                        y_offset = 20;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 77;
                        y_offset = 0;
                        end
                end
                else
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 61;
                        y_offset = 40;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 0;
                        y_offset = 40;
                        end
                end

                end
            walk6 : 
                begin
                Next_state_walk = stand_walk;

                 if (mogu_eaten != 1)
                begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 77;
                        y_offset = 20;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 77;
                        y_offset = 0;
                        end
                end
                else
                 begin
                    if (!right_on && left_on)
                        begin
                        right = 1'b0;
                        left = 1'b1;
                        x_offset = 61;
                        y_offset = 40;
                        end
                        else
                        begin
                        right = 1'b1;
                        left = 1'b0; 
                        x_offset = 0;
                        y_offset = 40;
                        end
                end

                end
			default : 
                begin
                    Next_state_walk = stand_walk;
                    right = 1'b1;
                    left = 1'b0; 
                    if (mogu_eaten != 1)
                    begin
                        x_offset = 19;
                        y_offset = 0;
                    end
                    else
                     begin
                        x_offset = 0;
                        y_offset = 40;
                    end
                end

		endcase
	end


   always_comb
	begin 
		Next_state = State;
		
		unique case (State)
            stand: 
            begin
                is_mario_up = 0;
				// if (can_down == 0) 
                // begin
                //     Next_state = fall_ready;
                //     x_jump_offset_in = 0;
                //     y_jump_offset_in = 0;
                // end
                
                    if (up_on) 
                        begin
                            Next_state = ready;
                            x_jump_offset_in = 0;
                            y_jump_offset_in = 0;
                        end
                    else
                        begin
                            Next_state = stand;
                            x_jump_offset_in = 0;
                            y_jump_offset_in = 0;
                        end
                        
            end
			ready: 
            
                begin
                   Next_state = up1; 
                   is_mario_up = 0;

                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end                    
			up1 : 
				begin
                    is_mario_up = 0;
                    if (at_brick1 || at_brick2 || at_brick3)
                        Next_state = still;
                    else
                        Next_state = up2; 
                                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
			up2 : 
				begin
                    is_mario_up = 0;
                     if (at_brick1 || at_brick2 || at_brick3)
                        Next_state = still;
                    else
                        Next_state = up3; 
                                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
			up3 : 
				begin
                    is_mario_up = 0;
                     if (at_brick1 || at_brick2 || at_brick3)
                        Next_state = still;
                    else
                        Next_state = up4; 
                                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
            up4 : 
				begin
                    is_mario_up = 0;
                     if (at_brick1 || at_brick2 || at_brick3)
                        Next_state = still;
                    else
                        Next_state = up5; 
                                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
            up5 : 
				begin
                    is_mario_up = 0;
                        Next_state = down0; 
                                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
            still : 
				begin
                    is_mario_up = 1;
                        Next_state = fall; 
                                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
            down0 : 
            begin
                is_mario_up = 0;
                if (can_down == 0) 
                     Next_state = fall_ready;
                else
                   Next_state = down1;
                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
			down1 :
            begin
                    is_mario_up = 0;
                    if (can_down == 0) 
                        Next_state = fall_ready;
                    else
                        Next_state = down2;
                               if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
            down2 :
			begin
                    is_mario_up = 0;
                if (can_down == 0) 
                     Next_state = fall_ready;
                else
                   Next_state = down3;

                               if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
            down3 :
            begin
                    is_mario_up = 0;
                if (can_down == 0) 
                     Next_state = fall_ready;
                else
                   Next_state = down4;
                                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
            down4 :
            begin
                is_mario_up = 0;
                if (can_down == 0) 
                     Next_state = fall_ready;
                else
                   Next_state = stand;
                                if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
                
        
			
            fall_ready:
            begin
                is_mario_up = 0;
            if (can_down == 1) 
                Next_state = fall;
            else
                Next_state = fall_ready;

                            if (mogu_eaten != 1)
                begin
                   if (left == 1'b1)
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 20;
                    end
                    else
                    begin
                        x_jump_offset_in = 100;
                        y_jump_offset_in = 0;
                    end
                end
                else
                begin
                    if (left == 1'b1)
                    begin
                        x_jump_offset_in = 20;
                        y_jump_offset_in = 76;
                    end
                    else
                    begin
                        x_jump_offset_in = 0;
                        y_jump_offset_in = 76;
                   
                    end
                end  
                end
           
            fall:
                begin
                    is_mario_up = 0;
                    Next_state = stand;
                    x_jump_offset_in = 0;
                    y_jump_offset_in = 0;
                end

			default : 
                begin
                    is_mario_up = 0;
					Next_state = stand;
                    x_jump_offset_in = 0;
                    y_jump_offset_in = 0;
                end

		endcase
	end

    

    always_ff @ (posedge Reset or posedge Clk_5Hz or posedge dead_reset)
    begin: Move_Mario
        if (Reset)  // Asynchronous Reset
        begin 
            Mario_Y_Motion <= 10'b0; //Mario_Y_Step;
            Mario_X_Motion <= 10'b0; //Mario_X_Step;
            Mario_Y_Pos <= Mario_Y_Home;
            Mario_X_Pos <= Mario_X_Home;
            x_jump_offset <= jump_offset;
            y_jump_offset <= jump_offset;
            State <= stand;
            State_walk <= stand_walk;
        end
        else if (dead_reset)
        begin
            Mario_Y_Motion <= 10'b0; //Mario_Y_Step;
            Mario_X_Motion <= 10'b0; //Mario_X_Step;
            Mario_Y_Pos <= Mario_Y_Home;
            Mario_X_Pos <= Mario_X_Home;
            x_jump_offset <= jump_offset;
            y_jump_offset <= jump_offset;
            State <= stand;
            State_walk <= stand_walk;
        end
        else
        begin 
            // if (mogu_eaten != 1)
            begin
                x_jump_offset <= x_jump_offset_in;
                y_jump_offset <= y_jump_offset_in;
                Mario_Y_Pos <= Mario_Y_Pos_in;
                Mario_Y_Motion <= Mario_Y_Motion_in;
                State <= Next_state;
                State_walk <= Next_state_walk;
            end
            // else if (Mario_Y_Pos_in != 10'd0)
            // begin
            //     x_jump_offset <= x_jump_offset_in;
            //     y_jump_offset <= y_jump_offset_in;
            //     Mario_Y_Pos <= (Mario_Y_Pos_in);
            //     Mario_Y_Motion <= Mario_Y_Motion_in;
            //     State <= Next_state;
            //     State_walk <= Next_state_walk;
            // end
            // else 
            // begin
            //     x_jump_offset <= x_jump_offset_in;
            //     y_jump_offset <= y_jump_offset_in;
            //     Mario_Y_Pos <= (Mario_Y_Pos_in - 14);
            //     Mario_Y_Motion <= Mario_Y_Motion_in;
            //     State <= Next_state;
            //     State_walk <= Next_state_walk;
            // end
        end

    end

    always_comb
    begin
        
        
				
//        case (keycode)
            // 8'h04 : begin
            // 			Mario_X_Motion <= -1;//A
            // 			Mario_Y_Motion<= 0;
            // 		end
                    
            // 8'h07 : begin	
            //             Mario_X_Motion <= 1;//D
            // 		    Mario_Y_Motion <= 0;
            // 		end

            // 8'h16 : begin
            //             Mario_Y_Motion_in = Mario_X_Step;//S
            //             end
           if(State == stand )
           begin
                //  if (at_tube1)
                //     Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                // else if (at_tube2)
                //     Mario_Y_Motion_in = (jump_down_tube2 - Mario_Y_Pos_in);
                // else if (at_tube3)
                //     Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                // else if (at_tube4)
                //     Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                // else if (at_tube5)
                //     Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                // else if (at_tube6)
                //     Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                // else if (at_brick1)
                //     Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                // else if (at_brick2)
                //     Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                // else if (at_brick3)
                //     Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                // else
                    Mario_Y_Motion_in = (Mario_Y_Home - Mario_Y_Pos_in);
           end
            else if(State == up1 )
            begin
                if (at_brick1 || at_brick2 || at_brick3)
                    Mario_Y_Motion_in = (jump_up_brick - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = (~(jump_Step1) + 1'b1);//W
            end	  
            else if(State == up2)
            begin
                if (at_brick1 || at_brick2 || at_brick3)
                    Mario_Y_Motion_in = (jump_up_brick - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = (~(jump_Step2) + 1'b1);//W
            end	  
            else if(State == up3)
            begin
                if (at_brick1 || at_brick2 || at_brick3)
                    Mario_Y_Motion_in = (jump_up_brick - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = (~(jump_Step3) + 1'b1);//W
            end	 
            else if(State == up4)
            begin
                if (at_brick1 || at_brick2 || at_brick3)
                    Mario_Y_Motion_in = (jump_up_brick - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = (~(jump_Step4) + 1'b1);//W
            end	 
            else if(State == up5)
            begin
                if (at_brick1 || at_brick2 || at_brick3)
                    Mario_Y_Motion_in = (jump_up_brick - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = (~(jump_Step5) + 1'b1);//W
            end	 
             else if(State == down0)
            begin
                 if (at_tube1)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube2)
                    Mario_Y_Motion_in = (jump_down_tube2 - Mario_Y_Pos_in);
                else if (at_tube3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube4)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube5)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube6)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_brick1)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick2)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = 0;//W
                // Mario_Y_Motion_in = jump_Step1;//W
                    
            end	 
            else if(State == down1 )
            begin
                 if (at_tube1)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube2)
                    Mario_Y_Motion_in = (jump_down_tube2 - Mario_Y_Pos_in);
                else if (at_tube3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube4)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube5)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube6)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_brick1)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick2)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = jump_down1;//W
                
            end	  

            else if(State == down2 )
            begin
                 if (at_tube1)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube2)
                    Mario_Y_Motion_in = (jump_down_tube2 - Mario_Y_Pos_in);
                else if (at_tube3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube4)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube5)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube6)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_brick1)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick2)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = jump_down2;
            end	  

            else if(State == down3 )
            begin
                 if (at_tube1)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube2)
                    Mario_Y_Motion_in = (jump_down_tube2 - Mario_Y_Pos_in);
                else if (at_tube3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube4)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube5)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube6)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_brick1)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick2)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = jump_down3;
                //  Mario_Y_Motion_in = 10'd0;//W
            end	  

            else if(State == down4)
            begin
                if (at_tube1)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube2)
                    Mario_Y_Motion_in = (jump_down_tube2 - Mario_Y_Pos_in);
                else if (at_tube3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube4)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_tube5)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_tube6)
                    Mario_Y_Motion_in = (jump_down_tube1 - Mario_Y_Pos_in);
                else if (at_brick1)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick2)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else if (at_brick3)
                    Mario_Y_Motion_in = (jump_down_tube3 - Mario_Y_Pos_in);
                else
                    Mario_Y_Motion_in = 10'd0;
            end	
            else if(State == fall && can_down == 1 )
            begin
                Mario_Y_Motion_in = (Mario_Y_Home - Mario_Y_Pos_in);//W
            end	
             else if(State == still)
            begin
                Mario_Y_Motion_in =10'd0;//W
            end	 
            else
                Mario_Y_Motion_in = 10'b0;
        
        
         
//        if (frame_clk_rising_edge) 
//        begin 
        // if ( (Mario_Y_Pos + Mario_Y_Size + Mario_Y_Motion_in) > Mario_Y_Max )  
        //     Mario_Y_Motion_in = 10'b0;
                
        // else if ( (Mario_Y_Pos + Mario_Y_Motion_in) < Mario_Y_Min )  
        //     Mario_Y_Motion_in = 10'b0;
        // else
        //     ;

        Mario_Y_Pos_in = (Mario_Y_Pos + Mario_Y_Motion);

				 
    end
       

   
    // assign MarioS = Mario_Size;

    assign MarioS_X = Mario_X_Size;

    assign MarioS_Y = Mario_Y_Size;

    assign MarioX = Mario_X_Pos;

     always_comb
    begin 
        if (mogu_eaten != 1)
            MarioY = Mario_Y_Pos;
        else
            MarioY = (Mario_Y_Pos - 32);
    end 
    
    // assign MarioY = Mario_Y_Pos;
    

endmodule
