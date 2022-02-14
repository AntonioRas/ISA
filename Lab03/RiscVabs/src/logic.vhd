----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: logic unit alu
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic is
    generic ( N : integer := 32);
       port ( A : IN std_logic_vector (N-1 downto 0);
              B : IN std_logic_vector (N-1 downto 0);
           ctrl : IN std_logic;
            
            res : OUT std_logic_vector(N-1 downto 0));
end logic;

architecture beh of logic is
begin
    logic_func : process(A, B, ctrl)
                 begin
                    if(ctrl = '0') then
                        res <= A and B;
                    else 
                        res <= A xor B;
                    end if;
                 end process;

end beh;
