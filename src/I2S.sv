module ADC (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low

	//WN8731
	output reg AUD_ADCDAT,
	input AUD_ADCLRCK,

	//I2S
	input start,
	output reg [15:0] record_data,
	output reg record_valid
);
	//contorl
	localparam INIT = 'd0;
	reg [:0] state n_state;

	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state <= INIT;
		end else begin

		end
	end
endmodule

module I2S (
	input clk,
	input rst,

	//WN8731
	input AUD_ADCDAT,
	inout AUD_ADCLRCK,
	inout AUD_BCLK,
	output AUD_DACDAT,
	input AUD_DACLRCK,
	output AUD_XCK,

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

assign AUD_XCK = clk;
endmodule // I2S