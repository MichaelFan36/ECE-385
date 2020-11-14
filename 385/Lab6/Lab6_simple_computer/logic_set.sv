module logic_set (
                        input logic N, Z, P,
                        input logic [15:0] IR,

                        output logic logic_out);


                always_comb begin
                    logic_out = N & IR[11] | Z & IR[10] | P & IR[9];
                end
endmodule

