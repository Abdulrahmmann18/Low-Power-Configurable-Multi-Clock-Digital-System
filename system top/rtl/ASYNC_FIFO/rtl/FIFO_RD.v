module FIFO_RD #(parameter BUS_WIDTH = 4, ADDR_SIZE = 3, localparam PTR_SIZE = ADDR_SIZE+1) 
(
	input  wire 				R_CLK,
	input  wire 				R_RST,
	input  wire  			    R_INC,
	input  wire [PTR_SIZE-1:0]  Gray_SYNC_WR_PTR,
	output wire 				R_empty,
	output wire [ADDR_SIZE-1:0] Binary_R_ADDR,
	output wire [PTR_SIZE-1:0]  Gray_UNSYNC_RD_PTR
);

	reg [PTR_SIZE-1:0] Binary_R_PTR;
	always @(posedge R_CLK or negedge R_RST) begin
		if (!R_RST) begin
			// reset
			Binary_R_PTR <= 'b0;		
		end
		else if (R_INC && ~R_empty) begin
			Binary_R_PTR <= Binary_R_PTR + 1;
		end
	end
	
	// binary to gray conversion
	Binary2Gray rd_ptr_b2g (
		.CLK(R_CLK), .RST(R_RST),
		.Binary_code(Binary_R_PTR), .Gray_code(Gray_UNSYNC_RD_PTR)
	);
	assign R_empty = Gray_UNSYNC_RD_PTR == Gray_SYNC_WR_PTR ;

	assign Binary_R_ADDR = Binary_R_PTR[ADDR_SIZE-1:0] ;

endmodule