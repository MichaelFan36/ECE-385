module control (
						input  logic Clk, 
						input  logic ClearA_LoadB, 
						input  logic Run, 
						input  logic M,
						output logic Shift_enable, 
						output logic Add, 
						output logic Sub, 
						output logic Clear_Load,
						output logic clear_X,
						output logic clear_A);
					 
					 
    enum logic [18:0] {S,clear_state, add_0, shift_0, add_1, shift_1, add_2, shift_2, add_3, shift_3, add_4, shift_4, add_5, shift_5, add_6, shift_6, add_7, shift_7, E} curr_state, next_state;
	 

    always_ff @ (posedge Clk)
    begin
        if (ClearA_LoadB) 
            curr_state <= S;
        else
            curr_state <= next_state;
    end

    always_comb
      begin

      next_state  = curr_state;	

      unique case (curr_state)
        S :    if (Run)
                next_state = clear_state;
					 
		  clear_state : next_state = add_0;
					 
        add_0 :    next_state = shift_0;
        shift_0 :    next_state = add_1;
		  
		  add_1 :    next_state = shift_1;
        shift_1 :    next_state = add_2;
		  
		  add_2 :    next_state = shift_2;
        shift_2 :    next_state = add_3;
		  
		  add_3 :    next_state = shift_3;
        shift_3 :    next_state = add_4;
		  
		  add_4 :    next_state = shift_4;
        shift_4 :    next_state = add_5;
		  
		  add_5 :    next_state = shift_5;
        shift_5 :    next_state = add_6;
		  
		  add_6 :    next_state = shift_6;
        shift_6 :    next_state = add_7;
		  
		  add_7 :    next_state = shift_7;
        shift_7 :    next_state = E;
		  
        E :    if (~Run)
                next_state = S;

      endcase

    
    case (curr_state)
        S:  
          begin
            Clear_Load = ClearA_LoadB;
            clear_X = ClearA_LoadB;
            clear_A = ClearA_LoadB;
            Add = 1'b0;
            Sub = 1'b0;
            Shift_enable = 1'b0;
          end
			 
		  clear_state:
				begin
            Clear_Load = 1'b0;
            clear_X = 1'b1;
            clear_A = 1'b1;
            Add = 1'b0;
            Sub = 1'b0;
            Shift_enable = 1'b0;
          end
			 
        add_0,
        add_1,
        add_2,
        add_3,
        add_4,
        add_5,
        add_6:
        begin
            Clear_Load = 1'b0;
            clear_X = 1'b0;
            clear_A = 1'b0;
            if (M)
              Add = 1'b1;
            else
              Add = 1'b0;
            Sub = 1'b0;
            Shift_enable = 1'b0;
          end
           
        add_7: 
          begin
            Clear_Load = 1'b0;
            clear_X = 1'b0;
            clear_A = 1'b0;
            if (M)
              Sub = 1'b1;
            else
              Sub = 1'b0;
            Add = 1'b1;
            Shift_enable = 1'b0;
          end


        default: 
          begin
            Clear_Load = 1'b0;
            clear_X = 1'b0;
            clear_A = 1'b0;
            Add = 1'b0;
            Sub = 1'b0;
            Shift_enable = 1'b1;
          end

        E:  
          begin
            Clear_Load = 1'b0;
            clear_X = 1'b0;
            clear_A = 1'b0;
            Add = 1'b0;
            Sub = 1'b0;
            Shift_enable = 1'b0;
          end
    endcase
  end

endmodule