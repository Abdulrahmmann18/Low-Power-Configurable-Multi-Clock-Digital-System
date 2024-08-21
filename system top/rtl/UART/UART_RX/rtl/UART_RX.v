module UART_RX #(parameter DATA_LENGTH = 8)
(
	input  wire 				  clk,
	input  wire 				  rst,
	input  wire 				  PAR_TYP,
	input  wire 				  PAR_EN,
	input  wire 		  		  RX_IN,
	input  wire [5:0] 			  Prescale,
	output wire [DATA_LENGTH-1:0] P_DATA,
	output wire 	  			  Data_valid,
	output wire		  			  Parity_Error,
	output wire 	  			  Stop_Error
);

	wire data_samp_en_top, sampled_bit_top, cnt_enable_top, deser_en_top,
		 par_chk_en_top, strt_chk_en_top, strt_glitch_top, stp_chk_en_top, last_edge_flag_top,
		 sample_done_top;
	wire [3:0] bit_cnt_top;
	wire [5:0] edge_cnt_top;

	data_sampling data_samp (
		.clk(clk), .rst(rst), .RX_IN(RX_IN),
		.data_samp_en(data_samp_en_top), .prescale(Prescale), 
		.edge_cnt(edge_cnt_top), .sampled_bit(sampled_bit_top), .sample_done(sample_done_top)
	);

	edge_bit_counter cnt (
		.clk(clk), .rst(rst),.cnt_enable(cnt_enable_top), .prescale(Prescale),
		.edge_cnt(edge_cnt_top), .bit_cnt(bit_cnt_top), .last_edge_flag(last_edge_flag_top)
	);

	parity_check par (
		.clk(clk), .rst(rst), .PAR_TYP(PAR_TYP),
		.sampled_bit(sampled_bit_top), .par_chk_en(par_chk_en_top),
		.P_DATA(P_DATA), .par_error(Parity_Error)
	);

	strt_check strt (
		.clk(clk), .rst(rst), .sampled_bit(sampled_bit_top),
		.strt_chk_en(strt_chk_en_top), .strt_glitch(strt_glitch_top)
	);

	stop_check stp (
		.clk(clk), .rst(rst), .sampled_bit(sampled_bit_top),
		.stp_chk_en(stp_chk_en_top), .stp_error(Stop_Error)
	);

	deserializer desr (
		.clk(clk), .rst(rst), .sampled_bit(sampled_bit_top),
		.deser_en(deser_en_top), .P_DATA(P_DATA)
	);

	UART_RX_FSM fsm (
		.clk(clk), .rst(rst), .PAR_EN(PAR_EN), .RX_IN(RX_IN),
		.bit_cnt(bit_cnt_top), .par_error(Parity_Error), .strt_glitch(strt_glitch_top), 
		.stp_error(Stop_Error), .last_edge_flag(last_edge_flag_top), .data_samp_en(data_samp_en_top), .cnt_enable(cnt_enable_top),
		.deser_en(deser_en_top), .sample_done(sample_done_top), .data_valid(Data_valid),
		.par_chk_en(par_chk_en_top), .strt_chk_en(strt_chk_en_top), .stp_chk_en(stp_chk_en_top)
	);

endmodule