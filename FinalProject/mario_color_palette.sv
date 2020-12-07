module mario_palette (
               output [9:0] MarioX_pixel, MarioY_pixel, marioX_counter, marioY_counter,
               input logic [4:0]mario_num,
               input logic Clk,
               input logic mario_on,
               output logic [7:0] R, G, B
               );
					
    logic [23:0] out;
    logic [19:0] start_address;
    logic [19:0] read_address;
    assign R = out[23:16];
    assign G = out[15:8];
    assign B = out[7:0];

    logic [3:0] index;


    always_ff @ (posedge Clk)
    begin
    if (mario_on)
        begin
            case (mario_num)
                5'd1:  start_address <= 19'd0;
                5'd2:  start_address <= 19'd4;
                5'd3:  start_address <= 19'd8;
                5'd4:  start_address <= 19'd12;
                5'd5:  start_address <= 19'd16;
                5'd6:  start_address <= 19'd20;
                5'd7:  start_address <= 19'd230;
                5'd8:  start_address <= 19'd234;
                5'd9:  start_address <= 19'd238;
                5'd10:  start_address <= 19'd242;
                5'd11:  start_address <= 19'd246;
            endcase

            marioX_counter <= marioX_counter + 1;
            if (marioX_counter % 8 == 0)
            begin
                marioX_counter <= 0;
                MarioX_pixel <= MarioX_pixel + 1;
            end
            
            
				// Not all marios are 3 * 4
            if (mario_num <= 11 && MarioX_pixel == 3)
            begin
                MarioX_pixel <= 0;
                marioY_counter <= marioY_counter + 1;
                if (marioY_counter % 8 == 0)
                begin
                    marioY_counter <= 0;
                    MarioY_pixel <= MarioY_pixel + 1;
                end
            end
            if (mario_num <= 11 && MarioY_pixel == 4)
            begin
                MarioX_pixel <= 0;
                MarioY_pixel <= 0;
            end
                

            read_address <= start_address + MarioX_pixel + MarioY_pixel*46;

        end
    end

    mario_frameRAM get_mario
        (
		.read_address(read_address),
		.Clk(Clk),
		.data_Out(index)
        );

    always_ff @ (posedge Clk)
    begin
        case (index)
             4'd0:  out <= 24'h800080;
             4'd1:  out <= 24'hFFFDFB;
             4'd2:  out <= 24'hB53121;
             4'd3:  out <= 24'hF83800;
             4'd4:  out <= 24'hE18300;
             4'd5:  out <= 24'h1D7B01;
             4'd6:  out <= 24'hAC7C00;
             4'd7:  out <= 24'hD4E7C7;
             4'd8:  out <= 24'h057987;
             4'd9:  out <= 24'h000000;
        endcase
    end

    // '0x800080','0xFFFDFB','0xB53121','0xF83800','0xE18300','0x1D7B01','0xAC7C00','0xD4E7C7','0x057987','0x000000'


endmodule
