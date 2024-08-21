module stop_check
(
	input wire 		 clk,
	input wire 		 rst,
	input wire 		 sampled_bit,
	input wire 		 stp_chk_en,
	output reg       stp_error
);

	// comb
	reg stp_error_comb;
	always @(*) begin
		stp_error_comb = 1'b0;
		if (stp_chk_en) begin
			if (sampled_bit==1'b1) begin
				stp_error_comb = 1'b0;
			end
			else begin
				stp_error_comb = 1'b1;
			end
		end
		else begin
			stp_error_comb = 1'b0;
		end
	end

	// seq
	always @(posedge clk or negedge rst) begin
		if (~rst) begin
			stp_error <= 1'b0;
		end
		else begin
			stp_error <= stp_error_comb;
		end
	end
	
endmodule