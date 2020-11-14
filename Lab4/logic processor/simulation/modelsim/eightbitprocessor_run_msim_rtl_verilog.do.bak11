transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/Router.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/Reg_4.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/Control.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/compute.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/Register_unit.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/Processor.sv}

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4/logic\ processor {C:/Users/cozyn/Desktop/ECE 385/Lab4/logic processor/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench_8

add wave *
view structure
view signals
run 1000 ns
