----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: execute stage wrapper
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.myTypes.all;

entity core is
      generic (NDATA : integer := 32 ;
               NADDR : integer := 32 ;
               REG_SIZE : integer := 5 );
      port (
            clk: in std_logic;
            rst: in std_logic;
            
            -- IMEM interface
            imem_instr: in std_logic_vector(NDATA-1 downto 0);
            imem_address: out std_logic_vector(NDATA-1 downto 0);
            
            -- DMEM interface
            dmem_en : out std_logic;
            dmem_rw : out std_logic; -- 1 for write, 0 for read
            dmem_datain: in std_logic_vector(NDATA-1 downto 0);
            dmem_dataout: out std_logic_vector(NDATA-1 downto 0);
            dmem_address: out std_logic_vector(NDATA-1 downto 0)
      );
end core;

architecture struct of core is
      component datapath is
            generic (NDATA : integer := 32;
                     NADDR : integer := 32;
                     REG_SIZE : integer := 5 );
              port (
                        clk: in std_logic;
                        rst: in std_logic;
                        -- CU interface
                        -- ID stage
                        id_instr_type_sel: in std_logic_vector(2 downto 0); -- see constants to check 
                        id_rd1_en, id_rd2_en : in std_logic;
                        id_rf_en : in std_logic;
                        id_rf_wr : in std_logic;
                        id_stall : out std_logic;
                        -- EXE stage
                        exe_b_sel: in std_logic;
                        exe_sel_op: in std_logic_vector(2 downto 0);
                        exe_branch_enable: in std_logic; -- if set to 1 enables the possibility to jump
                        -- MEM stage
                        mem_en : in std_logic;
                        mem_rw_in : in std_logic;
                        -- WB stage
                        wb_data_sel: in std_logic;

                        -- I-MEM interface
                        imem_address: out std_logic_vector(NADDR-1 downto 0);
                        imem_instr: in std_logic_vector(NDATA-1 downto 0);

                        -- D-MEM interface
                        dmem_rw, dmem_en : out std_logic;
                        dmem_datain: in std_logic_vector(NDATA-1 downto 0);
                        dmem_dataout: out std_logic_vector(NDATA-1 downto 0);
                        dmem_address: out std_logic_vector(NADDR-1 downto 0)
              );
        end component datapath;

        component cu is
            port (    -- INPUTS
                      Rst      	 : IN  std_logic;   -- Active high            
                      OPCODE  	 : IN  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
                      FUNC    	 : IN  std_logic_vector(  FUNC3_SIZE - 1 downto 0);
                      --zero     	 : IN  std_logic;
                      -- FETCH
                      --PCenable 	 : OUT std_logic;	-- enable reg PC
                            --DECODE
                      RD1en,RD2en: OUT std_logic;	-- read enable
                      RFen, RFwr : OUT std_logic;   -- rf enable, write enable (regWrite)
                      instr_type : OUT std_logic_vector (2 downto 0); -- instr type for sign extend
                      stall : in std_logic;
                            --EXECUTE
                      ALUSrc     : OUT std_logic;   --select second operand alu )b_sel
                      ALUctrl 	 : OUT std_logic_vector(2 downto 0); -- DECODER SIGNAL ALU
                      branch_en	 : OUT std_logic;
                      --jump_en	 : OUT std_logic;
                      --MEMORY
                      MemEn		 : OUT std_logic; -- ENABLE MEMORY 
                      MemRW 	 : OUT std_logic; -- 0 ENABLE READ PORT, 1 ENABLE WRITE PORT OF DATA MEMORY STAGE
                      --WB
                      MemToReg	 : OUT std_logic); -- SEL OF MUX IN WRITEBACK STAGE           
        end component cu;

        -- control signals
        signal id_instr_type_sel: std_logic_vector(2 downto 0); -- see constants to check 
        signal id_rd1_en, id_rd2_en, id_rf_en, id_rf_wr, id_stall :  std_logic;
        -- EXE stage
        signal exe_b_sel, exe_branch_enable: std_logic;
        signal exe_sel_op: std_logic_vector(2 downto 0);
        -- MEM stage
        signal mem_en, mem_rw_in : std_logic;
        -- WB stage
        signal wb_data_sel: std_logic;


begin

      datapath_inst :
      datapath generic map (NDATA, NADDR, REG_SIZE)
              port map ( clk, rst, id_instr_type_sel, id_rd1_en, id_rd2_en, id_rf_en, id_rf_wr, id_stall, 
                         exe_b_sel, exe_sel_op, exe_branch_enable, 
                         mem_en, mem_rw_in, 
                         wb_data_sel, 
                         imem_address, imem_instr, 
                         dmem_rw, dmem_en, dmem_datain, dmem_dataout, dmem_address );

      cu_inst :
      cu port map ( rst, imem_instr(OP_CODE_SIZE - 1 downto 0), imem_instr(FUNC3_SIZE + 12 - 1 downto 12), 
                    id_rd1_en, id_rd2_en, id_rf_en, id_rf_wr, id_instr_type_sel, id_stall, 
                    exe_b_sel, exe_sel_op, exe_branch_enable, 
                    mem_en, mem_rw_in, 
                    wb_data_sel );
                      
end struct;