/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [127:0] AES_MSG_DEC;
	logic [127:0] AES_KEY;
	logic [127:0] AES_MSG_ENC;
	logic AES_DONE;
	logic [31:0] reg_file[15:0];
	always_ff @ (posedge CLK) begin
		if (RESET) 
		begin
			reg_file[0] <= 32'd0;
			reg_file[1] <= 32'd0;
			reg_file[2] <= 32'd0;
			reg_file[3] <= 32'd0;
			reg_file[4] <= 32'd0;
			reg_file[5] <= 32'd0;
			reg_file[6] <= 32'd0;
			reg_file[7] <= 32'd0;
			reg_file[8] <= 32'd0;
			reg_file[9] <= 32'd0;
			reg_file[10] <= 32'd0;
			reg_file[11] <= 32'd0;
			reg_file[12] <= 32'd0;
			reg_file[13] <= 32'd0;
			reg_file[14] <= 32'd0;
			reg_file[15] <= 32'd0;
		end
		else if (AVL_WRITE && AVL_CS) 
			begin
				if (AVL_BYTE_EN[0])
					reg_file[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
				if (AVL_BYTE_EN[1])
					reg_file[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
				if (AVL_BYTE_EN[2])
					reg_file[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				if (AVL_BYTE_EN[3])
					reg_file[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
			end
			reg_file[15][0] <= AES_DONE;
			reg_file[11] <= AES_MSG_DEC[31:0];
			reg_file[10] <= AES_MSG_DEC[63:32];
			reg_file[9] <= AES_MSG_DEC[95:64];
			reg_file[8] <= AES_MSG_DEC[127:96];
	end
	
	assign AVL_READDATA = (AVL_READ && AVL_CS) ? reg_file[AVL_ADDR] : AVL_READDATA;

	assign EXPORT_DATA = {{reg_file[8][31:16]}, {reg_file[11][15:0]}};
	
	assign AES_KEY = {reg_file[0], reg_file[1], reg_file[2], reg_file[3]};
	
	assign AES_MSG_ENC = {reg_file[4], reg_file[5], reg_file[6], reg_file[7]};

	AES aes (
		.CLK, 
		.RESET, 
		.AES_START(reg_file[14][0]), 
		.AES_DONE, 
		.AES_KEY, 
		.AES_MSG_ENC, 
		.AES_MSG_DEC
	);
	
endmodule
