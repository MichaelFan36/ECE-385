module datapath(	input LD_MAR, LD_PC, LD_IR, LD_MDR, MIO_EN, GateMARMUX, GatePC, GateMDR, GateALU,
						input logic [15:0] Data_to_CPU,
						input logic [1:0] PCMUX,
						input Clk, Reset,

						input logic [1:0] ADDR2MUX, ALUK,
						input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
						input logic LD_REG, LD_CC, LD_BEN, 
						
						output logic [15:0] IR_val, MDR_val, MAR_val, PC_val,
						output logic BEN_val);
						
					
	logic [15:0] BUS, ALU_val;
	logic [15:0] ADDRADDER_output;

	tristate_MUX tri_mux(.GateMARMUX, .GatePC, .GateMDR, .GateALU, .MAR(ADDRADDER_output), .PC(PC_val), .MDR(MDR_val), .ALU(ALU_val), .Data_out(BUS));
	MAR mar(.Din(BUS), .LD_MAR, .Clk, .Reset, .Dout(MAR_val));
	PC pc(.Global_Bus(BUS), .Data_from_ADDR_ADDER(ADDRADDER_output), .PCMUX, .LD_PC, .Clk, .Reset, .PC_val);
	IR ir(.Instruction(BUS), .LD_IR, .Clk, .Reset, .IR(IR_val));
	MDR mdr(.Data_to_CPU, .Global_Bus(BUS), .LD_MDR, .MIO_EN, .Clk, .Reset, .Data_out(MDR_val));

	

	
	logic [15:0] SR1_out,SR2_out, ALU_A, ALU_B;
	logic [2:0] DRMUX_out, SR1MUX_out;
	logic logic_out, N, Z, P;
	
	ALU alu(.ALU_A(SR1_out), .ALU_B, .ALUK, .ALU_val);
	SR1MUX sr1mux(.IR(IR_val), .SR1MUX_sel(SR1MUX), .SR1MUX_out);
	SR2MUX sr2mux(.IR(IR_val), .SR2_out, .SR2MUX_sel(SR2MUX), .ALU_B);
	ADDRMUX addrmux(.PC_out(PC_val), .SR1_out, .ADDR1MUX_sel(ADDR1MUX), .ADDR2MUX_sel(ADDR2MUX), .IR(IR_val), .ADDR(ADDRADDER_output));
	DRMUX drmux(.IR(IR_val), .DRMUX_sel(DRMUX), .DRMUX_out);
	register_file reg_file( .Data_in(BUS), .IR(IR_val), .DRMUX_out, .SR1MUX_out, .LD_REG, .Clk, .Reset, 
									.SR1_out, .SR2_out);
	condition_code cc(.Global_Bus(BUS), .LD_CC, .Clk, .N, .Z, .P);
	logic_set ls(.N, .Z, .P, .IR(IR_val), .logic_out);
	BEN ben(.Din(logic_out), .LD_BEN, .Clk, .BEN_out(BEN_val));
	
	
endmodule
	
	

	
