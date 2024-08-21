module System_TOP_tb();

	////////////////////////////////// parameters declaration ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	parameter DATA_WIDTH           = 8; 
	parameter RST_NUM_STAGES       = 2;
	parameter DIV_RATIO_WIDTH      = 8;
	parameter DATA_SYNC_NUM_STAGES = 2;
	parameter ALU_OUT_WIDTH        = 16;
	parameter FUNC_WIDTH           = 4; 
	parameter ADDR_SIZE            = 4;
	parameter REF_CLK_PERIOD       = 20 ; // 50MHZ
	parameter UART_CLK_PERIOD      = 271; // 3.6864MHZ

	///////////////////////////////////// signals declaration ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////

	reg 						 REF_CLK_tb;
	reg 				 		 UART_CLK_tb;
	reg          				 RST_tb;
	reg         				 RX_IN_tb;
	wire 						 TX_OUT_tb;
	wire		 				 Parity_Error_tb;
	wire 						 Framing_Error_tb;	

	//////////////////////////////////// clk generation block ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	// REF clk
	initial begin
		REF_CLK_tb = 1'b0;
		forever #(REF_CLK_PERIOD/2) REF_CLK_tb = ~REF_CLK_tb;
	end

	// UART clk
	initial begin
		UART_CLK_tb = 1'b0;
		forever #(UART_CLK_PERIOD/2) UART_CLK_tb = ~UART_CLK_tb;
	end

	////////////////////////////////////// DUT Instantiation ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	System_TOP DUT (
		.REF_CLK(REF_CLK_tb),
		.UART_CLK(UART_CLK_tb), 
		.RST(RST_tb),
		.RX_IN(RX_IN_tb), 
		.TX_OUT(TX_OUT_tb), 
		.Parity_Error(Parity_Error_tb),
		.Framing_Error(Framing_Error_tb)
	);

	//////////////////////////////////////// test stimilus //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	// initial block for writing
	initial begin
		INITIALIZE_TASK();
		RST_TASK();
		// test write in register file operation
		COMMAND(11'b1_0_10101010_0);  // cmd  = 0xaa
		COMMAND(11'b1_1_00000100_0);  // addr = 0x04
		COMMAND(11'b1_0_00001001_0);  // data = 0x09
		

		// test read from register file operation
		COMMAND(11'b1_0_10111011_0);  // cmd  = 0xbb
		COMMAND(11'b1_1_00000100_0);  // addr = 0x04
		

		// test wALU operation With operands
		COMMAND(11'b1_0_11001100_0);  // cmd  = 0xcc
		COMMAND(11'b1_0_00111100_0);  // operand B = 60
		COMMAND(11'b1_1_00110010_0);  // operand A = 50
		COMMAND(11'b1_1_00000010_0);  // Func = 0x02 (multiplication)
		

		// test wALU operation Without operands
		COMMAND(11'b1_0_11011101_0);  // cmd  = 0xdd
		COMMAND(11'b1_1_00000001_0);  // Func = 0x01 (subtraction)
	
		#300000
	$stop;

	end


	///////////////////////////////////// Tasks definations /////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	task RST_TASK;
		begin
			RST_tb = 1'b0;
			#(2*UART_CLK_PERIOD)
			RST_tb = 1'b1;
		end
	endtask

	task INITIALIZE_TASK;
		begin
			RX_IN_tb   = 1'b1;
		end
	endtask
	
	integer i;
	task COMMAND;
		input [10:0] command_data;
		begin
			for (i=0; i<11; i=i+1) begin
				@(negedge DUT.uart_inst.TX_CLK)
				RX_IN_tb = command_data[i];
			end
		end
	endtask
	

endmodule