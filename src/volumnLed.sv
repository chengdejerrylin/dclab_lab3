module volumnLed(
	input clk,
	input rst,

	input record_valid,
	input [15:0] record_data,
	input [2:0] top_state,

	output reg [8:0] LEDG,
	output reg [17:0] LEDR
);

//output
reg [17:0] n_LEDR;
reg [7:0] n_LEDG;
reg n_LEDG_overflow;

wire [4:0] MSB;
assign MSB = record_data[14:10];

always_comb begin
	if (record_valid) begin
		n_LEDG_overflow = record_data[15] ? (record_data[14:0] == 15'd0) : (record_data[14:0] == 15'h7fff);

		if(~record_data[15]) begin
			n_LEDG = {MSB >= 5'd13, MSB >= 5'd12, MSB >= 5'd11, MSB >= 5'd10,
					  MSB >= 5'd9 , MSB >= 5'd8,  MSB >= 5'd7, record_data != 16'd0};
			n_LEDR = {MSB == 5'd31, MSB >= 5'd30, MSB >= 5'd29, MSB >= 5'd28, MSB >= 5'd27, MSB >= 5'd26, 
					  MSB >= 5'd25, MSB >= 5'd24, MSB >= 5'd23, MSB >= 5'd22, MSB >= 5'd21, MSB >= 5'd20, 
					  MSB >= 5'd19, MSB >= 5'd18, MSB >= 5'd17, MSB >= 5'd16, MSB >= 5'd15, MSB >= 5'd14 };
		end else begin
			n_LEDG = {MSB <= 5'd18, MSB <= 5'd19, MSB <= 5'd20, MSB <=5'd21, 
					  MSB <= 5'd22, MSB <= 5'd23, MSB <= 5'd24, record_data != 16'd0};
			n_LEDR = {MSB == 5'd0 , MSB <= 5'd1,  MSB <= 5'd2,  MSB <= 5'd3 , MSB <= 5'd4 , MSB <= 5'd5 , 
					  MSB <= 5'd6 , MSB <= 5'd7 , MSB <= 5'd8 , MSB <= 5'd9 , MSB <= 5'd10, MSB <= 5'd11, 
					  MSB <= 5'd12, MSB <= 5'd13, MSB <= 5'd14, MSB <= 5'd15, MSB <= 5'd16, MSB <= 5'd17 };
		end
	end
	else if(top_state == 3'b110) begin
		n_LEDG = LEDG[7:0];
		n_LEDG_overflow = LEDG[8];
		n_LEDR = LEDR;
	end else begin
		n_LEDG = 8'd0;
		n_LEDG_overflow = 1'd0;
		n_LEDR = 1'd0;
	end
end

always_ff @(posedge clk or negedge rst) begin
	if(~rst) begin 
		LEDG <= 9'd0;
		LEDR <= 1'd0;
	end 
	else begin
		LEDG <= {n_LEDG_overflow, n_LEDG};
		LEDR <= n_LEDR;
	end 
end

endmodule // volumnLed