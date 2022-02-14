----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: adder
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder is
    generic( N : integer := 32 );
       port( -- inputs
                A : IN std_logic_vector (N-1 downto 0);
                B : IN std_logic_vector (N-1 downto 0);
              Cin : IN std_logic;  
             -- output
                S : OUT std_logic_vector (N-1 downto 0));
end adder;

architecture Behavioral of adder is
    signal tmp_s : std_logic_vector(N downto 0);
    signal cin_s : std_logic_vector(N downto 0);
    
begin
    cin_s <= (0 => Cin, others => '0');
    tmp_s <= std_logic_vector(unsigned('0' & A) + unsigned('0' & b) + unsigned(Cin_s));
        s <= tmp_s (N-1 downto 0);

end Behavioral;
