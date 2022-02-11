----------------------------------------------------------------------------------
-- Create Date: 25.01.2022
-- Module Name: execute stage wrapper
-- Project Name: riscV
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity fetch_stage is
    generic( NADDR : integer := 32 ;
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
end fetch_stage;

architecture struct of fetch_stage is

    component adder is
        generic( N : integer := 32 );
           port( -- inputs
                    A : IN std_logic_vector (N-1 downto 0);
                    B : IN std_logic_vector (N-1 downto 0);
                  Cin : IN std_logic;
                 -- output
                    S : OUT std_logic_vector (N-1 downto 0));
    end component adder;

    component mux21 is
        generic ( N : integer := 32);
           port ( op1, op2 : IN  std_logic_vector(N-1 downto 0);
                       sel : IN  std_logic;
                       res : OUT std_logic_vector(N-1 downto 0));
    end component mux21;

    component reg is
        generic (
            NBIT: integer := 16
        );
        port (
            clk: in std_logic;
            rst: in std_logic;
            en: in std_logic;
            d: in std_logic_vector(NBIT-1 downto 0);
            q: out std_logic_vector(NBIT-1 downto 0)
        );
    end component reg;

    signal adder_out, mux_out, pc_out, four_value : std_logic_vector(NDATA-1 downto 0);

begin

    instr_loaded <= instr;

    pc_reg: reg generic map(NDATA) port map(clk, rst, pc_en, mux_out, pc_out);

    mux_to_pc : mux21 generic map(NDATA) port map(adder_out, target_exe_stage, pc_sel, mux_out);

    four_value <= std_logic_vector(to_unsigned(4, NDATA));

    adder_pc : adder generic map(NDATA) port map(pc_out, four_value, '0', adder_out);

    pc <= pc_out;

    address <= pc_out;

end struct;