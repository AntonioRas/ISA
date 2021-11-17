###################################################################

# Created by write_sdc on Wed Nov 17 19:19:38 2021

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_load -pin_load 3.40189 [get_ports {dout[9]}]
set_load -pin_load 3.40189 [get_ports {dout[8]}]
set_load -pin_load 3.40189 [get_ports {dout[7]}]
set_load -pin_load 3.40189 [get_ports {dout[6]}]
set_load -pin_load 3.40189 [get_ports {dout[5]}]
set_load -pin_load 3.40189 [get_ports {dout[4]}]
set_load -pin_load 3.40189 [get_ports {dout[3]}]
set_load -pin_load 3.40189 [get_ports {dout[2]}]
set_load -pin_load 3.40189 [get_ports {dout[1]}]
set_load -pin_load 3.40189 [get_ports {dout[0]}]
set_load -pin_load 3.40189 [get_ports vout]
create_clock [get_ports clk]  -name my_clk  -period 3.2  -waveform {0 1.6}
set_clock_uncertainty 0.07  [get_clocks my_clk]
