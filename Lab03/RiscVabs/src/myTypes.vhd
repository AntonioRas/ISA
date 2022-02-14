---------------------------------------------------------------------------------
-- Create Date: 29.01.2022
-- Module Name: booth multiplier
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: constants for the cu
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package myTypes is

-- Control unit input sizes
    constant OP_CODE_SIZE : integer :=  7;                                              -- OPCODE field size
    constant FUNC3_SIZE    : integer :=  3;                                             -- FUNC3 field size
    constant FUNC7_SIZE    : integer :=  7;                                             -- FUNC7 field size

    -- R-Type instruction -> OPCODE field -- arithmetic instr
    constant RTYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "0110011";          -- for register-to-register operation

    -- R-Type instruction -> FUNC fields
    constant RTYPE3_ADD : std_logic_vector(FUNC3_SIZE - 1 downto 0) :=  "000";    -- ADD RS1,RS2,RD
    constant RTYPE7_ADD : std_logic_vector(FUNC7_SIZE - 1 downto 0) :=  "0000000";   
    
    constant RTYPE3_XOR : std_logic_vector(FUNC3_SIZE - 1 downto 0) :=  "100";    -- XOR RS1,RS2,RD
    constant RTYPE7_XOR : std_logic_vector(FUNC7_SIZE - 1 downto 0) :=  "0000000";  
    
    constant RTYPE3_SLT : std_logic_vector(FUNC3_SIZE - 1 downto 0) :=  "010";    -- SLT RS1,RS2,RD
    constant RTYPE7_SLT : std_logic_vector(FUNC7_SIZE - 1 downto 0) :=  "0000000";  
    

-- I-Type instruction -> OPCODE field -- loads and immediate arith
    constant ITYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "0010011";
    
    constant ITYPE3_ADDi  : std_logic_vector(FUNC3_SIZE - 1 downto 0)  := "000";  -- ADDi RS1,RD,INP1
    
    constant ITYPE3_ANDi  : std_logic_vector(FUNC3_SIZE - 1 downto 0)  := "111";  -- ANDi RS1,RD,INP1
    
    constant ITYPE_SRAi   : std_logic_vector(FUNC3_SIZE - 1 downto 0) :=  "101";   -- SRAi 
    
    constant ITYPEOP_LW : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=    "0000011";   -- LOAD WORD
    constant ITYPE3_LW  : std_logic_vector(  FUNC3_SIZE - 1 downto 0) :=    "010"; 
    
    
    -- S-Type instruction -> OPCODE field -- store 
    constant STYPE     : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "0100011";
    constant STYPE3_SW : std_logic_vector(  FUNC3_SIZE - 1 downto 0) :=    "010";   -- STORE WORD
    
    -- J-Type instruction -> OPCODE field -- unconditional jump
    constant JTYPE_JAL : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "1101111";   -- JAL
    
    -- B-Type instruction -> OPCODE field -- branch
    constant BTYPE_BEQ : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "1100011";   -- BEQ
    
    -- U-Type instruction -> OPCODE field -- extended immediate
    constant UTYPE_LUI   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "0110111";   -- LUI
    
    constant UTYPE_AUIPC : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "0010111";   -- AUIPC
     
    
end myTypes;
