module ledGController(
	input clk,
	input rst,

	input record_valid,
	input [15:0] record_data,
	input [2:0] top_state,

	output reg [8:0] LEDG
);

//output
reg [7:0] n_LEDG;
reg n_LEDG_valid;

wire [2:0] MSB;
assign MSB = record_data[14:12];

always_comb begin
	if (record_valid) begin
		n_LEDG_valid = ~LEDG[8];

		if(record_data[15]) n_LEDG = {MSB == 3'd0, MSB <= 3'd1, MSB <= 3'd2, MSB <= 3'd3,
									  MSB <= 3'd4, MSB <= 3'd5, MSB <= 3'd6, record_data != 16'd0};
		else n_LEDG = {MSB == 3'd7, MSB >= 3'd6, MSB >= 3'd5, MSB >= 3'd4,
					   MSB >= 3'd3, MSB >= 3'd2, MSB >= 3'd1, record_data != 16'd0};
	end
	else if(top_state == 3'b110) begin
		n_LEDG = LEDG[7:0];
		n_LEDG_valid = LEDG[8];
	end else begin
		n_LEDG = 8'd0;
		n_LEDG_valid = 1'd0;
	end
end

always_ff @(posedge clk or negedge rst) begin
	if(~rst) LEDG <= 9'd0;
	else LEDG = {n_LEDG_valid, n_LEDG};
end
endmodule // ledGController