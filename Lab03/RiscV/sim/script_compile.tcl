# compile the src code
vcom -93 -work ./work ../src/myTypes.vhd
vcom -93 -work ./work ../src/constants.vhd
vcom -93 -work ./work ../src/reg.vhd
vcom -93 -work ./work ../src/mux21.vhd
vcom -93 -work ./work ../src/mux41.vhd
vcom -93 -work ./work ../src/mux61.vhd
vcom -93 -work ./work ../src/adder.vhd
vcom -93 -work ./work ../src/logic.vhd
vcom -93 -work ./work ../src/comparator.vhd
vcom -93 -work ./work ../src/shifter.vhd
vcom -93 -work ./work ../src/alu.vhd
vcom -93 -work ./work ../src/registerfile.vhd
vcom -93 -work ./work ../src/immediate_ext.vhd
vcom -93 -work ./work ../src/fetch_stage.vhd
vcom -93 -work ./work ../src/if_id_pipe_regs.vhd
vcom -93 -work ./work ../src/decode_stage.vhd
vcom -93 -work ./work ../src/id_exe_pipe_regs.vhd
vcom -93 -work ./work ../src/execute_stage_2.vhd
vcom -93 -work ./work ../src/exe_mem_pipe_regs.vhd
vcom -93 -work ./work ../src/mem_stage.vhd
vcom -93 -work ./work ../src/mem_wb_pipe_regs.vhd
vcom -93 -work ./work ../src/wb_stage.vhd
vcom -93 -work ./work ../src/hdu.vhd
vcom -93 -work ./work ../src/datapath.vhd
vcom -93 -work ./work ../src/cu.vhd
vcom -93 -work ./work ../src/imem.vhd
vcom -93 -work ./work ../src/dmem.vhd
vcom -93 -work ./work ../src/core.vhd
vcom -93 -work ./work ../src/risc_sim.vhd

# compile the testbench code
vcom -93 -work ./work ../tb/TB_RISCV.vhd

vsim -t 10ps work.tb_riscv