module testbench();


timeunit 10ns;
timeprecision 1ns;

integer ErrorCnt = 0;
logic CLK = 0;
logic RESET, AES_START, AES_DONE;
logic [127:0] AES_KEY, AES_MSG_ENC, AES_MSG_DEC;
logic [3:0] state;
logic [127:0] cur_state;
logic [3:0] round;
logic LD_AES_MSG_ENC, LD_addroundkey, LD_invsftrows, LD_invsubbytes, LD_invmixcols;
logic [1407:0] KeySchedule;

//
//logic CLK;
//
//logic RESET;
//
//logic AVL_READ;				
//logic AVL_WRITE;				
//logic AVL_CS;	
//logic AES_DONE;
//logic [3:0] AVL_BYTE_EN;	
//logic [3:0] AVL_ADDR;
//logic [31:0] AVL_WRITEDATA;
//logic [31:0] AVL_READDATA;
//logic [31:0] EXPORT_DATA;
//
//
//logic [31:0] register_file[15:0];

//avalon_aes_interface aesin(.*);

AES aesmod(.*);

always begin: CLOCK_GENERATION
   #1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
   CLK = 0;
end


always_comb begin: INTERNAL_MONITORING

   state = aesmod.state;
	cur_state = aesmod.cur_state;
	round = aesmod.round;
//	complete = aesmod.complete;
//	LD_MSG_DEC = aesmod.LD_MSG_DEC;
	LD_AES_MSG_ENC = aesmod.LD_AES_MSG_ENC;
	LD_addroundkey = aesmod.LD_addroundkey;
	LD_invsftrows = aesmod.LD_invsftrows;
	LD_invsubbytes = aesmod.LD_invsubbytes;
	LD_invmixcols = aesmod.LD_invmixcols;
	KeySchedule = aesmod.KeySchedule;

//register_file[15:0] =aesin.register_file[15:0];

//	AES_DONE = aesin.AES_DONE;
end


initial begin: TEST_VECTORS
   RESET = 0;
   AES_START = 0;
   AES_KEY     = 128'h000102030405060708090a0b0c0d0e0f;
   AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
   RESET = 1;

#2  RESET = 0;


#20; // wait for key expension

   AES_START = 1;
#2  AES_START = 0;


//#2	RESET = 1;
//#2	RESET = 0;
//
////#2 AVL_WRITEDATA = 128'h000102030405060708090a0b0c0d0e0f;
//#2 AVL_BYTE_EN = 4'b1111;
//#2 AVL_CS = 1;
//#2 AVL_READ = 1;
//
//#2 AVL_WRITE = 0;
//#2 AVL_ADDR = 4'b0000;
//#2 AVL_WRITEDATA = 32'h00010203;
//#2 AVL_WRITE = 1;
//
//#2 AVL_WRITE = 0;
//#2 AVL_ADDR = 4'b0001;
//#2 AVL_WRITEDATA = 32'h04050607;
//#2 AVL_WRITE = 1;
//
//#2 AVL_WRITE = 0;
//#2 AVL_ADDR = 4'b0010;
//#2 AVL_WRITEDATA = 32'h08090a0b;
//#2 AVL_WRITE = 1;
//
//#2 AVL_WRITE = 0;
//#2 AVL_ADDR = 4'b0011;
//#2 AVL_WRITEDATA = 32'h0c0d0e0f;
//#2 AVL_WRITE = 1;
//
//#2 AVL_WRITE = 0;
//#20
//
//// encrypted msg
//#2 AVL_WRITE = 0;
//#2 AVL_ADDR = 4'b0100;
//#2 AVL_WRITEDATA = 32'hdaec3055;
//#2 AVL_WRITE = 1;
//
//#2 AVL_WRITE = 0;
//#2 AVL_ADDR = 4'b0101;
//#2 AVL_WRITEDATA = 32'hdf058e1c;
//#2 AVL_WRITE = 1;
//
//#2 AVL_WRITE = 0;
//#2 AVL_ADDR = 4'b0110;
//#2 AVL_WRITEDATA = 32'h39e814ea;
//#2 AVL_WRITE = 1;
//
//#2 AVL_WRITE = 0;
//#2 AVL_ADDR = 4'b0111;
//#2 AVL_WRITEDATA = 32'h76f6747e;
//#2 AVL_WRITE = 1;
//
//#2 AVL_WRITE = 0;
//
//#2 AVL_WRITEDATA = 32'h1;
//#2 AVL_ADDR = 4'b1110;
//#2 AVL_WRITE = 1;
//#2 AVL_WRITE = 0;
//
//#2 AVL_ADDR = 4'b1000;

//#2 AVL_WRITEDATA = 32'hdaec3055df058e1c39e814ea76f6747e;



end

endmodule
