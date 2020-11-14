module CC (
                    input logic Clk,
                    input logic	LD_CC, 
                    input logic [15:0] In,
                    
                    output logic N, 
                    output logic Z, 
                    output logic P
                );
									
						logic sign;
						assign sign = In[15];
					

                    // set CC
				always_ff @ (posedge Clk) begin
                        if (LD_CC) 
                        begin
                            if (sign) 
                                begin
                                    N <= 1'b1;
                                    Z <= 1'b0;
                                    P <= 1'b0;
                                end
                            
                            else if (In == 16'd0) 
                                begin
                                    N <= 1'b0;
                                    Z <= 1'b1;
                                    P <= 1'b0;
                                end
                            
                            else 
                                begin
                                    N <= 1'b0;
                                    Z <= 1'b0;
                                    P <= 1'b1;
                                end
                        end

                    // hold the value
                        else 
                            begin
                                N <= N;
                                Z <= Z;
                                P <= P;
                            end
     end
endmodule

module nzp_logic (
                        input logic N, 
                        input logic Z, 
                        input logic P,
                        input logic [15:0] IR,

                        output logic nzp_logic
                );

                always_comb 
                begin
                    nzp_logic = N & IR[11] | Z & IR[10] | P & IR[9];
                end
endmodule

module set_CC(
                    input logic Clk,
                    input logic	LD_CC, 
                    input logic [15:0] In,
                    input logic [15:0] IR,

                    output logic nzp_logic


);

        logic N,Z,P;

        CC _CC (
                    .Clk(Clk),
                    .LD_CC(LD_CC), 
                    .In(In),
                    
                    .N(N), 
                    .Z(Z), 
                    .P(P)
        );

        nzp_logic _nzp_logic (
                        .N(N), 
                        .Z(Z), 
                        .P(P),
                        .IR(IR),

                        .nzp_logic(nzp_logic)
                    );


endmodule

