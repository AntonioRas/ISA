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
 generic ( N : integer := 32);
    port ( -- inputs
          immediate : IN  std_logic_vector(N-1 downto 0);
          operand_1 : IN  std_logic_vector(N-1 downto 0);
          operand_2 : IN  std_logic_vector(N-1 downto 0);
                 PC : IN  std_logic_vector(N-1 downto 0);
          reg_dest1 : IN  std_logic_vector(  4 downto 0);
          reg_dest2 : IN  std_logic_vector(  4 downto 0); 
           -- control signals
           alu_ctrl : IN  std_logic_vector(  2 downto 0);
             ALUSrc : IN  std_logic;
             regDst : IN  std_logic;
           -- outputs
             result : OUT std_logic_vector(N-1 downto 0);
             PC_out : OUT std_logic_vector(N-1 downto 0);
               zero : OUT std_logic;
              b_out : OUT std_logic_vector(N-1 downto 0);
               dest : OUT std_logic_vector(  4 downto 0));
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

signal imm_op2, mux_out, imm_shift : std_logic_vector (N-1 downto 0);

begin
ADD_C : adder generic map ( N )
                 port map ( PC, imm_shift, '0', PC_out );
                 
imm_shift <= immediate(N-3 downto 0) & "00";
                 
MX1_C : mux21 generic map ( N )
                 port map ( operand_2, immediate, ALUSrc, imm_op2);

ALU_C : alu   generic map ( N )
                 port map ( operand_1, imm_op2, alu_ctrl, zero, result); 

MX2_C : mux21 generic map ( N )
                 port map ( reg_dest1, reg_dest2, regDst, dest);

end beh;