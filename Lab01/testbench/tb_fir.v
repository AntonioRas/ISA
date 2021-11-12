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
    
    clk_gen CG    (.END_SIM(END_SIM_S),
                   .CLK(CLK_S),
                   .RST(RST_S));
        
    signal_gen SM (.CLK(CLK_S),
                   .RST(RST_S),
                   .VOUT(VIN_S),
                   .END_SIM(END_SIM_S),
                   .B0(B0_S),
                   .B1(B1_S),
                   .B2(B2_S),
                   .B3(B3_S),
                   .B4(B4_S),
                   .B5(B5_S),
                   .B6(B6_S),
                   .B7(B7_S),
                   .B8(B8_S),
                   .B9(B9_S),
                   .B10(B10_S),
                   .DIN(DIN_S));
                   
    myfir UUT     (.CLK(CLK_S),
                   .RST(RST_S), 
                   .DIN(DIN_S),
                   .VIN(VIN_S),
                   .B0(B0_S),
                   .B1(B1_S),
                   .B2(B2_S),
                   .B3(B3_S),
                   .B4(B4_S),
                   .B5(B5_S),
                   .B6(B6_S),
                   .B7(B7_S),
                   .B8(B8_S),
                   .B10(B10_S),
                   .DOUT(DOUT_S),
                   .VOUT(VOUT_S));
                   
    data_sink DS  (.CLK(CLK_S),
                   .RST(RST_S),
                   .VIN(VOUT_S), 
                   .DIN(DOUT_S));
    
    
endmodule
