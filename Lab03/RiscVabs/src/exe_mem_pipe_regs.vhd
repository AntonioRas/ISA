library ieee;
use ieee.std_logic_1164.ALL;
use work.constants.all;

entity exe_mem_pipe_regs is
    generic (NDATA : integer := 32 ;
             REG_SIZE : integer := 5 );
	port (
		clk: in std_logic;
		rst: in std_logic;

		alu_data_in: in std_logic_vector(NDATA-1 downto 0);
		reg_data_in: in std_logic_vector(NDATA-1 downto 0);
		rd_in: in std_logic_vector(REG_SIZE-1 downto 0);
        cu_signal_in : in std_logic_vector(at_MEM_SIGNALS-1 downto 0); 

		exemem_pipe_regs_en : in std_logic;

		alu_data_out: out std_logic_vector(NDATA-1 downto 0);
		reg_data_out: out std_logic_vector(NDATA-1 downto 0);
		rd_out: out std_logic_vector(REG_SIZE-1 downto 0);
        cu_signal_out : out std_logic_vector(at_MEM_SIGNALS-1 downto 0)
	);
end exe_mem_pipe_regs;

architecture struct of exe_mem_pipe_regs is

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

    alu_res_pipe_regs : reg generic map(NDATA) port map(clk, rst, exemem_pipe_regs_en, alu_data_in, alu_data_out);
    reg_out_pipe_regs : reg generic map(NDATA) port map(clk, rst, exemem_pipe_regs_en, reg_data_in, reg_data_out);
    rd_pipe_regs : reg generic map(REG_SIZE) port map(clk, rst, exemem_pipe_regs_en, rd_in, rd_out);
    cu_signal_regs : reg generic map(at_MEM_SIGNALS) port map(clk, rst, '1', cu_signal_in, cu_signal_out);

end struct;
