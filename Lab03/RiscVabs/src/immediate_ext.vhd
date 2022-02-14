library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;


entity immediate_ext is
	port(
		instr: in std_logic_vector(31 downto 0);
		instr_type_sel: in std_logic_vector(2 downto 0);
		immediate_out: out std_logic_vector(31 downto 0)
		);
end immediate_ext;

architecture beh of immediate_ext is

	constant zeros: std_logic_vector(11 downto 0) := (others => '0');

	signal msb: std_logic_vector(19 downto 0);

begin
	
	msb <= (others => instr(31));

	immediate_out <= 	msb(19 downto 0) & msb(6 downto 0) & instr(24 downto 20)							  when (instr_type_sel = I_INSTR_TYPE and instr(14 downto 12) = "101") else 
						msb(19 downto 0) & instr(31 downto 20)                                                when instr_type_sel = I_INSTR_TYPE else
				        msb(19 downto 0) & instr(31 downto 25) & instr(11 downto 7)                           when instr_type_sel = S_INSTR_TYPE else
				        msb(19 downto 0) & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8)    when instr_type_sel = B_INSTR_TYPE else
				        zeros & instr(31 downto 12)                                                           when instr_type_sel = U_INSTR_TYPE else
				        msb(11 downto 0) & instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21)  when instr_type_sel = J_INSTR_TYPE else
				        (others => '0');


end beh;