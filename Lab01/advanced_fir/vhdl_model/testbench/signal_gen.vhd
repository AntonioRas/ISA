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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity signal_gen is
	port( -- from clk_gen.vhd
		  clk:  IN std_logic;
		  rst:  IN std_logic;
		  
		  Vin0: OUT std_logic;   -- to filter
		  Vin1: OUT std_logic;   -- to filter
		  Vin2: OUT std_logic;   -- to filter
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
		  b10: OUT std_logic_vector(9 downto 0);
		 Din0: OUT std_logic_vector(9 downto 0);
		 Din1: OUT std_logic_vector(9 downto 0);
		 Din2: OUT std_logic_vector(9 downto 0));
end signal_gen;

architecture beh of signal_gen is 

	constant  t : time := 2 ns; -- T = 10 ns 
	
	signal end_sim_s : std_logic;
	signal end_sim_i : std_logic_vector(0 to 10);
	
	begin
	
	-- b <= "signal"; 10 bit
	b0 <= conv_std_logic_vector(-1,10);
	b1 <= conv_std_logic_vector(-7,10);
	b2 <= conv_std_logic_vector(-13,10);
	b3 <= conv_std_logic_vector(32,10);
	b4 <= conv_std_logic_vector(140,10);
	b5 <= conv_std_logic_vector(203,10);
	b6 <= conv_std_logic_vector(140,10);
	b7 <= conv_std_logic_vector(32,10);
	b8 <= conv_std_logic_vector(-13,10);
	b9 <= conv_std_logic_vector(-7,10);
	b10 <= conv_std_logic_vector(-1,10);
	
	dataProcess: process (clk, rst)
	                 file fp : text open READ_MODE is "./samples.txt";
	                 variable line_in : line;
	                 variable x : integer;
		         begin
			         if rst = '0' then           -- asynch reset (active low)
			             Din0 <= (others => '0') after t;
			             Vin0 <= '0' after t;
						 Din1 <= (others => '0') after t;
			             Vin1 <= '0' after t;
						 Din2 <= (others => '0') after t;
			             Vin2 <= '0' after t;
			             end_sim_s <= '0';       -- 0 sim running; 1 sim ended
			         elsif clk'event and clk = '1' then 
			             if not endfile(fp) then
			                 readline(fp, line_in);
			                 read(line_in, x);
			                 Din0 <= conv_std_logic_vector(x,10) after t;
			                 vin0 <= '1' after t;

							 readline(fp, line_in);
			                 read(line_in, x);
			                 Din1 <= conv_std_logic_vector(x,10) after t;
			                 vin1 <= '1' after t;

							 readline(fp, line_in);
			                 read(line_in, x);
			                 Din2 <= conv_std_logic_vector(x,10) after t;
			                 vin2 <= '1' after t;

			                 end_sim_s <= '0' after t;
			             else
			                 Vin0 <= '0' after t;
							 Vin1 <= '0' after t;
							 Vin2 <= '0' after t;
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