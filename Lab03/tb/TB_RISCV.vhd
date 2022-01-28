library ieee;
use ieee.std_logic_1164.all;

entity TB_RISCV is
end entity TB_RISCV;

architecture structural of TB_RISCV is

component clk_gen is
    port (clk: OUT std_logic;
              rst: OUT std_logic);
end component;

component DRAM is
	port(
		Din		: in 	std_logic_vector(31 downto 0);
		Addr	: in 	std_logic_vector(15 downto 0);
		Wr_en	: in	std_logic_vector(1 downto 0);
		en		: in	std_logic;
		clk		: in 	std_logic;
		Dout	: out 	std_logic_vector(31 downto 0)
);
end component;

component IRAM is
	port(Addr	:	in 	std_logic_vector(15 downto 0);
		 en		:	in 	std_logic;
		 clk	:	in	std_logic;
		 Dout	:	out	std_logic_vector(31 downto 0)
);
end component;
--Define RISCV CORE component here:

--Define extra signals:

begin
--instantiate the components

end structural;
