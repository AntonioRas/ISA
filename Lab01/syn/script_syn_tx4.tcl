# script to synthesize ard report area and timing with f=fmax/4


# constant values
set t4x_clk_period 12.8


# import source files
analyze -f vhdl -lib WORK ../src/adder.vhd
analyze -f vhdl -lib WORK ../src/ffd.vhd
analyze -f vhdl -lib WORK ../src/FIR_filter.vhd
analyze -f vhdl -lib WORK ../src/multiplier.vhd
analyze -f vhdl -lib WORK ../src/reg.vhd


# parameter to preserve rtl names in netlist
set power_preserve_rtl_heir_names true


# elaborate top entity of design
elaborate FIR_filter -arch struct -lib WORK
link


# constraints
create_clock -name my_clk -period $t4x_clk_period clk
set_dont_touch_network my_clk
set_clock_uncertainty 0.07 [get_clocks my_clk]
set_input_delay 0.5 -max -clock my_clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]


# compile architecture
compile


# save results
report_timing > ./report_timing_tx4.txt
report_area > ./report_area_tx4.txt


# save netlist
ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/FIR_filter.sdf
write -f verilog -hierarchy -output ../netlist/FIR_filter.v
write_sdc ../netlist/FIR_filter.sdc


quit
