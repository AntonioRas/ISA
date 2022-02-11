library ieee;
use ieee.std_logic_1164.ALL;
use work.constants.all;

entity id_exe_pipe_regs is
    generic (NDATA : integer := 32 ;
             REG_SIZE : integer := 5 );
	port (
		clk: in std_logic;
		rst: in std_logic;

		pc_in: in std_logic_vector(NDATA-1 downto 0); -- PC
		a_in: in std_logic_vector(NDATA-1 downto 0); -- rd1
		b_in: in std_logic_vector(NDATA-1 downto 0); --rd2
		imm_in: in std_logic_vector(NDATA-1 downto 0); -- immediate
		rd_in: in std_logic_vector(REG_SIZE-1 downto 0); -- destination register
        cu_signal_in : in std_logic_vector(at_EX_SIGNALS-1 downto 0); 

		-- enable signals
		idexe_pipe_regs_en : in std_logic;

		pc_out: out std_logic_vector(NDATA-1 downto 0);
		a_out: out std_logic_vector(NDATA-1 downto 0);
		b_out: out std_logic_vector(NDATA-1 downto 0);
		imm_out: out std_logic_vector(NDATA-1 downto 0);
		rd_out: out std_logic_vector(REG_SIZE-1 downto 0);
        cu_signal_out : in std_logic_vector(at_EX_SIGNALS-1 downto 0)
	);
end id_exe_pipe_regs;

architecture struct of id_exe_pipe_regs is

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

    pc_pipe_reg : reg generic map(NDATA) port map(clk, rst, idexe_pipe_regs_en, pc_in, pc_out);

    op_a_pipe_regs : reg generic map(NDATA) port map(clk, rst, idexe_pipe_regs_en, a_in, a_out);

    op_b_pipe_regs : reg generic map(NDATA) port map(clk, rst, idexe_pipe_regs_en, b_in, b_out);

    imm_pipe_regs : reg generic map(NDATA) port map(clk, rst, idexe_pipe_regs_en, imm_in, imm_out);

    rd_pipe_regs : reg generic map(REG_SIZE) port map(clk, rst, idexe_pipe_regs_en, rd_in, rd_out);

    cu_signal_regs : reg generic map(at_EX_SIGNALS) port map(clk, rst, '1', cu_signal_in, cu_signal_out);

end struct;
