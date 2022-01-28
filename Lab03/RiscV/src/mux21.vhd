----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: mux 41
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux21 is
    generic ( N : integer := 32);
       port ( op1, op2 : IN  std_logic_vector(N-1 downto 0);
                   sel : IN  std_logic;
                   res : OUT std_logic_vector(N-1 downto 0));
end mux21;

architecture Behavioral of mux21 is
begin

mux : process(op1, op2, sel)
      begin
        case sel is
            when '0' => 
                        res <= op1;
            when '1' =>
                        res <= op2;
        end case;
      end process;
end Behavioral;
