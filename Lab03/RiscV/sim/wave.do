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
add wave -noupdate -format Logic -label id_stall /tb_riscv/dut/core_inst/id_stall
add wave -noupdate -format Literal -label id_rs1_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/id_rs1_out
add wave -noupdate -format Literal -label id_rs2_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/id_rs2_out
add wave -noupdate -format Literal -label id_rd_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/id_rd_out
add wave -noupdate -format Literal -label register_file -radix hexadecimal -expand /tb_riscv/dut/core_inst/datapath_inst/decode_stage_inst/rf/registers
add wave -noupdate -format Literal -label cw /tb_riscv/dut/core_inst/cu_inst/cw
add wave -noupdate -format Literal -label exe_control /tb_riscv/dut/core_inst/datapath_inst/idexe_cu_signals_out
add wave -noupdate -format Literal -label mem_control /tb_riscv/dut/core_inst/datapath_inst/exemem_cu_signals_out
add wave -noupdate -format Literal -label wb_control /tb_riscv/dut/core_inst/datapath_inst/memwb_cu_signals_out
add wave -noupdate -format Literal -label idexe_rd_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/idexe_rd_out
add wave -noupdate -format Literal -label exemem_rd_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/exemem_rd_out
add wave -noupdate -format Literal -label memwb_rd_out -radix unsigned /tb_riscv/dut/core_inst/datapath_inst/memwb_rd_out
add wave -noupdate -format Logic -label pc_en_from_hdu /tb_riscv/dut/core_inst/datapath_inst/pc_en_from_hdu
add wave -noupdate -format Logic -label ifid_en_from_hdu /tb_riscv/dut/core_inst/datapath_inst/ifid_en_from_hdu
add wave -noupdate -format Literal -label target_address -radix hexadecimal /tb_riscv/dut/core_inst/datapath_inst/target_address_from_exe_stage
add wave -noupdate -format Literal -radix decimal /tb_riscv/dut/dmem_inst/curr_mem
add wave -noupdate -format Literal -radix hexadecimal /tb_riscv/dut/imem_inst/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {75140 ps} 0}
configure wave -namecolwidth 176
configure wave -valuecolwidth 204
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
WaveRestoreZoom {29350 ps} {86940 ps}
