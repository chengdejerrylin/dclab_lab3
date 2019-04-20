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
	input oneSlot

);
	//for eberyone
	reg [2:0] state, n_state;

	


endmodule // Top