----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: ALU
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: component of exec stage of the pipeline 
-- lite alu: ADD, AND, XOR, SHIFT, COMPARE
-- sel_op : 00 ADD, 01 logic, 10 compare, 11 shift
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu is
	generic ( N: integer := 32 );
	port ( -- inputs   
	         A : IN  std_logic_vector( N-1 downto 0);
		     B : IN  std_logic_vector( N-1 downto 0);
		sel_op : IN  std_logic_vector(   2 downto  0);
		   -- outputs
		  zero : OUT std_logic;
		   res : OUT std_logic_vector( N-1 downto 0));
end alu;

architecture structural of alu is
	component adder 
    generic( N : integer := 32 );
       port( -- inputs
                A : IN std_logic_vector (N-1 downto 0);
                B : IN std_logic_vector (N-1 downto 0);
              Cin : IN std_logic;  
             -- output
                S : OUT std_logic_vector (N-1 downto 0));
    end component;
    
    component logic 
    generic ( N : integer := 32);
       port ( A : IN std_logic_vector (N-1 downto 0);
              B : IN std_logic_vector (N-1 downto 0);
           ctrl : IN std_logic;
            
            res : OUT std_logic_vector(N-1 downto 0));
    end component;

    component comparator 
    generic( N : integer := 32);
       port( A : IN  std_logic_vector(N-1 downto 0);
             B : IN  std_logic_vector(N-1 downto 0);
          ctrl : IN  std_logic;  -- 0 eq 1 lt
          
           RES : OUT std_logic);
    end component;

    component shifter
    generic (N : integer := 32);
       port (to_shift :  IN std_logic_vector(N-1 downto 0);
                shamt :  IN std_logic_vector(  4 downto 0);
                
                  res : OUT std_logic_vector(N-1 downto 0));

    end component;
    
    component mux61 
    generic ( N : integer := 32);
       port ( op1, op2, op3, op4 : IN  std_logic_vector(N-1 downto 0);
			  op5, op6           : IN  std_logic_vector(N-1 downto 0);
                             sel : IN  std_logic_vector(  2 downto 0);
                             res : OUT std_logic_vector(N-1 downto 0));
    end component;

	
	signal add_o, logic_o, compare_o, shift_o: std_logic_vector(N-1 downto 0);
    signal imm_zero_s, abs_s: std_logic_vector(N-1 downto 0);
	signal tmp_cmp : std_logic;
begin

ADD_C : adder      generic map ( N )
                      port map ( A, B, '0', add_o );
                 
LOG_C : logic      generic map ( N )
                      port map ( A, B, sel_op(0), logic_o);

CMP_C : comparator generic map ( N )
                      port map ( A, B, sel_op(0), tmp_cmp);
compare_o <= (0 => tmp_cmp, others => '0');
     zero <= tmp_cmp;

SHF_C : shifter    generic map ( N )
                      port map ( A, B(4 downto 0), shift_o);

MUX_C : mux61      generic map ( N )
                      port map ( add_o, shift_o, logic_o, compare_o, imm_zero_s, abs_s, sel_op(2 downto 1), res); 
imm_zero_s <= B + '0';
abs_s <= (others => '0');

end structural;

