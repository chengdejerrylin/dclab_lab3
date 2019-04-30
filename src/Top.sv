module Top(
	input clk,
	input rst,

	//I2C
	input I2C_down,

	//user IO
	input playRecord,
	input stop,
	input fast,
	input slow,
	input oneSlot,
	input mode,
	input reverse,

	//SRAM
    output [19:0] SRAM_ADDR,
    inout [15:0] SRAM_DQ,
    output SRAM_CE_N,
    output SRAM_OE_N,
    output SRAM_WE_N,
    output SRAM_UB_N,
    output SRAM_LB_N,

    //I2S(WN8731)
	input AUD_ADCDAT,
	inout AUD_ADCLRCK,
	inout AUD_BCLK,
	output AUD_DACDAT,
	input AUD_DACLRCK,
	output AUD_XCK,

	//seven hex
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7,

	//LED
	output [8:0] LEDG,
	output [17:0] LEDR,

	//LCD
	output LCD_BLON,
	inout [7:0] LCD_DATA,
	output LCD_EN,
	output LCD_ON,
	output LCD_RS,
	output LCD_RW
);
	//state
	parameter INIT          = 3'b101;
	parameter PLAY_STOP     = 3'b000;
	parameter PLAY_PLAY     = 3'b010;
	parameter PLAY_PAUSE    = 3'b011;
	parameter RECORD_STOP   = 3'b100;
	parameter RECORD_RECORD = 3'b110;
	parameter RECORD_PAUSE  = 3'b111;
	reg [2:0] state, n_state;
	reg [3:0] play_speed, n_play_speed;
	reg _mode, _oneSlot, _reverse;

	//sram controller
	wire [19:0] play_addr, record_addr;
	wire [15:0] play_data, record_data;
	wire play_valid, record_valid;
	wire sram_end, dsp_request_data;
	SRAM sramController(.i_clk(clk), .i_rst(rst), .in_signal(record_data), .out_signal(play_data), .in_addr(record_addr), 
		.out_addr(play_addr), .in_signal_valid(record_valid), .out_signal_valid(play_valid), .full(sram_end), .top_state(state),
		.SRAM_ADDR(SRAM_ADDR), .SRAM_DQ(SRAM_DQ), .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N), .SRAM_WE_N(SRAM_WE_N), 
		.SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .request_out_signal(dsp_request_data), .reverse(_reverse));

	//I2S
	wire I2S_request_data, dsp_play_valid;
	wire [15:0] dsp_play_data;
	I2S i2s (.clk(clk), .rst(rst), .AUD_ADCDAT(AUD_ADCDAT), .AUD_ADCLRCK(AUD_ADCLRCK), .AUD_BCLK(AUD_BCLK), 
		.AUD_DACDAT(AUD_DACDAT), .AUD_DACLRCK(AUD_DACLRCK), .AUD_XCK(AUD_XCK), .top_state(state), 
		.record_data(record_data), .record_valid(record_valid), .request_play_data(I2S_request_data), 
		.play_data(dsp_play_data), .play_valid(dsp_play_valid));

	//dsp
	assign I2S_request_data = dsp_request_data;
	assign dsp_play_data = play_data;
	assign dsp_play_valid = play_valid;
	// DSP_LOGIC dsp(.i_clk(clk), .i_rst(rst), .current_state(state), .data_valid(play_valid), .data_in(play_data), 
	// 	.I2S_request_data(I2S_request_data), .slot_way(_oneSlot), .data_out(dsp_play_data), .valid(dsp_play_valid), 
	// 	.request_data(dsp_request_data), .play_speed(play_speed));

	//volumn
	wire volRed;
	volumnLed volLed (.clk(clk), .rst(rst), .record_valid(record_valid), .record_data (record_data), 
		.LEDG(LEDG), .top_state(state), .LEDR(volRed));

	assign LEDR = {17'd0, volRed};

	//seven segment
	assign HEX7 = play_speed[3] ? 7'b1111001 : 7'b1000000;
	assign HEX6 = play_speed[2] ? 7'b1111001 : 7'b1000000;
	assign HEX5 = play_speed[1] ? 7'b1111001 : 7'b1000000;
	assign HEX4 = play_speed[0] ? 7'b1111001 : 7'b1000000;
	assign HEX3 = I2C_down ? 7'b1111001 : 7'b1000000;
	assign HEX2 = state[2] ? 7'b1111001 : 7'b1000000;
	assign HEX1 = state[1] ? 7'b1111001 : 7'b1000000;
	assign HEX0 = state[0] ? 7'b1111001 : 7'b1000000;

	task fastSpeed;
		begin
			case (play_speed)
				4'b1111 : n_play_speed = 4'b1111; // x8 -> x8
				4'b0000 : n_play_speed = 4'b1001; // x1 -> x2
				4'b1001, 
				4'b1010, 
				4'b1011, 
				4'b1100, 
				4'b1101, 
				4'b1110 : n_play_speed = play_speed + 4'd1; // x2~x7 ->  x3~x8
				default : n_play_speed = play_speed - 4'd1;// x1/8 ~ x1/2 -> x1/7 ~ x1
			endcase
		end
	endtask

	task slowSpeed;
		begin
			case (play_speed)
				4'b0111 : n_play_speed = 4'b0111; // x1/8 -> x1/8
				4'b1001 : n_play_speed = 4'b0000; // x2 -> x1 
				4'b1010, 
				4'b1011, 
				4'b1100, 
				4'b1101, 
				4'b1110,
				4'b1111 : n_play_speed = play_speed - 4'd1; // x3~x8 ->  x2~x7
				default : n_play_speed = play_speed + 4'd1;// x1/7 ~ x1 -> x1/8 ~ x1/2
			endcase
		end
	endtask

	task changeSpeed;
		begin
			case ({fast, slow})
				2'b10 : fastSpeed();
				2'b01 : slowSpeed();

				default : n_play_speed = play_speed;
			endcase
		end
	endtask

	//state
	always_comb begin
		if(state == INIT) n_state = (I2C_down) ? {_mode, 2'b00} : INIT;
		else begin
			case(state[1:0] )
				2'b00 : begin // stop
					n_state = (_mode != state[2]) ? {_mode, 2'b00} :
							  (playRecord & (~sram_end))? {state[2], 2'b10} : 
							  state;
				end

				2'b10 : begin //play
					n_state = (stop | sram_end) ? {state[2], 2'b00} :
							  playRecord ? {state[2], 2'b11} :
							  state;
				end

				2'b11 : begin //pause
					n_state = (_mode != state[2]) ? {_mode, 2'b00} :
							  stop ? {state[2], 2'b00} :
							  playRecord ? {state[2], 2'b10} :
							  state;
				end

				default : n_state = state;
			endcase // state[1:0]
		end
	
	end

	//speed
	always_comb begin
		if (state[2]) n_play_speed = 4'd0;
		else changeSpeed();
	end

	always_ff @(posedge clk or negedge rst) begin
		if(~rst) begin
			 state<= INIT;
			 play_speed <= 4'd0;
			 _mode <= 1'd1;
			 _oneSlot <= 1'd0;
			 _reverse <= 1'd0;
		end else begin
			 state <= n_state;
			 play_speed <= n_play_speed;
			 _mode <= mode;
			 _oneSlot <= oneSlot;
			 _reverse <= reverse;
		end
	end

endmodule // Top