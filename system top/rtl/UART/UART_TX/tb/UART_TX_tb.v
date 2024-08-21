`timescale 1us/1ns

module UART_TX_tb();
	// parameters
	parameter DATA_LENGTH = 8;
	parameter CLK_PERIOD = 8.68;
	// signal declaration
	reg [DATA_LENGTH-1:0] P_DATA_tb;
	reg 				  DATA_VALID_tb;
	reg 				  PAR_EN_tb;
	reg 				  PAR_TYP_tb;
	reg 				  CLK_tb;
	reg 			      RST_tb;
	wire 				  TX_OUT_tb;
	wire 				  Busy_tb;
	// clk generation block
	initial begin
		CLK_tb = 0;
		forever #(CLK_PERIOD/2) CLK_tb = ~CLK_tb;
	end
	// DUT Instantiation
	UART_TX DUT (
		.P_DATA(P_DATA_tb), .DATA_VALID(DATA_VALID_tb),
		.PAR_EN(PAR_EN_tb), .PAR_TYP(PAR_TYP_tb),
		.CLK(CLK_tb), .RST(RST_tb),
		.TX_OUT(TX_OUT_tb), .Busy(Busy_tb)
	);
	// test stimulus
	initial begin
		INITIALIZE_TASK();
		RST_TASK();
		// test case(1) no parity bit
		TRANSMITION_TASK('h55, 1'b0, 1'b0);
		#(10*CLK_PERIOD)
		// test case(2) even parity bit
		TRANSMITION_TASK('h55, 1'b1, 1'b0);
		#(11*CLK_PERIOD)
		// test case(1) odd parity bit
		TRANSMITION_TASK('h55, 1'b1, 1'b1);
		#(11*CLK_PERIOD);
		#(CLK_PERIOD);
		$stop;
	end



	// tasks
	task RST_TASK;
		begin
			RST_tb = 0;
			#(CLK_PERIOD)
			RST_tb = 1;
		end
	endtask

	task INITIALIZE_TASK;
		begin
			DATA_VALID_tb = 0;
			PAR_EN_tb = 0;
			PAR_TYP_tb = 0;
			P_DATA_tb = 'b0;
		end
	endtask

	task TRANSMITION_TASK;
		input [DATA_LENGTH-1:0] Parallel_data;
		input parity_en;
		input parity_type;
		begin
			#(CLK_PERIOD)
			DATA_VALID_tb = 1;
			P_DATA_tb = Parallel_data;
			PAR_EN_tb = parity_en;
			PAR_TYP_tb = parity_type;
			#(CLK_PERIOD)
			DATA_VALID_tb = 0;
		end
	endtask


endmodule