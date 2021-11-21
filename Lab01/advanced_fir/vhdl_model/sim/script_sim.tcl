# compile the src code
vcom -93 -work ./work ../src/adder.vhd
vcom -93 -work ./work ../src/ffd.vhd
vcom -93 -work ./work ../src/reg.vhd
vcom -93 -work ./work ../src/multiplier.vhd
#vcom -93 -work ./work ../src/FIR_unfolding_filter.vhd
#vcom -93 -work ./work ../src/FIR_unfolding_pipeline_filter.vhd
vcom -93 -work ./work ../src/FIR_unfolding_pipeline2_filter.vhd

# compile the tb
vcom -93 -work ./work ../testbench/clk_gen.vhd
vcom -93 -work ./work ../testbench/signal_gen.vhd
vcom -93 -work ./work ../testbench/data_sink.vhd
vlog -work ./work ../testbench/tb_advanced_fir.v

vsim work.tb_advanced_fir
# simulate
#add waves *
run 2450 ns