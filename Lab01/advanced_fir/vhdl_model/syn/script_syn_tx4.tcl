# script to synthesize and report area and timing with fmax


# constant values
set min_clk_period 9.24


# import source files
analyze -f vhdl -lib WORK ../src/adder.vhd
analyze -f vhdl -lib WORK ../src/ffd.vhd
analyze -f vhdl -lib WORK ../src/FIR_unfolding_pipeline_filter.vhd
analyze -f vhdl -lib WORK ../src/multiplier.vhd
analyze -f vhdl -lib WORK ../src/reg.vhd


# parameter to preserve rtl names in netlist
set power_preserve_rtl_heir_names true


# elaborate top entity of design
elaborate FIR_unfolding_pipeline_filter -arch struct -lib WORK
uniquify
link


# constraints
create_clock -name my_clk -period $min_clk_period clk
set_dont_touch_network my_clk
set_clock_uncertainty 0.07 [get_clocks my_clk]
set_input_delay 0.5 -max -clock my_clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]


# compile architecture
compile


# save results
report_timing > ./report_timing.txt
report_area > ./report_area.txt


# save netlist
ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/FIR_unfolding_pipeline_filter.sdf
write -f verilog -hierarchy -output ../netlist/FIR_unfolding_pipeline_filter.v
write_sdc ../netlist/FIR_unfolding_pipeline_filter.sdc


quit
