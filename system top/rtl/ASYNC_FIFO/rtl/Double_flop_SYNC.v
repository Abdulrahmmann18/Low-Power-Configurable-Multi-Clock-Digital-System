module Double_flop_SYNC #(parameter BUS_WIDTH = 4) 
(
	input wire 				   CLK,
	input wire 				   RST,
	input wire [BUS_WIDTH-1:0] unsync_bus,
	output reg [BUS_WIDTH-1:0] sync_bus
);

	
	//////////////////////////////// double flop synchronaizer ///////////////////////////////
	reg [BUS_WIDTH-1:0] intermediate_reg;
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			intermediate_reg <= 'b0;
			sync_bus 		 <= 'b0;	
		end
		else begin
			intermediate_reg <= unsync_bus;
			sync_bus 		 <= intermediate_reg;
		end
	end

endmodule