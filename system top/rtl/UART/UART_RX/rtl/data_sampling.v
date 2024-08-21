module data_sampling
(
	input wire 		 clk,
	input wire 		 rst,
	input wire 		 RX_IN,
	input wire 		 data_samp_en,
	input wire [5:0] prescale,
	input wire [5:0] edge_cnt,
	output reg 		 sampled_bit,
	output reg 		 sample_done
);

	// sampling process
	reg [2:0] sampling_value;
	always @(posedge clk or negedge rst) begin
		if (~rst) begin
			sampling_value <= 3'b0;
		end
		else if (data_samp_en) begin
			case (prescale)
				6'd4 : 
				begin
					if (edge_cnt==6'd2) begin
						sampling_value <= RX_IN;
					end
				end
				6'd8 :
				begin
					if ((edge_cnt==6'd3) || (edge_cnt==6'd4) || (edge_cnt==6'd5)) begin
						sampling_value <= {sampling_value[1:0], RX_IN}; 
					end
				end
				6'd16 :
				begin
					if ((edge_cnt==6'd7) || (edge_cnt==6'd8) || (edge_cnt==6'd9)) begin
						sampling_value <= {sampling_value[1:0], RX_IN}; 
					end
				end
				6'd32 :
				begin
					if ((edge_cnt==6'd15) || (edge_cnt==6'd16) || (edge_cnt==6'd17)) begin
						sampling_value <= {sampling_value[1:0], RX_IN}; 
					end
				end
			endcase
		end
	end
	// sampled bit calc
	wire majority_bit;
	assign majority_bit = (sampling_value[0] & sampling_value[1]) | (sampling_value[0] & sampling_value[2]) | (sampling_value[1] & sampling_value[2]);
	always @(posedge clk or negedge rst) begin
		if (~rst) begin
			sampled_bit <= 1'b0;
			sample_done <= 1'b0;
		end
		else if (data_samp_en) begin
			case (prescale)
				6'd4 : 
				begin
					if (edge_cnt==6'd3) begin
						sampled_bit <= majority_bit;
						sample_done <= 1'b1; 
					end
					else
						sample_done <= 1'b0;
				end
				6'd8 :
				begin
					if (edge_cnt==6'd6) begin
						sampled_bit <= majority_bit;
						sample_done <= 1'b1; 
					end
					else
						sample_done <= 1'b0;
				end
				6'd16 :
				begin
					if (edge_cnt==6'd10) begin
						sampled_bit <= majority_bit;
						sample_done <= 1'b1; 
					end
					else
						sample_done <= 1'b0;
				end
				6'd32 :
				begin
					if (edge_cnt==6'd18) begin
						sampled_bit <= majority_bit; 
						sample_done <= 1'b1;
					end
					else
						sample_done <= 1'b0;
				end
			endcase
		end
	end

endmodule