`timescale 1ns/10ps
`define CYCLE 20
`define terminate 500

module WN8731 (
	output reg AUD_ADCDAT,
	inout AUD_ADCLRCK,
	input AUD_DACDAT,
	output reg AUD_DACLRCK,
	inout AUD_BLCK,
	input AUD_XCK
);

assign AUD_BLCK = ~AUD_XCK;

always #(`CYCLE) AUD_ADCDAT = ~AUD_ADCDAT;
always #(20 * `CYCLE) AUD_DACLRCK = ~AUD_DACLRCK;

initial begin
	AUD_DACLRCK = 1'd0;
	AUD_ADCDAT = 1'd1;
end

endmodule //WN8731

module testfiture ();

reg clk, rst;
always #(`CYCLE/2) clk = ~clk;

initial begin
	$fsdbDumpfile("I2S.fsdb");
	$fsdbDumpvars;
	$fsdbDumpMDA;

	clk = 1'd0;
	rst = 1'd1;

	#(`CYCLE/4) rst = 1'd0;
	#(`CYCLE*3) rst = 1'd1;
end

reg AUD_ADCDAT, _AUD_LRCK, _AUD_BCLK;
wire AUD_ADCLRCK, AUD_BCLK, AUD_XCK;
reg [2:0] top_state;
wire [15:0] record_data;
wire record_valid, request_play_data;
reg [15:0] play_data;
reg play_valid;

assign AUD_LRCK = _AUD_LRCK;
assign AUD_BCLK = _AUD_BCLK;
I2S u_i2s(.clk(clk), .rst(rst), .AUD_ADCDAT(AUD_ADCDAT), .AUD_ADCLRCK(AUD_LRCK), .AUD_BCLK(AUD_BCLK), .AUD_DACDAT(AUD_DACDAT), 
	.AUD_DACLRCK(AUD_LRCK), .AUD_XCK(AUD_XCK), .top_state(top_state), .record_data(record_data), .record_valid(record_valid), 
	.request_play_data(request_play_data), .play_data(play_data), .play_valid(play_valid));

initial begin
	@(posedge done);
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

initial begin
	# (`CYCLE * `terminate);
	$display("================================================================================================================");
	$display("(/`n`)/ ~#  There is something wrong with your code!!"); 
	$display("Time out!! The simulation didn't finish after %d cycles!!, Please check it!!!", `terminate); 
	$display("================================================================================================================");
	$finish;
end

endmodule
