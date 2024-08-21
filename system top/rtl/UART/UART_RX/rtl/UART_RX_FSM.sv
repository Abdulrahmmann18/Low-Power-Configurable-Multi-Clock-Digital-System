module UART_RX_FSM
(
	input wire 		 clk,
	input wire 		 rst,
	input wire 		 PAR_EN,
	input wire 		 RX_IN,
	input wire [3:0] bit_cnt,
	input wire 		 par_error,
	input wire 		 strt_glitch,
	input wire 		 stp_error,
	input wire		 last_edge_flag,
	input wire		 sample_done,
	output reg 		 data_samp_en,
	output reg 		 cnt_enable,
	output reg 		 deser_en,
	output reg 		 data_valid,
	output reg 		 par_chk_en,
	output reg 		 strt_chk_en,
	output reg 		 stp_chk_en
);

	typedef enum {
		IDLE,
		START,
		DESERIALIZE,
		PARITY,
		STOP
	}state_;
	
	state_ CS, NS;
	/*
	localparam IDLE        = 3'b000,
			   START 	   = 3'b001,
			   DESERIALIZE = 3'b010,
			   PARITY 	   = 3'b011,
			   STOP 	   = 3'b100;

	reg [2:0] CS, NS;
	*/
	

	// state memory
	always @(posedge clk or negedge rst) begin
		if (~rst)
			CS <= IDLE;	
		else 
			CS <= NS;
	end

	// next state logic
	always @(*) begin
		NS = IDLE;
		case (CS)	
			IDLE :
			begin
				if (RX_IN)
					NS = IDLE;
				else
					NS = START;
			end
			START :
			begin
				if (last_edge_flag) begin
					if (strt_glitch) 
						NS = IDLE;		
					else 
						NS = DESERIALIZE;
				end 
				else begin
					NS = START;
				end
			end
			DESERIALIZE :
			begin
				if (bit_cnt==4'd9) begin
					if (PAR_EN)
						NS = PARITY;
					else
						NS = STOP;	
				end
				else
					NS = DESERIALIZE;
			end
			PARITY :
			begin
				if (last_edge_flag) begin
					if (par_error) 
						NS = IDLE;		
					else 
						NS = STOP;
				end 
				else begin
					NS = PARITY;
				end
			end
			STOP :
			begin
				if (last_edge_flag) begin
					if (stp_error) begin
						NS = IDLE;
					end
					/*
					else if (~RX_IN) begin
						NS = START;
					end
					*/
					else begin
						NS = IDLE;
					end
				end
				else begin
					NS = STOP;
				end
			end
			default :
			begin
				NS = IDLE;
			end
		endcase
	end

	// output logic
	always @(*) begin
		data_samp_en = 1'b0;
		cnt_enable   = 1'b0;
		deser_en     = 1'b0;
		data_valid   = 1'b0;
		par_chk_en   = 1'b0;
		strt_chk_en  = 1'b0;
		stp_chk_en   = 1'b0;
		case (CS)
			IDLE :
			begin
				if (~RX_IN) begin
					data_samp_en = 1'b1;
					cnt_enable   = 1'b1;
				end
				else begin
					data_samp_en = 1'b0;
					cnt_enable   = 1'b0;
				end
			end
			START :
			begin
				data_samp_en = 1'b1;
				cnt_enable   = 1'b1;
				if (last_edge_flag) begin
					if (strt_glitch) begin
						data_samp_en = 1'b0;
						cnt_enable   = 1'b0;
					end
					else begin
						data_samp_en = 1'b1;
						cnt_enable   = 1'b1;
					end
				end
				else if (sample_done) begin
					strt_chk_en = 1'b1;
				end
			end
			DESERIALIZE :
			begin
				data_samp_en = 1'b1;
				cnt_enable   = 1'b1;
				if (sample_done) begin
					deser_en = 1'b1;
				end
			end
			PARITY :
			begin
				data_samp_en = 1'b1;
				cnt_enable   = 1'b1;
				if (last_edge_flag) begin
					if (par_error) begin
						data_samp_en = 1'b0;
						cnt_enable   = 1'b0;
					end
					else begin
						data_samp_en = 1'b1;
						cnt_enable   = 1'b1;
					end
				end
				else if (sample_done) begin
					par_chk_en = 1'b1;
				end
			end
			STOP :
			begin
				data_samp_en = 1'b1;
				cnt_enable   = 1'b1;
				if (last_edge_flag) begin
					if (stp_error) begin
						data_samp_en = 1'b0;
						cnt_enable   = 1'b0;
						data_valid   = 1'b0;
					end
					else if (~RX_IN) begin
						data_samp_en = 1'b1;
						cnt_enable   = 1'b0;
						data_valid   = 1'b1;
					end
					else begin
						data_samp_en = 1'b0;
						cnt_enable   = 1'b0;
						data_valid   = 1'b1;
					end
				end
				else if (sample_done) begin
					stp_chk_en = 1'b1;
				end
			end
			default :
			begin
				data_samp_en = 1'b0;
				cnt_enable   = 1'b0;
				deser_en     = 1'b0;
				data_valid   = 1'b0;
				par_chk_en   = 1'b0;
				strt_chk_en  = 1'b0;
				stp_chk_en   = 1'b0;
			end
		endcase
	end

endmodule