module datapath(
                input logic	Clk, Reset, Run,
                input logic LD_MAR, LD_MDR, LD_IR, LD_PC,
                input logic MIO_EN,
                input logic GatePC, GateMDR, GateALU, GateMARMUX,
                input logic [1:0] PCMUX, 
                input logic [15:0] Data_to_CPU,
                
                output logic [15:0] MAR, MDR, IR, PC
);

logic [15:0] bmux_out;


bus_MUXs bmux(
                .GatePC(GatePC), 
                .GateMDR(GateMDR), 
                .GateALU(GateALU), 
                .GateMARMUX(GateMARMUX),
                .PC(PC), 
                .MDR(MDR), 
                .MAR(MAR), 

                .Out(bmux_out)
            );


PC pc(
            .Clk(Clk),
			.Reset(Reset),
            .In(bmux_out),
            .PCMUX(PCMUX),
            .LD_PC(LD_PC),

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

