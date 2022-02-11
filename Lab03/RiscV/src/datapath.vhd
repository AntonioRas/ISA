----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: execute stage wrapper
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;

entity datapath is
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
end datapath;

architecture struct of datapath is

    component fetch_stage is
        generic( NADDR : integer := 16 ;
                 NDATA : integer := 32 );
        port( 
            --input
            clk, rst : in std_logic;
            pc_en: in std_logic;
            pc_sel : in std_logic;
            target_exe_stage : in std_logic_vector(NDATA-1 downto 0);
            instr : in std_logic_vector(NDATA-1 downto 0);
            --output
            address : out std_logic_vector(NADDR-1 downto 0);
            pc : out std_logic_vector(NDATA-1 downto 0);
            instr_loaded : out std_logic_vector(NDATA-1 downto 0)
        );
    end component fetch_stage;

    component if_id_pipe_regs is
        generic (NDATA : integer := 32 );
        port (
            clk: in std_logic;
            rst: in std_logic;
    
            pc_in: in std_logic_vector(NDATA-1 downto 0); 
            instr_in: in std_logic_vector(NDATA-1 downto 0); 
    
            -- enable signal
            ifid_pipe_regs_en: in std_logic;
    
            pc_out: out std_logic_vector(NDATA-1 downto 0);
            instr_out: out std_logic_vector(NDATA-1 downto 0)
        );
    end component if_id_pipe_regs;

    component decode_stage is
        generic( REG_SIZE : integer := 5 ;
                 NDATA : integer := 32 );
        port (
            -- input
            clk, rst: in std_logic;
            pc_in: in std_logic_vector(NDATA-1 downto 0);
            instr: in std_logic_vector(NDATA-1 downto 0);
            wb_addr_in: in std_logic_vector(REG_SIZE-1 downto 0);  -- address of destination of register coming from wb stage
            wb_data_in: in std_logic_vector(NDATA-1 downto 0); -- content of destination register coming from wb stage
            -- control signals
            rd1_en, rd2_en : in std_logic;
            rf_en : in std_logic;
            rf_wr : in std_logic;
            instr_type_sel: in std_logic_vector(2 downto 0);  -- used for immediate extension
            -- output
            pc_out: out std_logic_vector(NDATA-1 downto 0);
            rf_rp1_out: out std_logic_vector(NDATA-1 downto 0); -- read port data 1
            rf_rp2_out: out std_logic_vector(NDATA-1 downto 0); -- read port data 2
            rs1: out std_logic_vector(REG_SIZE-1 downto 0); -- register source 1 -- used for inserting possible stalls
            rs2: out std_logic_vector(REG_SIZE-1 downto 0); -- register source 2 -- used for inserting possible stalls
            rd: out std_logic_vector(REG_SIZE-1 downto 0);
            imm: out std_logic_vector(NDATA-1 downto 0)
        );
    end component decode_stage;

    component id_exe_pipe_regs is
        generic (NDATA : integer := 32 ;
                 REG_SIZE : integer := 5 );
        port (
            clk: in std_logic;
            rst: in std_logic;
    
            pc_in: in std_logic_vector(NDATA-1 downto 0); -- PC
            a_in: in std_logic_vector(NDATA-1 downto 0); -- rd1
            b_in: in std_logic_vector(NDATA-1 downto 0); --rd2
            imm_in: in std_logic_vector(NDATA-1 downto 0); -- immediate
            rd_in: in std_logic_vector(REG_SIZE-1 downto 0); -- destination register
            cu_signal_in : in std_logic_vector(at_EX_SIGNALS-1 downto 0); 
    
            -- enable signals
            idexe_pipe_regs_en : in std_logic;
    
            pc_out: out std_logic_vector(NDATA-1 downto 0);
            a_out: out std_logic_vector(NDATA-1 downto 0);
            b_out: out std_logic_vector(NDATA-1 downto 0);
            imm_out: out std_logic_vector(NDATA-1 downto 0);
            rd_out: out std_logic_vector(REG_SIZE-1 downto 0);
            cu_signal_out : in std_logic_vector(at_EX_SIGNALS-1 downto 0)
        );
    end component id_exe_pipe_regs;

    component execute_stage is
        generic (NDATA : integer := 32 );
         port (
             pc: in std_logic_vector(NDATA-1 downto 0); 
             a: in std_logic_vector(NDATA-1 downto 0);
             b: in std_logic_vector(NDATA-1 downto 0);
             imm: in std_logic_vector(NDATA-1 downto 0);
     
             b_sel: in std_logic;
             sel_op : in std_logic_vector(2 downto 0);
             branch_enable: in std_logic; -- if set to 1 enables the possibility to jump
     
             res: out std_logic_vector(NDATA-1 downto 0);
             reg_out: out std_logic_vector(NDATA-1 downto 0);
             pc_out: out std_logic_vector(NDATA-1 downto 0);
             pc_sel: out std_logic -- used by the IF stage to determine which PC must be used
         );
     end component execute_stage;

     component exe_mem_pipe_regs is
        generic (NDATA : integer := 32 ;
                 REG_SIZE : integer := 5 );
        port (
            clk: in std_logic;
            rst: in std_logic;
    
            alu_data_in: in std_logic_vector(NDATA-1 downto 0);
            reg_data_in: in std_logic_vector(NDATA-1 downto 0);
            rd_in: in std_logic_vector(REG_SIZE-1 downto 0);
            cu_signal_in : in std_logic_vector(at_MEM_SIGNALS-1 downto 0); 
    
            exemem_pipe_regs_en : in std_logic;
    
            alu_data_out: out std_logic_vector(NDATA-1 downto 0);
            reg_data_out: out std_logic_vector(NDATA-1 downto 0);
            rd_out: out std_logic_vector(REG_SIZE-1 downto 0);
            cu_signal_out : in std_logic_vector(at_MEM_SIGNALS-1 downto 0)
        );
    end component exe_mem_pipe_regs;

    component mem_stage is
        generic( NADDR : integer := 16 ;
                 NDATA : integer := 32 );
        port( 
            --input
            clk, rst : in std_logic;
            mem_en_in : in std_logic;
            mem_rw_in : in std_logic; 
            data_to_mem_in : in std_logic_vector(NDATA-1 downto 0);
            data_from_mem_in : in std_logic_vector(NDATA-1 downto 0);
            address_to_mem_in : in std_logic_vector(NADDR-1 downto 0);
            rd_in : in std_logic_vector(4 downto 0);
            --output
            mem_en_out : out std_logic;
            mem_rw_out : out std_logic;
            rd_out : out std_logic_vector(4 downto 0);
            mem_address : out std_logic_vector(NADDR-1 downto 0);
            data_mem_out : out std_logic_vector(NDATA-1 downto 0);
    
            reg_out : out std_logic_vector(NDATA-1 downto 0);
            mem_stage_data_out : out std_logic_vector(NDATA-1 downto 0) 
        );
    end component mem_stage;

    component mem_wb_pipe_regs is
        generic (NDATA : integer := 32 ;
                 REG_SIZE : integer := 5 );
        port (
            clk: in std_logic;
            rst: in std_logic;
    
            load_data_in: in std_logic_vector(NDATA-1 downto 0);
            alu_data_in: in std_logic_vector(NDATA-1 downto 0);
            rd_in: in std_logic_vector(REG_SIZE-1 downto 0);
            cu_signal_in : in std_logic_vector(at_WB_SIGNALS downto 0); 
    
            memwb_pipe_regs_en : in std_logic;
    
            load_data_out: out std_logic_vector(NDATA-1 downto 0);
            alu_data_out: out std_logic_vector(NDATA-1 downto 0);
            rd_out: out std_logic_vector(REG_SIZE-1 downto 0);
            cu_signal_out : in std_logic_vector(at_WB_SIGNALS downto 0)
        );
    end component mem_wb_pipe_regs;

    component wb_stage is
        generic( NDATA : integer := 32 );
        port( -- inputs
            -- control signals
            mem_to_reg : in std_logic;
            datain0 : in std_logic_vector(NDATA-1 downto 0);
            datain1 : in std_logic_vector(NDATA-1 downto 0);
            rd_in : in std_logic_vector(REG_SIZE-1 downto 0);
            -- output
            dataout : out std_logic_vector(NDATA-1 downto 0);
            rd_out : in std_logic_vector(REG_SIZE-1 downto 0) );
    end component wb_stage;

    component hdu is
        generic ( REG_SIZE : integer := 5 );
        port ( -- input
               id_rs1, id_rs2 : in std_logic_vector(REG_SIZE-1 downto 0);
               idexe_rd, exemem_rd, memwb_rd : in std_logic_vector(REG_SIZE-1 downto 0);
               id_instr_type: in std_logic_vector(2 downto 0); 
               exe_taken : in std_logic;
               -- output
               stall_out : out std_logic;
               if_pc_en, ifid_en : out std_logic
    
        );
    
    end component hdu;

    -- HDU
    signal pc_en_from_hdu, ifid_en_from_hdu, idexe_en_from_hdu, exemem_en_from_hdu, memwb_en_from_hdu : std_logic;
    
    -- FETCH
    signal pc_sel : std_logic;
    signal target_address_from_exe_stage : std_logic_vector(NDATA-1 downto 0);
    signal if_pc_out, if_instr_out : std_logic_vector(NDATA-1 downto 0);
    -- IF/ID 
    signal ifid_pc_out : std_logic_vector(NDATA-1 downto 0);
    signal ifid_instr_out : std_logic_vector(NDATA-1 downto 0);
    -- DECODE
    signal id_pc_out, id_rf_rp1_out, id_rf_rp2_out, id_imm_out: std_logic_vector(NDATA-1 downto 0);
    signal id_rs1_out, id_rs2_out, id_rd_out : std_logic_vector(REG_SIZE-1 downto 0); 
    -- ID/EXE
    signal idexe_cu_signals_in, idexe_cu_signals_out : std_logic_vector(at_EX_SIGNALS-1 downto 0);
    signal idexe_pc_out, idexe_a_out, idexe_b_out, idexe_imm_out : std_logic_vector(NDATA-1 downto 0);
    signal idexe_rd_out : std_logic_vector(REG_SIZE-1 downto 0);
    -- EXECUTE
    signal exe_res_out, exe_reg_out, exe_pc_out : std_logic_vector(NDATA-1 downto 0);
    -- EXE/MEM
    signal exemem_cu_signals_in, exemem_cu_signals_out : std_logic_vector(at_MEM_SIGNALS-1 downto 0);
    signal exemem_alu_data_out, exemem_reg_data_out: std_logic_vector(NDATA-1 downto 0);
    signal exemem_rd_out: std_logic_vector(REG_SIZE-1 downto 0);
    -- MEMORY
    signal mem_reg_out, mem_stage_data_out : std_logic_vector(NDATA-1 downto 0);
    -- MEM/WB
    signal memwb_cu_signals_in, memwb_cu_signals_out : std_logic_vector(at_WB_SIGNALS downto 0);
    signal memwb_load_data_out, memwb_alu_data_out: std_logic_vector(NDATA-1 downto 0);
    signal memwb_rd_out: std_logic_vector(REG_SIZE-1 downto 0);
    
    -- WRITE BACK
    signal wb_rd_out: std_logic_vector(REG_SIZE-1 downto 0);
    signal wb_data_out: std_logic_vector(NDATA-1 downto 0); 
