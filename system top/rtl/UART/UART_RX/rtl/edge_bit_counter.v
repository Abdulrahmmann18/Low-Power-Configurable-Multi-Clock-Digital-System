module edge_bit_counter
(
	input wire 		 clk,
	input wire 		 rst,
	input wire		 cnt_enable,
	input wire [5:0] prescale,
	output reg [5:0] edge_cnt,
	output reg [3:0] bit_cnt,
	output reg		 last_edge_flag
);

	always @(posedge clk or negedge rst) begin
		if (~rst) begin
			edge_cnt 	   <= 6'b0;
			bit_cnt  	   <= 4'b0;
			last_edge_flag <= 1'b0;
		end
		else if (cnt_enable) begin
			case (prescale)
				6'd4 : 
				begin
					if (edge_cnt==6'd3) begin
						last_edge_flag <= 1'b1;
						edge_cnt 	   <= edge_cnt+1;
					end
					else if (edge_cnt==6'd4) begin
						edge_cnt 	   <= 6'd1;
						last_edge_flag <= 1'b0;
						bit_cnt  	   <= bit_cnt+1;
					end
					else begin
						edge_cnt <= edge_cnt+1;
						last_edge_flag <= 1'b0;
					end
				end
				6'd8 :
				begin
					if (edge_cnt==6'd7) begin
						last_edge_flag <= 1'b1;
						edge_cnt 	   <= edge_cnt+1;
					end
					else if (edge_cnt==6'd8) begin
						edge_cnt 	   <= 6'd1;
						last_edge_flag <= 1'b0;
						bit_cnt  	   <= bit_cnt+1;
					end
					else begin
						edge_cnt <= edge_cnt+1;
						last_edge_flag <= 1'b0;
					end
				end
				6'd16 :
				begin
					if (edge_cnt==6'd15) begin
						last_edge_flag <= 1'b1;
						edge_cnt 	   <= edge_cnt+1;
					end
					else if (edge_cnt==6'd16) begin
						edge_cnt 	   <= 6'd1;
						last_edge_flag <= 1'b0;
						bit_cnt  	   <= bit_cnt+1;
					end
					else begin
						edge_cnt <= edge_cnt+1;
						last_edge_flag <= 1'b0;
					end
				end
				6'd32 :
				begin
					if (edge_cnt==6'd31) begin
						last_edge_flag <= 1'b1;
						edge_cnt 	   <= edge_cnt+1;
					end
					else if (edge_cnt==6'd32) begin
						edge_cnt 	   <= 6'd1;
						last_edge_flag <= 1'b0;
						bit_cnt  	   <= bit_cnt+1;
					end
					else begin
						edge_cnt <= edge_cnt+1;
						last_edge_flag <= 1'b0;
					end
				end
			endcase
		end
		else begin
			bit_cnt  	   <= 4'b0;
			last_edge_flag <= 1'b0;
			edge_cnt       <= 6'd1;
		end
	end

endmodule