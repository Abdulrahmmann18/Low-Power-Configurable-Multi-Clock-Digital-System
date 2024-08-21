module FIFO_WR #(parameter ADDR_SIZE = 3, localparam PTR_SIZE = ADDR_SIZE+1) 
(
	input  wire 				W_CLK,
	input  wire 				W_RST,
	input  wire  			    W_INC,
	input  wire [PTR_SIZE-1:0]  Gray_SYNC_RD_PTR,
	output wire 				W_full,
	output wire [ADDR_SIZE-1:0] Binary_W_ADDR,
	output wire [PTR_SIZE-1:0]  Gray_UNSYNC_WR_PTR
);

	reg [PTR_SIZE-1:0] Binary_W_PTR;
	always @(posedge W_CLK or negedge W_RST) begin
		if (!W_RST) begin
			// reset
			Binary_W_PTR <= 'b0;		
		end
		else if (W_INC && ~W_full) begin
			Binary_W_PTR <= Binary_W_PTR + 1;
		end
	end
	
	// binary to gray conversion
	Binary2Gray wr_ptr_b2g (
		.CLK(W_CLK), .RST(W_RST),
		.Binary_code(Binary_W_PTR), .Gray_code(Gray_UNSYNC_WR_PTR)
	);
	assign W_full = (Gray_UNSYNC_WR_PTR[PTR_SIZE-1] != Gray_SYNC_RD_PTR[PTR_SIZE-1]) && (Gray_UNSYNC_WR_PTR[PTR_SIZE-2] != Gray_SYNC_RD_PTR[PTR_SIZE-2]) &&
					(Gray_UNSYNC_WR_PTR[PTR_SIZE-3:0] == Gray_SYNC_RD_PTR[PTR_SIZE-3:0]);

	assign Binary_W_ADDR = Binary_W_PTR[ADDR_SIZE-1:0] ;

endmodule