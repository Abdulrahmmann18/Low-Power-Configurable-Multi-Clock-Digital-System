module UART_FSM #(parameter DATA_LENGTH = 8)
(
	input wire 					 CLK,
	input wire 					 RST,
	input wire 					 ser_done,
	input wire 					 Par_en,
	input wire					 Data_valid, 
	output reg [1:0] 			 mux_sel,
	output reg 				     ser_en,
	output reg 					 Enable_Parity_output,
	output reg 					 busy
);  

	/*
	typedef enum {
		IDLE,
		START,
		DATA,
		PARITY,
		STOP
	}state_;
	
	state_ CU_S, NX_S;
	*/
	
	reg [2:0] CU_S, NX_S;

	localparam IDLE = 3'b000,
			   START = 3'b001,
			   DATA = 3'b010,
			   PARITY = 3'b011,
			   STOP = 3'b100;
	
	
	
	// Current state ff
	always @(posedge CLK or negedge RST) begin
		if (~RST) begin
			CU_S <= IDLE;			
		end
		else begin
			CU_S <= NX_S;
		end
	end

	// next state logic
	always @(*) begin
		NX_S = IDLE; // default value
		case (CU_S)
			IDLE :
			begin
				if (Data_valid)
					NX_S = START;
				else
					NX_S = IDLE;
			end
			START :
			begin
				NX_S = DATA;
			end
			DATA :
			begin
				if (~ser_done)
					NX_S = DATA;
				else if (~Par_en)
					NX_S = STOP;
				else 
					NX_S = PARITY;
			end
			PARITY :
			begin
				NX_S = STOP;
			end
			STOP :
			begin
				NX_S = IDLE;
			end
			default :
			begin
				NX_S = IDLE;
			end
		endcase
	end

	// output logic
	reg busy_comb;
	always @(*) begin
		// default values
		ser_en 				 = 1'b0;
		mux_sel 			 = 2'b01;  // stop
		busy_comb 		     = 1'b0;
		Enable_Parity_output = 1'b0;
		case (CU_S)
			IDLE :
			begin
				ser_en 				 = 1'b0;
				mux_sel 			 = 2'b01;  // stop
				busy_comb 		     = 1'b0;
				Enable_Parity_output = 1'b0;
			end
			START :
			begin
				ser_en 				 = 1'b1;
				mux_sel 			 = 2'b00;  // start 
				busy_comb 		     = 1'b1;
				Enable_Parity_output = 1'b0;
			end
			DATA :
			begin
				ser_en 				 = 1'b1;
				mux_sel 			 = 2'b10;  // ser data
				busy_comb 		     = 1'b1;
				Enable_Parity_output = 1'b1;
			end
			PARITY :
			begin
				ser_en 				 = 1'b0;
				mux_sel 			 = 2'b11;  // parity
				busy_comb 		     = 1'b1;
				Enable_Parity_output = 1'b0;
			end
			STOP :
			begin
				ser_en 				 = 1'b0;
				mux_sel 			 = 2'b01;  // stop
				busy_comb 		     = 1'b1;
				Enable_Parity_output = 1'b0;
			end
			default :
			begin
				ser_en 				 = 1'b0;
				mux_sel 			 = 2'b01;  // stop
				busy_comb 		     = 1'b1;
				Enable_Parity_output = 1'b0;
			end
		endcase
	end

	// busy output 
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			busy <= 1'b0;
		end
		else begin
			busy <= busy_comb;
		end
	end


endmodule