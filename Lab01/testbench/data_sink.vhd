----------------------------------------------------------------------------------
-- Create Date: 09.11.2021 
-- Module Name: data_sink - Behavioral
-- Description: data sink needed for the tb to test a FIR filter
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
-- use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink is 
	port(
		    clk : IN std_logic;
		    rst : IN std_logic;
		   Vout : IN std_logic;
		   Dout : IN std_logic_vector (9 downto 0));
end data_sink;

architecture beh of data_sink is 

begin

sink_proc:  process (clk, rst) 
                file res_fp : text open WRITE_MODE is "../results.txt";
                variable line_out : line;
            begin
                if rst = '0' then 
                    null;
                elsif clk'event and clk = '1' then 
                    if Vout = '1' then 
                        write(line_out, conv_integer(signed(Dout)));
                        writeline(res_fp, line_out);
                    end if;
                end if;
            end process;

end beh;