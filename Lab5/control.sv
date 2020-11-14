 //Code for the control unit
//Two-always example for state machine

module control (input  logic Clk, Reset, ClA_LdB, Execute, M,
                output logic Shift_En, Add, Sub, Clr_Ld, Clear);

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	  // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    // UPDATE: modified for the expanded bit input
    enum logic [18:0] {S, Q, A, A1, B, B1, C, C1, D, D1, E, E1, F, F1, G, G1, H, H1, L} curr_state, next_state;

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)
    begin
        if (Reset)
            curr_state <= S;
        else
            curr_state <= next_state;
    end

    // Assign outputs based on state
    always_comb
      begin

      next_state  = curr_state;	//required because I haven't enumerated all possibilities below
      unique case (curr_state)
        S :    if (Execute)
                next_state = Q;
        Q :    next_state = A;
        A :    next_state = A1;
        A1:    next_state = B;
        B :    next_state = B1;
        B1:    next_state = C;
        C :    next_state = C1;
        C1:    next_state = D;
        D :    next_state = D1;
        D1:    next_state = E;
        E :    next_state = E1;
        E1:    next_state = F;
        F :    next_state = F1;
        F1:    next_state = G;
        G :    next_state = G1;
        G1:    next_state = H;
        H :    next_state = H1;
        H1 :   next_state = L;  //Finish shifting data out of the register unit
        // Here is when we go back to the begining of the state machine

        // It can go back to the previous state only if the execute becomes low
        L :    if (~Execute)
                next_state = S;

      endcase

    // Assign outputs based on ‘state’
    case (curr_state)
        S:  // The start state
          begin
            Clr_Ld = ClA_LdB;
            Clear = ClA_LdB;
            Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end
        // The Q state designed to clear the register A
        Q:
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b1;
            Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end
        A:  // Responsible for 1st bit addition
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end

        B:  // Responsible for 2nd bit addition
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end

        C:  // Responsible for 3rd bit addition
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end

        D:  // Responsible for 4th bit addition
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end

        E:  // Responsible for 5th bit addition
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end

        F:  // Responsible for 6th bit addition
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end

        G:  // Responsible for 7th bit addition
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end

        H:  // Responsible for 8th bit addition (if M is 1, we need to do subtraction)
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b1;
            Shift_En = 1'b0;
          end

        default: // Responsible for shifting the bits
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b1;
          end

        L:  // The last holding state before stepping into the new computation circle
          begin
            Clr_Ld = 1'b0;
            Clear = 1'b0;
            Add = 1'b0;
            Sub = 1'b0;
            Shift_En = 1'b0;
          end
    endcase
  end

endmodule
