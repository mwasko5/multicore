`timescale 1ns / 1ps

module alu_multiplier (
    input wire CLK,
    input wire RST_N, // Active-low asynchronous reset
    
    input wire [31:0] IN_A,
    input wire [31:0] IN_B,
    output reg [63:0] OUTPUT
);

    // Stage 1 Registers (Input Capture)
    reg [31:0] a_reg;
    reg [31:0] b_reg;

    // Stage 2 Registers (Multiplication Result)
    reg [63:0] mult_reg;

    // Sequential Logic Block
    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            // Reset all pipeline registers
            a_reg    <= 32'b0;
            b_reg    <= 32'b0;
            mult_reg <= 64'b0;
            OUTPUT   <= 64'b0;
        end else begin
            // Stage 1: Latches inputs on clock edge
            a_reg <= IN_A;
            b_reg <= IN_B;

            // Stage 2: Multiplies registered inputs
            mult_reg <= a_reg * b_reg;

            // Stage 3: Latches the result to the final output
            OUTPUT <= mult_reg;
        end
    end

endmodule