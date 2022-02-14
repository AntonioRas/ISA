library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity DRAM is
	port(
		Din		: in 	std_logic_vector(31 downto 0);
		Addr	: in 	std_logic_vector(15 downto 0);
		Wr_en	: in	std_logic_vector(1 downto 0);
		en		: in	std_logic;
		clk		: in 	std_logic;
		Dout	: out 	std_logic_vector(31 downto 0)
);
end DRAM;

architecture behavioral of DRAM is
	constant	SIZE	: positive:= 2**16;
	type		memory	is array (SIZE-1 downto 0) of std_logic_vector(31 downto 0);
	signal		MEM		: memory;
	signal		addr_int: natural;
begin
	addr_int<=to_integer(unsigned(Addr));

	Dout<=MEM(addr_int);

	read_write_file: process(clk)
		file fd: text;
		variable fl : line;
		variable loc : integer:=0;
		variable instruction: std_logic_vector(31 downto 0);

	begin
		if rising_edge(clk) then
			file_open(fd,"data.hex",READ_MODE); 
			while(not endfile(fd)) loop
				readline(fd,fl);
				hread(fl,instruction);
				MEM(loc) <= instruction;
				loc:=loc+1;
			end loop;
			if en='1' then
				if Wr_en ="01" then
					MEM(addr_int)(7 downto 0)<=Din(7 downto 0);
				elsif Wr_en ="10" then
					MEM(addr_int)(15 downto 0)<=Din(15 downto 0);
				elsif Wr_en ="11" then
					MEM(addr_int)(31 downto 0)<=Din(31 downto 0);
				end if;
			end if;
		end if;
	end process read_write_file;
end behavioral;
