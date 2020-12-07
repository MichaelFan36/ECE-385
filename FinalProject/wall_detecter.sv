module wall_detector(
    input [9:0] x_pos, y_pos,
    input [9:0] x_size, y_size,
    input [8:0] bg_step,

    output can_up, can_down, can_left, can_right
);

    parameter [8:0] tube1_left=70;      
    parameter [8:0] tube2_left=110;     
    parameter [8:0] tube3_left=142;     
    parameter [8:0] tube4_left=186;      
    parameter [8:0] tube5_left=254;      
    parameter [8:0] tube6_left=318;      

    parameter [8:0] tube1_right=81;      
    parameter [8:0] tube2_right=121;     
    parameter [8:0] tube3_right=153;     
    parameter [8:0] tube4_right=197;      
    parameter [8:0] tube5_right=265;      
    parameter [8:0] tube6_right=329; 

    // 60, 50, 45, 35, 368
    parameter [9:0] tube1_height=206;      
    parameter [9:0] tube2_height=206;     
    parameter [9:0] tube3_height=238;     
    parameter [9:0] tube4_height=238;      
    parameter [9:0] tube5_height=213;      
    parameter [9:0] tube6_height=206; 

always_comb
begin: right_check

if (bg_step == tube1_left && (y_pos) >= tube1_height)
begin 
    can_right = 0;
end
else if (bg_step == tube2_left && (y_pos) >= tube2_height)
begin 
    can_right = 0;
end
else if (bg_step == tube3_left && (y_pos) >= tube3_height)
begin 
    can_right = 0;
end
else if (bg_step == tube4_left && (y_pos) >= tube4_height)
begin 
    can_right = 0;
end

else if (bg_step == tube5_left && (y_pos) >= tube5_height)
begin 
    can_right = 0;
end
else if (bg_step == tube6_left && (y_pos) >= tube6_height)
begin 
    can_right = 0;
end
else
begin
    can_right = 1;
end

end 


always_comb
begin: left_check

if (bg_step == tube1_right && (y_pos) >= tube1_height)
begin 
    can_left = 0;
end
else if (bg_step == tube2_right && (y_pos) >= tube2_height)
begin 
    can_left = 0;
end
else if (bg_step == tube3_right && (y_pos) >= tube3_height)
begin 
    can_left = 0;
end
else if (bg_step == tube4_right && (y_pos) >= tube4_height)
begin 
    can_left = 0;
end

else if (bg_step == tube5_right && (y_pos) >= tube5_height)
begin 
    can_left = 0;
end
else if (bg_step == tube6_right && (y_pos) >= tube6_height)
begin 
    can_left = 0;
end
else
begin
    can_left = 1;
end

end 

always_comb
begin: down_check

if (bg_step > tube1_left && bg_step < tube1_right && (y_pos) >= tube1_height)
begin 
    can_down = 0;
end
else if (bg_step > tube2_left && bg_step < tube2_right && (y_pos) >= tube2_height)
begin 
    can_down = 0;
end
else if (bg_step > tube3_left && bg_step < tube3_right && (y_pos) >= tube3_height)
begin 
    can_down = 0;
end
else if (bg_step > tube4_left && bg_step < tube4_right && (y_pos) >= tube4_height)
begin 
    can_down = 0;
end

else if (bg_step > tube5_left && bg_step < tube5_right && (y_pos) >= tube5_height)
begin 
    can_down = 0;
end
else if (bg_step > tube6_left && bg_step < tube6_right && (y_pos) >= tube6_height)
begin 
    can_down = 0;
end
else
begin
    can_down = 1;
end

end 

endmodule
