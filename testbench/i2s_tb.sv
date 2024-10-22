`timescale 1ns/10ps
`define CYCLE 20
`define terminate 500

module WN8731 (
	output reg AUD_ADCDAT,
	inout AUD_ADCLRCK,
	input AUD_DACDAT,
	output reg AUD_DACLRCK,
	inout AUD_BCLK,
	input AUD_XCK,

	input rst
);

reg [4:0] counter;

assign AUD_BCLK = AUD_XCK;
assign AUD_ADCLRCK = AUD_DACLRCK;

always_ff @(negedge AUD_XCK or negedge rst) begin
	if(~rst) begin
		AUD_ADCDAT <= 1'd1;
		AUD_DACLRCK <= 1'd0;
		counter <= 5'd0;
	end else begin
		AUD_ADCDAT <= ~AUD_ADCDAT;
		AUD_DACLRCK <= (counter == 5'd20) ? ~AUD_DACLRCK : AUD_DACLRCK;
		counter <= (counter == 5'd20) ? 5'd0 : counter + 5'd1;
	end
end

endmodule //WN8731

module testfiture ();

reg clk, rst;

//WN8731
WN8731 chip(.AUD_ADCDAT (AUD_ADCDAT), .AUD_ADCLRCK(AUD_ADCLRCK), .AUD_DACDAT (AUD_DACDAT), 
			.AUD_DACLRCK(AUD_DACLRCK), .AUD_BCLK   (AUD_BCLK), .AUD_XCK    (AUD_XCK), .rst(rst));

wire [2:0] top_state;
wire [15:0] record_data;
wire record_valid, request_play_data;
reg [15:0] play_data, n_play_data;
reg play_valid, n_play_valid;

I2S u_i2s(.clk(clk), .rst(rst), .AUD_ADCDAT(AUD_ADCDAT), .AUD_ADCLRCK(AUD_ADCLRCK), .AUD_BCLK(AUD_BCLK), .AUD_DACDAT(AUD_DACDAT), 
	.AUD_DACLRCK(AUD_DACLRCK), .AUD_XCK(AUD_XCK), .top_state(top_state), .record_data(record_data), .record_valid(record_valid), 
	.request_play_data(request_play_data), .play_data(play_data), .play_valid(play_valid));

always #(`CYCLE/2) clk = ~clk;

`ifdef PLAY 
assign top_state = 3'b010;
`else 
assign top_state = 3'b110;
`endif

always_ff @(posedge clk or negedge rst) begin
	if(~rst) begin
		play_data <= 16'hffff;
		play_valid <= 1'd0; 
	end else begin
		play_data <= n_play_data;
		play_valid <= n_play_data;
	end
end

always_comb begin
	n_play_data = request_play_data ? play_data + 16'd1 : play_data;
	n_play_valid = request_play_data;

end

initial begin
	$fsdbDumpfile("I2S.fsdb");
	$fsdbDumpvars;
	$fsdbDumpMDA;

	clk = 1'd0;
	rst = 1'd1;

	#(`CYCLE/4) rst = 1'd0;
	#(`CYCLE*3) rst = 1'd1;
end

initial begin
	# (`CYCLE * `terminate);
	 $display("============================================================================");
        $display("\n");
        $display("        ****************************              ");
        $display("        **                        **        /|__/|");
        $display("        **  Congratulations !!    **      / O,O  |");
        $display("        **                        **    /_____   |");
        $display("        **  Simulation Complete!! **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w|");
        $display("        *************** ************   \\m___m__|_|");
        $display("\n");
        $display("============================================================================");
	#(`CYCLE) $finish;
end

endmodule
