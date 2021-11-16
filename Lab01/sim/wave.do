onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_fir/CLK_S
add wave -noupdate -format Logic /tb_fir/RST_S
add wave -noupdate -format Logic /tb_fir/VIN_S
add wave -noupdate -format Logic /tb_fir/VOUT_S
add wave -noupdate -format Literal -radix decimal /tb_fir/DIN_S
add wave -noupdate -format Literal -radix decimal /tb_fir/DOUT_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B0_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B1_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B2_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B3_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B4_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B5_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B6_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B7_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B8_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B9_S
add wave -noupdate -format Literal -radix decimal /tb_fir/B10_S
add wave -noupdate -format Logic /tb_fir/END_SIM_S
add wave -noupdate -format Literal -radix decimal -expand /tb_fir/UUT/adder_out
add wave -noupdate -format Literal -radix decimal -expand /tb_fir/UUT/mult_out
add wave -noupdate -format Literal -radix decimal -expand /tb_fir/UUT/reg_out
add wave -noupdate -format Literal -radix decimal /tb_fir/UUT/coeff_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46780 ps} 0}
configure wave -namecolwidth 206
configure wave -valuecolwidth 100
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
WaveRestoreZoom {34787 ps} {160787 ps}
