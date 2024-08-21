module parity_check
(
	input wire 		 clk,
	input wire 		 rst,
	input wire 		 PAR_TYP,
	input wire 		 sampled_bit,
	input wire 		 par_chk_en,
	input wire [7:0] P_DATA,
	output reg       par_error
);

	wire data_parity;
	assign data_parity = (~PAR_TYP) ? (^P_DATA) : (~^P_DATA);

	// comb 
	reg par_error_comb;
	always @(*) begin
		par_error_comb = 1'b0;
		if (par_chk_en) begin
			if (sampled_bit==data_parity) begin
				par_error_comb = 1'b0;
			end
			else begin
				par_error_comb = 1'b1;
			end
		end
		else begin
			par_error_comb = 1'b0;
		end
	end
	// seq
	always @(posedge clk or negedge rst) begin
		if (~rst) begin
			par_error <= 1'b0;
		end
		else begin
			par_error <= par_error_comb;
		end
	end
	
endmodule