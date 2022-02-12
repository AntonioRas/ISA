library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity tb_hdu is
end tb_hdu;

architecture tb of tb_hdu is
    component hdu is
        generic ( REG_SIZE : integer := 5 );
        port ( -- input
               id_rs1, id_rs2 : in std_logic_vector(REG_SIZE-1 downto 0);
               idexe_rd, exemem_rd, memwb_rd : in std_logic_vector(REG_SIZE-1 downto 0);
               id_instr_type: in std_logic_vector(2 downto 0); 
               exe_taken : in std_logic;
               -- output
               stall_out : out std_logic;
               if_pc_en, ifid_en : out std_logic;
               rst_ifid, rst_idexe : out std_logic
    
        );
    
    end component hdu;

    signal id_rs1, id_rs2 : std_logic_vector(4 downto 0);
    signal idexe_rd, exemem_rd, memwb_rd : std_logic_vector(4 downto 0);
    signal id_instr_type: std_logic_vector(2 downto 0); 
    signal exe_taken : std_logic;
    -- output
    signal stall_out : std_logic;
    signal if_pc_en, ifid_en : std_logic;
    signal rst_ifid, rst_idexe : std_logic;

begin

    dut: hdu generic map(5) port map(id_rs1, id_rs2, idexe_rd, exemem_rd, memwb_rd, id_instr_type, exe_taken, stall_out, if_pc_en, ifid_en, rst_ifid, rst_idexe);

	test_p: process
	begin
        exe_taken <= '0';

        id_rs1 <= "00100"; id_rs2 <= "00101";
        idexe_rd <= "00100"; exemem_rd <= "00000"; memwb_rd <= "10000";
        id_instr_type <= R_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= I_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= U_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= S_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= J_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= B_INSTR_TYPE;
        wait for 1 ns;

        idexe_rd <= "01100";
        id_instr_type <= R_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= I_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= U_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= S_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= J_INSTR_TYPE;
        wait for 1 ns;
        id_instr_type <= B_INSTR_TYPE;
        wait;



    end process;
end tb;