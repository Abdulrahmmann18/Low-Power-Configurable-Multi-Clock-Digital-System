module UART_TOP  #(parameter DATA_LENGTH = 8)
(
	input  wire 				  TX_CLK,
	input  wire 		          RX_CLK,
	input  wire 				  RST,
	input  wire [DATA_LENGTH-1:0] TX_P_DATA_IN,
	input  wire 				  TX_DATA_VALID_IN,
	input  wire 				  PAR_EN,
	input  wire 				  PAR_TYP,
	input  wire 		          RX_IN,
	input  wire [5:0] 			  Prescale,
	output wire 				  TX_OUT,
	output wire 				  Busy,
	output wire [DATA_LENGTH-1:0] RX_P_DATA_OUT,
	output wire 	 			  RX_Data_valid_OUT,
	output wire		 			  Parity_Error,
	output wire 	 			  Stop_Error
);

	UART_TX #(.DATA_LENGTH(DATA_LENGTH)) uart_tx_inst (
		.P_DATA(TX_P_DATA_IN),
		.DATA_VALID(TX_DATA_VALID_IN),
		.PAR_EN(PAR_EN),
		.PAR_TYP(PAR_TYP),
		.CLK(TX_CLK),
		.RST(RST),
		.TX_OUT(TX_OUT),
		.Busy(Busy)
	); 

	UART_RX #(.DATA_LENGTH(DATA_LENGTH)) uart_rx_inst (
		.clk(RX_CLK),
		.rst(RST), 
		.PAR_TYP(PAR_TYP), 
		.PAR_EN(PAR_EN),
		.RX_IN(RX_IN), 
		.Prescale(Prescale), 
		.P_DATA(RX_P_DATA_OUT),
		.Data_valid(RX_Data_valid_OUT), 
		.Parity_Error(Parity_Error), 
		.Stop_Error(Stop_Error)
	);


endmodule