module System_TOP #(parameter DATA_WIDTH = 8, RST_NUM_STAGES = 2, DIV_RATIO_WIDTH = 8, DATA_SYNC_NUM_STAGES = 2,
							  ALU_OUT_WIDTH = 16, FUNC_WIDTH = 4, ADDR_SIZE = 4)
(
	input  wire REF_CLK,
	input  wire UART_CLK,
	input  wire RST,
	input  wire RX_IN,
	output wire TX_OUT,
	output wire Parity_Error,
	output wire Framing_Error 
);

	//////////////////////////////////////////////////////// top module wires ///////////////////////////////////////////////////////////// 
	wire 					   SYNC_REF_RST_top, SYNC_UART_RST_top;
	wire 					   divided_TX_CLK_top, divided_RX_CLK_top, REF_GATED_CLK_top;
	wire 					   RX_Data_valid_OUT_top, ALU_OUT_VALID_top, reg_file_RdData_valid_top, SYNC_RX_DATA_VALID_top;
	wire 					   ALU_Enable_top, CLK_GATE_Enable_top, clk_div_en_top, reg_file_WrEn_top, reg_file_RdEn_top;
	wire 					   FULL_top, EMPTY_top, W_INC_top, R_INC_top, Busy_top;
	wire [FUNC_WIDTH-1:0] 	   ALU_FUNC_top;
	wire [ADDR_SIZE-1:0] 	   Reg_file_Adderss_top;
	wire [DIV_RATIO_WIDTH-1:0] rx_div_ratio_top;
	wire [DATA_WIDTH-1:0] 	   REG0_top, REG1_top, REG2_top, REG3_top, reg_file_WrData_top;
	wire [DATA_WIDTH-1:0] 	   RX_P_DATA_OUT_top, reg_file_RdData_top, SYNC_RX_P_DATA_top, fifo_WR_DATA_top, fifo_RD_DATA_top;
	wire [ALU_OUT_WIDTH-1:0]   ALU_OUT_top;

	/////////////////////////////////////////////////// RST synchronizers Instantiation ///////////////////////////////////////////////////
	RST_SYNC REF_RST_SYNC (
		.CLK(REF_CLK),
		.RST(RST),
		.SYNC_RST(SYNC_REF_RST_top)
	);
	RST_SYNC UART_RST_SYNC (
		.CLK(UART_CLK),
		.RST(RST),
		.SYNC_RST(SYNC_UART_RST_top)
	);

	///////////////////////////////////////////////////////// clock div Instantiation /////////////////////////////////////////////////////
	Clk_Div TX_CLK_DIV (
		.i_ref_clk(UART_CLK),
		.i_rst_n(SYNC_UART_RST_top),
		.i_clk_en(clk_div_en_top),
		.i_div_ratio(REG3_top),
		.o_div_clk(divided_TX_CLK_top)
	);
	CLKDIV_MUX div_mux (
		.IN(REG2_top[DATA_WIDTH-1:2]),
		.OUT(rx_div_ratio_top)
	);
	Clk_Div RX_CLK_DIV (
		.i_ref_clk(UART_CLK),
		.i_rst_n(SYNC_UART_RST_top),
		.i_clk_en(clk_div_en_top),
		.i_div_ratio(rx_div_ratio_top),
		.o_div_clk(divided_RX_CLK_top)
	);

	//////////////////////////////////////////////////////////// UART Instantiation ////////////////////////////////////////////////////////
	UART_TOP uart_inst  (
		.TX_CLK(divided_TX_CLK_top),
		.RX_CLK(divided_RX_CLK_top),
		.RST(SYNC_UART_RST_top),
		.TX_P_DATA_IN(fifo_RD_DATA_top),
		.TX_DATA_VALID_IN(!EMPTY_top),
		.PAR_EN(REG2_top[0]),
		.PAR_TYP(REG2_top[1]),
		.RX_IN(RX_IN),
		.Prescale(REG2_top[DATA_WIDTH-1:2]),
		.TX_OUT(TX_OUT),
		.Busy(Busy_top),
		.RX_P_DATA_OUT(RX_P_DATA_OUT_top),
		.RX_Data_valid_OUT(RX_Data_valid_OUT_top),
		.Parity_Error(Parity_Error),
		.Stop_Error(Framing_Error)
	);

	////////////////////////////////////////////////////////// Register file instantiation ///////////////////////////////////////////////////
	Reg_File rfile_inst (
		.CLK(REF_CLK),				// source clk
		.RST(SYNC_REF_RST_top),				// asynchronous negative edge reset
		.WrEn(reg_file_WrEn_top),			// write enable 
		.RdEn(reg_file_RdEn_top), 			// read enable
		.Address(Reg_file_Adderss_top),			// address bus to access register file
		.WrData(reg_file_WrData_top),     	    // write data
		.RdData(reg_file_RdData_top),		    // read data
		.RdData_valid(reg_file_RdData_valid_top),    // read data valid signal (high when read data is ready)
		.REG0(REG0_top),		    // register at address 0x00 >> configuration to ALU
		.REG1(REG1_top),			// register at address 0x01 >> configuration to ALU
		.REG2(REG2_top),			// register at address 0x02 >> configuration to UART
		.REG3(REG3_top)			    // register at address 0x03 >> configuration to clock devider
	);

	//////////////////////////////////////////////////// clock gating Instantiation //////////////////////////////////////////////////////////
	Clk_Gate  clk_gat_inst (
		.CLK(REF_CLK),
		.CLK_EN(CLK_GATE_Enable_top),
		.GATED_CLK(REF_GATED_CLK_top) 
	);

	//////////////////////////////////////////////////////////// ALU Instantiation ///////////////////////////////////////////////////////////
	Unsigned_ALU alu_inst (
	    .CLK(REF_GATED_CLK_top),
	    .RST(SYNC_REF_RST_top),
	    .Enable(ALU_Enable_top),
	    .A(REG0_top),
	    .B(REG1_top),
	    .ALU_FUN(ALU_FUNC_top),
	    .ALU_OUT(ALU_OUT_top),
	    .ALU_OUT_VALID(ALU_OUT_VALID_top)
	);

	///////////////////////////////////////////////////////// DATA Synchronaizer Instantiation //////////////////////////////////////////////
	DATA_SYNC data_syn_inst (
		.bus_enable(RX_Data_valid_OUT_top),
		.CLK(REF_CLK),
		.RST(SYNC_REF_RST_top),
		.unsync_bus(RX_P_DATA_OUT_top),
		.sync_bus(SYNC_RX_P_DATA_top),
		.enable_pulse(SYNC_RX_DATA_VALID_top)
	);

	//////////////////////////////////////////////////////// system cntrl Instantiation /////////////////////////////////////////////////////
	SYS_CTRL sys_cntrol_inst (
		.CLK(REF_CLK),
		.RST(SYNC_REF_RST_top),
		.ALU_OUT(ALU_OUT_top),
		.ALU_OUT_VALID(ALU_OUT_VALID_top),
		.reg_file_RdData(reg_file_RdData_top),
		.reg_file_RdData_valid(reg_file_RdData_valid_top),
		.SYNC_RX_P_DATA(SYNC_RX_P_DATA_top),
		.SYNC_RX_DATA_VALID(SYNC_RX_DATA_VALID_top),
		.FIFO_FULL(FULL_top),
		.ALU_Enable(ALU_Enable_top),
		.ALU_FUNC(ALU_FUNC_top),
		.CLK_GATE_Enable(CLK_GATE_Enable_top),
		.Reg_file_Adderss(Reg_file_Adderss_top),
		.reg_file_WrEn(reg_file_WrEn_top),
		.reg_file_RdEn(reg_file_RdEn_top),
		.reg_file_WrData(reg_file_WrData_top),
		.TX_P_DATA(fifo_WR_DATA_top),
		.TX_DATA_VALID(W_INC_top),
		.clk_div_en(clk_div_en_top)
	);

	//////////////////////////////////////////////////// pulse generator Instantiation ////////////////////////////////////////////////////////
	Pulse_gen pul_gen (
		.CLK(divided_TX_CLK_top),
		.RST(SYNC_UART_RST_top),
		.LVL_SIG(Busy_top),
		.PULSE_SIG(R_INC_top)
	);

	///////////////////////////////////////////////////////// FIFO Instantiation //////////////////////////////////////////////////////////////
	ASYNC_FIFO fifo_inst (
		.W_CLK(REF_CLK), 
		.W_RST(SYNC_REF_RST_top), 
		.W_INC(W_INC_top),
		.R_CLK(divided_TX_CLK_top), 
		.R_RST(SYNC_UART_RST_top), 
		.R_INC(R_INC_top),
		.WR_DATA(fifo_WR_DATA_top), 
		.RD_DATA(fifo_RD_DATA_top), 
		.FULL(FULL_top), 
		.EMPTY(EMPTY_top)
	);


endmodule