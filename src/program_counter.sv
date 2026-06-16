`timescale 1ns / 1ps
module program_counter (
    input  logic        CLK,
    input  logic        RST_N,
    input  logic        EN,        // Enable signal for pipeline stalls
    
    input  logic [31:0] ADDRESS,
    
    output logic [31:0] PC_RESULT
);

    always_ff @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            PC_RESULT <= '0;
        end
        else if (EN) begin         // Only fetch next PC if not stalling
            PC_RESULT <= ADDRESS;
        end
        // If EN is low, the register naturally holds its current value
    end

endmodule