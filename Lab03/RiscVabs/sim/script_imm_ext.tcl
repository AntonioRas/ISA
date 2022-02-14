# compile the src code

vcom -93 -work ./work ../src/dmem.vhd

# compile the testbench code
vcom -93 -work ./work ../tb/tb_ram.vhd

vsim -t 10ps work.tb_ram