library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
	generic (
		NBIT: integer := 10
	);
	port (
		a: in std_logic_vector(NBIT-1 downto 0);
		b: in std_logic_vector(NBIT-1 downto 0);
		res: out std_logic_vector(NBIT-1 downto 0)
	);
end multiplier;

architecture beh of multiplier is

begin
	comblogic: process(a, b)
		variable res_ext: std_logic_vector(2*NBIT-1 downto 0);
	begin
		res_ext := std_logic_vector(signed(a) * signed(b));
        -- Result needs to be truncated
		res <= res_ext(2*NBIT-2 downto NBIT-1);
	end process comblogic;

end beh;