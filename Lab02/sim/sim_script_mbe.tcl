# compile the src code

vcom -93 -work ./work ../mbe/dadda_lib.vhd
#vcom -93 -work ./work ../mbe/FF.vhd
vcom -93 -work ./work ../mbe/HA.vhd
vcom -93 -work ./work ../mbe/FA.vhd
vcom -93 -work ./work ../mbe/dadda.vhd

vcom -93 -work ./work ../src/fpnormalize_fpnormalize.vhd
vcom -93 -work ./work ../src/fpround_fpround.vhd
vcom -93 -work ./work ../src/packfp_packfp.vhd
vcom -93 -work ./work ../src/unpackfp_unpackfp.vhd

vcom -93 -work ./work ../src/reg.vhd

vcom -93 -work ./work ../src/fpmul_stage1_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage2_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage3_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage4_struct.vhd
vcom -93 -work ./work ../src/fpmul_pipeline.vhd

# compile the tb
vcom -93 -work ./work ../testbench/data_maker.vhd
vcom -93 -work ./work ../testbench/fpmul_test.vhd

vsim work.fpmul_test
# simulate
add waves *
run 2000 ns
