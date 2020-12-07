

module  mario ( 
                input Reset, 
                input Clk,
                input frame_clk,
				input [31:0] keycode,
                input can_up, can_down, can_left, can_right,
                output [9:0]  MarioX, MarioY, MarioS_X, MarioS_Y,
                output [31:0] x_offset, y_offset, x_jump_offset, y_jump_offset
               );
    
    logic [9:0] Mario_X_Pos, Mario_X_Motion, Mario_Y_Pos, Mario_Y_Motion, Mario_Size,Mario_X_Size,Mario_Y_Size;
	logic [9:0] Mario_Y_Pos_in, Mario_X_Pos_in, Mario_Y_Motion_in;
    int x_jump_offset_in, y_jump_offset_in;

    parameter [9:0] Mario_X_Home=305;  // Center position on the X axis
    parameter [9:0] Mario_Y_Home=368;  // Center position on the Y axis
    parameter [9:0] Mario_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Mario_X_Max=0;     // Rightmost point on the X axis
    parameter [9:0] Mario_Y_Min=10;       // Topmost point on the Y axis
    parameter [9:0] Mario_Y_Max=400;     // Bottommost point on the Y axis
    parameter [9:0] Mario_X_Step=4;      // Step size on the X axis
    parameter [9:0] Mario_Y_Step=4;      // Step size on the Y axis
    parameter [9:0] jump_Step1=60;      // Step size on the Y axis
    parameter [9:0] jump_Step2=50;      // Step size on the Y axis
    parameter [9:0] jump_Step3=45;      // Step size on the Y axis
    parameter [9:0] jump_Step4=35;      // Step size on the Y axis
    parameter [9:0] jump_Step5=0;      // Step size on the Y axis
    parameter [31:0] jump_offset = 0;

    assign Mario_X_Size = 34;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign Mario_Y_Size = 32;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
    enum logic [6:0] {stand, up1, up2, up3, up4, up5, down0,down1, down2, down3,down4, ready, fall_ready, fall} State, Next_state;
    enum logic [6:0] {stand_walk, walk1, walk2, walk3, walk4, walk5, walk6, ready_walk} State_walk, Next_state_walk;
    logic right, left;
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
                    Next_state_walk = stand_walk;
                    right = 1'b1;
                    left = 1'b0; 
                    x_offset = 19;
                    y_offset = 0;
                    end
            end
			ready_walk: 
                begin
				Next_state_walk = walk1;     
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
			walk1 : 
                begin
				Next_state_walk = walk2;
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
			walk2 : 
                begin
				Next_state_walk = walk3;
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
			walk3 : 
                begin
				Next_state_walk = walk4;
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
            walk4 : 
                begin
				Next_state_walk = walk5;
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
            walk5 : 
                begin
				Next_state_walk = walk6;
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
            walk6 : 
                begin
                Next_state_walk = stand_walk;
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
			default : 
                begin
				Next_state_walk = stand_walk;
                right = 1'b1;
                left = 1'b0; 
                x_offset = 19;
                y_offset = 0;
                end

		endcase
	end


   always_comb
	begin 
		Next_state = State;
		
		unique case (State)
            stand: 
            begin
				if (up_on) 
                    begin
						  Next_state = ready;
                    x_jump_offset_in = 0;
                    y_jump_offset_in = 0;
                    end
                else if (can_down) 
                    begin
                    Next_state = fall_ready;
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
			up1 : 
				begin
                   Next_state = up2; 
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
			up2 : 
				begin
                   Next_state = up3; 
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
			up3 : 
				begin
                   Next_state = up4; 
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
            up4 : 
				begin
                   Next_state = up5; 
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
            up5 : 
				begin
                   Next_state = down0; 
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
            down0 : 
            begin
                if (can_down == 0) 
                     Next_state = stand;
                else
                   Next_state = down1;
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
			down1 :
                begin
                if (can_down == 0) 
                     Next_state = stand;
                else
                   Next_state = down2;
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
            down2 :
				begin
                if (can_down == 0) 
                     Next_state = stand;
                else
                   Next_state = down3;
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
            down3 :
                begin
                if (can_down == 0) 
                     Next_state = stand;
                else
                   Next_state = down4;
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
            down4 :
            begin
                if (can_down == 0) 
                     Next_state = stand;
                else
                   Next_state = stand;
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
                
        
			
            fall_ready:
            begin
            if (can_down) 
                Next_state = fall;
            else
                Next_state = fall_ready;
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
           
            fall:
                begin
                Next_state = stand;
                x_jump_offset_in = 0;
                y_jump_offset_in = 0;
                end

			default : 
                begin
						  Next_state = stand;
                    x_jump_offset_in = 0;
                    y_jump_offset_in = 0;
                end

		endcase
	end

    

    always_ff @ (posedge Reset or posedge Clk_5Hz )
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
        else
        begin 
            x_jump_offset <= x_jump_offset_in;
            y_jump_offset <= y_jump_offset_in;
            Mario_Y_Pos <= Mario_Y_Pos_in;
            Mario_Y_Motion <= Mario_Y_Motion_in;
            State <= Next_state;
            State_walk <= Next_state_walk;
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
           
            if(State == up1 )
            begin
                Mario_Y_Motion_in = (~(jump_Step1) + 1'b1);//W
            end	  
            else if(State == up2)
            begin
                Mario_Y_Motion_in = (~(jump_Step2) + 1'b1);//W
            end	  
            else if(State == up3)
            begin
                Mario_Y_Motion_in = (~(jump_Step3) + 1'b1);//W
            end	 
            else if(State == up4)
            begin
                Mario_Y_Motion_in = (~(jump_Step4) + 1'b1);//W
            end	 
            else if(State == up5)
            begin
                Mario_Y_Motion_in = (~(jump_Step5) + 1'b1);//W
            end	 
             else if(State == down0)
            begin
                Mario_Y_Motion_in = jump_Step1;//W
            end	 
            else if(State == down1 && can_down == 1)
            begin
                Mario_Y_Motion_in = jump_Step2;//W
            end	  
            else if(State == down1 && can_down == 0)
            begin
                Mario_Y_Motion_in = 10'd0;//W
            end	  
            else if(State == down2 && can_down == 1)
            begin
                Mario_Y_Motion_in = jump_Step3;
            end	  
            else if(State == down2 && can_down == 0)
            begin
                Mario_Y_Motion_in = 10'd0;//W
            end	
            else if(State == down3 && can_down == 1)
            begin
                Mario_Y_Motion_in = jump_Step5;
            end	  
            else if(State == down3 && can_down == 0)
            begin
                Mario_Y_Motion_in = 10'd0;//W
            end	
            else if(State == down4 && can_down == 1)
            begin
                Mario_Y_Motion_in = (Mario_Y_Home - Mario_Y_Pos_in);
            end	  
            else if(State == fall && can_down == 1 )
            begin
                Mario_Y_Motion_in = (Mario_Y_Home - Mario_Y_Pos_in);//W
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

				
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Mario_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Mario_Y_pos.  Will the new value of Mario_Y_Motion be used,
          or the old?  How will this impact behavior of the Mario during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
//		end  
    end
       

   
    // assign MarioS = Mario_Size;

    assign MarioS_X = Mario_X_Size;

    assign MarioS_Y = Mario_Y_Size;
    assign MarioX = Mario_X_Pos;
    
    assign MarioY = Mario_Y_Pos;
    

endmodule
