module I2C (
	input clk, 
	input rst, 

	//WN8731
	output reg I2C_SCLK,
	inout I2C_SDAT,

	output reg done,
);

endmodule // I2C