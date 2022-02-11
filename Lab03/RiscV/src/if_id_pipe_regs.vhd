library ieee;
use ieee.std_logic_1164.ALL;

entity if_id_pipe_regs is
    generic (NDATA : integer := 32 );
    port (
		clk: in std_logic;
		rst: in std_logic;

		pc_in: in std_logic_vector(NDATA-1 downto 0); 
		instr_in: in std_logic_vector(NDATA-1 downto 0); 

		-- enable signal
		ifid_pipe_regs_en: in std_logic;

		pc_out: out std_logic_vector(NDATA-1 downto 0);
		instr_out: out std_logic_vector(NDATA-1 downto 0)
	);
end if_id_pipe_regs;

architecture struct of if_id_pipe_regs is

    component reg is
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
    end component reg;

begin

    pc_pipe_reg : reg generic map(NDATA) port map(clk, rst, ifid_pipe_regs_en, pc_in, pc_out);

    instr_pipe_reg : reg generic map(NDATA) port map(clk, rst, ifid_pipe_regs_en, instr_in, instr_out);

end struct;