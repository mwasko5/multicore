`timescale 1ns / 1ps

// --------------------------
// TEST INSTRUCTION MEMORY
// REPLACE LATER
// --------------------------

module instruction_memory (
    input  logic [31:0] ADDRESS,     // Input Address from PC
    output logic [31:0] INSTRUCTION  // Output Instruction word
);
    
    // 1024 words of 32-bit memory
    logic [31:0] mem [0:1023];

    // Initialize memory (perfect for simulation or hardcoded FPGA bitstreams)
    initial begin
        // Clear everything to NOPs first
        for (int i = 0; i < 1024; i++) begin
            mem[i] = '0;
        end

        // Hardcode your machine code entries here just like your lab code:
        mem[6]  = 32'b00100000000010010000000000000110; // addi $t1, $zero, 6
        mem[12] = 32'b00100000000010100000000000001010; // addi $t2, $zero, 10
    end

    // Asynchronous/Combinational Read
    // Drops the bottom 2 bits for 4-byte word alignment (ADDRESS[11:2] indexes 1024 words)
    always_comb begin
        INSTRUCTION = mem[ADDRESS[11:2]];
    end

endmodule