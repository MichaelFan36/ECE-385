module slowClock_5HZ_mogu ( Clk, Reset, Clk_5Hz);

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

module  mogu ( 
                input Reset, 
                input Clk,
                input frame_clk,
				input [31:0] keycode,
                input [9:0] DrawX, DrawY,
                input [8:0] BG_step,
                input logic can_down, is_mario_up,
                input logic dead_reset,


                output [7:0]  Red, Green, Blue,
                output logic mogu_eaten,
                inout is_mogu
               );
    
    
    logic [9:0] mogu_X_Pos, mogu_X_Motion, mogu_Y_Pos, mogu_Y_Motion, mogu_Size,mogu_X_Size,mogu_Y_Size;
	 logic [9:0] mogu_Y_Pos_in, mogu_X_Pos_in, mogu_X_Motion_in, mogu_Y_Motion_in;
    logic [18:0] moguReadAdd;

    parameter [9:0] mogu_X_Home= 305;  // Center position on the X axis 400
    parameter [9:0] mogu_Y_Home= 243;  // Center position on the Y axis 270
    // parameter [9:0] mogu_X_Min=0;       // Leftmost point on the X axis
    // parameter [9:0] mogu_X_Max=0;     // Rightmost point on the X axis
    // parameter [9:0] mogu_Y_Min=10;       // Topmost point on the Y axis
    // parameter [9:0] mogu_Y_Max=400;     // Bottommost point on the Y axis
    // parameter [9:0] mogu_X_Step=4;      // Step size on the X axis
    // parameter [9:0] mogu_Y_Step=4;      // Step size on the Y axis

    
    parameter [9:0] ground_pos = 420;

    assign mogu_X_Size = 32;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign mogu_Y_Size = 32;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
    enum logic [3:0] {ready, fall, disappear} State, Next_state;
    logic is_on;

    // assign up_on = (keycode[31:24] == 8'h1A | keycode[23:16] == 8'h1A | keycode[15: 8] == 8'h1A | keycode[ 7: 0] == 8'h1A);
    // assign down_on = (keycode[31:24] == 8'h16 | keycode[23:16] == 8'h16 | keycode[15: 8] == 8'h16 | keycode[ 7: 0] == 8'h16);
    // assign left_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
    // assign right_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);

    logic Clk_5Hz;

    slowClock_5HZ_mogu Clock_5Hz_mogu(.Clk(Clk), .Reset(Reset), .Clk_5Hz(Clk_5Hz));

   always_comb
	begin 
		Next_state = State;
		
		unique case (State)
            ready: 
				if (BG_step >= 45 && BG_step<=65 && is_mario_up)   
                    begin
					Next_state = fall;
                    is_on = 1'b1;
                    mogu_eaten = 0;
                    end
                else
                    begin
                    Next_state = ready;
                    is_on = 1'b0;
                    // is_on = 1'b1;
                    mogu_eaten = 0;
                    end
			fall: 
            begin
                if (can_down)
                begin
                    Next_state = disappear;
                    is_on = 1'b1;
                    mogu_eaten = 0;
                end
                else
                begin
                    Next_state = fall;
                    // is_on = 1'b0;
                    is_on = 1'b1;
						  mogu_eaten = 0;
                end
            end

            disappear:
            begin
                Next_state = disappear;
                is_on = 1'b0;
                    // is_on = 1'b1;
                    mogu_eaten = 1;
            end
              

			default : 
                begin
                    Next_state = ready;
                    is_on = 1'b0;
                    mogu_eaten = 0;
                end
		endcase
	end



    always_comb
    begin
        if (State == fall && can_down == 1)
            begin
                mogu_Y_Motion_in = (ground_pos - mogu_X_Pos);
            end
        else
            begin
                mogu_Y_Motion_in = 10'd0;
            end
   
        // mogu_X_Pos_in = (mogu_X_Pos + mogu_X_Motion);
        mogu_Y_Pos_in = (mogu_Y_Pos + mogu_Y_Motion);
    end
       
    always_ff @ (posedge Reset or posedge Clk_5Hz or posedge dead_reset )
    begin: Move_mogu
        if (Reset)  // Asynchronous Reset
        begin 
            mogu_Y_Motion <= 10'b0; //mogu_Y_Step;
            // mogu_X_Motion <= 10'b0; //mogu_X_Step;
            mogu_Y_Pos <= mogu_Y_Home;
            mogu_X_Pos <= mogu_X_Home;
            State <= ready;
        end
        else if (dead_reset)
        begin
            mogu_Y_Motion <= 10'b0; //mogu_Y_Step;
            // mogu_X_Motion <= 10'b0; //mogu_X_Step;
            mogu_Y_Pos <= mogu_Y_Home;
            mogu_X_Pos <= mogu_X_Home;
            State <= ready;
        end
        else
        begin  
            // mogu_X_Pos <= mogu_X_Pos_in;
            mogu_Y_Pos <= mogu_Y_Pos_in;
            mogu_Y_Motion <= mogu_Y_Motion_in;
            // mogu_X_Motion <= mogu_X_Motion_in;
            State <= Next_state;
        end

    end

    int DistX, DistY;
	assign DistX = DrawX - mogu_X_Pos;
	assign DistY = DrawY - mogu_Y_Pos;
	always_comb begin
		if (((DrawX >= mogu_X_Pos) && (DrawY >= mogu_Y_Pos)) && ((DistX < mogu_X_Size) && (DistY < mogu_Y_Size)) && is_on) // 292
			is_mogu = 1'b1;
		else
			is_mogu = 1'b0;
	end

    int enlarge_DrawX, enlarge_DrawY;
	assign enlarge_DrawX = (DrawX - mogu_X_Pos)/ 2;
    assign enlarge_DrawY = (DrawY - mogu_Y_Pos)/2;
    always_comb 
    begin
		moguReadAdd = 18'b0;
		if (is_mogu) begin
            moguReadAdd = (enlarge_DrawX + 112 + 46) + (enlarge_DrawY+99 + 16) * 188;
        end
    end
       
    logic [3:0] data_sprite;

mario_frameRAM _mogu_frameRAM(.read_address(moguReadAdd), .data_Out(data_sprite), .*);

always_comb
begin
    Red = 8'hff;
    Green = 8'h00;
    Blue = 8'h00;
    if (is_mogu) begin
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
