`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 10.11.2021 19:49:49
// Module Name: tb_fir
// Description: testbench links clk gen, signal gen, data sink
// Additional Comments: written in verilog
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_advanced_fir();

    wire CLK_S; 
    wire RST_S;
    wire VIN0_S;
    wire VIN1_S;
    wire VIN2_S;
    wire VOUT0_S;
    wire VOUT1_S;
    wire VOUT2_S;
    wire [9:0] DIN0_S;
    wire [9:0] DIN1_S;
    wire [9:0] DIN2_S;
    wire [9:0] DOUT0_S;
    wire [9:0] DOUT1_S;
    wire [9:0] DOUT2_S;
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
                   .vin0(VIN0_S),
                   .vin1(VIN1_S),
                   .vin2(VIN2_S),
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
                   .din0(DIN0_S), 
                   .din1(DIN1_S), 
                   .din2(DIN2_S) );
                   
FIR_unfolding_pipeline_filter UUT (.clk(CLK_S),
                   .rst_n(RST_S), 
                   .din0(DIN0_S), 
                   .din1(DIN1_S), 
                   .din2(DIN2_S), 
                   .vin0(VIN0_S),
                   .vin1(VIN1_S),
                   .vin2(VIN2_S),
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
                   .dout0(DOUT0_S),
                   .dout1(DOUT1_S),
                   .dout2(DOUT2_S),
                   .vout0(VOUT0_S), 
                   .vout1(VOUT1_S), 
                   .vout2(VOUT2_S) );
                   
    data_sink DS  (.clk(CLK_S),
                   .rst(RST_S),
                   .vout0(VOUT0_S), 
                   .vout1(VOUT1_S), 
                   .vout2(VOUT2_S), 
                   .dout0(DOUT0_S),
                   .dout1(DOUT1_S),
                   .dout2(DOUT2_S));
    
    
endmodule
