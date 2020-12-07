module draw_test(
    input [9:0] drawX, drawY,
    input Clk,
    output logic [7:0]  R, G, B 
);



logic [23:0] out;
logic [19:0] read_address;
logic [3:0] index;


assign R = 8'hff; 
assign G = 8'h00;
assign B = 8'h00;

//mario_frameRAM get_mario
//    (
//    .read_address(read_address),
//    .Clk(Clk),
//    .data_Out(index)
//    );

// always_ff @ (posedge Clk)
// begin
//     case (index)
//             5'd0:  out <= 24'h800080;
//             5'd1:  out <= 24'hFFFDFB;
//             5'd2:  out <= 24'hB53121;
//             5'd3:  out <= 24'hF83800;
//             5'd4:  out <= 24'hE18300;
//             5'd5:  out <= 24'h1D7B01;
//             5'd6:  out <= 24'hAC7C00;
//             5'd7:  out <= 24'hD4E7C7;
//             5'd8:  out <= 24'h057987;
//             5'd9:  out <= 24'h000000;
//     endcase
// end

//assign R = out[23:16];
//assign G = out[15:8];
//assign B = out[7:0];


endmodule
