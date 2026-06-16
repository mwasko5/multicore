`timescale 1ns / 1ps
module alu_multiplier (
    input  logic        CLK,
    input  logic        RST_N,  // Active-low asynchronous reset

    input  logic [63:0] IN_A,   // Only lower 32-bits used in multiplication
    input  logic [63:0] IN_B,   // Only lower 32-bits used in multiplication
    output logic [63:0] OUTPUT
);
    
    // input registers (stage 1)
    logic [63:0] a_reg;
    logic [63:0] b_reg;

    // output (stage 2) register
    logic [63:0] mult_reg;

    always_ff @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            a_reg    <= '0;
            b_reg    <= '0;
            mult_reg <= '0;
            OUTPUT   <= '0;
        end else begin
            a_reg <= IN_A;
            b_reg <= IN_B;

            mult_reg <= 64'(a_reg[31:0] * b_reg[31:0]);
            
            OUTPUT <= mult_reg;
        end
    end

endmodule