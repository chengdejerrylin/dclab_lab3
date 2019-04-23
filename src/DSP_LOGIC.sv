module DSP_LOGIC(
	input i_clk,
	input i_rst,
	input [2:0] current_state,
	input [15:0] data_in,
	input data_valid,
	input I2S_request_data,
	input slot_way,
	input [3:0] play_speed,

 
 	output reg request_data,
	output reg [15:0] data_out,
	output reg valid
);

endmodule // DSP_LOGIC