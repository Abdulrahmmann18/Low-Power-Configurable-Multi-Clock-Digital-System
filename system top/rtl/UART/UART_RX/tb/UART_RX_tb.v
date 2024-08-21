`timescale 1us/1ps
module UART_RX_tb();
	/////////////////////////////////////////// parameters //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	parameter TX_CLK_PERIOD  = 8.68;
	///////////////////////////////////// signals declaration ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	reg 	   TX_CLK;
	reg 	   RX_CLK;
	reg 	   RX_RST;
	reg 	   PAR_TYP_tb;
	reg 	   PAR_EN_tb;
	reg   	   RX_IN_tb;
	reg  [5:0] Prescale_tb;
	wire [7:0] P_DATA_tb;
	wire 	   Data_valid_tb;
	wire	   Parity_Error_tb;
	wire 	   Stop_Error_tb;
	/////////////////////////////////// clk generation block ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	// clk generation block for TX
	initial begin
		TX_CLK = 0;
		forever #(TX_CLK_PERIOD/2) TX_CLK = ~TX_CLK;
	end
	// clk generation block for RX
	initial begin
		Prescale_tb = 6'd8;
		RX_CLK = 0;
		forever #(TX_CLK_PERIOD/(2*Prescale_tb)) RX_CLK = ~RX_CLK;
	end
	////////////////////////////////////// DUT Instantiation ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	UART_RX DUT (
		.clk(RX_CLK), .rst(RX_RST), .PAR_TYP(PAR_TYP_tb), .PAR_EN(PAR_EN_tb),
		.RX_IN(RX_IN_tb), .Prescale(Prescale_tb), .P_DATA(P_DATA_tb),
		.Data_valid(Data_valid_tb), .Parity_Error(Parity_Error_tb), .Stop_Error(Stop_Error_tb)
	);

	//////////////////////////////////////// test stimilus //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	initial begin
		INITIALIZE_TASK();
		RST_TASK();
		//////////////////////////// test with prescale of 8 ///////////////////////////////
		$display(" ////////////////// prescale = 8 /////////////////");
		// test case(1) : frame with even parity 
		Recieve_Frame_with_parity(11'b1_0_01010101_0, 1'b0, 6'd8);
		check_out(8'h55);
		
		// test case(2) : frame with odd parity 
		Recieve_Frame_with_parity(11'b1_1_01010101_0, 1'b1, 6'd8);
		check_out(8'h55);

		// test case(3) : frame with no parity
		Recieve_Frame_without_parity(10'b1_01010101_0, 6'd8);
		check_out(8'h55);

		//////////////////////////// test with prescale of 16 ///////////////////////////////
		$display(" ////////////////// prescale = 16 /////////////////");
		// test case(1) : frame with even parity 
		Recieve_Frame_with_parity(11'b1_0_01010101_0, 1'b0, 6'd16);
		check_out(8'h55);
		
		// test case(2) : frame with odd parity 
		Recieve_Frame_with_parity(11'b1_1_01010101_0, 1'b1, 6'd16);
		check_out(8'h55);

		// test case(3) : frame with no parity
		Recieve_Frame_without_parity(10'b1_01010101_0, 6'd16);
		check_out(8'h55);
		
		//////////////////////////// test with prescale of 32 ///////////////////////////////
		$display(" ////////////////// prescale = 32 /////////////////");
		// test case(1) : frame with even parity 
		Recieve_Frame_with_parity(11'b1_0_01010101_0, 1'b0, 6'd32);
		check_out(8'h55);
		
		// test case(2) : frame with odd parity 
		Recieve_Frame_with_parity(11'b1_1_01010101_0, 1'b1, 6'd32);
		check_out(8'h55);

		// test case(3) : frame with no parity
		Recieve_Frame_without_parity(10'b1_01010101_0, 6'd32);
		check_out(8'h55);
		#(10)
		$stop; 
	end

	////////////////////////////////////////////// TASKS ////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	task RST_TASK;
		begin
			RX_RST = 0;
			@(negedge RX_CLK);
			@(negedge RX_CLK);
			RX_RST = 1;
		end
	endtask
	/////////////////////////////
	task INITIALIZE_TASK;
		begin
			PAR_EN_tb   = 1'b0;
			PAR_TYP_tb  = 1'b0;
			RX_IN_tb    = 1'b1;
			Prescale_tb = 6'd8;
		end
	endtask
	/////////////////////////////
	integer i;
	task Recieve_Frame_with_parity;
		input  [10:0] frame;
		input  		  par_type;
		input  [5:0]  Prescale_value;
		begin
			PAR_EN_tb   = 1'b1;
			PAR_TYP_tb  = par_type;
			Prescale_tb = Prescale_value;
			for (i=0; i<11; i=i+1) begin
				@(negedge TX_CLK)
				RX_IN_tb = frame[i];
			end
		end
	endtask
	/////////////////////////////
	integer j;
	task Recieve_Frame_without_parity;
		input  [9:0] frame;
		input  [5:0] Prescale_value;
		begin
			PAR_EN_tb = 1'b0;
			Prescale_tb = Prescale_value;
			for (j=0; j<10; j=j+1) begin
				@(negedge TX_CLK)
				RX_IN_tb = frame[j];
			end
		end
	endtask
	/////////////////////////////
	task check_out;
		input [7:0] expected_data;
		begin
			@(posedge Data_valid_tb)
			if (P_DATA_tb==expected_data) begin
				$display("test case is clean");
			end
			else begin
				$display("error");
			end
		end
	endtask


endmodule