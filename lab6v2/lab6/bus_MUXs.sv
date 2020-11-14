module bus_MUXs(
                input logic GatePC, GateMDR, GateALU, GateMARMUX,
                input logic [15:0] PC, MDR, MAR, ALU,

                output logic [15:0] Out
                );

                always_comb
                begin
                    if (GateMARMUX) 
                        Out = MAR;

                    else if (GatePC) 
                        Out = PC;

                    else if (GateMDR) 
                        Out = MDR;
                    
                    else if (GateALU) 
                        Out = ALU;

                    else 
                        Out = 16'bX;
                    
                end


endmodule

