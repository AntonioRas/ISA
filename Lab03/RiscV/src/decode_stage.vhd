----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: execute stage wrapper
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity decode_stage is
    generic( REG_SIZE : integer := 5 ;
             NDATA : integer := 32 );
	port (
        -- input
		clk, rst: in std_logic;
        stall : in std_logic;
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
end decode_stage;

architecture struct of decode_stage is

    component register_file is
        generic( NBIT : integer := 32;
                 REG_SIZE : integer := 5 );
      
        port (  clk, rst: in std_logic;
                rf_en:    in std_logic;
                rd1 :     in std_logic;
                rd2 :     in std_logic;
                rf_wr:    in std_logic;
                add_wr:   in std_logic_vector(REG_SIZE-1 downto 0);
                add_rd1:  in std_logic_vector(REG_SIZE-1 downto 0);
                add_rd2:  in std_logic_vector(REG_SIZE-1 downto 0);
                datain:   in std_logic_vector(NBIT-1 downto 0);
                out1:     out std_logic_vector(NBIT-1 downto 0);
                out2:     out std_logic_vector(NBIT-1 downto 0));
      end component register_file;

    component immediate_ext is
        port(
            instr: in std_logic_vector(31 downto 0);
            instr_type_sel: in std_logic_vector(2 downto 0);
            immediate_out: out std_logic_vector(31 downto 0)
            );
    end component immediate_ext;

    component mux21 is
        generic ( N : integer := 32);
           port ( op1, op2 : IN  std_logic_vector(N-1 downto 0);
                       sel : IN  std_logic;
                       res : OUT std_logic_vector(N-1 downto 0));
    end component mux21;

    signal rs1_int, rs2_int: std_logic_vector(4 downto 0);
    signal rd_s : std_logic_vector(4 downto 0);

begin

    --rd <= instr(11 downto 7);
    rd <= rd_s;
	pc_out <= pc_in;
	rs1_int <= instr(19 downto 15);
	rs2_int <= instr(24 downto 20);
	rs1 <= rs1_int;
	rs2 <= rs2_int;

    stall_ins :
    mux21 generic map (REG_SIZE)
           port map( instr(11 downto 7), "00000", stall, rd_s);

    rf : register_file generic map(NDATA, REG_SIZE) 
                port map(clk, rst, rf_en, rd1_en, rd2_en, rf_wr, wb_addr_in, rs1_int, rs2_int, wb_data_in, rf_rp1_out, rf_rp2_out);

    imm_ext : immediate_ext port map(instr, instr_type_sel, imm);

end struct;