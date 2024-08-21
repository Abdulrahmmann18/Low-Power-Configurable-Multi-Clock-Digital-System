module Serializer #(parameter DATA_LENGTH = 8)
(
	input wire [DATA_LENGTH-1:0] P_DATA,
	input wire 					 ser_en,
	input wire 					 CLK,
	input wire 					 RST,
	input wire 					 Data_valid,
	output wire 				 ser_done,
	output reg					 ser_data 
); 
	reg [DATA_LENGTH-1:0] P_DATA_Reg; 

	reg [3:0] counter;
	always @(posedge CLK or negedge RST) begin
		if (~RST) begin
			counter    <= 4'b0;
			ser_data   <= 1'b0;
			P_DATA_Reg <= 'b0;
		end
		else if (ser_en) begin	
			counter <= counter + 1;
			P_DATA_Reg <= {1'b0, P_DATA_Reg[DATA_LENGTH-1:1]};
			ser_data <= P_DATA_Reg[0];
			if (counter == 4'd8) begin
				counter <= 4'b0;
			end		
		end
		else if (Data_valid) begin
			P_DATA_Reg <= P_DATA;
		end	
		
	end
	assign ser_done = (counter == 4'd8) ? 1'b1 : 1'b0 ;
	



endmodule
