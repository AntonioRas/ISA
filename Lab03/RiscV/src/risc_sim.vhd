library ieee;
use ieee.std_logic_1164.all;

entity riscv_sim is
	generic (
        NDATA : integer := 32 ;
        NADDR : integer := 32 ;
        REG_SIZE : integer := 5;
		A_ROM: integer := 32; -- address bit width
		W_ROM: integer := 256; -- number of words
		A_RAM: integer := 32; -- address bit width
		W_RAM: integer := 256; -- number of words
        D_RAM: integer := 0
	);
	port (
		clk: in std_logic;
		rst: in std_logic
	);
end riscv_sim;

architecture struct of riscv_sim is
    component core is
        generic (NDATA : integer := 32 ;
                 NADDR : integer := 32 ;
                 REG_SIZE : integer := 32 );
        port (
              clk: in std_logic;
              rst: in std_logic;
              
              -- IMEM interface
              imem_instr: in std_logic_vector(NDATA-1 downto 0);
              imem_address: out std_logic_vector(NDATA-1 downto 0);
              
              -- DMEM interface
              dmem_en : out std_logic;
              dmem_rw : out std_logic; -- 1 for write, 0 for read
              dmem_datain: in std_logic_vector(NDATA-1 downto 0);
              dmem_dataout: out std_logic_vector(NDATA-1 downto 0);
              dmem_address: out std_logic_vector(NDATA-1 downto 0)
        );
  end component core;

  component imem is
        generic (
            N: integer := 32; -- data bit width
            A: integer := 32; -- address bit width
            W: integer := 32 -- number of words
        );
        port (
            rst: in std_logic;
            address: in std_logic_vector(A-1 downto 0);
            data: out std_logic_vector(N-1 downto 0)
        );
    end component imem;
    component dmem is
        generic (
            N: integer := 32; -- data bit width
            A: integer := 32; -- address bit width
            W: integer := 16; -- number of words
            D: integer := 0 -- start address of data segment
        );
        port (
            clk: in std_logic;
            rst: in std_logic;
            address: in std_logic_vector(A-1 downto 0);
            wr, en: in std_logic; -- 1 for write, 0 for read
            datain: in std_logic_vector(N-1 downto 0);
            dataout: out std_logic_vector(N-1 downto 0)
        );
    end component dmem;

    signal imem_instr_s: std_logic_vector(NDATA-1 downto 0);
    signal imem_address_s: std_logic_vector(NDATA-1 downto 0);
    
    -- DMEM interface
    signal dmem_en_s : std_logic;
    signal dmem_rw_s : std_logic; -- 1 for write, 0 for read
    signal dmem_datain_s: std_logic_vector(NDATA-1 downto 0);
    signal dmem_dataout_s: std_logic_vector(NDATA-1 downto 0);
    signal dmem_address_s: std_logic_vector(NDATA-1 downto 0);

begin

    core_inst :
    core generic map (NDATA, NADDR, REG_SIZE )
        port map ( clk, rst, imem_instr_s, imem_address_s, dmem_en_s, dmem_rw_s, dmem_datain_s, dmem_dataout_s, dmem_address_s );

    imem_inst :
    imem generic map ( NDATA, A_ROM-2, W_ROM )
        port map ( rst, imem_address_s(A_ROM-1 downto 2), imem_instr_s );
    
    dmem_inst :
    dmem generic map ( NDATA, A_RAM, W_RAM, D_RAM )
        port map ( clk, rst, dmem_address_s(A_RAM-1 downto 0), dmem_rw_s, dmem_en_s, dmem_datain_s, dmem_dataout_s );

end struct;