----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: mux 41
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux61 is
    generic ( N : integer := 32);
       port ( op1, op2, op3, op4 : IN  std_logic_vector(N-1 downto 0);
			  op5, op6           : IN  std_logic_vector(N-1 downto 0);
                             sel : IN  std_logic_vector(  2 downto 0);
                             res : OUT std_logic_vector(N-1 downto 0));
end mux61;

architecture Behavioral of mux61 is
begin

mux : process(op1, op2, op3, op4, op5, op6, sel)
      begin
        case sel is
            when "000" => 
                        res <= op1;
            when "001" =>
                        res <= op2;
            when "010" =>
                        res <= op3;
			when "011" =>
                        res <= op3;
			when "100" =>
                        res <= op4;
			when "101" =>
                        res <= op4;
			when "110" =>
                        res <= op5;
            when others =>
                        res <= op6;
        end case;
      end process;
end Behavioral;
