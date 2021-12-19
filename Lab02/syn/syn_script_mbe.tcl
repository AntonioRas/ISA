# script to synthesize and report area and timing with fmax


# constant values
set min_clk_period 2.9


# import source files
analyze -f vhdl -lib WORK ../mbe/dadda_lib.vhd
analyze -f vhdl -lib WORK ../mbe/HA.vhd
analyze -f vhdl -lib WORK ../mbe/fa.vhd
analyze -f vhdl -lib WORK ../mbe/dadda.vhd
analyze -f vhdl -lib WORK ../src/fpmul_pipeline.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage1_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage2_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage3_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage4_struct.vhd
analyze -f vhdl -lib WORK ../src/fpnormalize_fpnormalize.vhd
analyze -f vhdl -lib WORK ../src/fpround_fpround.vhd
analyze -f vhdl -lib WORK ../src/packfp_packfp.vhd
analyze -f vhdl -lib WORK ../src/unpackfp_unpackfp.vhd
analyze -f vhdl -lib WORK ../src/reg.vhd


# parameter to preserve rtl names in netlist
set power_preserve_rtl_heir_names true


# elaborate top entity of design
elaborate FPmul -arch pipeline -lib WORK
link


# constraints
create_clock -name my_clk -period $min_clk_period clk
set_dont_touch_network my_clk
set_clock_uncertainty 0.07 [get_clocks my_clk]
set_input_delay 0.5 -max -clock my_clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]


# compile architecture
ungroup -all -flatten
compile

# save results
report_resources > ./report_resources_mbe_maxfreq.txt
report_timing > ./report_timing_mbe_maxfreq.txt
report_area > ./report_area_mbe_maxfreq.txt

quit


