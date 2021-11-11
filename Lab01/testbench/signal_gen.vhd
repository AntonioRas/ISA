----------------------------------------------------------------------------------
-- Create Date: 09.11.2021 
-- Module Name: signal_gen - Behavioral
-- Description: signal generator needed for the tb to test a FIR filter
-- Additional Comments: IN clk and rst from clk_gen.vhd
-- OUT to filter
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
-- use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity signal_generator is
	port( -- from clk_gen.vhd
		  clk:  IN std_logic;
		  rst:  IN std_logic;
		  
		  Vin: OUT std_logic;   -- to filter
      end_sim: OUT std_logic;	-- to clk_gen	  
		
		   b0: OUT std_logic_vector(9 downto 0);      -- 10 is the number of bits of our filter
		   b1: OUT std_logic_vector(9 downto 0);
		   b2: OUT std_logic_vector(9 downto 0);
		   b3: OUT std_logic_vector(9 downto 0);
		   b4: OUT std_logic_vector(9 downto 0);
		   b5: OUT std_logic_vector(9 downto 0);
		   b6: OUT std_logic_vector(9 downto 0);
		   b7: OUT std_logic_vector(9 downto 0);
		   b8: OUT std_logic_vector(9 downto 0);
		   b9: OUT std_logic_vector(9 downto 0);
		  Din: OUT std_logic_vector(9 downto 0));
end signal_generator;

architecture beh of signal_generator is 

	constant  t : time := 2 ns; -- T = 10 ns 
	
	signal end_sim_s : std_logic;
	signal end_sim_i : std_logic_vector(0 to 10);
	
	begin
	
	-- b <= "signal"; 10 bit
	b0 <= "0000000000";
	b1 <= "0000000001";
	b2 <= "0000000010";
	b3 <= "0000000011";
	b4 <= "0000000100";
	b5 <= "0000000101";
	b6 <= "0000000110";
	b7 <= "0000000111";
	b8 <= "0000001000";
	b9 <= "0000001001";
	
	dataProcess: process (clk, rst)
	                 file fp : text open READ_MODE is "../path_to/samples.txt";
	                 variable line_in : line;
	                 variable x : integer;
		         begin
			         if rst = '0' then           -- asynch reset (active low)
			             Din <= (others => '0') after t;
			             Vin <= '0' after t;
			             end_sim_s <= '0';       -- 0 sim running; 1 sim ended
			         elsif clk'event and clk = '1' then 
			             if not endfile(fp) then
			                 readline(fp, line_in);
			                 read(line_in, x);
			                 Din <= conv_std_logic_vector(x,10) after t;
			                 vin <= '1' after t;
			                 end_sim_s <= '0' after t;
			             else
			                 Vin <= '0' after t;
			                 end_sim_s <= '1' after t;
			             end if;
			         end if;
			     end process;
			             
   end_sim_proc: process (clk, rst)
                 begin  -- process
                    if rst = '0' then                 -- asynchronous reset (active low)
                        end_sim_i <= (others => '0') after t;
                    elsif clk'event and clk = '1' then  -- rising clock edge
                        end_sim_i(0) <= end_sim_s after t;
                        end_sim_i(1 to 10) <= end_sim_i(0 to 9) after t;
                    end if;
                 end process;

  end_sim <= end_sim_i(10);  

end beh;