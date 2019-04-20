module Top(
	input clk,
	input rst,

	//I2C
	input I2C_Down,

	//user IO
	input playRecord,
	input stop,
	input fast,
	input slow,
	input oneSlot,

	//SRAM
    output [19:0] SRAM_ADDR,
    inout [15:0] SRAM_DQ,
    output SRAM_CE_N,
    output SRAM_OE_N,
    output SRAM_WE_N,
    output SRAM_UB_N,
    output SRAM_LB_N,

    //I2S(WN8731)
	input AUD_ADCDAT,
	inout AUD_ADCLRCK,
	inout AUD_BCLK,
	output AUD_DACDAT,
	input AUD_DACLRCK,
	output AUD_XCK,

);
	//state
	parameter INIT          = 3'b001;
	parameter PLAY_STOP     = 3'b000;
	parameter PLAY_PLAY     = 3'b010;
	parameter PLAY_PAUSE    = 3'b011;
	parameter RECORD_STOP   = 3'b100;
	parameter RECORD_RECORD = 3'b110;
	parameter RECORD_PAUSE  = 3'b111;
	reg [2:0] state, n_state;
	reg [3:0] play_speed, n_play_speed;

	//sram controller
	wire [19:0] play_addr, record_addr;
	wire [15:0] play_data, record_data;
	wire play_valid, record_valid;
	wire sram_end, dsp_request_data;
	SRAM sramController(.clk(clk), .rst(rst), .in_signal(record_data), .out_signal(play_data), .in_addr(record_addr), 
		.out_addr(play_addr), .in_signal_valid(record_valid), .out_signal_valid(play_valid), .full(sram_end), .top_state(state),
		.SRAM_ADDR(SRAM_ADDR), .SRAM_DQ(SRAM_DQ), .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N), .SRAM_WE_N(SRAM_WE_N), 
		.SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .request_out_signal(dsp_request_data));

	//I2S
	wire I2S_request_data, dsp_play_valid;
	wire [15:0] dsp_play_data;
	I2S i2s (.clk(clk), .rst(rst), .AUD_ADCDAT(AUD_ADCDAT), .AUD_ADCLRCK(AUD_ADCLRCK), .AUD_BCLK(AUD_BCLK), 
		.AUD_DACDAT(AUD_DACDAT), .AUD_DACLRCK(AUD_DACLRCK), .AUD_XCK(AUD_XCK), .top_state(state), 
		.record_data(record_data), .record_valid(record_valid), .request_play_data(I2S_request_data), 
		.play_data(dsp_play_data), .play_valid(dsp_play_valid));

	//dsp
	DSP_LOGIC dsp(.i_clk(clk), .i_rst(rst), .current_state(state), .data_valid(play_valid), .data_in(play_data), 
		.I2S_request_data(I2S_request_data), .slot_way(oneSlot), .data_out(dsp_play_data), .valid(dsp_play_valid), 
		.request_data(dsp_request_data), play_speed(play_speed));



endmodule // Top