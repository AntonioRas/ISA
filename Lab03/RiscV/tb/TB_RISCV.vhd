library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity tb_riscv is
end tb_riscv;

architecture test of tb_riscv is
	component riscv_sim is
			generic (
        NDATA : integer := 32 ;
        NADDR : integer := 32 ;
        REG_SIZE : integer := 5;
		A_ROM: integer := 32; -- address bit width
		W_ROM: integer := 256; -- number of words
		A_RAM: integer := 32; -- address bit width
		W_RAM: integer := 256; -- number of words
        D_RAM: integer := 64524
	);
	port (
		clk: in std_logic;
		rst: in std_logic
	);
	end component riscv_sim;

	constant period : time := 10 ns;

	signal clk, rst: std_logic;

begin
	dut: riscv_sim
		generic map (
			NDATA => 32, 
			NADDR => 32, 
			REG_SIZE => 5, 
			A_ROM => 8,
			W_ROM => 256,
			A_RAM => 10,
			W_RAM => 1024,
			D_RAM => 64524
		)
		port map (
			clk => clk,
			rst => rst
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	test_proc: process
	begin
		rst <= '1';
		wait for period + period/2;
		rst <= '0';
		wait;
	end process test_proc;
end test;