library ieee;
use ieee.std_logic_1164.all;

entity FIR_unfolding_pipeline_filter is
    generic(
        N : natural := 11;
        NBIT : natural := 10
    );
    port(
        rst_n : in std_logic;
        clk : in std_logic;
        din0 : in std_logic_vector(NBIT-1 downto 0);
        din1 : in std_logic_vector(NBIT-1 downto 0);
        din2 : in std_logic_vector(NBIT-1 downto 0);
        vin0 : in std_logic;
        vin1 : in std_logic;
        vin2 : in std_logic;
        
        b0 : in std_logic_vector(NBIT-1 downto 0);
        b1 : in std_logic_vector(NBIT-1 downto 0);
        b2 : in std_logic_vector(NBIT-1 downto 0);
        b3 : in std_logic_vector(NBIT-1 downto 0);
        b4 : in std_logic_vector(NBIT-1 downto 0);
        b5 : in std_logic_vector(NBIT-1 downto 0);
        b6 : in std_logic_vector(NBIT-1 downto 0);
        b7 : in std_logic_vector(NBIT-1 downto 0);
        b8 : in std_logic_vector(NBIT-1 downto 0);
        b9 : in std_logic_vector(NBIT-1 downto 0);
        b10 : in std_logic_vector(NBIT-1 downto 0);

        dout0 : out std_logic_vector(NBIT-1 downto 0);
        dout1 : out std_logic_vector(NBIT-1 downto 0);
        dout2 : out std_logic_vector(NBIT-1 downto 0);
        vout0 : out std_logic;
        vout1 : out std_logic;
        vout2 : out std_logic

    );

end entity;

architecture struct of FIR_unfolding_pipeline_filter is

    component adder is
        generic (
            NBIT: integer := 10
        );
        port (
            a: in std_logic_vector(NBIT-1 downto 0);
            b: in std_logic_vector(NBIT-1 downto 0);
            sum: out std_logic_vector(NBIT-1 downto 0)
        );
    end component adder;

    component ffd is
        port (
            clk: in std_logic;
            rst_n: in std_logic;
            en: in std_logic;
            d: in std_logic;
            q: out std_logic
        );
    end component ffd;

    component reg is
        generic (
            NBIT: integer := 10
        );
        port (
            clk: in std_logic;
            rst_n: in std_logic;
            en: in std_logic;
            d: in std_logic_vector(NBIT-1 downto 0);
            q: out std_logic_vector(NBIT-1 downto 0)
        );
    end component reg;

    component multiplier is
        generic (
            NBIT: integer := 10
        );
        port (
            a: in std_logic_vector(NBIT-1 downto 0);
            b: in std_logic_vector(NBIT-1 downto 0);
            res: out std_logic_vector(NBIT-1 downto 0)
        );
    end component multiplier;

    type arr_11x10 is array (0 to 10) of std_logic_vector(NBIT-1 downto 0);
    type arr_10x10 is array (0 to 9) of std_logic_vector(NBIT-1 downto 0);
    type arr_4x10 is array (0 to 3) of std_logic_vector(NBIT-1 downto 0);
    type arr_5x10 is array (0 to 4) of std_logic_vector(NBIT-1 downto 0);
    type arr_6x10 is array (0 to 5) of std_logic_vector(NBIT-1 downto 0);
    type arr_3x3 is array (0 to 2) of std_logic_vector(2 downto 0);

    signal chain0_adder_out : arr_10x10;
    signal chain1_adder_out : arr_10x10;
    signal chain2_adder_out : arr_10x10;

    signal chain0_mult_out : arr_11x10;
    signal chain1_mult_out : arr_11x10;
    signal chain2_mult_out : arr_11x10;

    signal pipeline_reg_chain0_mult : arr_11x10;
    signal pipeline_reg_chain1_mult : arr_11x10;
    signal pipeline_reg_chain2_mult : arr_11x10;

    signal chain0_reg_out : arr_4x10;
    signal chain1_reg_out : arr_4x10;
    signal chain2_reg_out : arr_5x10;
    signal b, coeff_out : arr_11x10;

    signal vin_s : arr_3x3;
    signal coeff_en : std_logic;


