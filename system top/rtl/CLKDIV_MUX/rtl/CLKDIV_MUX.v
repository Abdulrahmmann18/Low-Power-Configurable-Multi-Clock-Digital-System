module CLKDIV_MUX #(parameter WIDTH = 8)  
(
		input  wire [5:0] 			IN,
		output reg  [WIDTH-1:0] OUT
);


		always @(*) begin
		  case(IN) 
				6'b100000 : OUT = 'd1 ;
				6'b010000 : OUT = 'd2 ;
				6'b001000 : OUT = 'd4 ;
				6'b000100 : OUT = 'd8 ;
				default   : OUT = 'd1 ;					
			endcase
		end	
		    
endmodule