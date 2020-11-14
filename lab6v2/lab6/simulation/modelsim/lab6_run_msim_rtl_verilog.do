transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/test_memory.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/SLC3_2.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/set_CC.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/register.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/PC.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/MUXs.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/MDR.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/MAR.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/IR.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/datapath.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/bus_MUXs.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/BEN.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/ALU.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/slc3.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/memory_contents.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/slc3_testtop.sv}

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/lab6v2/lab6 {C:/Users/cozyn/Desktop/lab6v2/lab6/testbench2.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench2

add wave *
view structure
view signals
run 50000 ns
