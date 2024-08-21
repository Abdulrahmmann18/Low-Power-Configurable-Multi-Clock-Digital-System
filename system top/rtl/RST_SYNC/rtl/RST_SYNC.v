module RST_SYNC #(parameter NUM_STAGES = 2) 
(
	input wire  CLK,
	input wire  RST,
	output wire SYNC_RST
);
	
	reg [NUM_STAGES-1:0] RST_REG;
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			RST_REG <= 'b0;
		end
		else begin
			RST_REG <= {RST_REG[NUM_STAGES-2:0], 1'b1};
		end
	end
	assign SYNC_RST = RST_REG[NUM_STAGES-1];

endmodule