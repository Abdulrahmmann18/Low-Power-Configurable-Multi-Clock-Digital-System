module Clk_Div_tb();

	/////////////////////////////////////////// parameters //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	parameter RATIO_WIDTH = 5;
	parameter CLK_PERIOD  = 10;
	///////////////////////////////////// signals declaration ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	reg 		 	 	  i_ref_clk;
	reg 			   	  i_rst_n;
	reg 				  i_clk_en_tb;
	reg [RATIO_WIDTH-1:0] i_div_ratio_tb;
	wire				  o_div_clk_tb;

	/////////////////////////////////// clk generation block ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	initial begin
		i_ref_clk = 0;
		forever #(CLK_PERIOD/2) i_ref_clk = ~i_ref_clk;
	end

	////////////////////////////////////// DUT Instantiation ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	Clk_Div #(5) div (
		.i_ref_clk(i_ref_clk), .i_rst_n(i_rst_n), .i_clk_en(i_clk_en_tb), 
		.i_div_ratio(i_div_ratio_tb), .o_div_clk(o_div_clk_tb)
	);

	//////////////////////////////////////// test stimilus //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	initial begin
		INITIALIZE_TASK();
		RST_TASK();
		// test case(1) : div ratio = 1 (o_div_clk = 0)
		TEST_FUNCTIONALITY(1'b1, 1);
		#300;
		// test case(2) : div ratio = 2
		TEST_FUNCTIONALITY(1'b1, 2);
		#200;
		// test case(3) : div ratio = 4
		TEST_FUNCTIONALITY(1'b1, 4);
		#400;
		// test case(4) : div ratio = 8
		TEST_FUNCTIONALITY(1'b1, 8);
		#800;
		// test case(5) : div ratio = 3
		TEST_FUNCTIONALITY(1'b1, 3);
		#300;
		// test case(6) : div ratio = 5
		TEST_FUNCTIONALITY(1'b1, 5);
		#500;
		// test case(4) : div ratio = 7
		TEST_FUNCTIONALITY(1'b1, 7);
		#700;
		$stop;
	end	

	////////////////////////////////////////////// TASKS ////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	task RST_TASK;
		begin
			i_rst_n = 0;
			#(2*CLK_PERIOD)
			i_rst_n = 1;
		end
	endtask
	/////////////////////////////////
	task INITIALIZE_TASK;
		begin
			i_clk_en_tb     = 1'b0;
			i_div_ratio_tb  =  'd2;
		end
	endtask
	/////////////////////////////////
	task TEST_FUNCTIONALITY;
		input 					clock_enable;
		input [RATIO_WIDTH-1:0] div_ratio;
		begin
			@(negedge i_ref_clk);
			i_clk_en_tb    = clock_enable;
			i_div_ratio_tb = div_ratio;
		end
	endtask



endmodule