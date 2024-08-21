module Reg_File #(parameter ADDR_SIZE = 4, DATA_WIDTH = 8, localparam MEM_DEPTH = 1 << ADDR_SIZE )
(
	input  wire 		  		 CLK,			// source clk
	input  wire 		  		 RST,			// asynchronous negative edge reset
	input  wire 		  		 WrEn,			// write enable 
	input  wire 		  		 RdEn, 			// read enable
	input  wire [ADDR_SIZE-1:0]  Address,		// address bus to access register file
	input  wire [DATA_WIDTH-1:0] WrData,     	// write data
	output reg  [DATA_WIDTH-1:0] RdData,		// read data
	output reg 	 	  		     RdData_valid,  // read data valid signal (high when read data is ready)
	output wire [DATA_WIDTH-1:0] REG0,		    // register at address 0x00 >> configuration to ALU
	output wire [DATA_WIDTH-1:0] REG1,			// register at address 0x01 >> configuration to ALU
	output wire [DATA_WIDTH-1:0] REG2,			// register at address 0x02 >> configuration to UART
	output wire [DATA_WIDTH-1:0] REG3			// register at address 0x03 >> configuration to clock devider
);
	

	reg [DATA_WIDTH-1:0] R_FILE [MEM_DEPTH-1:0];

	integer i;
	always @(posedge CLK or negedge RST) begin
		if (~RST) begin			
			RdData 	  	 <= 16'b0;
			RdData_valid <= 1'b0;
			for (i=0; i<MEM_DEPTH; i=i+1) begin
				if (i==2) begin                  // UART Config
					R_FILE[i] <= 'b100000_0_1;   // prescale_ParityType_ParityEnable
				end 						     
				else if (i==3) begin             // clock divider Config
					R_FILE[i] <= 'd32;           // div ratio 
				end
				else begin
					R_FILE[i] <= 'b0;
				end
			end
		end
		else begin
			case ({WrEn, RdEn})
				2'b01 :
				begin
					RdData 		 <= R_FILE[Address];
					RdData_valid <= 1'b1;
				end
				2'b10 :
				begin
					R_FILE[Address] <= WrData;	
				end
				default :
				begin
					RdData_valid <= 1'b0;
				end
			endcase
		end
	end

	// configuration registers output
	assign REG0 = R_FILE[0] ;
	assign REG1 = R_FILE[1] ;
	assign REG2 = R_FILE[2] ;
	assign REG3 = R_FILE[3] ;

endmodule