transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4 {C:/Users/cozyn/Desktop/ECE 385/Lab4/select_adder.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4 {C:/Users/cozyn/Desktop/ECE 385/Lab4/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4 {C:/Users/cozyn/Desktop/ECE 385/Lab4/router.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4 {C:/Users/cozyn/Desktop/ECE 385/Lab4/reg_17.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4 {C:/Users/cozyn/Desktop/ECE 385/Lab4/control.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4 {C:/Users/cozyn/Desktop/ECE 385/Lab4/adder2.sv}

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/Lab4 {C:/Users/cozyn/Desktop/ECE 385/Lab4/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
