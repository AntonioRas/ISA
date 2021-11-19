`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 10.11.2021 19:49:49
// Module Name: tb_fir
// Description: testbench links clk gen, signal gen, data sink
// Additional Comments: written in verilog
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_fir();

    wire CLK_S; 
    wire RST_S;
    wire VIN_S;
    wire VOUT_S;
    wire [9:0] DIN_S;
    wire [9:0] DOUT_S;
    wire [9:0] B0_S;
    wire [9:0] B1_S;
    wire [9:0] B2_S;
    wire [9:0] B3_S;
    wire [9:0] B4_S;
    wire [9:0] B5_S;
    wire [9:0] B6_S;
    wire [9:0] B7_S;
    wire [9:0] B8_S;
    wire [9:0] B9_S;
    wire [9:0] B10_S;
    wire END_SIM_S;
    
    clk_gen CG    (.end_sim(END_SIM_S),
                   .clk(CLK_S),
                   .rst(RST_S));
        
    signal_gen SM (.clk(CLK_S),
                   .rst(RST_S),
                   .vin(VIN_S),
                   .end_sim(END_SIM_S),
                   .b0(B0_S),
                   .b1(B1_S),
                   .b2(B2_S),
                   .b3(B3_S),
                   .b4(B4_S),
                   .b5(B5_S),
                   .b6(B6_S),
                   .b7(B7_S),
                   .b8(B8_S),
                   .b9(B9_S),
                   .b10(B10_S),
                   .din(DIN_S));
                   
    FIR_filter UUT (.clk(CLK_S),
                   .rst_n(RST_S), 
                   .din(DIN_S),
                   .vin(VIN_S),
                   .b0(B0_S),
                   .b1(B1_S),
                   .b2(B2_S),
                   .b3(B3_S),
                   .b4(B4_S),
                   .b5(B5_S),
                   .b6(B6_S),
                   .b7(B7_S),
                   .b8(B8_S),
                   .b9(B9_S),
                   .b10(B10_S),
                   .dout(DOUT_S),
                   .vout(VOUT_S));
                   
    data_sink DS  (.clk(CLK_S),
                   .rst(RST_S),
                   .vout(VOUT_S), 
                   .dout(DOUT_S));
    
    
endmodule
