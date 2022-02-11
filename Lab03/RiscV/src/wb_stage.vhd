----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: execute stage wrapper
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity wb_stage is
    generic( NDATA : integer := 32 );
       port( -- inputs
             -- control signals
             mem_to_reg : in std_logic;
             datain0 : in std_logic_vector(NDATA-1 downto 0);
             datain1 : in std_logic_vector(NDATA-1 downto 0);
             rd_in : in std_logic_vector(REG_SIZE-1 downto 0);
             -- output
             dataout : out std_logic_vector(NDATA-1 downto 0):
             rd_out : in std_logic_vector(REG_SIZE-1 downto 0) );
end wb_stage;

architecture struct of wb_stage is

    component mux21 is
        generic ( N : integer := 32);
           port ( op1, op2 : IN  std_logic_vector(N-1 downto 0);
                       sel : IN  std_logic;
                       res : OUT std_logic_vector(N-1 downto 0));
    end component mux21;
begin

    mux_wb: mux21 generic map(NDATA) port map(datain0, datain1, mem_to_reg, dataout);

end struct;