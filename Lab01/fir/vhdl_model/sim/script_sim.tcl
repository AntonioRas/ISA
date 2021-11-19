# compile the src code
vcom -93 -work ./work ../src/adder.vhd
vcom -93 -work ./work ../src/ffd.vhd
vcom -93 -work ./work ../src/reg.vhd
vcom -93 -work ./work ../src/multiplier.vhd
vcom -93 -work ./work ../src/FIR_filter.vhd

# compile the tb
vcom -93 -work ./work ../testbench/clk_gen.vhd
vcom -93 -work ./work ../testbench/signal_gen.vhd
vcom -93 -work ./work ../testbench/data_sink.vhd
vlog -work ./work ../testbench/tb_fir.v

vsim work.tb_fir
# simulate
#add waves *
source wave.do
run 2450 ns