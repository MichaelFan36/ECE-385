module PC (
                input logic     [15:0] Global_Bus, Data_from_ADDR_ADDER,
                input logic     [1:0] PCMUX,
                input logic     LD_PC, Clk, Reset,
                output logic    [15:0] PC_val
                );

            logic [15:0] new_PC;

            always_comb begin  
                case(PCMUX)
                    2'b00 : new_PC = PC_val + 1;
                    2'b01 : new_PC = Global_Bus;
                    2'b10 : new_PC = Data_from_ADDR_ADDER;

                    default:
                        new_PC = Global_Bus;
                endcase
                
            end

            always_ff @ (posedge Clk) begin
					 if (Reset) begin
                    PC_val = 16'b0000000000000000;
                end

                else if (LD_PC) begin
                    PC_val <= new_PC;
                end
                else begin
                    PC_val <= PC_val;
                end
            end
endmodule
