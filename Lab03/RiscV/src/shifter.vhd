----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: shifter
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
    generic (N : integer := 32);
       port (to_shift :  IN std_logic_vector(N-1 downto 0);
                shamt :  IN std_logic_vector(  4 downto 0);
                
                  res : OUT std_logic_vector(N-1 downto 0));

end shifter;

architecture beh of shifter is

begin
sh: process (to_shift, shamt)
    begin        
        res <= to_stdlogicvector(to_bitvector(std_logic_vector(to_shift)) sra to_integer(unsigned(shamt)));
    end process;
end beh;