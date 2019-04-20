module SRAM(
    input  i_clk,
    input  i_rst,       //i_rst = 1 -> reset
    input  [15:0] in_signal,      //from I2S
    output reg [15:0] out_signal,     //to DSP
    output reg [20:0] in_addr,
    output reg [20:0] out_addr,
    input request_out_signa1,
    input  in_signal_valid,  
    output reg out_signal_valid,  
    output reg full,
    input [2:0] top_state,

    //SRAM
    output reg [19:0] SRAM_ADDR,
    inout [15:0] SRAM_DQ,
    output reg SRAM_CE_N,
    output reg SRAM_OE_N,
    output reg SRAM_WE_N,
    output reg SRAM_UB_N,
    output reg SRAM_LB_N
);

endmodule // SRAM
