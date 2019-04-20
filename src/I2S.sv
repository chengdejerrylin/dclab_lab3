module I2S (
	input clk,
	input rst,

	//WN8731
	input AUD_ADCDAT,
	inout AUD_ADCLRCK,
	inout AUD_BCLK,
	output reg AUD_DACDAT,
	input AUD_DACLRCK,
	output reg AUD_XCK,

	//top
	input [2:0] top_state,

	//record
	output reg [15:0] record_data,
	output reg record_valid,

	//play
	output reg request_play_data,
	input [15:0] play_data,
	input play_valid

	
);
endmodule // I2S