module Binary2Gray #(parameter PTR_SIZE = 4) 
(
	input  wire                CLK,
	input  wire 			   RST, 
	input  wire [PTR_SIZE-1:0] Binary_code ,
	output reg  [PTR_SIZE-1:0] Gray_code
);
	/*
	always @(posedge CLK or negedge RST) begin
 		if (!RST) begin
    		Gray_code <= 0 ;
   		end
 		else begin
   			Gray_code[PTR_SIZE-1] <= Binary_code[PTR_SIZE-1] ; // MSB
			Gray_code[PTR_SIZE-2] <= Binary_code[PTR_SIZE-1] ^ Binary_code[PTR_SIZE-2] ;
			Gray_code[PTR_SIZE-3] <= Binary_code[PTR_SIZE-2] ^ Binary_code[PTR_SIZE-3] ;
			Gray_code[PTR_SIZE-4] <= Binary_code[PTR_SIZE-3] ^ Binary_code[PTR_SIZE-4] ;
  		end
 	end
	
	*/
	integer i;
	always @(posedge CLK or negedge RST) begin
 		if (!RST) begin
    		Gray_code <= 0 ;
   		end
 		else begin
   			Gray_code[PTR_SIZE-1] <= Binary_code[PTR_SIZE-1] ; // MSB
   			for (i = 1; i < PTR_SIZE; i = i + 1) begin
				Gray_code[PTR_SIZE-i-1] <= Binary_code[PTR_SIZE-i] ^ Binary_code[PTR_SIZE-i-1] ;
			end
  		end
 	end


endmodule