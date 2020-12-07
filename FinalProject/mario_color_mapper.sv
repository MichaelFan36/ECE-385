module  mario_color_mapper ( input [9:0] MarioX, MarioY, DrawX, DrawY, Mario_size, MarioS_X, MarioS_Y,
                             input is_mario,
									  input Clk,
                             input frame_clk,
                             input [18:0] MarioReadAdd,
									  input Reset_h,
									  output [7:0]  Red, Green, Blue 
                             );

logic [3:0] data_sprite;

mario_frameRAM _mario_frameRAM(.read_address(MarioReadAdd), .data_Out(data_sprite), .*);

always_comb
begin
    Red = 8'hff;
    Green = 8'h00;
    Blue = 8'h00;
    if (is_mario) begin
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
