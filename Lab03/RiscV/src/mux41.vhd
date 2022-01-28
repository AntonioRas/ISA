----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: mux 41
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux41 is
    generic ( N : integer := 32);
       port ( op1, op2, op3, op4 : IN  std_logic_vector(N-1 downto 0);
                             sel : IN  std_logic_vector(  1 downto 0);
                             res : OUT std_logic_vector(N-1 downto 0));
end mux41;

architecture Behavioral of mux41 is
begin

mux : process(op1, op2, op3, op4, sel)
      begin
        case sel is
            when "00" => 
                        res <= op1;
            when "01" =>
                        res <= op2;
            when "10" =>
                        res <= op3;
            when others =>
                        res <= op4;
        end case;
      end process;
end Behavioral;
