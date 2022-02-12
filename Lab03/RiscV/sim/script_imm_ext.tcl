# compile the src code

vcom -93 -work ./work ../src/hdu.vhd

# compile the testbench code
vcom -93 -work ./work ../tb/tb_hdu.vhd

vsim -t 10ps work.tb_hdu