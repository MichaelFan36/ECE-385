module PC (
                input logic  Clk,
                input logic  Reset,
                input logic  [15:0] In,
                input logic  [1:0] PCMUX,
                input logic  LD_PC,

                output logic [15:0] PC
            );

            logic [15:0] next_PC;

            always_comb begin  
                case(PCMUX)
                    2'b00 : next_PC = PC + 1;
                    2'b01 : next_PC = In;

                    default:
                        next_PC = In;
                endcase
                
            end

            always_ff @ (posedge Clk) begin
				if (Reset) 
                    PC = 16'd0;

                else if (LD_PC) 
                    PC <= next_PC;
                
                else 
                    PC <= PC;
                
            end
endmodule
