library ieee;
use ieee.std_logic_1164.all;

entity FIR_filter is
    generic(
        N : natural := 11;
        NBIT : natural := 10
    );
    port(
        rst_n : in std_logic;
        clk : in std_logic;
        din : in std_logic_vector(NBIT-1 downto 0);
        vin : in std_logic;
        
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

        dout : out std_logic_vector(NBIT-1 downto 0);
        vout : out std_logic

    );

end entity;

architecture struct of FIR_filter is

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

    type arr_10x10 is array (0 to 10) of std_logic_vector(NBIT-1 downto 0);

    signal adder_out : arr_11x10;

    signal mult_out : arr_11x10;

    signal reg_out : arr_11x10;
    signal b, coeff_out : arr_11x10;

    signal x_reg_out : std_logic_vector(NBIT-1 downto 0);
    signal vin_reg_out : std_logic;


begin

    x_reg : reg generic map(NBIT) port map(clk, rst_n, vin, din, reg_out(0));

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
    
    -- Generate regs containing input coefficients
    coeff_reg_gen : for i in 0 to N-1 generate

        coeff_reg_i : reg generic map(NBIT) port map(clk, rst_n, vin, b(i), coeff_out(i));
    
    end generate coeff_reg_gen;

    mult_0 : multiplier generic map(NBIT) port map(reg_out(0), coeff_out(0), mult_out(0));

    adder_out(0) <= mult_out(0);

    -- Generate delay reg, multiplier and adder starting from x[n-1], b1*x[n-1] and mult(0)+b1*x[n-1]
    reg_mult_adder_gen : for i in 1 to N-1 generate

        blocks_i : reg   generic map(NBIT) port map(clk, rst_n, vin, reg_out(i-1), reg_out(i) );
        mult_i   : multiplier generic map(NBIT) port map(reg_out(i), coeff_out(i), mult_out(i));
        adder_i  : adder      generic map(NBIT) port map(adder_out(i-1), mult_out(i), adder_out(i));
    
    end generate reg_mult_adder_gen;

    dout_reg : reg generic map(NBIT) port map(clk, rst_n, vin_reg_out, adder_out(N-1), dout );


    -- Gestione Vin e validazione dell'output

    vin_reg : ffd port map(clk, rst_n, '1', vin, vin_reg_out);

    vout_reg : ffd port map(clk, rst_n, '1', vin_reg_out, vout);

end struct;