----------------------------------------------------------------------------------
-- Create Date: 09.11.2021 
-- Module Name: clk_gen - Behavioral
-- Description: clock & reset generator needed for the tb to test a FIR filter
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_gen is
    port (end_sim:  IN std_logic; -- 1 if sim is ended
              clk: OUT std_logic;
              rst: OUT std_logic);
end clk_gen;

architecture Behavioral of clk_gen is

    constant half_period : time := 5 ns; -- half clock period
    
    signal clk_s : std_logic;

begin

clk_proc: process 
          begin
              if (clk_s = 'U') then 
                clk_s <= '0';
              else
                clk_s <= not(clk_s);
              end if;
              wait for half_period;
         end process;
         
clk <= clk_s and not(end_sim); -- clock updated only if the sim is still running

rst_proc: process
          begin 
              rst <= '0';
              wait for 5*half_period;
              rst <= '1';
              wait;
          end process;
            
end Behavioral;
