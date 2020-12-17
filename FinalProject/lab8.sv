//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8 (

      ///////// Clocks /////////
      input              Clk,

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [31:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	lab8_soc u0 (
		.clk_clk                           (Clk),            //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.

// Initialize variables
logic [7:0] Red, Blue, Green;
logic [9:0] drawxsig, drawysig, marioxsig, marioysig, mario_sizex, mario_sizey, kubaxsig, kubaysig, kuba_sizex, kuba_sizey,firexsig, fireysig, fire_sizex, fire_sizey;
wire  [9:0] marioX_counter, marioY_counter;
logic [18:0] MarioReadAdd, KubaReadAdd;
logic [7:0] mario_Red, mario_Blue, mario_Green;
logic [7:0] BG_Red, BG_Blue, BG_Green;
logic [7:0] mogu_Red, mogu_Blue, mogu_Green;
logic [7:0] kuba_Red, kuba_Blue, kuba_Green;
logic [7:0] fire_Red, fire_Blue, fire_Green;
logic [7:0] Start_Red, Start_Blue, Start_Green;
logic [7:0] Princess_Red, Princess_Blue, Princess_Green;
logic [7:0] live_Red1, live_Green1, live_Blue1, live_Red2, live_Green2, live_Blue2, live_Red3, live_Green3, live_Blue3;
logic is_mario, is_BG,is_jump, is_mario_up;
wire [8:0] dead_times;
wire is_kuba, is_fire, game_on, is_life1, is_life2, is_life3, is_mogu, is_ending, dead_reset, is_princess;
wire [8:0] BG_step;
int x_offset, y_offset, x_jump_offset, y_jump_offset;


logic can_up, can_down, can_left, can_right;
logic at_tube1, at_tube2, at_tube3, at_tube4, at_tube5, at_tube6, at_brick1, at_brick2, at_brick3;
logic is_kuba_appeared, bg_cur_displacement, mogu_eaten;

always_comb
begin 
	if (game_on)
	begin
	
	if(is_BG && !is_mario && !is_kuba && !is_fire && !is_life1 && !is_life2 && !is_life3 && !is_mogu && !is_princess)
	begin 
		Red = BG_Red;
		Green = BG_Green;
		Blue = BG_Blue; 
		if (BG_step > 400)
		begin
		Red = 8'hff;
		Green = 8'h69;
		Blue = 8'hb4; 
		end
	end
	else if(is_life1)
	begin
		Red = live_Red1;
		Green = live_Blue1;
		Blue = live_Green1;
		if (Red == 8'hff && Green == 8'h00 && Blue == 8'h00)
		begin
			Red = BG_Red;
			Green = BG_Green;
			Blue = BG_Blue;
			if (BG_step > 400)
			begin
			Red = 8'hff;
			Green = 8'h69;
			Blue = 8'hb4; 
			end
		end
	end
	else if(is_life2)
	begin
		Red = live_Red2;
		Green = live_Blue2;
		Blue = live_Green2;
		if (Red == 8'hff && Green == 8'h00 && Blue == 8'h00)
		begin
			Red = BG_Red;
			Green = BG_Green;
			Blue = BG_Blue; 
		end
		if (BG_step > 400)
		begin
		Red = 8'hff;
		Green = 8'h69;
		Blue = 8'hb4; 
		end
	end
	else if(is_life3)
	begin
		Red = live_Red3;
		Green = live_Blue3;
		Blue = live_Green3;
		if (Red == 8'hff && Green == 8'h00 && Blue == 8'h00)
		begin
			Red = BG_Red;
			Green = BG_Green;
			Blue = BG_Blue; 
		end
		if (BG_step > 400)
		begin
		Red = 8'hff;
		Green = 8'h69;
		Blue = 8'hb4; 
		end
	end
	else if(is_mario)
	begin
		Red = mario_Red;
		Green = mario_Green;
		Blue = mario_Blue;
		if (Red == 8'hff && Green == 8'h00 && Blue == 8'h00)
		begin
			Red = BG_Red;
			Green = BG_Green;
			Blue = BG_Blue;
		if (BG_step > 400)
		begin
		Red = 8'hff;
		Green = 8'h69;
		Blue = 8'hb4; 
		end	
		end
	end
	else if(is_fire)
	begin
		Red = fire_Red;
		Green = fire_Green;
		Blue = fire_Blue;
		if (Red == 8'hff && Green == 8'h00 && Blue == 8'h00)
		begin
			Red = BG_Red;
			Green = BG_Green;
			Blue = BG_Blue; 
		end
	end
	else if(is_kuba)
	begin
		Red = kuba_Red;
		Green = kuba_Green;
		Blue = kuba_Blue;
		if (Red == 8'hff && Green == 8'h00 && Blue == 8'h00)
		begin
			Red = BG_Red;
			Green = BG_Green;
			Blue = BG_Blue; 
		end
	end
	else if(is_mogu)
	begin
		Red = mogu_Red;
		Green = mogu_Green;
		Blue = mogu_Blue;
		if (Red == 8'hff && Green == 8'h00 && Blue == 8'h00)
		begin
			Red = BG_Red;
			Green = BG_Green;
			Blue = BG_Blue; 
		end
	end
	else if(is_princess)
	begin
		Red = Princess_Red;
		Green = Princess_Green;
		Blue = Princess_Blue;
		if (Red == 8'hff && Green == 8'h00 && Blue == 8'h00)
		begin
		Red = BG_Red;
			Green = BG_Green;
			Blue = BG_Blue;
		if (BG_step > 400)
		begin
		Red = 8'hff;
		Green = 8'h69;
		Blue = 8'hb4; 
		end	
		end
	end
	else
	begin
		Red = 8'h000000000;
		Green = 8'h000000000;
		Blue = 8'h000000000;
	end
	end

	else
	begin
		Red = Start_Red;
		Green = Start_Green;
		Blue = Start_Blue;
	end
end




vga_controller vga(
					.Clk(Clk), 
					.Reset(Reset_h), 
					.hs(VGA_HS),
					.vs(VGA_VS),
					.pixel_clk(VGA_Clk), 
					.blank(blank), 
					.sync(sync),
					.DrawX(drawxsig), 
					.DrawY(drawysig)
				);

mario_color_mapper _mario_color_mapper(
								.MarioX(marioxsig), 
								.MarioY(marioysig), 
								.DrawX(drawxsig), 
								.DrawY(drawysig),
								.MarioReadAdd(MarioReadAdd), 
								.MarioS_X(mario_sizex),
								.MarioS_Y(mario_sizey),
								.is_mario(is_mario),
								.Reset_h(Reset_h),
								.Clk(Clk),
								.frame_clk(VGA_VS), 

								.Red(mario_Red),
								.Green(mario_Green), 
								.Blue(mario_Blue)
							);

Read_Address _mario_read_address(
										.is_mario(is_mario),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.X_Pos(marioxsig), 
										.Y_Pos(marioysig),
										.keycode(keycode),
										.x_offset(x_offset),
										.y_offset(y_offset),
										.x_jump_offset(x_jump_offset),
										.y_jump_offset(y_jump_offset),

										.marioX_counter(marioX_counter),
										.marioY_counter(marioY_counter),
										.read_address(MarioReadAdd)
);

draw _draw_mario(
			.X_pos(marioxsig), 
			.Y_pos(marioysig),
			.DrawX(drawxsig), 
			.DrawY(drawysig),
			.Size_X(mario_sizex),
			.Size_Y(mario_sizey),

			.is_this(is_mario)
);


wall_detector wall_detector_mario(
    .x_pos(marioxsig), 
    .y_pos(marioysig),
    .x_size(34), 
    .y_size(32),
    .bg_step(BG_step),

    .can_up(can_up), 
	.can_down(can_down), 
	.can_left(can_left), 
	.can_right(can_right),
	.at_tube1(at_tube1), .at_tube2(at_tube2), .at_tube3(at_tube3), .at_tube4(at_tube4), .at_tube5(at_tube5), .at_tube6(at_tube6),
	.at_brick1(at_brick1), .at_brick2(at_brick2), .at_brick3(at_brick3)
);


mario _mario(
			.Reset(Reset_h),
			.Clk(Clk),
			.frame_clk(VGA_VS), 
			.keycode(keycode),
			.can_up(can_up), 
			.can_down(can_down), 
			.can_left(can_left), 
			.can_right(can_right),
			.at_tube1(at_tube1), .at_tube2(at_tube2), .at_tube3(at_tube3), .at_tube4(at_tube4), .at_tube5(at_tube5), .at_tube6(at_tube6),
			.at_brick1(at_brick1), .at_brick2(at_brick2), .at_brick3(at_brick3),
			.mogu_eaten(mogu_eaten),
			.dead_reset(dead_reset),

			.MarioX(marioxsig), 
			.MarioY(marioysig), 
			.MarioS_X(mario_sizex),
			.MarioS_Y(mario_sizey),
			.x_offset(x_offset),
			.y_offset(y_offset),
			.x_jump_offset(x_jump_offset),
			.y_jump_offset(y_jump_offset),
			.is_mario_up(is_mario_up)
		);

Kuba _kuba(
			.Reset(Reset_h), 
			.Clk(Clk),
			.frame_clk(VGA_VS),
			.keycode(keycode),
			.DrawX(drawxsig), 
			.DrawY(drawysig),
			.BG_step(BG_step),
			.dead_reset(dead_reset),

			.is_kuba(is_kuba),
			.Red_kuba(kuba_Red), 
			.Green_kuba(kuba_Green), 
			.Blue_kuba(kuba_Blue)
		);

Fire _fire(
			.Reset(Reset_h), 
			.Clk(Clk),
			.frame_clk(VGA_VS),
			.keycode(keycode),
			.DrawX(drawxsig), 
			.DrawY(drawysig),
			.BG_step(BG_step),
			.MarioX(marioxsig), 
			.MarioY(marioysig), 
			.MarioS_X(mario_sizex),
			.MarioS_Y(mario_sizey),
			.dead_reset(dead_reset),

			.dead_times(dead_times),
			.is_fire(is_fire),
			.Red(fire_Red), 
			.Green(fire_Green), 
			.Blue(fire_Blue),
			.FireX(firexsig), 
			.FireY(fireysig), 
			.FireS_X(fire_sizex), 
			.FireS_Y(fire_sizex)
		);

Background  _Background ( 
						.Reset(Reset_h), 
						.Clk(Clk),
						.frame_clk(VGA_VS),
						.keycode(keycode),
						.DrawX(drawxsig), 
						.DrawY(drawysig),
						.Mario_X_Pos(marioxsig), 
						.Mario_Y_Pos(marioysig),
						.BG_step(BG_step),
						.is_mario(is_mario),
						.dead_reset(dead_reset),


						.is_BG(is_BG),
						.Red(BG_Red), 
						.Green(BG_Green), 
						.Blue(BG_Blue)
						
               );

Beginning  _Beginning ( 
						.Reset(Reset_h), 
						.Clk(Clk),
						.frame_clk(VGA_VS),
						.keycode(keycode),
						.BG_step(BG_step),
						.DrawX(drawxsig), 
						.DrawY(drawysig),
						.dead_reset(dead_reset),
						.is_life2(is_life2),

						.game_on(game_on),
						.Red(Start_Red), 
						.Green(Start_Green), 
						.Blue(Start_Blue)
						
               );

Life	_Life (
			.Reset(Reset_h), 
			.Clk(Clk),
			.frame_clk(VGA_VS),
			.DrawX(drawxsig), 
			.DrawY(drawysig),
			.dead_times(dead_times),

			.is_life1(is_life1),
			.is_life2(is_life2),
			.is_life3(is_life3),
			.Red1(live_Red1), 
			.Green1(live_Green1), 
			.Blue1(live_Blue1),
			.Red2(live_Red2), 
			.Green2(live_Green2), 
			.Blue2(live_Blue2),
			.Red3(live_Red3), 
			.Green3(live_Green3), 
			.Blue3(live_Blue3)
);

mogu  _mogu ( 
                .Reset(Reset_h), 
				.Clk(Clk),
				.frame_clk(VGA_VS),
				.DrawX(drawxsig), 
				.DrawY(drawysig),
				.keycode(keycode),
                .BG_step(BG_step),
				.can_down(can_down),
				.is_mario_up(is_mario_up),
				.dead_reset(dead_reset),


				.is_mogu(is_mogu),
				.Red(mogu_Red), 
				.Green(mogu_Green), 
				.Blue(mogu_Blue),
				.mogu_eaten(mogu_eaten)
               );

Princess  _Princess ( 
                .Reset(Reset_h), 
				.Clk(Clk),
				.frame_clk(VGA_VS),
				.DrawX(drawxsig), 
				.DrawY(drawysig),
				.keycode(keycode),
                .BG_step(BG_step),


				.is_princess(is_princess),
				.Red(Princess_Red), 
				.Green(Princess_Green), 
				.Blue(Princess_Blue),
               );

endmodule
