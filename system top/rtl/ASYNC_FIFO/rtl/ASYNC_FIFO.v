module ASYNC_FIFO #(parameter DATA_WIDTH = 8, ADDR_SIZE = 3, localparam PTR_SIZE = ADDR_SIZE+1) 
(
	input  wire 				 W_CLK,
	input  wire 				 W_RST,
	input  wire 				 W_INC,
	input  wire 				 R_CLK,
	input  wire 				 R_RST,
	input  wire 				 R_INC,
	input  wire [DATA_WIDTH-1:0] WR_DATA,
	output wire [DATA_WIDTH-1:0] RD_DATA,
	output wire 				 FULL,
	output wire 				 EMPTY
);

	///////////////////////////////////////// internal wires ///////////////////////////////////////////
	wire W_CLK_EN_top, R_CLK_EN_top;
	wire [ADDR_SIZE-1:0] W_ADDR_top, R_ADDR_top;
	wire [PTR_SIZE-1:0]  Gray_SYNC_RD_PTR_top, Gray_UNSYNC_WR_PTR_top, Gray_SYNC_WR_PTR_top, Gray_UNSYNC_RD_PTR_top;

	// AND GATE For W_CLK_EN and R_CLK_EN
	AND_GATE w_en_and ( .in1(W_INC), .in2(~FULL), .out(W_CLK_EN_top) );
	// AND_GATE r_en_and ( .in1(R_INC), .in2(~EMPTY), .out(R_CLK_EN_top) );
	
	// FIFO MEM Instantiation
	FIFO_MEM F_MEM (
		.W_CLK(W_CLK), .W_RST(W_RST), .W_CLK_EN(W_CLK_EN_top),
		/*.R_CLK_EN(R_CLK_EN_top),*/ .W_ADDR(W_ADDR_top), .R_ADDR(R_ADDR_top),
		.WR_DATA(WR_DATA), .RD_DATA(RD_DATA)
	);

	// FIFO_WR & FULL FLAG 
	FIFO_WR F_WR (
		.W_CLK(W_CLK), .W_RST(W_RST), .W_INC(W_INC),
		.Gray_SYNC_RD_PTR(Gray_SYNC_RD_PTR_top), .W_full(FULL),
		.Binary_W_ADDR(W_ADDR_top), .Gray_UNSYNC_WR_PTR(Gray_UNSYNC_WR_PTR_top)
	);

	// double flop sync for write ptr
	Double_flop_SYNC wr_ptr_sync (
		.CLK(R_CLK), .RST(R_RST),
		.unsync_bus(Gray_UNSYNC_WR_PTR_top), .sync_bus(Gray_SYNC_WR_PTR_top)
	);

	// FIFO_RD & EMPTY FLAG
	FIFO_RD F_RD (
		.R_CLK(R_CLK), .R_RST(R_RST), .R_INC(R_INC),
		.Gray_SYNC_WR_PTR(Gray_SYNC_WR_PTR_top), .R_empty(EMPTY),
		.Binary_R_ADDR(R_ADDR_top), .Gray_UNSYNC_RD_PTR(Gray_UNSYNC_RD_PTR_top)
	);

	// double flop sync for READ ptr
	Double_flop_SYNC rd_ptr_sync (
		.CLK(W_CLK), .RST(W_RST),
		.unsync_bus(Gray_UNSYNC_RD_PTR_top), .sync_bus(Gray_SYNC_RD_PTR_top)
	);

	
	

endmodule