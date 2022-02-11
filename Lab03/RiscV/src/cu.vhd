---------------------------------------------------------------------------------
-- Create Date: 29.01.2022
-- Module Name: control unit
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: main entity of the control unit
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity cu is
    port (    -- INPUTS
              Rst      	 : IN  std_logic;   -- Active Low              
              OPCODE  	 : IN  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC    	 : IN  std_logic_vector(  FUNC3_SIZE - 1 downto 0);
              zero     	 : IN  std_logic;
              -- FETCH
			  PCenable 	 : OUT std_logic;	-- enable reg PC
              --DECODE
			  RD1en,RD2en: OUT std_logic;	-- read enable
			  RFen, RFwr : OUT std_logic;   -- rf enable, write enable (regWrite)
			  instr_type : OUT std_logic_vector (2 downto 0); -- instr type for sign extend
              --EXECUTE
			  ALUSrc     : OUT std_logic;   --select second operand alu )b_sel
              ALUctrl 	 : OUT std_logic_vector(3 downto 0); -- DECODER SIGNAL ALU
			  branch_en	 : OUT std_logic;
			  jump_en	 : OUT std_logic;
              --MEMORY
              MemEn		 : OUT std_logic; -- ENABLE MEMORY 
              MemRW 	 : OUT std_logic; -- 0 ENABLE READ PORT, 1 ENABLE WRITE PORT OF DATA MEMORY STAGE
              --WB
              MemToReg	 : OUT std_logic); -- SEL OF MUX IN WRITEBACK STAGE           
end cu;

architecture Behavioral of cu is
    signal branch : std_logic;
    constant MICROCODE_MEM_SIZE : integer := 28; -- number of possible operations
    constant CW_SIZE : integer := 17; -- number of output control signals
  
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := (--R-TYPE IN INCRESING  ORDER OF FUNC VALUE
                                "11011001100000101",  -- LW
                                "00000000000000000",  -- FUNC 0x01
                                "00000000000000000",  -- FUNC 0x02
                                "00000000000000000",  -- FUNC 0x03
                                "11011001100000000",  -- ADDI
                                "00000000000000000",  -- FUNC 0x05
                                "11010100100011000",  -- AUIPC
                                "00000000000000000",  -- FUNC 0X07
                                "00000000000000000",  -- FUNC 0x08
                                "11011001100100000",  -- SRAI
                                "11111010100000110",  -- SW
                                "11011001101000000",  -- ANDI
                                "11111000000000000",  -- ADD
                                "11111100111000000",  -- LUI
                                "11111000010100000",  -- SLT
                                "00000000000000000",  -- FUNC 0x0F
                                "11111000001100000",  -- XOR 
                                "00000000000000000",  -- FUNC 0x11
                                "00000000000000000",  -- FUNC 0x12
                                "00000000000000000",  -- FUNC 0x13
                                "00000000000000000",  -- FUNC 0x14
                                "00000000000000000",  -- FUNC 0x15
                                "00000000000000000",  -- FUNC 0x16
                                "00000000000000000",  -- FUNC 0x17
                                "11110011110010000",  -- BEQ
                                "00000000000000000",  -- FUNC 0x19
                                "00000000000000000",  -- FUNC 0x1A
                                "00000000000000000",  -- FUNC 0x1B
                                "11010101100011000"); -- JAL 
                         
  -- signals
  signal cw : std_logic_vector(CW_SIZE -1 downto 0);
  
begin
    process(OPCODE, FUNC, rst)
       begin
        if (rst = '0') then
            cw <= (OTHERS => '0');
        end if;
        
         case conv_integer(OPCODE(2)) is
         -- from analysys of opcodes and func of all the instructions: if opcode(3) is 1 - no need of func
         -- no need also to look at opcode (1 downto 0) because it is equal to all the implemented functions
         
		        when 1 => cw <= cw_mem(conv_integer(OPCODE(OP_CODE_SIZE - 1 downto 2)) + 1); 
                when others => cw <= cw_mem(conv_integer(OPCODE(OP_CODE_SIZE - 1 downto 2)) + conv_integer(FUNC)); 
         end case;
  end process;
  
  PCenable       <= CW(CW_SIZE - 1);
  RD1en    		 <= CW(CW_SIZE - 2);
  RD2en      	 <= CW(CW_SIZE - 3);
  RFen      	 <= CW(CW_SIZE - 4);
  RFwr     		 <= CW(CW_SIZE - 5);
  instr_type     <= CW(CW_SIZE - 6 downto CW_SIZE - 8);
  ALUSrc      	 <= CW(CW_SIZE - 9);
  ALUctrl  		 <= CW(CW_SIZE - 10 downto CW_SIZE - 12);
  branch_en      <= CW(CW_SIZE - 13);
  jump_en		 <= CW(CW_SIZE - 14);
  MemEn			 <= CW(CW_SIZE - 15);
  MemRW			 <= CW(CW_SIZE - 16);
  MemToReg		 <= CW(CW_SIZE - 17);

end Behavioral;
