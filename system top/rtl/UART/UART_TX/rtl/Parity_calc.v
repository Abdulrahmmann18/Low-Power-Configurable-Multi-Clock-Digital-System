module Parity_calc #(parameter DATA_LENGTH = 8)
(
	input wire 					 CLK,
	input wire 					 RST,
	input wire [DATA_LENGTH-1:0] P_DATA,
	input wire 					 Data_valid,
	input wire 					 PAR_TYPE,
	input wire  				 Enable_Par_Output,
	input wire					 busy,
	output reg 				 	 PAR_BIT
);  
	
	reg [DATA_LENGTH-1:0] P_DATA_Reg;

	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			PAR_BIT    <= 1'b0;
			P_DATA_Reg <= 'b0;
		end		
		else if (Data_valid&&!busy) begin
			P_DATA_Reg <= P_DATA;
		end
		else if (Enable_Par_Output) begin
			PAR_BIT <= (~PAR_TYPE) ? (^P_DATA_Reg) : (~^P_DATA_Reg);
		end
	end

endmodule