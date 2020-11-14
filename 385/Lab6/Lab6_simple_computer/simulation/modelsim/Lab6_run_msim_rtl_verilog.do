transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/logic_set.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/Condition_Code.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/BEN.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/PC.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/tristate_MUX.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/MDR.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/tristate.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/test_memory.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/SLC3_2.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/IR.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/MAR.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/ALU.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/SR2MUX.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/SR1MUX.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/DRMUX.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/ADDRMUX.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/register_8.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/register_file.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/memory_contents.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/datapath.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/slc3.sv}
vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/lab6_toplevel.sv}

vlog -sv -work work +incdir+C:/Users/cozyn/Desktop/ECE\ 385/385/Lab6/Lab6_simple_computer {C:/Users/cozyn/Desktop/ECE 385/385/Lab6/Lab6_simple_computer/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 5000 ns
