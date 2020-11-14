transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab5/Lab5/Lab5 {C:/Users/cozyn/Desktop/ECE 385/385/Lab5/Lab5/Lab5/shift_register.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab5/Lab5/Lab5 {C:/Users/cozyn/Desktop/ECE 385/385/Lab5/Lab5/Lab5/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab5/Lab5/Lab5 {C:/Users/cozyn/Desktop/ECE 385/385/Lab5/Lab5/Lab5/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab5/Lab5/Lab5 {C:/Users/cozyn/Desktop/ECE 385/385/Lab5/Lab5/Lab5/control.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab5/Lab5/Lab5 {C:/Users/cozyn/Desktop/ECE 385/385/Lab5/Lab5/Lab5/adder.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab5/Lab5/Lab5 {C:/Users/cozyn/Desktop/ECE 385/385/Lab5/Lab5/Lab5/flip_flop.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab5/Lab5/Lab5 {C:/Users/cozyn/Desktop/ECE 385/385/Lab5/Lab5/Lab5/multiplier.sv}

