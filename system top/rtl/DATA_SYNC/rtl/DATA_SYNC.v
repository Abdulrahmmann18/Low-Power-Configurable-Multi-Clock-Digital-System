module DATA_SYNC #(parameter NUM_STAGES = 2, BUS_WIDTH = 8) 
(
	input wire 				   bus_enable,
	input wire 				   CLK,
	input wire 				   RST,
	input wire [BUS_WIDTH-1:0] unsync_bus,
	output reg [BUS_WIDTH-1:0] sync_bus,
	output reg 				   enable_pulse
);

	
	//////////////////////////////// multi flop synchronaizer ///////////////////////////////
	reg [NUM_STAGES-1:0] sync_flop_out;
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			sync_flop_out <= 'b0;
		end
		else begin
			sync_flop_out <= {sync_flop_out[NUM_STAGES-2:0], bus_enable};
		end
	end

	////////////////////////////////////// pulse gen ////////////////////////////////////////
	reg pulse_gen_flop_out;
	wire pulse_gen;
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			pulse_gen_flop_out <= 1'b0;
		end
		else begin
			pulse_gen_flop_out <= sync_flop_out[NUM_STAGES-1];
		end
	end
	assign pulse_gen = (~pulse_gen_flop_out) & sync_flop_out[NUM_STAGES-1];

	/////////////////////////////////////// sync_bus ////////////////////////////////////////
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			sync_bus <= 'b0;
		end
		else if (pulse_gen) 
			sync_bus <= unsync_bus;
	end

	/////////////////////////////////////// enable_pulse ////////////////////////////////////////
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			// reset
			enable_pulse <= 1'b0;
		end
		else 
			enable_pulse <= pulse_gen;
	end


endmodule