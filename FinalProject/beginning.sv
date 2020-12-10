module slowClock_5HZ_begin ( Clk, Reset, Clk_5Hz);

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

module  Beginning ( 
                input Reset, 
                input Clk,
                input frame_clk,
				input [31:0] keycode,
					 input [8:0] BG_step,
                input [9:0]  DrawX, DrawY,
                input is_life2, dead_reset,

				output game_on,
                output [7:0]  Red, Green, Blue
               );
    
    logic [9:0] Begin_X_Pos, Begin_X_Motion, Begin_Y_Pos, Begin_Y_Motion, Begin_X_Size, Begin_Y_Size;
    logic [18:0] read_address;
    logic [2:0] data_sprite;
    int enlarge_DrawX, enlarge_DrawY;
    logic game_on_in, offset;
	logic is_Begin;
    parameter [9:0] Begin_X_Home=290;  // Center position on the X axis
    parameter [9:0] Begin_Y_Home=170;  // Center position on the Y axis
    parameter [9:0] Begin_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Begin_X_Max=554;     // 554 Rightmost point on the X axis
    parameter [9:0] Begin_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Begin_Y_Max=55;     // 55 Bottommost point on the Y axis
    parameter [9:0] Begin_X_Step=1;      // Step size on the X axis
    parameter [9:0] Begin_Y_Step=1;      // Step size on the Y axis
    parameter off = 0;

    assign Begin_X_Size = 360;  // 73 assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign Begin_Y_Size = 415;  // 55 assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign enlarge_DrawX = DrawX/6;
    assign enlarge_DrawY = DrawY/6;

    logic dead_game;
	 assign dead_game = dead_reset && !is_life2;
    enum logic [3:0] {still, begin1, begin2, begin3, ready} State, Next_state;
	
    always_comb
    begin
        if ((keycode[31:24] == 8'h28 | keycode[23:16] == 8'h28 | keycode[15: 8] == 8'h28 | keycode[ 7: 0] == 8'h28))
        offset = 1'b1;
        else
        offset = 1'b0; 
        
        game_on_in = game_on + offset;
    end

    int begin_y_offset;

    logic Clk_5Hz;

    slowClock_5HZ_begin Clock_5Hz_begin(.Clk(Clk), .Reset(Reset), .Clk_5Hz(Clk_5Hz));

   always_comb
	begin 
		Next_state = State;
		
		unique case (State)
            still: 
                begin
				Next_state = ready;
                begin_y_offset = 0;
                end
				ready: 
                begin
                   Next_state = begin1; 
                   begin_y_offset = 0;
                end                      
            begin1: 
                begin
                   Next_state = begin2; 
                   begin_y_offset = 0;
                end     

            begin2: 
                begin
                   Next_state = begin3; 
                   begin_y_offset = 69;
                end    

            begin3: 
                begin
                   Next_state = still; 
                   begin_y_offset = 69;
                end    
            
			default : 
                begin
					Next_state = still;
                    begin_y_offset = 0;
                end

		endcase
	end

    always_ff @ (posedge Reset or posedge Clk_5Hz or posedge dead_game)
    begin: Set_begin
        if (Reset || dead_game)
        begin 
            State <= still;
            game_on <= off;
        end
        else
        begin
            State <= Next_state;
            game_on <= game_on_in;
        end

    end


    always_comb begin
		if (((DrawX >= Begin_X_Pos) && (DrawY >= Begin_Y_Pos)) && ((DrawX < Begin_X_Size) && (DrawY < Begin_Y_Size)))
			is_Begin = 1'b1;
		else
			is_Begin = 1'b0;
	end

    always_comb 
    begin
		read_address = 18'b0;
		if (is_Begin) begin
            read_address = (enlarge_DrawX - Begin_X_Pos) + (enlarge_DrawY - Begin_Y_Pos + begin_y_offset) * 60;
        end
    end

    

    end_frameRAM _end_frameRAM(.read_address(read_address), .data_Out(data_sprite), .Clk(Clk));


    always_comb
    begin
    Red = 8'h80;
    Green = 8'h00;
    Blue = 8'h80;

// '0x800080','0xE5E7E7','0xEEECEB','0xADADAD','0xC1C1C0','0xB9BCBE','0xA7968C'

    if (is_Begin) begin
        if (data_sprite == 4'd1) begin
            Red = 8'he5;
            Green = 8'he7;
            Blue = 8'he7;
        end
        if (data_sprite == 4'd2) begin
            Red = 8'hee;
            Green = 8'hec;
            Blue = 8'heb; 
        end
        if (data_sprite == 4'd3) begin
            Red = 8'had;
            Green = 8'had;
            Blue = 8'had;
        end
        if (data_sprite == 4'd4) begin
            Red = 8'hc1;
            Green = 8'hc1;
            Blue = 8'hc0;
        end
        if (data_sprite == 4'd5) begin
            Red = 8'hb9;
            Green = 8'hbc;
            Blue = 8'hbe;
        end
        if (data_sprite == 4'd6) begin
            Red = 8'ha7;
            Green = 8'h96;
            Blue = 8'h8c;
        end
    end
end
       
    

endmodule
