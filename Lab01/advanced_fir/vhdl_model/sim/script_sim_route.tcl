# script to simulate netlist post route with f=f/4 to obtain sw activity

# testbench
vcom -93 -work ./work ../testbench/clk_gen.vhd
vcom -93 -work ./work ../testbench/signal_gen.vhd
vcom -93 -work ./work ../testbench/data_sink.vhd

vlog -work ./work ../innovus/FIR_unfolding_pipeline_filter.v
vlog -work ./work ../testbench/tb_advanced_fir.v

# link compiled library
vsim -L /software/dk/nangate45/verilog/msim6.2g work.tb_advanced_fir

# link delay file
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_advanced_fir/UUT=../innovus/FIR_unfolding_pipeline_filter.sdf work.tb_advanced_fir

vcd file ../vcd/design_advanced.vcd
vcd add /tb_advanced_fir/UUT/*

run 10 us

