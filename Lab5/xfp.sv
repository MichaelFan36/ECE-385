module xfp(
          input logic Clk,
          input logic Load,
          input logic Clear,
          input logic D,
          output logic Q
          );

      always_ff @ (posedge Clk)
      begin

        if (Clear)
        Q <= 1'b0;
        else
          if (Load)
            Q <= D;
          else
            Q <= Q;
      end

endmodule
