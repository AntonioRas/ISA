---------------------------------------------------------------------------------
-- Create Date: 12.02.2022
-- Module Name: abs unit
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: additional unit of the processor
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity abs_fu is
	generic (   N: integer := 32 );
	   port (   A: IN  std_logic_vector(N-1 downto 0);
		      res: OUT std_logic_vector(N-1 downto 0));
end abs_fu;

architecture behavioral of abs_fu is

begin

	res <= std_logic_vector(abs(signed(A)));

end behavioral;