transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE385/lab9 {C:/Users/cozyn/Desktop/ECE385/lab9/SubBytes.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE385/lab9 {C:/Users/cozyn/Desktop/ECE385/lab9/InvShiftRows.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE385/lab9 {C:/Users/cozyn/Desktop/ECE385/lab9/InvMixColumns.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE385/lab9 {C:/Users/cozyn/Desktop/ECE385/lab9/KeyExpansion.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE385/lab9 {C:/Users/cozyn/Desktop/ECE385/lab9/AES.sv}
vlib lab9_soc
vmap lab9_soc lab9_soc

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE385/lab9 {C:/Users/cozyn/Desktop/ECE385/lab9/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -L lab9_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 50000 ns
