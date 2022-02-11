library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
  generic( NBIT : integer := 32;
           REG_SIZE : integer := 5 );

  port (  clk, rst: in std_logic;
          rf_en:    in std_logic;
          rd1 :     in std_logic;
          rd2 :     in std_logic;
          rf_wr:    in std_logic;
          add_wr:   in std_logic_vector(REG_SIZE-1 downto 0);
          add_rd1:  in std_logic_vector(REG_SIZE-1 downto 0);
          add_rd2:  in std_logic_vector(REG_SIZE-1 downto 0);
          datain:   in std_logic_vector(NBIT-1 downto 0);
          out1:     out std_logic_vector(NBIT-1 downto 0);
	      out2:     out std_logic_vector(NBIT-1 downto 0));
end register_file;

architecture beh of register_file is

      -- suggested structures
      subtype REG_ADDR is natural range 0 to 2**REG_SIZE-1; -- using natural type
      type REG_ARRAY is array(REG_ADDR) of std_logic_vector(NBIT-1 downto 0); 
	    signal REGISTERS : REG_ARRAY:=(others=>(others=>'0')); 
	
begin 
      -- write your RF code 
      regFile: process(clk, rst)
      begin
      if (rst = '1') then
          out1<=(others=>'0'); 
          out2<=(others=>'0');
          REGISTERS<=(others=>(others=>'0'));
      elsif rising_edge(CLK) then

          if(rf_en = '1' and rf_wr = '1') then
              REGISTERS(to_integer(unsigned(add_wr))) <= datain;
          end if;

          if (rd1='1' and rf_en = '1') then
              out1 <= REGISTERS(to_integer(unsigned(add_rd1)));
          end if;
          
          if (rd2 = '1'and rf_en = '1') then
              out2 <= REGISTERS(to_integer(unsigned(add_rd2)));
          end if;
      end if;
end process;

end beh;
