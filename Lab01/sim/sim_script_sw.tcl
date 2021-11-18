# script to simulate netlist post synthesis with f=f/4 to obtain sw activity

# testbench
vcom -93 -work ./work ../testbench/clk_gen.vhd
vcom -93 -work ./work ../testbench/signal_gen.vhd
vcom -93 -work ./work ../testbench/data_sink.vhd

vlog -work ./work ../netlist/FIR_filter.v
vlog -work ./work ../testbench/tb_fir.v

# link compiled library
vsim -L /software/dk/nangate45/verilog/msim6.2g work.tb_fir

# link delay file
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_fir/UUT=../netlist/FIR_filter.sdf work.tb_fir

vcd file ../vcd/FIR_filter_syn.vcd
vcd add /tb_fir/UUT/*

run 10 us

