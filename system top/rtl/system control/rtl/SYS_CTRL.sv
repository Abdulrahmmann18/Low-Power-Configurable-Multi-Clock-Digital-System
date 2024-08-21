module SYS_CTRL #(parameter ALU_OUT_WIDTH = 16, DATA_WIDTH = 8, FUNC_WIDTH = 4, ADDR_SIZE = 4)
(
	input  wire 	   				CLK,
	input  wire 	   				RST,
	input  wire [ALU_OUT_WIDTH-1:0] ALU_OUT,
	input  wire 	   				ALU_OUT_VALID,
	input  wire [DATA_WIDTH-1:0]  	reg_file_RdData,
	input  wire        				reg_file_RdData_valid,
	input  wire [DATA_WIDTH-1:0]  	SYNC_RX_P_DATA,
	input  wire 	   				SYNC_RX_DATA_VALID,
	input  wire        				FIFO_FULL,
	output reg         				ALU_Enable,
	output reg  [FUNC_WIDTH-1:0]  	ALU_FUNC,
	output reg  	   				CLK_GATE_Enable,
	output reg  [ADDR_SIZE-1:0]  	Reg_file_Adderss,
	output reg  	   				reg_file_WrEn,
	output reg  	   				reg_file_RdEn,
	output reg  [DATA_WIDTH-1:0]  	reg_file_WrData,
	output reg  [DATA_WIDTH-1:0]  	TX_P_DATA,
	output reg  	   				TX_DATA_VALID,
	output reg  	   				clk_div_en
);

	typedef enum {
		IDLE,
		RF_WR_ADDR,
		RF_WR_DATA,
		RF_RD_ADDR,
		FIFO_WRITE,
		WRITE_OPER_A,
		WRITE_OPER_B,
		ALU_FUN,
		WRITE_ALU_LOW_BYTE,
		WRITE_ALU_HIGH_BYTE
	}state_;
	
	state_ CS, NS;
	/*
	localparam IDLE 	 			= 4'b0000,
			   RF_WR_ADDR			= 4'b0001,
			   RF_WR_DATA			= 4'b0010,
			   RF_RD_ADDR 			= 4'b0011,
			   FIFO_WRITE 			= 4'b0100,
			   WRITE_OPER_A 		= 4'b0101,
			   WRITE_OPER_B 		= 4'b0110,
			   ALU_FUN      		= 4'b0111,
			   WRITE_ALU_LOW_BYTE   = 4'b1000,
			   WRITE_ALU_HIGH_BYTE  = 4'b1001;	

	reg [3:0] CS, NS;
	*/
	// state memory
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			CS <= IDLE;
		end
		else begin
			CS <= NS;
		end
	end

	// internal wires
	reg addr_en;
	// sequintial always block for internal signals
	reg  [ADDR_SIZE-1:0]  Reg_file_Adderss_temp;
	// next state logic 
	always @(*) begin
		NS = IDLE;
		case (CS)
			IDLE :
			begin
				if (SYNC_RX_DATA_VALID) begin
					case (SYNC_RX_P_DATA)
						'hAA : NS = RF_WR_ADDR;
						'hBB : NS = RF_RD_ADDR;
						'hCC : NS = WRITE_OPER_A;
						'hDD : NS = ALU_FUN;
					endcase
				end
				else begin
					NS = IDLE;
				end
			end

			RF_WR_ADDR :
			begin
				if (SYNC_RX_DATA_VALID) begin
					NS = RF_WR_DATA;
				end
				else begin
					NS = RF_WR_ADDR;
				end
			end

			RF_WR_DATA :
			begin
				if (SYNC_RX_DATA_VALID) begin
					NS = IDLE;
				end
				else begin
					NS = RF_WR_DATA;
				end
			end

			RF_RD_ADDR :
			begin
				if (SYNC_RX_DATA_VALID) begin
					NS = FIFO_WRITE;
				end
				else begin
					NS = RF_RD_ADDR;
				end
			end

			FIFO_WRITE :
			begin
				if (!FIFO_FULL&&reg_file_RdData_valid) begin				
					NS = IDLE;
				end
				else begin
					NS = FIFO_WRITE;
				end
			end


			WRITE_OPER_A :
			begin
				if (SYNC_RX_DATA_VALID) begin
					NS = WRITE_OPER_B;
				end
				else begin
					NS = WRITE_OPER_A;
				end
			end

			WRITE_OPER_B :
			begin
				if (SYNC_RX_DATA_VALID) begin
					NS = ALU_FUN;
				end
				else begin
					NS = WRITE_OPER_B;
				end
			end

			ALU_FUN :
			begin
				if (SYNC_RX_DATA_VALID) begin
					NS = WRITE_ALU_LOW_BYTE;
				end
				else begin
					NS = ALU_FUN;
				end
			end

			WRITE_ALU_LOW_BYTE :
			begin
				if (ALU_OUT_VALID) begin
					NS = WRITE_ALU_HIGH_BYTE;
				end
				else begin
					NS = WRITE_ALU_LOW_BYTE;
				end
			end

			WRITE_ALU_HIGH_BYTE :
			begin
				if (ALU_OUT_VALID) begin
					NS = IDLE;
				end
				else begin
					NS = WRITE_ALU_HIGH_BYTE;
				end
			end

		endcase
	end

	// output logic 
	always @(*) begin
		// outputs
		ALU_Enable		 = 1'b0;
		ALU_FUNC         =  'b0;
		CLK_GATE_Enable  = 1'b0;
		Reg_file_Adderss =  'b0;
		reg_file_WrEn    = 1'b0;
		reg_file_RdEn    = 1'b0;
		reg_file_WrData  =  'b0;
		TX_P_DATA		 =  'b0;
		TX_DATA_VALID	 = 1'b0;
		clk_div_en       = 1'b1;
		// internal wires
		addr_en          = 1'b0;
		case (CS)
			IDLE :
			begin
				// outputs
				ALU_Enable		 = 1'b0;
				ALU_FUNC         =  'b0;
				CLK_GATE_Enable  = 1'b0;
				Reg_file_Adderss =  'b0;
				reg_file_WrEn    = 1'b0;
				reg_file_RdEn    = 1'b0;
				reg_file_WrData  =  'b0;
				TX_P_DATA		 =  'b0;
				TX_DATA_VALID	 = 1'b0;
			end

			RF_WR_ADDR :
			begin
				if (SYNC_RX_DATA_VALID) begin
					// outputs
					ALU_Enable		 = 1'b0;
					ALU_FUNC         =  'b0;
					CLK_GATE_Enable  = 1'b0;
					Reg_file_Adderss =  'b0;
					reg_file_WrEn    = 1'b0;
					reg_file_RdEn    = 1'b0;
					reg_file_WrData  =  'b0;
					TX_P_DATA		 =  'b0;
					TX_DATA_VALID	 = 1'b0;
					// internal wires
					addr_en          = 1'b1;
				end
			end

			RF_WR_DATA :
			begin
				if (SYNC_RX_DATA_VALID) begin
					// outputs
					ALU_Enable		 = 1'b0;
					ALU_FUNC         =  'b0;
					CLK_GATE_Enable  = 1'b0;
					Reg_file_Adderss = Reg_file_Adderss_temp;
					reg_file_WrEn    = 1'b1;
					reg_file_RdEn    = 1'b0;
					reg_file_WrData  = SYNC_RX_P_DATA;
					TX_P_DATA		 =  'b0;
					TX_DATA_VALID	 = 1'b0;
				end
			end

			RF_RD_ADDR :
			begin
				if (SYNC_RX_DATA_VALID) begin
					// outputs
					ALU_Enable		 = 1'b0;
					ALU_FUNC         =  'b0;
					CLK_GATE_Enable  = 1'b0;
					Reg_file_Adderss = SYNC_RX_P_DATA[ADDR_SIZE-1:0];
					reg_file_WrEn    = 1'b0;
					reg_file_RdEn    = 1'b1;
					reg_file_WrData  =  'b0;
					TX_P_DATA		 =  'b0;
					TX_DATA_VALID	 = 1'b0;
				end
			end

			FIFO_WRITE :
			begin
				if (!FIFO_FULL&&reg_file_RdData_valid) begin				
					// outputs
					ALU_Enable		 = 1'b0;
					ALU_FUNC         =  'b0;
					CLK_GATE_Enable  = 1'b0;
					Reg_file_Adderss =  'b0;
					reg_file_WrEn    = 1'b0;
					reg_file_RdEn    = 1'b0;
					reg_file_WrData  =  'b0;
					TX_P_DATA		 = reg_file_RdData;
					TX_DATA_VALID	 = reg_file_RdData_valid /*1'b1*/;
				end
			end

			WRITE_OPER_A :
			begin
				if (SYNC_RX_DATA_VALID) begin
					// outputs
					ALU_Enable		 = 1'b0;
					ALU_FUNC         =  'b0;
					CLK_GATE_Enable  = 1'b0;
					Reg_file_Adderss =  'b0;
					reg_file_WrEn    = 1'b1;
					reg_file_RdEn    = 1'b0;
					reg_file_WrData  = SYNC_RX_P_DATA;
					TX_P_DATA		 =  'b0;
					TX_DATA_VALID	 = 1'b0;
				end
			end

			WRITE_OPER_B :
			begin
				if (SYNC_RX_DATA_VALID) begin
					// outputs
					ALU_Enable		 = 1'b0;
					ALU_FUNC         =  'b0;
					CLK_GATE_Enable  = 1'b1;
					Reg_file_Adderss =  'b1;
					reg_file_WrEn    = 1'b1;
					reg_file_RdEn    = 1'b0;
					reg_file_WrData  = SYNC_RX_P_DATA;
					TX_P_DATA		 =  'b0;
					TX_DATA_VALID	 = 1'b0;
				end
			end

			ALU_FUN :
			begin
				if (SYNC_RX_DATA_VALID) begin
					// outputs
					ALU_Enable		 = 1'b1;
					ALU_FUNC         = SYNC_RX_P_DATA[FUNC_WIDTH-1:0] ;
					CLK_GATE_Enable  = 1'b1;
					Reg_file_Adderss =  'b0;
					reg_file_WrEn    = 1'b0;
					reg_file_RdEn    = 1'b0;
					reg_file_WrData  =  'b0;
					TX_P_DATA		 =  'b0;
					TX_DATA_VALID	 = 1'b0;
				end
			end
			WRITE_ALU_LOW_BYTE :
			begin
				if (ALU_OUT_VALID) begin
					// outputs
					ALU_Enable		 = 1'b1;
					ALU_FUNC         = SYNC_RX_P_DATA[FUNC_WIDTH-1:0];
					CLK_GATE_Enable  = 1'b1;
					Reg_file_Adderss =  'b0;
					reg_file_WrEn    = 1'b0;
					reg_file_RdEn    = 1'b0;
					reg_file_WrData  =  'b0;
					TX_P_DATA		 = ALU_OUT[DATA_WIDTH-1:0];
					TX_DATA_VALID	 = ALU_OUT_VALID /*1'b1*/;
				end
			end

			WRITE_ALU_HIGH_BYTE :
			begin
				if (ALU_OUT_VALID) begin
					// outputs
					ALU_Enable		 = 1'b0;
					ALU_FUNC         = SYNC_RX_P_DATA[FUNC_WIDTH-1:0];
					CLK_GATE_Enable  = 1'b1;
					Reg_file_Adderss =  'b0;
					reg_file_WrEn    = 1'b0;
					reg_file_RdEn    = 1'b0;
					reg_file_WrData  =  'b0;
					TX_P_DATA		 = ALU_OUT[ALU_OUT_WIDTH-1:DATA_WIDTH];
					TX_DATA_VALID	 = ALU_OUT_VALID /*1'b1*/;
				end
			end

			
		endcase
	end


	
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			Reg_file_Adderss_temp <= 'b0;
		end
		else if (addr_en) begin
			Reg_file_Adderss_temp <= SYNC_RX_P_DATA[FUNC_WIDTH-1:0];
		end
	end

endmodule
