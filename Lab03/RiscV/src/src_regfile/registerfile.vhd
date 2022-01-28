library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ALL;
use WORK.all;

entity register_file is
  generic(NBIT:integer :=32;
          NREG:integer :=32);
 port ( CLK: 		IN std_logic;
         RESET: 	IN std_logic;
	 ENABLE: 	IN std_logic;
	 RD1: 		IN std_logic;
	 RD2: 		IN std_logic;
	 WR: 		IN std_logic;
	 ADD_WR: 	IN std_logic_vector(integer(ceil(log2(real(NREG))))-1 downto 0);
	 ADD_RD1: 	IN std_logic_vector(integer(ceil(log2(real(NREG))))-1 downto 0);
	 ADD_RD2: 	IN std_logic_vector(integer(ceil(log2(real(NREG))))-1 downto 0);
	 DATAIN: 	IN std_logic_vector(NBIT-1 downto 0);
         OUT1: 		OUT std_logic_vector(NBIT-1 downto 0);
	 OUT2: 		OUT std_logic_vector(NBIT-1 downto 0));
end register_file;

architecture A of register_file is

        -- suggested structures
        subtype REG_ADDR is natural range 0 to NREG-1; -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(NBIT-1 downto 0); 
	signal REGISTERS : REG_ARRAY:=(others=>(others=>'0')); 
	
begin 
-- write your RF code 
regFile: process(CLK,RESET)
    begin
      if (RESET = '1') then
      OUT1<=(others=>'0'); 
	  OUT2<=(others=>'0');
	  REGISTERS<=(others=>(others=>'0'));
      elsif rising_edge(CLK) then
         if(ENABLE = '1' and WR = '1') then
          REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
         end if;
           if (RD1='1' and ENABLE = '1') then
            OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
           end if;
            if (RD2 = '1'and ENABLE = '1') then
             OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
            end if;
      end if;
    end process;

end A;

----


configuration CFG_RF_BEH of register_file is
  for A
  end for;
end configuration;
