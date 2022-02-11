library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;

entity hdu is
    generic ( REG_SIZE : integer := 5 );
    port ( -- input
           id_rs1, id_rs2 : in std_logic_vector(REG_SIZE-1 downto 0);
           idexe_rd, exemem_rd, memwb_rd : in std_logic_vector(REG_SIZE-1 downto 0);
		   id_instr_type: in std_logic_vector(2 downto 0); 
           exe_taken : in std_logic;
           -- output
           stall_out : out std_logic;
           if_pc_en, ifid_en : out std_logic

    );

end hdu;

architecture beh of hdu is

begin
    process(idexe_rd, exemem_rd, memwb_rd, id_rs1, id_rs2)
    begin
        if (id_instr_type = R_INSTR_TYPE or id_instr_type = S_INSTR_TYPE or id_instr_type = B_INSTR_TYPE) then -- instruction uses both registers
            if (((id_rs1 = idexe_rd and idexe_rd /= "00000") or (id_rs1 = exemem_rd and exemem_rd /= "00000") or (id_rs1 = memwb_rd and exemem_rd /= "00000") or (id_rs2 = idexe_rd and idexe_rd /= "00000") or (id_rs2 = exemem_rd and exemem_rd /= "00000") or (id_rs2 = memwb_rd and exemem_rd /= "00000")) and exe_taken = '0') then
                stall_out <= '1'; -- force NOP
                if_pc_en <= '0';
                ifid_en <= '0';
            end if;
        elsif (id_instr_type = I_INSTR_TYPE) then
            if (((id_rs1 = idexe_rd and idexe_rd /= "00000") or (id_rs1 = exemem_rd and exemem_rd /= "00000") or (id_rs1 = exemem_rd and memwb_rd /= "00000")) and exe_taken = '0') then
                stall_out <= '1'; -- force NOP
                if_pc_en <= '0';
                ifid_en <= '0';
            end if;
        else
            stall_out <= '0'; -- force NOP
            if_pc_en <= '1';
            ifid_en <= '1';
        end if;
    end process;

end beh;