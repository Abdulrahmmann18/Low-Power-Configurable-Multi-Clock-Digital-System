module strt_check
(
	input wire 		 clk,
	input wire 		 rst,
	input wire 		 sampled_bit,
	input wire 		 strt_chk_en,
	output reg       strt_glitch
);

	// comb
	reg strt_glitch_comb;
	always @(*) begin
		strt_glitch_comb = 1'b0;
		if (strt_chk_en) begin
			if (sampled_bit==1'b0) begin
				strt_glitch_comb = 1'b0;
			end
			else begin
				strt_glitch_comb = 1'b1;
			end
		end
		else begin
			strt_glitch_comb = 1'b0;
		end
	end

	// seq
	always @(posedge clk or negedge rst) begin
		if (~rst) begin
			strt_glitch <= 1'b0;
		end
		else begin
			strt_glitch <= strt_glitch_comb;
		end
	end

	
endmodule