module Pulse_gen  
(
	input  wire CLK,
	input  wire RST,
	input  wire LVL_SIG,
	output wire PULSE_SIG
);

	
	
	reg flop1, flop2;
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			flop1 <= 'b0;
			flop2 <= 'b0;	
		end
		else begin
			flop1 <= LVL_SIG;
			flop2 <= flop1;
		end
	end
	assign PULSE_SIG = flop1 & ~flop2 ;

endmodule