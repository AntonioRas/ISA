# power consumption estimation

# read netlist 
read_verilog -netlist ../netlist/FIR_filter.v

# read saif
read_saif -input ../saif/FIR_filter_syn.saif -instance tb_fir/UUT -unit ns -scale 1

create_clock -name my_clk clk

report_power > report_power_tx4.txt
