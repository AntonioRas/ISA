----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: execute stage wrapper
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity core is
      generic (NDATA : integer := 32);
      port (
            clk: in std_logic;
            rst: in std_logic;
            
            -- IMEM interface
            imem_instr: in std_logic_vector(NDATA-1 downto 0);
            imem_address: out std_logic_vector(NDATA-1 downto 0);
            
            -- DMEM interface
            dmem_en : out std_logic;
            dmem_wr : out std_logic; -- 1 for write, 0 for read
            dmem_datain: in std_logic_vector(NDATA-1 downto 0);
            dmem_dataout: out std_logic_vector(NDATA-1 downto 0);
            dmem_address: out std_logic_vector(NDATA-1 downto 0)
      );
end core;

architecture struct of core is

begin

end struct;