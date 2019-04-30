module DSP_LOGIC(
	input i_clk,
	input i_rst,
	input [2:0] current_state,
	input [15:0] data_in, 
	input data_valid,
	input I2S_request_data,
	input slot_way, 
	input [3:0] play_speed, 

	output request_data,
	output [15:0] data_out, 
	output valid 
);

	reg request_data, request_data_n;
	reg signed [15:0] data_out, data_out_n;
	reg valid, valid_n;

	reg signed [15:0] store_1, store_2;
	reg signed [15:0] store_1_n, store_2_n;
					  
	reg [2:0] record_n, record;

	always_comb begin
		request_data_n = request_data;
		data_out_n = data_out;
		valid_n = valid;

		record_n = record;

		store_1_n = store_1;
		store_2_n = store_2;


		if (I2S_request_data == 1) begin
			request_data_n = 1;
			if (data_valid == 1) begin
				case(play_speed)
					default: begin
						request_data_n = 0;
						valid_n = 0;
						data_out_n = 0;
						record_n = record;
					end
					4'b0000: begin // 1 time
						request_data_n = 1;
						valid_n = 1;
						data_out_n = data_in;
						record_n = 1;						
					end
					4'b1001: begin// 2 times
						if (record == 2) begin
							request_data_n = 1;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
						else begin
							request_data_n = 1;
							valid_n = 0;
							data_out_n = data_out;
							record_n = record + 1;
						end
					end
					
					4'b1010: begin// 3 times
						if (record == 3) begin
							request_data_n = 1;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;

						end
						else begin
							request_data_n = 1;
							valid_n = 0;
							data_out_n = data_out;
							record_n = record + 1;
						end
					end

					4'b1011: begin// 4 times
						if (record == 4) begin
							request_data_n = 1;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
						else begin
							request_data_n = 1;
							valid_n = 0;
							data_out_n = data_out;
							record_n = record + 1;
						end
					end
					4'b1100: begin// 5 times
						if (record == 5) begin
							request_data_n = 1;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
						else begin
							request_data_n = 1;
							valid_n = 0;
							data_out_n = data_out;
							record_n = record + 1;
						end
					end
					4'b1101: begin// 6 times
						if (record == 6) begin
							request_data_n = 1;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
						else begin
							request_data_n = 1;
							valid_n = 0;
							data_out_n = data_out;
							record_n = record + 1;
						end
					end
					4'b1110: begin// 7 times
						if (record == 7) begin
							request_data_n = 1;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
						else begin
							request_data_n = 1;
							valid_n = 0;
							data_out_n = data_out;
							record_n = record + 1;
						end
					end
					4'b1111: begin// 8 times
						if (record == 8) begin
							request_data_n = 1;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
						else begin
							request_data_n = 1;
							valid_n = 0;
							data_out_n = data_out;
							record_n = record + 1;
						end
					end
					4'b0001: begin// 1/2 time
						if (~slot_way) begin
							if (record == 2) begin					
								request_data_n = 1;
								valid_n = 1;
								data_out_n = data_in;
								store_1_n = data_in;
								record_n = 1;
							end
							else begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								store_1_n = store_1;
								record_n = record + 1; 
							end
						end

						else begin 														
							if (record == 1) begin
								request_data_n = 1;
								valid_n = 0;
								store_1_n = store_2;
								record_n = record + 1;
							end
							if (record == 2) begin// 
								request_data_n = 1;
								valid_n = 0;
								store_2_n = data_in;
								record_n = record + 1;
							end
							if (record == 3) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								record_n = record + 1;
							end
							if (record == 4) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.5 + $signed (store_2) * 0.5;
								record_n = record + 1;
							end
							if (record == 5) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_2;
								record_n = 1;
							end
						end 						
					end
					4'b0010: begin// 1/3 time
						if (~slot_way) begin
							if (record == 3) begin
								request_data_n = 1;
								valid_n = 1;
								data_out_n = data_in;
								store_1_n = data_in;
								record_n = 1;
							end
							else begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								store_1_n = store_1;
								record_n = record + 1;
							end
						end

						else begin
							if (record == 1) begin
								request_data_n = 1;
								valid_n = 0;
								store_1_n = store_2;
								record_n = record + 1;
							end
							if (record == 2) begin// 
								request_data_n = 1;
								valid_n = 0;
								store_2_n = data_in;
								record_n = record + 1;
							end
							if (record == 3) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								record_n = record + 1;
							end
							if (record == 4) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.66 + $signed (store_2) * 0.33;
								record_n = record + 1;
							end
							if (record == 5) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.33 + $signed (store_2) * 0.66;
								record_n = record + 1;
							end
							if (record == 6) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_2;
								record_n = 1;
							end
						end
						
					end
					4'b0011: begin// 1/4 time
						if (~slot_way) begin
							if (record == 2) begin
								request_data_n = 1;
								valid_n = 1;
								data_out_n = data_in;
								store_1_n = data_in;
								record_n = 1;
							end
							else begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								store_1_n = store_1;
								record_n = record + 1;
							end
						end

						else begin
							if (record == 1) begin
								request_data_n = 1;
								valid_n = 0;
								store_1_n = store_2;
								record_n = record + 1;
							end
							if (record == 2) begin// 
								request_data_n = 1;
								valid_n = 0;
								store_2_n = data_in;
								record_n = record + 1;
							end
							if (record == 3) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								record_n = record + 1;
							end
							if (record == 4) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.75 + $signed (store_2) * 0.25;
								record_n = record + 1;
							end
							if (record == 5) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.5 + $signed (store_2) * 0.5;
								record_n = record + 1;
							end
							if (record == 6) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.75 + $signed (store_2) * 0.25;
								record_n = record + 1;
							end
							if (record == 7) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_2;
								record_n = 1;
							end
						end
					end
					4'b0100: begin// 1/5 time
						if (~slot_way) begin
							if (record == 2) begin
								request_data_n = 1;
								valid_n = 1;
								data_out_n = data_in;
								store_1_n = data_in;
								record_n = 1;
							end
							else begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								store_1_n = store_1;
								record_n = record + 1;
							end
						end

						else begin
							if (record == 1) begin
								request_data_n = 1;
								valid_n = 0;
								store_1_n = store_2;
								record_n = record + 1;
							end
							if (record == 2) begin// 
								request_data_n = 1;
								valid_n = 0;
								store_2_n = data_in;
								record_n = record + 1;
							end
							if (record == 3) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								record_n = record + 1;
							end
							if (record == 4) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.8 + $signed (store_2) * 0.2;
								record_n = record + 1;
							end
							if (record == 5) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.6 + $signed (store_2) * 0.4;
								record_n = record + 1;
							end
							if (record == 6) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.4 + $signed (store_2) * 0.6;
								record_n = record + 1;
							end
							if (record == 7) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.8 + $signed (store_2) * 0.2;
								record_n = record + 1;
							end
							if (record == 8) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_2;
								record_n = 1;
							end
						end
					end
					4'b0101: begin// 1/6 time
						if (~slot_way) begin
							if (record == 2) begin
								request_data_n = 1;
								valid_n = 1;
								data_out_n = data_in;
								store_1_n = data_in;
								record_n = 1;
							end
							else begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								store_1_n = store_1;
								record_n = record + 1;
							end							
						end

						else begin
							if (record == 1) begin
								request_data_n = 1;
								valid_n = 0;
								store_1_n = store_2;
								record_n = record + 1;
							end
							if (record == 2) begin// 
								request_data_n = 1;
								valid_n = 0;
								store_2_n = data_in;
								record_n = record + 1;
							end
							if (record == 3) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								record_n = record + 1;
							end
							if (record == 4) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.84 + $signed (store_2) * 0.16;
								record_n = record + 1;
							end
							if (record == 5) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.68 + $signed (store_2) * 0.32;
								record_n = record + 1;
							end
							if (record == 6) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.52 + $signed (store_2) * 0.48;
								record_n = record + 1;
							end
							if (record == 7) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.32 + $signed (store_2) * 0.68;
								record_n = record + 1;								
							end
							if (record == 8) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.16 + $signed (store_2) * 0.84;
								record_n = record + 1;								
							end
							if (record == 9) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_2;
								record_n = 1;
							end
						end
					end
					4'b0110: begin// 1/7 time
						if (~slot_way) begin
							if (record == 2) begin
								request_data_n = 1;
								valid_n = 1;
								data_out_n = data_in;
								store_1_n = data_in;
								record_n = 1;
							end
							else begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								store_1_n = store_1;
								record_n = record + 1;
							end
						end

						else begin
							if (record == 1) begin
								request_data_n = 1;
								valid_n = 0;
								store_1_n = store_2;
								record_n = record + 1;
							end
							if (record == 2) begin// 
								request_data_n = 1;
								valid_n = 0;
								store_2_n = data_in;
								record_n = record + 1;
							end
							if (record == 3) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								record_n = record + 1;
							end
							if (record == 4) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.86 + $signed (store_2) * 0.14;
								record_n = record + 1;
							end
							if (record == 5) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.72 + $signed (store_2) * 0.28;
								record_n = record + 1;
							end
							if (record == 6) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.58 + $signed (store_2) * 0.42;
								record_n = record + 1;
							end
							if (record == 7) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.44 + $signed (store_2) * 0.56;
								record_n = record + 1;								
							end
							if (record == 8) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.28 + $signed (store_2) * 0.72;
								record_n = record + 1;								
							end
							if (record == 9) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.14 + $signed (store_2) * 0.86;
								record_n = record + 1;								
							end
							if (record == 10) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_2;
								record_n = 1;
							end
						end
					end
					4'b0111: begin// 1/8 time
						if (~slot_way) begin
							if (record == 2) begin
								request_data_n = 1;
								valid_n = 1;
								data_out_n = data_in;
								store_1_n = data_in;
								record_n = 1;
							end
							else begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								store_1_n = store_1;
								record_n = record + 1;
							end
						end
						else begin
							if (record == 1) begin
								request_data_n = 1;
								valid_n = 0;
								store_1_n = store_2;
								record_n = record + 1;
							end
							if (record == 2) begin// 
								request_data_n = 1;
								valid_n = 0;
								store_2_n = data_in;
								record_n = record + 1;
							end
							if (record == 3) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_1;
								record_n = record + 1;
							end
							if (record == 4) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.875 + $signed (store_2) * 0.125;
								record_n = record + 1;
							end
							if (record == 5) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.75 + $signed (store_2) * 0.25;
								record_n = record + 1;
							end
							if (record == 6) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.625 + $signed (store_2) * 0.375;
								record_n = record + 1;
							end
							if (record == 7) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.5 + $signed (store_2) * 0.5;
								record_n = record + 1;								
							end
							if (record == 8) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.375 + $signed (store_2) * 0.625;
								record_n = record + 1;								
							end
							if (record == 9) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.25 + $signed (store_2) * 0.75;
								record_n = record + 1;								
							end
							if (record == 10) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = $signed (store_1) * 0.125 + $signed (store_2) * 0.875;
								record_n = record + 1;								
							end
							if (record == 11) begin
								request_data_n = 0;
								valid_n = 1;
								data_out_n = store_2;
								record_n = 1;
							end
						end
					end // play_speed
				endcase
			end
		end
	end

	always_ff @ (posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			request_data <= 0;
			data_out <= 0;
			valid <= 0;
			record <= 1;
			store_1 <= 0;
			store_2 <= 0;
		end

		else begin
			request_data <= request_data_n;
			data_out <= data_out_n;
			valid <= valid_n;
			record <= record_n;
			store_1 <= store_1_n;
			store_2 <= store_2_n;
		end
	end

endmodule


