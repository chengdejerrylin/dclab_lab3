`timescale 1ns/10ps
`define CYCLE 20
`define terminate 1000

module testfiture ();
reg clk, rst;
wire done, I2C_SDAT, I2C_SCLK;
reg _I2C_SDAT;

assign I2C_SDAT = _I2C_SDAT;
I2C u_i2c(.clk(clk), .rst(rst), .I2C_SCLK(I2C_SCLK), .I2C_SDAT(I2C_SDAT), .done(done));

always #(`CYCLE/2) clk = ~clk;

initial begin
	$fsdbDumpfile("I2C.fsdb");
	$fsdbDumpvars;
	$fsdbDumpMDA;

	clk = 1'd0;
	rst = 1'd1;

	#(`CYCLE/4) rst = 1'd0;
	#(`CYCLE*3) rst = 1'd1;
end

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

always_ff @(posedge I2C_SCLK or negedge rst)  begin 
	if (~rst) _I2C_SDAT = 1'dz;
	else _I2C_SDAT = (I2C_SDAT === 1'dz) ? 1'd0 : 1'dz; 
end

endmodule
