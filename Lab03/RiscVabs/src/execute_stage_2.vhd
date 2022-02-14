----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: execute stage wrapper
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity execute_stage is
   generic (NDATA : integer := 32 ;
           REG_SIZE : integer := 5);
	port (
		pc: in std_logic_vector(NDATA-1 downto 0); 
		a: in std_logic_vector(NDATA-1 downto 0);
		b: in std_logic_vector(NDATA-1 downto 0);
		imm: in std_logic_vector(NDATA-1 downto 0);
      rd_in : in std_logic_vector(REG_SIZE-1 downto 0);

		b_sel: in std_logic;
		sel_op : in std_logic_vector(2 downto 0);
		branch_enable: in std_logic; -- if set to 1 enables the possibility to jump
      jump_enable: in std_logic;

		res: out std_logic_vector(NDATA-1 downto 0);
		reg_out: out std_logic_vector(NDATA-1 downto 0);
		pc_out: out std_logic_vector(NDATA-1 downto 0);
      rd_out : out std_logic_vector(REG_SIZE-1 downto 0);
		pc_sel: out std_logic -- used by the IF stage to determine which PC must be used
	);
end execute_stage;


architecture beh of execute_stage is

      component alu 
         generic ( N: integer := 32 );
         port ( -- inputs   
                  A : IN  std_logic_vector( N-1 downto 0);
               B : IN  std_logic_vector( N-1 downto 0);
            sel_op : IN  std_logic_vector(   2 downto 0);
               -- outputs
            zero : OUT std_logic;
               res : OUT std_logic_vector( N-1 downto 0));
      end component;

      component adder 
         generic( N : integer := 32 );
            port( -- inputs
                     A : IN std_logic_vector (N-1 downto 0);
                     B : IN std_logic_vector (N-1 downto 0);
                  Cin : IN std_logic;  
                  -- output
                     S : OUT std_logic_vector (N-1 downto 0));
      end component;

      component mux21 
         generic ( N : integer := 32);
            port ( op1, op2 : IN  std_logic_vector(N-1 downto 0);
                        sel : IN  std_logic;
                        res : OUT std_logic_vector(N-1 downto 0));
      end component;

      signal imm_op2, mux_out, imm_shift : std_logic_vector (NDATA-1 downto 0);
      signal zero : std_logic;

begin
      -- compute address destination when jump/branch instruction is fetched
      ADD_C : adder generic map ( NDATA )
                     port map ( PC, imm_shift, '0', pc_out );
                     
      imm_shift <= imm(NDATA-2 downto 0) & '0';
                     
      MX1_C : mux21 generic map ( NDATA )
                     port map ( b, imm, b_sel, imm_op2);

      ALU_C : alu   generic map ( NDATA )
                     port map ( a, imm_op2, sel_op, zero, res); 

      reg_out <= b;

      rd_out <= rd_in;

      pc_sel <= '1' when ( (zero = '1' and branch_enable = '1' ) or jump_enable = '1' ) else
                '0';
                     
end beh;