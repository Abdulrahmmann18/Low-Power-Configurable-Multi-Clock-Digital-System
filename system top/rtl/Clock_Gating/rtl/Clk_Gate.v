module Clk_Gate 
(
	input  wire CLK,
	input  wire CLK_EN,
	output wire GATED_CLK 
);

	reg latch_out;
	always @(CLK or CLK_EN) begin
		if (!CLK) begin
			latch_out <= CLK_EN;
		end
	end
	assign GATED_CLK = latch_out & CLK ;

	/*
	TLATNCAX12M U0_TLATNCAX12M (
		.E(CLK_EN),
		.CK(CLK),
		.ECK(GATED_CLK)
	);
	*/

endmodule