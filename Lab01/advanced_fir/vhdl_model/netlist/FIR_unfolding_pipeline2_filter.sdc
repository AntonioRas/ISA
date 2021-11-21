###################################################################

# Created by write_sdc on Sun Nov 21 03:23:47 2021

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_load -pin_load 3.40189 [get_ports {dout0[9]}]
set_load -pin_load 3.40189 [get_ports {dout0[8]}]
set_load -pin_load 3.40189 [get_ports {dout0[7]}]
set_load -pin_load 3.40189 [get_ports {dout0[6]}]
set_load -pin_load 3.40189 [get_ports {dout0[5]}]
set_load -pin_load 3.40189 [get_ports {dout0[4]}]
set_load -pin_load 3.40189 [get_ports {dout0[3]}]
set_load -pin_load 3.40189 [get_ports {dout0[2]}]
set_load -pin_load 3.40189 [get_ports {dout0[1]}]
set_load -pin_load 3.40189 [get_ports {dout0[0]}]
set_load -pin_load 3.40189 [get_ports {dout1[9]}]
set_load -pin_load 3.40189 [get_ports {dout1[8]}]
set_load -pin_load 3.40189 [get_ports {dout1[7]}]
set_load -pin_load 3.40189 [get_ports {dout1[6]}]
set_load -pin_load 3.40189 [get_ports {dout1[5]}]
set_load -pin_load 3.40189 [get_ports {dout1[4]}]
set_load -pin_load 3.40189 [get_ports {dout1[3]}]
set_load -pin_load 3.40189 [get_ports {dout1[2]}]
set_load -pin_load 3.40189 [get_ports {dout1[1]}]
set_load -pin_load 3.40189 [get_ports {dout1[0]}]
set_load -pin_load 3.40189 [get_ports {dout2[9]}]
set_load -pin_load 3.40189 [get_ports {dout2[8]}]
set_load -pin_load 3.40189 [get_ports {dout2[7]}]
set_load -pin_load 3.40189 [get_ports {dout2[6]}]
set_load -pin_load 3.40189 [get_ports {dout2[5]}]
set_load -pin_load 3.40189 [get_ports {dout2[4]}]
set_load -pin_load 3.40189 [get_ports {dout2[3]}]
set_load -pin_load 3.40189 [get_ports {dout2[2]}]
set_load -pin_load 3.40189 [get_ports {dout2[1]}]
set_load -pin_load 3.40189 [get_ports {dout2[0]}]
set_load -pin_load 3.40189 [get_ports vout0]
set_load -pin_load 3.40189 [get_ports vout1]
set_load -pin_load 3.40189 [get_ports vout2]
create_clock [get_ports clk]  -name my_clk  -period 7.4  -waveform {0 3.7}
set_clock_uncertainty 0.07  [get_clocks my_clk]
