module DSP_LOGIC(
	input i_clk,
	input i_rst,
	input [2:0] current_state,
	input [15:0] data_in, 
	input data_valid,
	input I2S_request_data,
	input slot_way, 
	input [3:0] play_speed, 

	output reg request_data,
	output reg signed [15:0] data_out, 
	output reg valid 
);

	reg request_data_n;
	reg signed [15:0] data_out_n;
	reg valid_n;

	reg signed [15:0] store_1, store_2;
	reg signed [15:0] store_1_n, store_2_n;
					  
	reg [3:0] record_n, record;

	always_comb begin
		request_data_n = request_data;
		data_out_n = data_out;
		valid_n = 0;

		record_n = record;

		store_1_n = store_1;
		store_2_n = store_2;


		if (I2S_request_data & ~valid) begin
			case(play_speed)
				default: begin
					request_data_n = 0;
					valid_n = 0;
					data_out_n = 0;
					record_n = record;
				end
				4'b0000: begin // 1 time
					request_data_n = 1;
					if (data_valid) begin
						request_data_n = 0;
						valid_n = 1;
						data_out_n = data_in;
						record_n = 1;
					end						
				end
				4'b1001: begin// 2 times
					if (record == 2) begin
						request_data_n = 1;
						if (data_valid) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
					end
					else begin
						request_data_n = 1;
						valid_n = 0;
						data_out_n = data_out;
						if (data_valid) begin							
							record_n = record + 1;
						end
					end
				end
				
				4'b1010: begin// 3 times
					if (record == 3) begin
						request_data_n = 1;
						if (data_valid) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
					end
					else begin
						request_data_n = 1;
						valid_n = 0;
						data_out_n = data_out;
						if (data_valid) begin							
							record_n = record + 1;
						end
					end
				end

				4'b1011: begin// 4 times
					if (record == 4) begin
						request_data_n = 1;
						if (data_valid) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
					end
					else begin
						request_data_n = 1;
						valid_n = 0;
						data_out_n = data_out;
						if (data_valid) begin							
							record_n = record + 1;
						end
					end
				end
				4'b1100: begin// 5 times
					if (record == 5) begin
						request_data_n = 1;
						if (data_valid) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
					end
					else begin
						request_data_n = 1;
						valid_n = 0;
						data_out_n = data_out;
						if (data_valid) begin							
							record_n = record + 1;
						end
					end
				end
				4'b1101: begin// 6 times
					if (record == 6) begin
						request_data_n = 1;
						if (data_valid) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
					end
					else begin
						request_data_n = 1;
						valid_n = 0;
						data_out_n = data_out;
						if (data_valid) begin							
							record_n = record + 1;
						end
					end
				end
				4'b1110: begin// 7 times
					if (record == 7) begin
						request_data_n = 1;
						if (data_valid) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
					end
					else begin
						request_data_n = 1;
						valid_n = 0;
						data_out_n = data_out;
						if (data_valid) begin							
							record_n = record + 1;
						end
					end
				end
				4'b1111: begin// 8 times
					if (record == 8) begin
						request_data_n = 1;
						if (data_valid) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_in;
							record_n = 1;
						end
					end
					else begin
						request_data_n = 1;
						valid_n = 0;
						data_out_n = data_out;
						if (data_valid) begin							
							record_n = record + 1;
						end
					end
				end
				4'b0001: begin// 1/2 time
					if (~slot_way) begin
						if (record == 2) begin
							request_data_n = 1;
							if (data_valid) begin
								request_data_n = 0;													
								valid_n = 1;
								data_out_n = data_in;
								record_n = 1;
							end
						end
						else begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_out;
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
							data_out_n = $signed (store_1) / 2 + $signed (store_2) / 2;
							record_n = 1;
						end
					end					 						
				end
				4'b0010: begin// 1/3 time
					if (~slot_way) begin
						if (record == 3) begin
							request_data_n = 1;
							if (data_valid) begin
								request_data_n = 0;													
								valid_n = 1;
								data_out_n = data_in;
								record_n = 1;
							end
						end
						else begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_out;
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
							data_out_n = $signed (store_1) / 2 + $signed (store_2) / 2;
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
				4'b0011: begin// 1/4 time
					if (~slot_way) begin
						if (record == 4) begin
							request_data_n = 1;
							if (data_valid) begin
								request_data_n = 0;													
								valid_n = 1;
								data_out_n = data_in;
								record_n = 1;
							end
						end
						else begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_out;
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
							data_out_n = $signed (store_1) * 2 / 3 + $signed (store_2) / 3;
							record_n = record + 1;
						end
						if (record == 5) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) / 3 + $signed (store_2) * 2 / 3;
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
				4'b0100: begin// 1/5 time
					if (~slot_way) begin
						if (record == 5) begin
							request_data_n = 1;
							if (data_valid) begin
								request_data_n = 0;													
								valid_n = 1;
								data_out_n = data_in;
								record_n = 1;
							end
						end
						else begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_out;
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
							data_out_n = $signed (store_1) * 3 / 4 + $signed (store_2) / 4;
							record_n = record + 1;
						end
						if (record == 5) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) / 2 + $signed (store_2) / 2;
							record_n = record + 1;
						end
						if (record == 6) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 3 / 4 + $signed (store_2) / 4;
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
				4'b0101: begin// 1/6 time
					if (~slot_way) begin
						if (record == 6) begin
							request_data_n = 1;
							if (data_valid) begin
								request_data_n = 0;													
								valid_n = 1;
								data_out_n = data_in;
								record_n = 1;
							end
						end
						else begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_out;
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
							data_out_n = $signed (store_1) * 4 / 5 + $signed (store_2) / 5;
							record_n = record + 1;
						end
						if (record == 5) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 3 / 5 + $signed (store_2) * 2 / 5;
							record_n = record + 1;
						end
						if (record == 6) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 2 / 5 + $signed (store_2) * 3 / 5;
							record_n = record + 1;
						end
						if (record == 7) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) / 5 + $signed (store_2) * 4 / 5;
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
				4'b0110: begin// 1/7 time
					if (~slot_way) begin
						if (record == 7) begin
							request_data_n = 1;
							if (data_valid) begin
								request_data_n = 0;													
								valid_n = 1;
								data_out_n = data_in;
								record_n = 1;
							end
						end
						else begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_out;
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
							data_out_n = $signed (store_1) * 5 / 6 + $signed (store_2) / 6;
							record_n = record + 1;
						end
						if (record == 5) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 4 / 6 + $signed (store_2) * 2 / 6;
							record_n = record + 1;
						end
						if (record == 6) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 3 / 6 + $signed (store_2) * 3 / 6;
							record_n = record + 1;
						end
						if (record == 7) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 2 / 6 + $signed (store_2) * 4 / 6;
							record_n = record + 1;								
						end
						if (record == 8) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) / 6 + $signed (store_2) * 5 / 6;
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
				4'b0111: begin// 1/8 time
					if (~slot_way) begin
						if (record == 8) begin
							request_data_n = 1;
							if (data_valid) begin
								request_data_n = 0;													
								valid_n = 1;
								data_out_n = data_in;
								record_n = 1;
							end
						end
						else begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = data_out;
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
							data_out_n = $signed (store_1) * 6 / 7 + $signed (store_2) / 7;
							record_n = record + 1;
						end
						if (record == 5) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 5 / 7 + $signed (store_2) * 2 / 7;
							record_n = record + 1;
						end
						if (record == 6) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 4 / 7 + $signed (store_2) * 3 / 7;
							record_n = record + 1;
						end
						if (record == 7) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 3 / 7 + $signed (store_2) * 4 / 7;
							record_n = record + 1;								
						end
						if (record == 8) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) * 2 / 7 + $signed (store_2) * 5 / 7;
							record_n = record + 1;								
						end
						if (record == 9) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = $signed (store_1) / 7 + $signed (store_2) * 6 / 7;
							record_n = record + 1;								
						end
						if (record == 10) begin
							request_data_n = 0;
							valid_n = 1;
							data_out_n = store_2;
							record_n = 1;
						end
					end
				end // play_speed
			endcase

			if (data_valid) begin
				
			end
		end
	end

	always_ff @ (posedge i_clk or negedge i_rst) begin
		if (~i_rst) begin
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


