onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -label clk /tb_riscv/dut/core_inst/clk
add wave -noupdate -format Logic -label rst /tb_riscv/dut/core_inst/rst
add wave -noupdate -format Literal -label imem_instr -radix hexadecimal /tb_riscv/dut/core_inst/imem_instr
add wave -noupdate -format Literal -label imem_addr -radix unsigned /tb_riscv/dut/core_inst/imem_address
add wave -noupdate -format Literal -label instr -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/instr
add wave -noupdate -format Literal -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/imm
add wave -noupdate -format Literal -label dmem_datain -radix decimal /tb_riscv/dut/core_inst/dmem_datain
add wave -noupdate -format Literal -label dmem_dataout -radix decimal /tb_riscv/dut/core_inst/dmem_dataout
add wave -noupdate -format Literal -label dmme_addr -radix unsigned /tb_riscv/dut/core_inst/dmem_address
add wave -noupdate -format Literal -label instr_type /tb_riscv/dut/core_inst/id_instr_type_sel
add wave -noupdate -format Logic -label id_rs1_en /tb_riscv/dut/core_inst/id_rd1_en
add wave -noupdate -format Logic -label id_rs2_en /tb_riscv/dut/core_inst/id_rd2_en
add wave -noupdate -format Literal -label id_rd_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/id_rd_out
add wave -noupdate -format Literal -label register_file -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/registers
add wave -noupdate -format Literal -label cw /tb_riscv/dut/core_inst/cu_inst/cw
add wave -noupdate -format Literal -label exe_control /tb_riscv/dut/core_inst/datapath_inst/idexe_cu_signals_out
add wave -noupdate -format Literal -label mem_control /tb_riscv/dut/core_inst/datapath_inst/exemem_cu_signals_out
add wave -noupdate -format Literal -label wb_control /tb_riscv/dut/core_inst/datapath_inst/memwb_cu_signals_out
add wave -noupdate -format Literal -label a -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/execute_stage_inst/a
add wave -noupdate -format Literal -label add_rs1 -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/add_rd1
add wave -noupdate -format Literal -label b -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/execute_stage_inst/b
add wave -noupdate -format Literal -label add_rs2 -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/add_rd2
add wave -noupdate -format Literal -label imm -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/imm_ext/immediate_out
add wave -noupdate -format Literal -label exe_res -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/exe_res_out
add wave -noupdate -format Literal -label exe_rd2_out -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/exe_reg_out
add wave -noupdate -format Literal -label exe_target_address -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/exe_pc_out
add wave -noupdate -format Literal -label idexe_rd_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/idexe_rd_out
add wave -noupdate -format Literal -label exemem_rd_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/exemem_rd_out
add wave -noupdate -format Literal -label memwb_rd_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/memwb_rd_out
add wave -noupdate -format Literal -label target_address -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/target_address_from_exe_stage
add wave -noupdate -format Literal -radix decimal /tb_riscv/dut/dmem_inst/curr_mem
add wave -noupdate -format Literal -radix hexadecimal /tb_riscv/dut/imem_inst/mem
add wave -noupdate -format Logic /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/rf_en
add wave -noupdate -format Logic /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/rd1
add wave -noupdate -format Logic /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/rd2
add wave -noupdate -format Logic /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/rf_wr
add wave -noupdate -format Literal -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/add_rd1
add wave -noupdate -format Literal -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/add_rd2
add wave -noupdate -format Literal -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/out1
add wave -noupdate -format Literal -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/out2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85210 ps} 0}
configure wave -namecolwidth 500
configure wave -valuecolwidth 88
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {67250 ps} {93370 ps}
