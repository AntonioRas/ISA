----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: execute stage wrapper
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mem_stage is
    generic( NADDR : integer := 32 ;
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
end mem_stage;

architecture rtl of mem_stage is

begin

    rd_out <= rd_in;
    reg_out <= address_to_mem_in;
    
    -- interface with DRAM memory
    mem_rw_out <= mem_rw_in;
    mem_en_out <= mem_en_in;
    data_mem_out <= data_to_mem_in;
    mem_address <= address_to_mem_in;
    mem_stage_data_out <= data_from_mem_in;

end rtl;