module bus_MUXs(
                input logic GatePC, GateMDR, GateALU, GateMARMUX,
                input logic [15:0] PC, MDR, MAR,

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

                    else 
                        Out = 16'd0;
                    
                end


endmodule

