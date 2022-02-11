library ieee;
use ieee.std_logic_1164.ALL;

package constants is

    -- constants used for the extension of the immediate during decode stage depending on the instruction type
    constant R_INSTR_TYPE: std_logic_vector(2 downto 0) := "000";
	constant I_INSTR_TYPE: std_logic_vector(2 downto 0) := "001";
	constant S_INSTR_TYPE: std_logic_vector(2 downto 0) := "010";
	constant B_INSTR_TYPE: std_logic_vector(2 downto 0) := "011";
	constant U_INSTR_TYPE: std_logic_vector(2 downto 0) := "100";
	constant J_INSTR_TYPE: std_logic_vector(2 downto 0) := "101";
    -- numer of signal for each stage
    constant at_EX_SIGNALS : natural := 8;
    constant at_MEM_SIGNALS : natural := 3;
    constant at_WB_SIGNALS : natural := 1;

end constants;