----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: eq_comparator
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity comparator is
    generic( N : integer := 32);
       port( A : IN  std_logic_vector(N-1 downto 0);
             B : IN  std_logic_vector(N-1 downto 0);
          ctrl : IN  std_logic;  -- 0 eq 1 lt
           RES : OUT std_logic);
end comparator;

architecture Behavioral of comparator is

begin

compare : process (A, B, ctrl)
          begin
            case ctrl is
                when '0' => 
                    if ( A = B) then
                        RES <= '1';
                    else
                        RES <= '0'; 
                    end if;
                when others =>
                    if ( signed(A) < signed(B)) then
                        RES <= '1';
                    else
                        RES <= '0'; 
                    end if;
                end case; 
          end process compare;

end Behavioral;
