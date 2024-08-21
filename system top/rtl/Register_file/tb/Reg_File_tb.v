module Reg_File_tb();

	/////////////////////////////////////////// parameters //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	parameter CLK_PERIOD  = 10;
	parameter ADDR_SIZE   = 4;
	parameter DATA_WIDTH  = 8;

	///////////////////////////////////// signals declaration ///////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	reg 				  CLK_tb; 
	reg 				  RST_tb;
	reg 				  WrEn_tb;
	reg 				  RdEn_tb;
	reg  [ADDR_SIZE-1:0]  Address_tb;
	reg  [DATA_WIDTH-1:0] WrData_tb;
	wire [DATA_WIDTH-1:0] RdData_tb;
	wire 				  RdData_valid_tb;
	wire [DATA_WIDTH-1:0] REG0_tb;
	wire [DATA_WIDTH-1:0] REG1_tb;
	wire [DATA_WIDTH-1:0] REG2_tb;
	wire [DATA_WIDTH-1:0] REG3_tb;

	////////////////////////////////////// DUT Instantiation ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	Reg_File DUT (
		.CLK(CLK_tb),
		.RST(RST_tb),
		.WrEn(WrEn_tb),
		.RdEn(RdEn_tb),
		.Address(Address_tb),
		.WrData(WrData_tb),
		.RdData(RdData_tb),
		.RdData_valid(RdData_valid_tb),
		.REG0(REG0_tb),
		.REG1(REG1_tb),
		.REG2(REG2_tb),
		.REG3(REG3_tb)
	);

	/////////////////////////////////// clk generation block ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	always begin
		#(CLK_PERIOD/2) CLK_tb = ~CLK_tb;
	end

	//////////////////////////////////////// test stimilus //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	initial begin
		// initialization
		CLK_tb = 0;
		RST_tb = 0;
		WrEn_tb = 0;
		RdEn_tb = 0;
		Address_tb = 3'b000;
		WrData_tb = 16'b1;
		#10
		RST_tb = 1;
		// test write operation for two clock cycles
		WrEn_tb = 1;
		#10
		Address_tb = 3'b001;
		WrData_tb = 16'b10;
		// test read operation for two clock cycle
		#10
		WrEn_tb = 0;
		RdEn_tb = 1;
		Address_tb = 3'b000;
		#10
		Address_tb = 3'b001;
		// test no operation when RdEn and WrEn both are high
		#10
		WrEn_tb = 1;
		#30
		$stop;
	end

endmodule