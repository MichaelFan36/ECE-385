module datapath(
                input logic	Clk, Reset, Run,
                input logic LD_MAR, LD_MDR, LD_IR, LD_PC, LD_BEN, LD_CC, LD_REG,
                input logic MIO_EN,
                input logic GatePC, GateMDR, GateALU, 
                input logic GateMARMUX, SR1MUX, SR2MUX, DRMUX, BEN, ADDR1MUX,
                input logic [1:0] PCMUX, ADDR2MUX, ALUK,
                input logic [15:0] Data_to_CPU,
                
                output logic [15:0] MAR, MDR, IR, PC
);

logic [15:0] bmux_out;
logic [2:0] SR1;
logic [2:0] DRMUX_out;
logic [15:0] ADDRMUX_out, SR2;
logic [15:0] SR1_out, SR2_out, ALU;
logic nzp_logic;

MUXs _MUXs(
            .IR(IR),
            .PC(PC),
            .SR1MUX_select(SR1MUX), 
            .SR2MUX_select(SR2MUX), 
            .DRMUX_select(DRMUX), 
            .ADDR1MUX_select(ADDR1MUX), 
            .ADDR2MUX_select(ADDR2MUX), 
            .SR1_out(SR1_out), 
            .SR2_out(SR2_out),
            
            .SR1(SR1),
				.SR2(SR2),
            .DRMUX(DRMUX_out),
            .ADDRMUX_out(ADDRMUX_out)
            );

eight_registers _eight_registers (
                            .Clk(Clk),
                            .Reset(Reset),
                            .Ld_REG(Ld_REG),
							.In(bmux_out),
                            .IR(IR),
                            .DRMUX(DRMUX_out), 
                            .SR1MUX(SR1),

                            .SR1(SR1_out), 
                            .SR2(SR2_out)
						);

ALU _ALU(
                .Input_A(SR1_out), 
                .Input_B(SR2),
				.ALUK(ALUK),

				.ALU_out(ALU)
			);

set_CC _set_CC(
                    .Clk(Clk),
                    .LD_CC(LD_CC), 
                    .In(bmux_out),
                    .IR(IR),

                    .nzp_logic(nzp_logic)


);

BEN _BEN (
                .Clk(Clk), 
                .LD_BEN(LD_BEN), 
                .In(nzp_logic), 

                .BEN(BEN)
            );


bus_MUXs bmux(
                .GatePC(GatePC), 
                .GateMDR(GateMDR), 
                .GateALU(GateALU), 
                .GateMARMUX(GateMARMUX),
                .PC(PC), 
                .MDR(MDR), 
                .MAR(MAR),
                .ALU(ALU),

                .Out(bmux_out)
            );


PC pc(
            .Clk(Clk),
			.Reset(Reset),
            .In(bmux_out),
            .PCMUX(PCMUX),
            .LD_PC(LD_PC),
            .ADDRMUX_out(ADDRMUX_out),

            .PC(PC)
    );

    
MAR mar(
            .Clk(Clk),
            .Reset(Reset),
            .LD_MAR(LD_MAR),
            .In(bmux_out),

            .MAR(MAR)
		);

IR ir(
            .Clk(Clk),
            .Reset(Reset),
            .LD_IR(LD_IR),
            .In(bmux_out),

            .IR(IR)
    );

MDR mdr(
            .Clk(Clk),
            .Reset(Reset),
            .LD_MDR(LD_MDR),
            .MIO_EN(MIO_EN),
            .In(bmux_out),
            .Data_to_CPU(Data_to_CPU),

            .MDR(MDR)
		);



endmodule

