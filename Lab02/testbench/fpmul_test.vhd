LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity fpmul_test is
end fpmul_test;

architecture behavior of fpmul_test is

component FPmul IS
   PORT( 
      FP_Atemp : IN     std_logic_vector (31 DOWNTO 0);
      FP_Btemp : IN     std_logic_vector (31 DOWNTO 0);
      clk  : IN     std_logic;
      FP_Z : OUT    std_logic_vector (31 DOWNTO 0)
   );	
END component ;

component data_maker is
  port (
    CLK  : in  std_logic;
    DATA : out std_logic_vector(31 downto 0));
end component;

signal FP_A: std_logic_vector (31 DOWNTO 0):= (others=>'0');
signal FP_B: std_logic_vector (31 DOWNTO 0):= (others=>'0');
signal   fz: std_logic_vector (31 downto 0):= (others=>'0');
signal   eq: std_logic;
signal read: std_logic;
signal clk : std_logic:= '0';
signal FP_Z: std_logic_vector (31 DOWNTO 0):= (others=>'0');

begin
  D1: data_maker port map(clk,FP_A);
  D2: data_maker port map(clk,FP_B);
  uut: FPmul port map (FP_A,FP_B,clk,FP_Z);
  clk <= not clk after 1 ns;

  read <= '0', '1' after 12 ns;

  read_proc: process(clk, read)
			 file fp: text open read_mode is "./fp_prod.hex";
		variable lin: line;
        variable val: std_logic_vector(31 downto 0);

			 begin
				if clk'event and clk = '1' and read = '1' then 
					if (not(endfile(fp))) then
						readline(fp, lin);
						hread(lin, val);
						fz <= val;
					end if;
				end if;
			end process read_proc;

  check : process (fp_z, fz)
		  begin 
			if(fp_z = fz) then
				eq <= '1';
			else
				eq <= '0';
			end if;
		  end process check;

end architecture behavior;
