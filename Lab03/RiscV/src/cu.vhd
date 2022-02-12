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
              Rst      	 : IN  std_logic;   -- Active high             
              OPCODE  	 : IN  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC    	 : IN  std_logic_vector(  FUNC3_SIZE - 1 downto 0);
              --zero     	 : IN  std_logic;
              -- FETCH
                    --DECODE
              instr_type : OUT std_logic_vector (2 downto 0); -- instr type for sign extend
                    --EXECUTE
              ALUSrc     : OUT std_logic;   --select second operand alu )b_sel
              ALUctrl 	 : OUT std_logic_vector(2 downto 0); -- DECODER SIGNAL ALU
              branch_en	 : OUT std_logic;
              jump_en	 : OUT std_logic;
              --MEMORY
              MemEn		 : OUT std_logic; -- ENABLE MEMORY 
              MemRW 	 : OUT std_logic; -- 0 ENABLE READ PORT, 1 ENABLE WRITE PORT OF DATA MEMORY STAGE
              --WB
              RFwr : out std_logic;
              MemToReg	 : OUT std_logic); -- SEL OF MUX IN WRITEBACK STAGE           
end cu;

architecture Behavioral of cu is
    signal branch : std_logic;
    constant MICROCODE_MEM_SIZE : integer := 29; -- number of possible operations
    constant CW_SIZE : integer := 13; -- number of output control signals
  
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := (--R-TYPE IN INCRESING  ORDER OF FUNC VALUE
                                "0011000001011",  -- LW
                                "0000000000000",  -- FUNC 0x01
                                "0011000001011",  -- FUNC 0x02
                                "0000000000000",  -- FUNC 0x03
                                "0011000000010",  -- ADDI
                                "0000000000000",  -- FUNC 0x05
                                --"11010100100011000",  -- AUIPC
                                "1001000000010",  -- AUIPC
                                "0000000000000",  -- FUNC 0X07
                                "0000000000000",  -- FUNC 0x08
                                "0011001000010",  -- SRAI
                                "0101000001110",  -- SW
                                "0011010000010",  -- ANDI
                                "0000000000010",  -- ADD
                                "1001110000010",  -- LUI
                                --"1001110000010",  -- LUI
                                "0000101000010",  -- SLT
                                "0000000000000",  -- FUNC 0x0F
                                "0000011000010",  -- XOR 
                                "0000000000000",  -- FUNC 0x11
                                "0000000000000",  -- FUNC 0x12
                                "0000000000000",  -- FUNC 0x13
                                "0000000000000",  -- FUNC 0x14
                                "0000000000000",  -- FUNC 0x15
                                "0000000000000",  -- FUNC 0x16
                                "0000000000000",  -- FUNC 0x17
                                "0111100100000",  -- BEQ
                                "0000000000000",  -- FUNC 0x19
                                "0000000000000",  -- FUNC 0x1A
                                "0000000000000",  -- FUNC 0x1B
                                "1011000010000"); -- JAL 
                         
  -- signals
  signal cw : std_logic_vector(CW_SIZE -1 downto 0);
  
begin
    process(OPCODE, FUNC, rst)
       begin
        if (rst = '1') then
            cw <= (OTHERS => '0');
        elsif(OPCODE /= "0000000") then
            case conv_integer(OPCODE(2)) is
              -- from analysys of opcodes and func of all the instructions: if opcode(3) is 1 - no need of func
              -- no need also to look at opcode (1 downto 0) because it is equal to all the implemented functions
                  when 1 => cw <= cw_mem(conv_integer(OPCODE(OP_CODE_SIZE - 1 downto 2)) + conv_integer(1)); 
                  
                  when others => cw <= cw_mem(conv_integer(OPCODE(OP_CODE_SIZE - 1 downto 2)) + conv_integer(FUNC)); 
              end case;
        end if;

  end process;
  
  
  instr_type     <= CW(CW_SIZE - 1 downto CW_SIZE - 3);
  ALUSrc      	 <= CW(CW_SIZE - 4);
  ALUctrl  		 <= CW(CW_SIZE - 5 downto CW_SIZE - 7);
  branch_en      <= CW(CW_SIZE - 8);
  jump_en <= CW(CW_SIZE - 9);
  MemEn			 <= CW(CW_SIZE - 10);
  MemRW			 <= CW(CW_SIZE - 11);
  RFwr     		 <= CW(CW_SIZE - 12);
  MemToReg		 <= CW(CW_SIZE - 13);

end Behavioral;
