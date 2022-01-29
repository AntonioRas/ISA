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
              Rst      : IN  std_logic;   -- Active Low              
              OPCODE   : IN  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC     : IN  std_logic_vector(  FUNC3_SIZE - 1 downto 0);
              zero     : IN  std_logic;
              -- FETCH
              PCSrc    : OUT std_logic;   -- Sel mux on Program Counter
              --DECODE
              RegWrite : OUT std_logic;   -- ENABLE WRITE PORT OF RF COMING FROM WRITEBACK ---- TO DO IN DATAPATH
              --EXECUTE
              RegDst   : OUT std_logic;   --select destination register
   --???????           -- RFImm    : OUT std_logic;   --select destination register
              ALUSrc   : OUT std_logic;   --select second operand alu
              ALUctrl  : OUT std_logic_vector(3 downto 0); -- DECODER SIGNAL ALU
              --MEMORY
              MemWrite : OUT std_logic; -- ENABLE WRITE PORT OF DATA MEMORY STAGE
              MemRead  : OUT std_logic; -- ENABLE READ PORT OF DATA MEMORY STAGE
              --WB
              MemToReg : OUT std_logic); -- SEL OF MUX IN WRITEBACK STAGE           
end cu;

architecture Behavioral of cu is
    signal branch : std_logic;
    constant MICROCODE_MEM_SIZE : integer := 28; -- number of possible operations
    constant CW_SIZE : integer := 10; -- number of output control signals
  
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := (--R-TYPE IN INCRESING  ORDER OF FUNC VALUE
                                "01000000011",  -- LW
                                "00000000000",  -- FUNC 0x01
                                "00000000000",  -- FUNC 0x02
                                "00000000000",  -- FUNC 0x03
                                "01001000000",  -- ADDI
                                "00000000000",  -- FUNC 0x05
                                "11000000000",  -- AUIPC
                                "00000000000",  -- FUNC 0X07
                                "00000000000",  -- FUNC 0x08
                                "01001110000",  -- SRAI
                                "00000000101",  -- SW
                                "01001010000",  -- ANDI
                                "01000000000",  -- ADD
                                "0100",  -- LUI
                                "0000000000",  -- SLT
                                "0000000000",  -- FUNC 0x0F
                                "0000000000",  -- XOR 
                                "0000000000",  -- FUNC 0x11
                                "0000000000",  -- FUNC 0x12
                                "0000000000",  -- FUNC 0x13
                                "0000000000",  -- FUNC 0x14
                                "0000000000",  -- FUNC 0x15
                                "0000000000",  -- FUNC 0x16
                                "0000000000",  -- FUNC 0x17
                                "0000000000",  -- BEQ
                                "0000000000",  -- FUNC 0x19
                                "0000000000",  -- FUNC 0x1A
                                "0000000000",  -- FUNC 0x1B
                                "0000000000"); -- JAL 
                         
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
  
  PCSrc       <= CW(CW_SIZE - 1);
  RegWrite    <= CW(CW_SIZE - 2);
  RegDst      <= CW(CW_SIZE - 3);
  ALUSrc      <= CW(CW_SIZE - 4);
  ALUctrl     <= CW(CW_SIZE - 5 downto CW_SIZE - 7);
  MemWrite    <= CW(CW_SIZE - 8);
  MemRead     <= CW(CW_SIZE - 9);
  MemToReg    <= CW(CW_SIZE - 10);

end Behavioral;
