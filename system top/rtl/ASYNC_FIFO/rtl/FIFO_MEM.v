module FIFO_MEM #(parameter DATA_WIDTH = 8, ADDR_SIZE = 3) 
(
	input  wire 				 W_CLK,
	input  wire					 W_RST,
	input  wire 				 W_CLK_EN,
	input  wire [ADDR_SIZE-1:0]  W_ADDR,
	input  wire [ADDR_SIZE-1:0]  R_ADDR,
	input  wire [DATA_WIDTH-1:0] WR_DATA,
	output wire [DATA_WIDTH-1:0] RD_DATA
);
	localparam MEM_DEPTH = 1 << ADDR_SIZE;
	// mem declaration
	reg [DATA_WIDTH-1:0] fifo_mem [MEM_DEPTH-1:0];
	// write operation
	integer i;
	always @(posedge W_CLK or negedge W_RST) begin
		if (!W_RST) begin
			// reset
			for (i=0; i<MEM_DEPTH ; i=i+1) begin
				fifo_mem[i] <= 'b0;
			end
		end
		else if (W_CLK_EN) begin
			fifo_mem[W_ADDR] <= WR_DATA;
		end
	end
	
	// read operation
	assign RD_DATA = fifo_mem[R_ADDR] ;

endmodule