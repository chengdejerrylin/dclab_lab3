module ADC (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low

	//WN8731
	input AUD_ADCDAT,
	input AUD_ADCLRCK,

	//I2S
	input start,
	output reg [15:0] record_data,
	output reg record_valid
);
	//input output
	reg [15:0] n_record_data;
	reg n_record_valid, _start;

	//contorl
	localparam INIT = 2'd0;
	localparam WAITL = 2'd1;
	localparam READ = 2'd2;
	localparam WAITH = 2'd3;

	reg [1:0] state, n_state;
	reg [3:0] counter, n_counter;

	always_comb begin
		case (state)
			INIT : begin
				if(_start) n_state = AUD_ADCLRCK ? WAITL : WAITH;
				else n_state = INIT;

				n_counter = 4'd0;
				n_record_data = record_data;
				n_record_valid = 1'd0;
			end

			WAITL : begin
				n_state = ~AUD_ADCLRCK ? READ : WAITL;
				n_counter = 4'd0;
				n_record_data = record_data;
				n_record_valid = 1'd0;
			end

			READ : begin
				n_state = (counter == 4'd15) ? WAITH : READ;
				n_counter = counter + 4'd1;
				n_record_data = {record_data[14:0], AUD_ADCDAT};
				n_record_valid = (counter == 4'd15);
			end

			WAITH : begin
				n_state = AUD_ADCLRCK ? WAITL : WAITH;
				n_counter = 4'd0;
				n_record_data = record_data;
				n_record_valid = 1'd0;
			end

		endcase
	
	end

	always_ff @(negedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state <= INIT;
			counter <= 4'd0;
			record_data <= 16'd0;
			record_valid <= 1'd0;
			_start <= 1'd0;
		end else begin
			state <= n_state;
			counter <= n_counter;
			record_data <= n_record_data;
			record_valid <= n_record_valid;
			_start <= start;
		end
	end
endmodule //ADC

module DAC (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low

	//WN8731
	output reg AUD_DACDAT,
	input AUD_DACLRCK,

	//I2S
	input start,
	input [15:0] play_data,
	output reg take_data
);
	//input output
	reg _start, n_take_data, n_AUD_DACDAT;
	reg [15:0] _play_data;

	//contorl
	localparam INIT = 2'd0;
	localparam WAITL = 2'd1;
	localparam READ = 2'd2;
	localparam WAITH = 2'd3;
	reg [1:0] state, n_state;
	reg [3:0] counter, n_counter;

	//data
	reg [15:0] data, n_data;

	always_comb begin
		case (state)
			INIT : begin
				if(_start) n_state = AUD_DACLRCK ? WAITL : WAITH;
				else n_state = INIT;

				n_counter = 4'd0;
				n_AUD_DACDAT = 1'd0;
				n_take_data = 1'd0;
				n_data = 16'd0;
			end

			WAITL : begin
				n_take_data = 1'd0;

				if(~AUD_DACLRCK) begin 
					n_state = READ;
					n_counter = 4'd1;
					n_AUD_DACDAT = data[15];
					n_data = {data[14:0], data[15]};
				end else begin
					n_state = WAITL;
					n_counter = 4'd0;
					n_AUD_DACDAT = 1'd0;
					n_data = data;
				end
			end

			WAITH : begin
				n_take_data = 1'd0;

				if(AUD_DACLRCK) begin 
					n_state = READ;
					n_counter = 4'd1;
					n_AUD_DACDAT = data[15];
					n_data = {data[14:0], data[15]};
				end else begin
					n_state = WAITH;
					n_counter = 4'd0;
					n_AUD_DACDAT = 1'd0;
					n_data = data;
				end
			end

			READ : begin
				n_counter = counter + 4'd1;
				n_AUD_DACDAT = data[15];

				if(counter == 4'd15) begin
					n_state = (AUD_DACLRCK) ? WAITL : WAITH;
					n_data =  (AUD_DACLRCK) ? _play_data : {data[14:0], data[15]};
					n_take_data = AUD_DACLRCK;
				end else begin
					n_state = READ;
					n_data = {data[14:0], data[15]};
					n_take_data = 1'd0;
				end
			end
			
		endcase
	end

	always_ff @(negedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state <= INIT;
			counter <= 4'd0;
			AUD_DACDAT <= 1'd0;
			take_data <= 1'd0;
			_start <= 1'd0;
			_play_data <= 16'd0;
			data <= 16'd0;
		end else begin
			state <= n_state;
			counter <= n_counter;
			AUD_DACDAT <= n_AUD_DACDAT;
			take_data <= n_take_data;
			_start <= start;
			_play_data <= play_data;
			data <= n_data;
		end
	end
endmodule //DAC

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