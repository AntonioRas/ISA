# script to synthesize and report area and timing 

# constant values
set min_clk_period 1.4

# import source files

analyze -f vhdl -lib WORK ../src/myTypes.vhd
analyze -f vhdl -lib WORK ../src/constants.vhd
analyze -f vhdl -lib WORK ../src/reg.vhd
analyze -f vhdl -lib WORK ../src/mux21.vhd
analyze -f vhdl -lib WORK ../src/mux41.vhd
analyze -f vhdl -lib WORK ../src/mux61.vhd
analyze -f vhdl -lib WORK ../src/adder.vhd
analyze -f vhdl -lib WORK ../src/comparator.vhd
analyze -f vhdl -lib WORK ../src/logic.vhd
analyze -f vhdl -lib WORK ../src/shifter.vhd
analyze -f vhdl -lib WORK ../src/alu.vhd
analyze -f vhdl -lib WORK ../src/registerfile.vhd
analyze -f vhdl -lib WORK ../src/immediate_ext.vhd
analyze -f vhdl -lib WORK ../src/fetch_stage.vhd
analyze -f vhdl -lib WORK ../src/decode_stage.vhd
analyze -f vhdl -lib WORK ../src/execute_stage_2.vhd
analyze -f vhdl -lib WORK ../src/mem_stage.vhd
analyze -f vhdl -lib WORK ../src/wb_stage.vhd
analyze -f vhdl -lib WORK ../src/if_id_pipe_regs.vhd
analyze -f vhdl -lib WORK ../src/id_exe_pipe_regs.vhd
analyze -f vhdl -lib WORK ../src/exe_mem_pipe_regs.vhd
analyze -f vhdl -lib WORK ../src/mem_wb_pipe_regs.vhd
analyze -f vhdl -lib WORK ../src/datapath.vhd
analyze -f vhdl -lib WORK ../src/cu.vhd
analyze -f vhdl -lib WORK ../src/core.vhd

# parameter to preserve rtl names in netlist
set power_preserve_rtl_heir_names true


# elaborate top entity of design
elaborate core -arch struct -lib WORK
link

# constraints
create_clock -name my_clk -period $min_clk_period clk
set_dont_touch_network my_clk
set_clock_uncertainty 0.07 [get_clocks my_clk]
set_input_delay 0.5 -max -clock my_clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock my_clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]


# compile architecture
ungroup -all -flatten
compile


# save results
report_timing > ./report_timing_max_freq.txt
report_area > ./report_area_max_freq.txt

# save netlist
change_names -hierarchy -rules verilog
write_sdf ../netlist/core.sdf
write -f verilog -hierarchy -output ../netlist/core.v
write_sdc ../netlist/core.sdc

quit




