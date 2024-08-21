module TX_OUT_MUX
(
	input wire		 CLK,
	input wire 		 RST,
	input wire 		 ser_data,
	input wire 		 par_bit,
	input wire [1:0] mux_sel,
	output reg  	 TX
);  

	reg TX_COMB;
	always @(*) begin
		TX_COMB = 1'b1;  // default value
		case (mux_sel) 
			2'b00 : TX_COMB = 1'b0;
			2'b01 : TX_COMB = 1'b1;
			2'b10 : TX_COMB = ser_data;
			2'b11 : TX_COMB = par_bit;
		endcase
	end
	
	always @(posedge CLK or negedge RST) begin
		if (~RST) begin
			// reset
			TX <= 1'b0;
		end
		else begin
			TX <= TX_COMB;
		end
	end

endmodule