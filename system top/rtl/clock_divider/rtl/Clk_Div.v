module Clk_Div #(parameter RATIO_WIDTH = 8)
(
	input wire 					 i_ref_clk,
	input wire 					 i_rst_n,
	input wire 					 i_clk_en,
	input wire [RATIO_WIDTH-1:0] i_div_ratio,
	output wire					 o_div_clk
);

	
	wire valid_ratio, odd_ratio, high_condition, low_condition;
	wire [RATIO_WIDTH-2:0] high_time, low_time;
	reg [RATIO_WIDTH-2:0] counter; 
	reg toggle_flag, divided_clock;

	assign valid_ratio    = ((i_div_ratio=='b0) || (i_div_ratio=='b1)) ? 1'b0 : 1'b1 ;
	assign odd_ratio      = i_div_ratio[0] ;
	assign high_time      = (i_div_ratio >> 1) ;
	assign low_time       = (i_div_ratio >> 1) -1;
	assign high_condition = odd_ratio && (counter==high_time) && (~toggle_flag) ;
	assign low_condition  = odd_ratio && (counter==low_time)  && (toggle_flag);

	always @(posedge i_ref_clk or negedge i_rst_n) begin
		if (!i_rst_n) begin
			// reset
			divided_clock   <= 1'b0;
			counter         <= 'b0;
			toggle_flag     <= 1'b0;
		end
		else if (valid_ratio&&i_clk_en) begin
			// even div ratio
			if (!odd_ratio && counter==low_time) begin
				divided_clock <= ~divided_clock;
				counter       <= 'b0;
			end
			// odd div ratio
			else if (high_condition || low_condition) begin
				divided_clock   <= ~divided_clock;
				counter         <= 'b0;
				toggle_flag     <= ~toggle_flag;
			end
			else begin
				counter <= counter+1;
			end
		end
	end
	assign o_div_clk = (i_clk_en&&valid_ratio) ? divided_clock : i_ref_clk ;

endmodule