begin

    -- FETCH STAGE --
    fetch_stage_inst :
    fetch_stage generic map( NADDR, NDATA) 
                port map ( clk, rst, pc_en_from_hdu, pc_sel, target_address_from_exe_stage, 
                           imem_instr, imem_address, if_pc_out, if_instr_out );

    if_id_pipeline_registers_inst :
    if_id_pipe_regs generic map (NDATA)
        port map ( clk, rst, if_pc_out, if_instr_out, ifid_en_from_hdu, ifid_pc_out, ifid_instr_out );


    -- DECODE STAGE --
    decode_stage_inst :
    decode_stage generic map ( REG_SIZE, NDATA)  
        port map ( clk, rst, ifid_pc_out, ifid_instr_out, wb_rd_out, wb_data_out, 
                   id_rd1_en, id_rd2_en, id_rf_en, id_rf_wr, id_instr_type_sel, 
                   id_pc_out, id_rf_rp1_out, id_rf_rp2_out, id_rs1_out, id_rs2_out, id_rd_out, id_imm_out ); 

    idexe_cu_signals_in <= exe_b_sel & exe_sel_op & exe_branch_enable & mem_en & mem_rw_in & wb_data_sel;

    idexe_en_from_hdu <= '1';
    id_exe_pipeline_registers_inst :
    id_exe_pipe_regs generic map (NDATA, REG_SIZE)
        port map ( clk, rst, id_pc_out, id_rf_rp1_out, id_rf_rp2_out, id_imm_out, id_rd_out, idexe_cu_signals_in, 
                   idexe_en_from_hdu, 
                   idexe_pc_out, idexe_a_out, idexe_b_out, idexe_imm_out, idexe_rd_out, idexe_cu_signals_out );

    stalls_detection :
    hdu generic map ( REG_SIZE )
    port map ( id_rs1_out, id_rs2_out, idexe_rd_out, exemem_rd_out, memwb_rd_out, id_instr_type_sel, pc_sel, id_stall, 
               pc_en_from_hdu, ifid_en_from_hdu );

    -- EXECUTE STAGE --
    execute_stage_inst :
    execute_stage generic map (NDATA)
         port map ( idexe_pc_out, idexe_a_out, idexe_b_out, idexe_imm_out, 
                    idexe_cu_signals_out(at_EX_SIGNALS-1), idexe_cu_signals_out(at_EX_SIGNALS-2 downto at_EX_SIGNALS-4), idexe_cu_signals_out(at_EX_SIGNALS-5), 
                    exe_res_out, exe_reg_out, exe_pc_out, pc_sel );

    exemem_cu_signals_in <= idexe_cu_signals_out(at_EX_SIGNALS-6) & idexe_cu_signals_out(at_EX_SIGNALS-7) & idexe_cu_signals_out(at_EX_SIGNALS-8);


    exemem_en_from_hdu <= '1';
    exe_mem_pipeline_registers_inst :
    exe_mem_pipe_regs generic map (NDATA, REG_SIZE)
        port map ( clk, rst, exe_res_out, exe_reg_out, exe_pc_out, exemem_cu_signals_in, exemem_en_from_hdu, 
                   exemem_alu_data_out, exemem_reg_data_out, exemem_rd_out, exemem_cu_signals_out ); 

    -- MEMORY STAGE --
    memory_stage_inst :
    mem_stage generic map ( NADDR, NDATA)
        port map ( clk, rst, exemem_cu_signals_out(at_MEM_SIGNALS-1), exemem_cu_signals_out(at_MEM_SIGNALS-2),
                   exemem_reg_data_out, dmem_datain, exemem_alu_data_out, exemem_rd_out, dmem_en, dmem_rw, dmem_address, dmem_dataout, 
                   mem_reg_out, mem_stage_data_out );

    memwb_cu_signals_in <= exemem_cu_signals_out(0) & exemem_cu_signals_out(0);

    memwb_en_from_hdu <= '1';
    mem_wb_pipeline_registers_inst :
    mem_wb_pipe_regs generic map (NDATA, REG_SIZE)
        port map ( clk, rst, mem_stage_data_out, mem_reg_out, exemem_rd_out, memwb_cu_signals_in, memwb_en_from_hdu, 
                   memwb_load_data_out, memwb_alu_data_out, memwb_rd_out, memwb_cu_signals_out );

    -- WRITE BACK STAGE --
    writeback_stage_inst :
    wb_stage generic map (NDATA )
           port map ( memwb_cu_signals_out(0), memwb_alu_data_out, memwb_load_data_out, memwb_rd_out, wb_data_out, wb_rd_out );

end struct;