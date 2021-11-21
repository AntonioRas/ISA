# script to simulate netlist post synthesis with f=f/4 to obtain sw activity

# testbench
vcom -93 -work ./work ../testbench/clk_gen.vhd
vcom -93 -work ./work ../testbench/signal_gen.vhd
vcom -93 -work ./work ../testbench/data_sink.vhd

# vlog -work ./work ../netlist/FIR_unfolding_pipeline_filter.v
vlog -work ./work ../netlist/FIR_unfolding_pipeline2_filter.v
vlog -work ./work ../testbench/tb_advanced_fir.v

# link compiled library
vsim -L /software/dk/nangate45/verilog/msim6.2g work.tb_advanced_fir

# link delay file
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_advanced_fir/UUT=../netlist/FIR_unfolding_pipeline2_filter.sdf work.tb_advanced_fir

vcd file ../vcd/FIR_unfolding_pipeline2_filter_syn.vcd
vcd add /tb_advanced_fir/UUT/*

run 10 us
