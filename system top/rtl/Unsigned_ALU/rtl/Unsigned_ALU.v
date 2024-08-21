// this is a module for unsigned 16-bit ALU

module Unsigned_ALU #(parameter DATA_IN_WIDTH = 8, OP_CODE_WIDTH = 4, localparam DATA_OUT_WIDTH = 2*DATA_IN_WIDTH)
(
    input  wire                      CLK,
    input  wire                      RST,
    input  wire                      Enable,
    input  wire [DATA_IN_WIDTH-1:0]  A,
    input  wire [DATA_IN_WIDTH-1:0]  B,
    input  wire [OP_CODE_WIDTH-1:0]  ALU_FUN,
    output reg  [DATA_OUT_WIDTH-1:0] ALU_OUT,
    output reg                       ALU_OUT_VALID
);

    // internal signals
    reg [DATA_OUT_WIDTH-1:0] ALU_OUT_comb;
    reg ALU_OUT_VALID_comb;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // combinational always block for ALU_OUT
    always @(*) begin
        ALU_OUT_comb       = 'b0;
        ALU_OUT_VALID_comb = 1'b0;
        if (Enable) begin
            ALU_OUT_VALID_comb = 1'b1;
            case (ALU_FUN)
                4'b0000 : ALU_OUT_comb = A + B;
                4'b0001 : ALU_OUT_comb = A - B;
                4'b0010 : ALU_OUT_comb = A * B;
                4'b0011 : ALU_OUT_comb = A / B;
                4'b0100 : ALU_OUT_comb = A & B;
                4'b0101 : ALU_OUT_comb = A | B;
                4'b0110 : ALU_OUT_comb = ~(A & B);
                4'b0111 : ALU_OUT_comb = ~(A | B);
                4'b1000 : ALU_OUT_comb = A ^ B;
                4'b1001 : ALU_OUT_comb = ~(A ^ B);
                4'b1010 : ALU_OUT_comb = (A == B) ? 16'd1 : 16'd0;
                4'b1011 : ALU_OUT_comb = (A > B)  ? 16'd2 : 16'd0;
                4'b1100 : ALU_OUT_comb = (A < B)  ? 16'd3 : 16'd0;
                4'b1101 : ALU_OUT_comb = A >> 1;
                4'b1110 : ALU_OUT_comb = A << 1; 
                default : ALU_OUT_comb = 16'b0;
            endcase    
        end
        else begin
            ALU_OUT_comb       = 'b0;
            ALU_OUT_VALID_comb = 1'b0;
        end
    end    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // sequintial always block for output
    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            ALU_OUT       <= 'b0;
            ALU_OUT_VALID <= 1'b0;
        end
        else begin
            ALU_OUT       <= ALU_OUT_comb;
            ALU_OUT_VALID <= ALU_OUT_VALID_comb;    
        end
    end

endmodule