library ieee;
use ieee.std_logic_1164.all;

entity ffd is
	port (
		clk: in std_logic;
		rst_n: in std_logic;
		en: in std_logic;
		d: in std_logic;
		q: out std_logic
	);
end ffd;

architecture beh of ffd is

begin
	clk_proc: process(rst_n, clk)
	begin
		if (rst_n = '0') then
			q <= '0';
		elsif (clk = '1' and clk'event) then
			if (en = '1') then
				q <= d;
			end if;
		end if;
	end process clk_proc;
end beh;