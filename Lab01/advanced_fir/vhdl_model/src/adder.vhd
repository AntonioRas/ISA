library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic (
		NBIT: integer := 10
	);
	port (
		a: in std_logic_vector(NBIT-1 downto 0);
		b: in std_logic_vector(NBIT-1 downto 0);
		sum: out std_logic_vector(NBIT-1 downto 0)
	);
end adder;

architecture beh of adder is

begin

	comblogic: process(a, b)
		variable sum_ext: signed(NBIT downto 0);
		variable a_ext, b_ext: std_logic_vector(NBIT downto 0);
	begin
		a_ext := a(NBIT-1) & a;
		b_ext := b(NBIT-1) & b;
		sum_ext := signed(a_ext) + signed(b_ext);
		sum <= std_logic_vector( sum_ext(NBIT-1 downto 0) );
		
	end process comblogic;

end beh;