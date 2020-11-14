//------------------------------------------------------------------------------
// Company:        UIUC ECE Dept.
// Engineer:       Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 10-19-2017 
//    spring 2018 Distribution
//
//------------------------------------------------------------------------------
module slc3(
    input logic [15:0] S,
    input logic Clk, Reset, Run, Continue,
    output logic [11:0] LED,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic CE, UB, LB, OE, WE,
    output logic [19:0] ADDR,
    inout wire [15:0] Data //tristate buffers need to be of type wire
);

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// Internal connections
logic BEN;
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;
logic MIO_EN;

logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC;
logic [15:0] Data_from_SRAM, Data_to_SRAM;

// Signals being displayed on hex display
logic [3:0][3:0] hex_4;

// For week 1, hexdrivers will display IR. Comment out these in week 2.
//HexDriver hex_driver3 (IR[15:12], HEX3);
//HexDriver hex_driver2 (IR[11:8], HEX2);
//HexDriver hex_driver1 (IR[7:4], HEX1);
//HexDriver hex_driver0 (IR[3:0], HEX0);

// For week 2, hexdrivers will be mounted to Mem2IO
 HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
 HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
 HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
 HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

// The other hex display will show PC for both weeks.
HexDriver hex_driver7 (PC[15:12], HEX7);
HexDriver hex_driver6 (PC[11:8], HEX6);
HexDriver hex_driver5 (PC[7:4], HEX5);
HexDriver hex_driver4 (PC[3:0], HEX4);

// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
// input into MDR)
assign ADDR = { 4'b00, MAR }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign MIO_EN = ~OE;

// You need to make your own datapath module and connect everything to the datapath
// Be careful about whether Reset is active high or low
datapath d0 (.*);

// Components 

assign LED = IR[11:0];
// internal logic
logic [15:0] BUS,
             MUX_to_PC,
             MUX1_to_adder, MUX2_to_adder, adder_out,
             SR1, SR2, SR1_OUT, SR2_OUT, DR,
             ALU_OUT, MUX_to_ALU, MUX_to_MDR;
logic [2:0] MUX_to_DR, MUX_to_SR1;
logic N, Z, P, N_in, Z_in, P_in, BEN_In;

// IR SECTION
always_ff @(posedge Clk) begin
    if (Reset_ah)
        IR <= 16'b0;
    else if(LD_IR)
        IR <= BUS;
end

// PC SECTION

always_ff @(posedge Clk) begin
    if (Reset_ah)
        PC <= 16'b0;
    else if (LD_PC)
        PC <= MUX_to_PC;
end

MUX_4_1 MUX_PC (.d0(PC+1), 
                .d1(BUS),
                .d2(adder_out), 
                .d3(16'b0), 
                .s(PCMUX), 
                .y(MUX_to_PC));

// Adder part

assign adder_out = MUX1_to_adder + MUX2_to_adder;

MUX_2_1 MUX_ADDR1 (
                .d0(PC),
                .d1(SR1_OUT),
                .s(ADDR1MUX),
                .y(MUX1_to_adder)); 

MUX_4_1 MUX_ADDR2 (
                .d0(16'b0),
                .d1({{10{IR[5]}},{IR[5:0]}}),
                .d2({{7{IR[8]}},IR[8:0]}),
                .d3({{5{IR[10]}},IR[10:0]}),
                .s(ADDR2MUX),
                .y(MUX2_to_adder));

// REG FILE 

reg_file REG (.*,
            .Reset(Reset_ah),
            .DR(MUX_to_DR),
            .SR1(MUX_to_SR1),
            .SR2(IR[2:0]),
            .LD(LD_REG));

MUX_2_1 #(3) MUX_DR (
                .d0(IR[11:9]),
                .d1(3'b111),
                .s(DRMUX),
                .y(MUX_to_DR));

MUX_2_1 #(3) MUX_SR1 (
                .d0(IR[11:9]),
                .d1(IR[8:6]),
                .s(SR1MUX),
                .y(MUX_to_SR1));

// ALU

MUX_2_1 MUX_SR2 (
                .d0(SR2_OUT),
                .d1({{11{IR[4]}},IR[4:0]}),
                .s(SR2MUX),
                .y(MUX_to_ALU));

ALU ALunit (.*,
            .A (SR1_OUT),
            .B (MUX_to_ALU));

// MDR
MUX_2_1 MIO_MUX (
                .d0(BUS),
                .d1(MDR_In),
                .s(MIO_EN),
                .y(MUX_to_MDR));

always_ff @(posedge Clk) begin
    if (Reset_ah)
        MDR <= 16'b0;
    else if (LD_MDR)
        MDR <= MUX_to_MDR;
end

//  MAR
always_ff @(posedge Clk) begin
    if (Reset_ah)
        MAR <= 16'b0;
    else if (LD_MAR)
        MAR <= BUS;
end

// BEN 

NZP_logic NZP(.*);

always_ff @(posedge Clk) begin
    if (Reset_ah) begin
        N <= 1'b0;
        Z <= 1'b0;
        P <= 1'b0;
    end
    else if (LD_CC) begin
        N <= N_in;
        Z <= Z_in;
        P <= P_in;
    end
end

BEN_logic BEN_signal(.*, .Cond(IR[11:9]));

always_ff @(posedge Clk) begin
    if (Reset_ah)
        BEN <= 1'b0;
    else if (LD_BEN)
        BEN <= BEN_In;
end

// end lc-3 components

// Our SRAM and I/O controller
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
);

// State machine and control signals
ISDU state_controller(
    .*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
    .Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
    .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
);

endmodule