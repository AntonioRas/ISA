library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity IRAM is
	port(Addr	:	in 	std_logic_vector(15 downto 0);
		 en		:	in 	std_logic;
		 clk	:	in	std_logic;
		 Dout	:	out	std_logic_vector(31 downto 0)
);
end IRAM;

Architecture behavioral of IRAM is
	constant	SIZE	: positive:= 2**16;
	type		memory	is array (SIZE-1 downto 0) of std_logic_vector(31 downto 0);
	signal		MEM		: memory;
	signal		addr_int: natural;

begin
	addr_int<=to_integer(unsigned(Addr));

	read_write_file: process(clk)
		file fd: text;
		variable fl : line;
		variable loc : integer:=0;
		variable instruction : std_logic_vector(31 downto 0);
	begin
		if rising_edge(clk) then
			if en='1' then
				Dout<=MEM(addr_int);
			else
				Dout<=(others=>'0');
			end if;
			file_open(fd,"text.txt",READ_MODE); 
			while(not endfile(fd)) loop
				readline(fd,fl);
				hread(fl,instruction);
				MEM(loc) <= instruction;
				loc:=loc+1;
			end loop;
		end if;
	end process read_write_file;
end behavioral;
