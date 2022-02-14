library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic (
		NBIT: integer := 10
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		en: in std_logic;
		d: in std_logic_vector(NBIT-1 downto 0);
		q: out std_logic_vector(NBIT-1 downto 0)
	);
end reg;

architecture beh of reg is

begin
	clk_proc: process(rst, clk)
	begin
		if (rst = '1') then
			q <= (others => '0');
		elsif (clk = '1' and clk'event) then
			if (en = '1') then
				q <= d;
			end if;
		end if;
	end process clk_proc;
end beh;