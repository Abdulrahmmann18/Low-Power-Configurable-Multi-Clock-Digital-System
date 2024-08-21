module deserializer
(
	input wire 		 clk,
	input wire 		 rst,
	input wire 		 sampled_bit,
	input wire 		 deser_en,
	output reg [7:0] P_DATA
);

	always @(posedge clk or negedge rst) begin
		if (~rst) begin
			P_DATA <= 8'b0;
		end
		else if (deser_en) begin
			P_DATA <= {sampled_bit, P_DATA[7:1]};
		end
	end

endmodule