begin

    coeff_en <= vin0 or vin1 or vin2;

    -- Generate regs containing input coefficients
    coeff_reg_gen : for i in 0 to N-1 generate

        coeff_reg_i : reg generic map(NBIT) port map(clk, rst_n, coeff_en, b(i), coeff_out(i));
    
    end generate coeff_reg_gen;

    -- Coefficients organization
    b(0) <= b0;
    b(1) <= b1;
    b(2) <= b2;
    b(3) <= b3;
    b(4) <= b4;
    b(5) <= b5;
    b(6) <= b6;
    b(7) <= b7;
    b(8) <= b8;
    b(9) <= b9;
    b(10) <= b10;

    -- FIRST OUTPUT GENERATION
    -- Generation of delayed registers
    x0_reg_out_0 : reg generic map(NBIT) port map(clk, rst_n, vin0, din0, chain0_reg_out(0));
    x0_reg_out_1 : reg generic map(NBIT) port map(clk, rst_n, vin0, chain0_reg_out(0), chain0_reg_out(1));
    x0_reg_out_2 : reg generic map(NBIT) port map(clk, rst_n, vin0, chain0_reg_out(1), chain0_reg_out(2));
    x0_reg_out_3 : reg generic map(NBIT) port map(clk, rst_n, vin0, chain0_reg_out(2), chain0_reg_out(3));
    -- Generation of multiplier outputs
    mult_0_b0 :  multiplier generic map(NBIT) port map(chain0_reg_out(0), coeff_out(0), chain0_mult_out(0));
    mult_0_b1 :  multiplier generic map(NBIT) port map(chain2_reg_out(1), coeff_out(1), chain0_mult_out(1));
    mult_0_b2 :  multiplier generic map(NBIT) port map(chain1_reg_out(1), coeff_out(2), chain0_mult_out(2));
    mult_0_b3 :  multiplier generic map(NBIT) port map(chain0_reg_out(1), coeff_out(3), chain0_mult_out(3));
    mult_0_b4 :  multiplier generic map(NBIT) port map(chain2_reg_out(2), coeff_out(4), chain0_mult_out(4));
    mult_0_b5 :  multiplier generic map(NBIT) port map(chain1_reg_out(2), coeff_out(5), chain0_mult_out(5));
    mult_0_b6 :  multiplier generic map(NBIT) port map(chain0_reg_out(2), coeff_out(6), chain0_mult_out(6));
    mult_0_b7 :  multiplier generic map(NBIT) port map(chain2_reg_out(3), coeff_out(7), chain0_mult_out(7));
    mult_0_b8 :  multiplier generic map(NBIT) port map(chain1_reg_out(3), coeff_out(8), chain0_mult_out(8));
    mult_0_b9 :  multiplier generic map(NBIT) port map(chain0_reg_out(3), coeff_out(9), chain0_mult_out(9));
    mult_0_b10 : multiplier generic map(NBIT) port map(chain2_reg_out(4), coeff_out(10), chain0_mult_out(10));

    pipe0_mult_0 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(0), pipeline_reg_chain0_mult(0));
    pipe0_mult_1 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(1), pipeline_reg_chain0_mult(1));
    pipe0_mult_2 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(2), pipeline_reg_chain0_mult(2));
    pipe0_mult_3 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(3), pipeline_reg_chain0_mult(3));
    pipe0_mult_4 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(4), pipeline_reg_chain0_mult(4));
    pipe0_mult_5 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(5), pipeline_reg_chain0_mult(5));
    pipe0_mult_6 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(6), pipeline_reg_chain0_mult(6));
    pipe0_mult_7 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(7), pipeline_reg_chain0_mult(7));
    pipe0_mult_8 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(8), pipeline_reg_chain0_mult(8));
    pipe0_mult_9 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(9), pipeline_reg_chain0_mult(9));
    pipe0_mult_10 : reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(0), chain0_mult_out(10), pipeline_reg_chain0_mult(10));

    -- Generation of adder outputs
    adder_0_out_0 :  adder generic map(NBIT) port map(pipeline_reg_chain0_mult(0), pipeline_reg_chain0_mult(1), chain0_adder_out(0));
    adder_0_out_1 :  adder generic map(NBIT) port map(chain0_adder_out(0), pipeline_reg_chain0_mult(2), chain0_adder_out(1));
    adder_0_out_2 :  adder generic map(NBIT) port map(chain0_adder_out(1), pipeline_reg_chain0_mult(3), chain0_adder_out(2));
    adder_0_out_3 :  adder generic map(NBIT) port map(chain0_adder_out(2), pipeline_reg_chain0_mult(4), chain0_adder_out(3));
    adder_0_out_4 :  adder generic map(NBIT) port map(chain0_adder_out(3), pipeline_reg_chain0_mult(5), chain0_adder_out(4));
    adder_0_out_5 :  adder generic map(NBIT) port map(chain0_adder_out(4), pipeline_reg_chain0_mult(6), chain0_adder_out(5));
    adder_0_out_6 :  adder generic map(NBIT) port map(chain0_adder_out(5), pipeline_reg_chain0_mult(7), chain0_adder_out(6));
    adder_0_out_7 :  adder generic map(NBIT) port map(chain0_adder_out(6), pipeline_reg_chain0_mult(8), chain0_adder_out(7));
    adder_0_out_8 :  adder generic map(NBIT) port map(chain0_adder_out(7), pipeline_reg_chain0_mult(9), chain0_adder_out(8));
    adder_0_out_9 :  adder generic map(NBIT) port map(chain0_adder_out(8), pipeline_reg_chain0_mult(10), chain0_adder_out(9));
    -- Output data
    dout0_reg : reg generic map(NBIT) port map(clk, rst_n, vin_s(0)(1), chain0_adder_out(9), dout0 );
    -- Validation input signal
    vin0_reg_0 : ffd port map(clk, rst_n, '1', vin0, vin_s(0)(0));
    vin0_reg_1 : ffd port map(clk, rst_n, '1', vin_s(0)(0),vin_s(0)(1));
    -- Validation output signal
    vout0_reg : ffd port map(clk, rst_n, '1', vin_s(0)(1), vout0);


    -- SECOND OUTPUT GENERATION
    -- Generation of delayed registers
    x1_reg_out_0 : reg generic map(NBIT) port map(clk, rst_n, vin1, din1, chain1_reg_out(0));
    x1_reg_out_1 : reg generic map(NBIT) port map(clk, rst_n, vin1, chain1_reg_out(0), chain1_reg_out(1));
    x1_reg_out_2 : reg generic map(NBIT) port map(clk, rst_n, vin1, chain1_reg_out(1), chain1_reg_out(2));
    x1_reg_out_3 : reg generic map(NBIT) port map(clk, rst_n, vin1, chain1_reg_out(2), chain1_reg_out(3));
    -- Generation of multiplier outputs
    mult_1_b0 :  multiplier generic map(NBIT) port map(chain1_reg_out(0), coeff_out(0), chain1_mult_out(0));
    mult_1_b1 :  multiplier generic map(NBIT) port map(chain0_reg_out(0), coeff_out(1), chain1_mult_out(1));
    mult_1_b2 :  multiplier generic map(NBIT) port map(chain2_reg_out(1), coeff_out(2), chain1_mult_out(2));
    mult_1_b3 :  multiplier generic map(NBIT) port map(chain1_reg_out(1), coeff_out(3), chain1_mult_out(3));
    mult_1_b4 :  multiplier generic map(NBIT) port map(chain0_reg_out(1), coeff_out(4), chain1_mult_out(4));
    mult_1_b5 :  multiplier generic map(NBIT) port map(chain2_reg_out(2), coeff_out(5), chain1_mult_out(5));
    mult_1_b6 :  multiplier generic map(NBIT) port map(chain1_reg_out(2), coeff_out(6), chain1_mult_out(6));
    mult_1_b7 :  multiplier generic map(NBIT) port map(chain0_reg_out(2), coeff_out(7), chain1_mult_out(7));
    mult_1_b8 :  multiplier generic map(NBIT) port map(chain2_reg_out(3), coeff_out(8), chain1_mult_out(8));
    mult_1_b9 :  multiplier generic map(NBIT) port map(chain1_reg_out(3), coeff_out(9), chain1_mult_out(9));
    mult_1_b10 : multiplier generic map(NBIT) port map(chain0_reg_out(3), coeff_out(10), chain1_mult_out(10));

    pipe1_mult_0 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(0), pipeline_reg_chain1_mult(0));
    pipe1_mult_1 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(1), pipeline_reg_chain1_mult(1));
    pipe1_mult_2 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(2), pipeline_reg_chain1_mult(2));
    pipe1_mult_3 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(3), pipeline_reg_chain1_mult(3));
    pipe1_mult_4 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(4), pipeline_reg_chain1_mult(4));
    pipe1_mult_5 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(5), pipeline_reg_chain1_mult(5));
    pipe1_mult_6 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(6), pipeline_reg_chain1_mult(6));
    pipe1_mult_7 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(7), pipeline_reg_chain1_mult(7));
    pipe1_mult_8 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(8), pipeline_reg_chain1_mult(8));
    pipe1_mult_9 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(9), pipeline_reg_chain1_mult(9));
    pipe1_mult_10 : reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(0), chain1_mult_out(10), pipeline_reg_chain1_mult(10));

    -- Generation of adder outputs
    adder_1_out_0 :  adder generic map(NBIT) port map(pipeline_reg_chain1_mult(0) , pipeline_reg_chain1_mult(1), chain1_adder_out(0));
    adder_1_out_1 :  adder generic map(NBIT) port map(chain1_adder_out(0), pipeline_reg_chain1_mult(2), chain1_adder_out(1));
    adder_1_out_2 :  adder generic map(NBIT) port map(chain1_adder_out(1), pipeline_reg_chain1_mult(3), chain1_adder_out(2));
    adder_1_out_3 :  adder generic map(NBIT) port map(chain1_adder_out(2), pipeline_reg_chain1_mult(4), chain1_adder_out(3));
    adder_1_out_4 :  adder generic map(NBIT) port map(chain1_adder_out(3), pipeline_reg_chain1_mult(5), chain1_adder_out(4));
    adder_1_out_5 :  adder generic map(NBIT) port map(chain1_adder_out(4), pipeline_reg_chain1_mult(6), chain1_adder_out(5));
    adder_1_out_6 :  adder generic map(NBIT) port map(chain1_adder_out(5), pipeline_reg_chain1_mult(7), chain1_adder_out(6));
    adder_1_out_7 :  adder generic map(NBIT) port map(chain1_adder_out(6), pipeline_reg_chain1_mult(8), chain1_adder_out(7));
    adder_1_out_8 :  adder generic map(NBIT) port map(chain1_adder_out(7), pipeline_reg_chain1_mult(9), chain1_adder_out(8));
    adder_1_out_9 :  adder generic map(NBIT) port map(chain1_adder_out(8), pipeline_reg_chain1_mult(10), chain1_adder_out(9));
    -- Output data
    dout1_reg : reg generic map(NBIT) port map(clk, rst_n, vin_s(1)(1), chain1_adder_out(9), dout1 );
    -- Validation input signal
    vin1_reg_0 : ffd port map(clk, rst_n, '1', vin1, vin_s(1)(0));
    vin1_reg_1 : ffd port map(clk, rst_n, '1', vin_s(1)(0), vin_s(1)(1));
    -- Validation output signal
    vout1_reg : ffd port map(clk, rst_n, '1', vin_s(1)(1), vout1);


    -- THIRD OUTPUT GENERATION
    -- Generation of delayed registers
    x2_reg_out_0 : reg generic map(NBIT) port map(clk, rst_n, vin2, din2, chain2_reg_out(0));
    x2_reg_out_1 : reg generic map(NBIT) port map(clk, rst_n, vin2, chain2_reg_out(0), chain2_reg_out(1));
    x2_reg_out_2 : reg generic map(NBIT) port map(clk, rst_n, vin2, chain2_reg_out(1), chain2_reg_out(2));
    x2_reg_out_3 : reg generic map(NBIT) port map(clk, rst_n, vin2, chain2_reg_out(2), chain2_reg_out(3));
    x2_reg_out_4 : reg generic map(NBIT) port map(clk, rst_n, vin2, chain2_reg_out(3), chain2_reg_out(4));
    -- Generation of multiplier outputs
    mult_2_b0 :  multiplier generic map(NBIT) port map(chain2_reg_out(0), coeff_out(0), chain2_mult_out(0));
    mult_2_b1 :  multiplier generic map(NBIT) port map(chain1_reg_out(0), coeff_out(1), chain2_mult_out(1));
    mult_2_b2 :  multiplier generic map(NBIT) port map(chain0_reg_out(0), coeff_out(2), chain2_mult_out(2));
    mult_2_b3 :  multiplier generic map(NBIT) port map(chain2_reg_out(1), coeff_out(3), chain2_mult_out(3));
    mult_2_b4 :  multiplier generic map(NBIT) port map(chain1_reg_out(1), coeff_out(4), chain2_mult_out(4));
    mult_2_b5 :  multiplier generic map(NBIT) port map(chain0_reg_out(1), coeff_out(5), chain2_mult_out(5));
    mult_2_b6 :  multiplier generic map(NBIT) port map(chain2_reg_out(2), coeff_out(6), chain2_mult_out(6));
    mult_2_b7 :  multiplier generic map(NBIT) port map(chain1_reg_out(2), coeff_out(7), chain2_mult_out(7));
    mult_2_b8 :  multiplier generic map(NBIT) port map(chain0_reg_out(2), coeff_out(8), chain2_mult_out(8));
    mult_2_b9 :  multiplier generic map(NBIT) port map(chain2_reg_out(3), coeff_out(9), chain2_mult_out(9));
    mult_2_b10 : multiplier generic map(NBIT) port map(chain1_reg_out(3), coeff_out(10), chain2_mult_out(10));

    pipe2_mult_0 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(0), pipeline_reg_chain2_mult(0));
    pipe2_mult_1 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(1), pipeline_reg_chain2_mult(1));
    pipe2_mult_2 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(2), pipeline_reg_chain2_mult(2));
    pipe2_mult_3 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(3), pipeline_reg_chain2_mult(3));
    pipe2_mult_4 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(4), pipeline_reg_chain2_mult(4));
    pipe2_mult_5 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(5), pipeline_reg_chain2_mult(5));
    pipe2_mult_6 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(6), pipeline_reg_chain2_mult(6));
    pipe2_mult_7 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(7), pipeline_reg_chain2_mult(7));
    pipe2_mult_8 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(8), pipeline_reg_chain2_mult(8));
    pipe2_mult_9 :  reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(9), pipeline_reg_chain2_mult(9));
    pipe2_mult_10 : reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(0), chain2_mult_out(10), pipeline_reg_chain2_mult(10));

    -- Generation of adder outputs
    adder_2_out_0 :  adder generic map(NBIT) port map(pipeline_reg_chain2_mult(0), pipeline_reg_chain2_mult(1), chain2_adder_out(0));
    adder_2_out_1 :  adder generic map(NBIT) port map(chain2_adder_out(0), pipeline_reg_chain2_mult(2), chain2_adder_out(1));
    adder_2_out_2 :  adder generic map(NBIT) port map(chain2_adder_out(1), pipeline_reg_chain2_mult(3), chain2_adder_out(2));
    adder_2_out_3 :  adder generic map(NBIT) port map(chain2_adder_out(2), pipeline_reg_chain2_mult(4), chain2_adder_out(3));
    adder_2_out_4 :  adder generic map(NBIT) port map(chain2_adder_out(3), pipeline_reg_chain2_mult(5), chain2_adder_out(4));
    adder_2_out_5 :  adder generic map(NBIT) port map(chain2_adder_out(4), pipeline_reg_chain2_mult(6), chain2_adder_out(5));
    adder_2_out_6 :  adder generic map(NBIT) port map(chain2_adder_out(5), pipeline_reg_chain2_mult(7), chain2_adder_out(6));
    adder_2_out_7 :  adder generic map(NBIT) port map(chain2_adder_out(6), pipeline_reg_chain2_mult(8), chain2_adder_out(7));
    adder_2_out_8 :  adder generic map(NBIT) port map(chain2_adder_out(7), pipeline_reg_chain2_mult(9), chain2_adder_out(8));
    adder_2_out_9 :  adder generic map(NBIT) port map(chain2_adder_out(8), pipeline_reg_chain2_mult(10), chain2_adder_out(9));
    -- Output data
    dout2_reg : reg generic map(NBIT) port map(clk, rst_n, vin_s(2)(1), chain2_adder_out(9), dout2 );
    -- Validation input signal
    vin2_reg_0 : ffd port map(clk, rst_n, '1', vin2, vin_s(2)(0));
    vin2_reg_1 : ffd port map(clk, rst_n, '1', vin_s(2)(0),vin_s(2)(1));
    -- Validation output signal
    vout2_reg : ffd port map(clk, rst_n, '1', vin_s(2)(1), vout2);


end struct;