module I2C (
	input clk, 
	input rst, 

	//WN8731
	output reg I2C_SCLK,
	inout I2C_SDAT,

	output reg done
);


//act
reg ack, n_ack;
//input output
reg _I2C_SDAT, n_I2C_SDAT, n_I2C_SCLK, n_done;
assign I2C_SDAT = ack ? 1'bz : _I2C_SDAT;

//cmd
reg [167:0] cmd, n_cmd;
localparam cmd1 = 24'b0011_0100_000_1111_0_0000_0000;
localparam cmd2 = 24'b0011_0100_000_0100_0_0001_0101;
localparam cmd3 = 24'b0011_0100_000_0101_0_0000_0000;
localparam cmd4 = 24'b0011_0100_000_0110_0_0000_0000;
localparam cmd5 = 24'b0011_0100_000_0111_0_0100_0010;
localparam cmd6 = 24'b0011_0100_000_1000_0_0001_1001;
localparam cmd7 = 24'b0011_0100_000_1001_0_0000_0001;

//control
localparam INIT = 3'd0;
localparam START = 3'd1;
localparam SEND = 3'd2;
localparam ACT = 3'd3;
localparam END = 3'd4;
localparam PRE_END = 3'd5;
reg [2:0] state, n_state;
reg [7:0] counter, n_counter;

always_comb begin
	case (state)
		INIT : begin
			n_state = START;
			n_counter = 8'd0;
			n_I2C_SCLK = 1'b1;
			n_I2C_SDAT = 1'b0;
			n_cmd = cmd;
			n_done = 1'b0;
			n_ack = 1'b0;
		end
		START : begin
			n_state = SEND;
			n_counter = 8'd1;
			n_I2C_SCLK = 1'b0;
			n_I2C_SDAT = cmd[167];
			n_cmd = {cmd[166:0], 1'b0};
			n_done = 1'b0;
			n_ack = 1'b0;
		end

		SEND : begin
			n_done = 1'b0;
			n_state = SEND;
			n_I2C_SCLK = ~I2C_SCLK;

			if(I2C_SCLK) begin
				if(counter[2:0] == 3'd0) begin
					n_state = ACT;
					n_counter = counter;
					n_I2C_SDAT = 1'bz;
					n_cmd = cmd;
					n_ack = 1'b1;
				end else begin
					n_counter = counter +1;
					n_I2C_SDAT = cmd[167];
					n_cmd = {cmd[166:0], 1'b0};
					n_ack = 1'b0;
				end

			end else begin
				n_counter = counter;
				n_I2C_SDAT = _I2C_SDAT;
				n_cmd = cmd;
				n_ack = 1'b0;
			end
		end

		ACT : begin
			n_done = 1'd0;
			n_state = ACT;
			n_counter = counter;
			n_I2C_SCLK = ~I2C_SCLK;
			n_I2C_SDAT = 1'bz;
			n_cmd = cmd;
			n_ack = 1'b1;
			
			if(I2C_SCLK & (I2C_SDAT === 1'b0) ) begin
				if(counter == 8'd168) begin
					n_done = 1'd0;
					n_state = PRE_END;
					n_counter = counter;
					n_I2C_SCLK = 1'd0;
					n_I2C_SDAT = 1'd0;
					n_cmd = cmd;
					n_ack = 1'b0;
				end else begin
					n_state = SEND;
					n_counter = counter +1;
					n_I2C_SDAT = cmd[167];
					n_cmd = {cmd[166:0], 1'b0};
					n_ack = 1'b1;
				end
			end 
		end

		PRE_END : begin
			n_state = END;
			n_counter = 8'd0;
			n_I2C_SCLK = 1'b1;
			n_I2C_SDAT = 1'b0;
			n_cmd = cmd;
			n_done = 1'b0;
			n_ack = 1'b0;
		end

		//END
		default : begin
			n_state = END;
			n_counter = 8'd0;
			n_I2C_SCLK = 1'b1;
			n_I2C_SDAT = 1'b1;
			n_cmd = cmd;
			n_done = 1'b1;
			n_ack = 1'b0;
		end
	endcase
end

always_ff @(posedge clk or negedge rst) begin
	if(~rst) begin
		state <= INIT;
		counter <= 8'd0;
		I2C_SCLK <= 1'b1;
		_I2C_SDAT <= 1'b1;
		cmd <= {cmd1, cmd2, cmd3, cmd4, cmd5, cmd6, cmd7};
		done <= 1'b0;
		ack <= 1'b0;
	end else begin
		state <= n_state;
		counter <= n_counter;
		I2C_SCLK <= n_I2C_SCLK;
		_I2C_SDAT <= n_I2C_SDAT;
		cmd <= n_cmd;
		done <= n_done;
		ack <= n_ack;
	end
end

endmodule // I2C