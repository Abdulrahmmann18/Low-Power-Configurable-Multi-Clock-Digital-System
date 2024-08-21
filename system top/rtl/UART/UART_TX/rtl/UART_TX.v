module UART_TX #(parameter DATA_LENGTH = 8)
(
	input wire [DATA_LENGTH-1:0] P_DATA,
	input wire 					 DATA_VALID,
	input wire 					 PAR_EN,
	input wire 					 PAR_TYP,
	input wire 					 CLK,
	input wire 					 RST,
	output wire 				 TX_OUT,
	output wire 				 Busy
); 
	wire ser_done_TOP, ser_en_TOP, Enable_Parity_output_TOP, ser_data_TOP, PAR_BIT_TOP;
	wire [1:0] mux_sel_TOP;

	UART_FSM fsm (
		.CLK(CLK),
		.RST(RST),
		.ser_en(ser_en_TOP),
		.Par_en(PAR_EN),
		.Data_valid(DATA_VALID), 
		.mux_sel(mux_sel_TOP),
		.ser_done(ser_done_TOP),
		.Enable_Parity_output(Enable_Parity_output_TOP),
		.busy(Busy)
	);

	Serializer ser (
		.P_DATA(P_DATA),
		.ser_en(ser_en_TOP),
		.CLK(CLK),
		.RST(RST),
		.Data_valid(DATA_VALID),
		.ser_done(ser_done_TOP),
		.ser_data(ser_data_TOP)
	);  

	Parity_calc par (
		.CLK(CLK),
		.RST(RST),
		.P_DATA(P_DATA),
		.Data_valid(DATA_VALID),
		.PAR_TYPE(PAR_TYP),
		.Enable_Par_Output(Enable_Parity_output_TOP),
		.busy(Busy),
		.PAR_BIT(PAR_BIT_TOP)
	);  

	TX_OUT_MUX mux (
		.CLK(CLK),
		.RST(RST),
		.ser_data(ser_data_TOP),
		.par_bit(PAR_BIT_TOP),
		.mux_sel(mux_sel_TOP),
		.TX(TX_OUT)
	);  


endmodule