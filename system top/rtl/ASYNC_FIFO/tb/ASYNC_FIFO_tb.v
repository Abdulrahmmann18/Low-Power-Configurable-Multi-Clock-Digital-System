module ASYNC_FIFO_tb();

	////////////////////////////////// parameters declaration ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	parameter DATA_WIDTH = 8; 
	parameter ADDR_SIZE  = 4;
	parameter W_CLK_PERIOD = 10;
	parameter R_CLK_PERIOD = 25;

	///////////////////////////////////// signals declaration ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////

	reg 						 W_CLK_tb;
	reg 				 		 W_RST_tb;
	reg          				 W_INC_tb;
	reg         				 R_CLK_tb;
	reg         				 R_RST_tb;
	reg         				 R_INC_tb;
	reg  [DATA_WIDTH-1:0]        WR_DATA_tb;
	wire [DATA_WIDTH-1:0] 		 RD_DATA_tb;
	wire 						 FULL_tb;
	wire		 				 EMPTY_tb;

	//////////////////////////////////// clk generation block ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	// writing clk
	initial begin
		W_CLK_tb = 1'b0;
		forever #(W_CLK_PERIOD/2) W_CLK_tb = ~W_CLK_tb;
	end

	// reading clk
	initial begin
		R_CLK_tb = 1'b0;
		forever #(R_CLK_PERIOD/2) R_CLK_tb = ~R_CLK_tb;
	end

	////////////////////////////////////// DUT Instantiation ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	ASYNC_FIFO DUT (
		.W_CLK(W_CLK_tb), .W_RST(W_RST_tb), .W_INC(W_INC_tb),
		.R_CLK(R_CLK_tb), .R_RST(R_RST_tb), .R_INC(R_INC_tb),
		.WR_DATA(WR_DATA_tb), .RD_DATA(RD_DATA_tb), .FULL(FULL_tb), .EMPTY(EMPTY_tb)
	);

	//////////////////////////////////////// test stimilus //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	// initial block for writing
	initial begin
		W_INITIALIZE_TASK();
		W_RST_TASK();
		@(negedge W_CLK_tb)
		WRITE_TASK(8'h01);
		@(negedge W_CLK_tb)
		WRITE_TASK(8'h02);
		@(negedge W_CLK_tb)
		WRITE_TASK(8'h03);
		@(negedge W_CLK_tb)
		WRITE_TASK(8'h04);
		@(negedge W_CLK_tb)
		WRITE_TASK(8'h05);
		@(negedge W_CLK_tb)
		WRITE_TASK(8'h06);
		@(negedge W_CLK_tb)
		WRITE_TASK(8'h07);
		@(negedge W_CLK_tb)
		WRITE_TASK(8'h08);
		@(negedge W_CLK_tb)
		W_INC_tb = 1'b0;
		#1000
		$stop;

	end

	// initial block for reading
	initial begin
		R_INITIALIZE_TASK();
		R_RST_TASK();
		R_INC_tb = 1'b1;
	end


	///////////////////////////////////// Tasks definations /////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	task W_RST_TASK;
		begin
			W_RST_tb = 1'b0;
			#(5*W_CLK_PERIOD)
			W_RST_tb = 1'b1;
		end
	endtask

	task R_RST_TASK;
		begin
			R_RST_tb = 1'b0;
			#(2*R_CLK_PERIOD)
			R_RST_tb = 1'b1;
		end
	endtask

	task W_INITIALIZE_TASK;
		begin
			W_INC_tb   = 1'b0;
			WR_DATA_tb = 'b0;
		end
	endtask

	task R_INITIALIZE_TASK;
		begin
			R_INC_tb   = 1'b0;
		end
	endtask
	

	task WRITE_TASK;
		input [DATA_WIDTH-1:0] WRITE_DATA;
		begin
			W_INC_tb   = 1'b1;
			WR_DATA_tb = WRITE_DATA;
		end
	endtask 

endmodule