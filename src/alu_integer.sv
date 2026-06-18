`timescale 1ns / 1ps
module alu_integer (
    input logic [63:0] IN_A, IN_B,

    input logic [1:0] SELECT, // select signal for operation

    output logic [63:0] ALU_OUTPUT,
    
    output logic ZERO, // zero signal
    output logic OVERFLOW // overflow signal
);

    always_comb begin
        ALU_OUTPUT = '0;

        case (SELECT)
            2'b00: // add
                ALU_OUTPUT = IN_A + IN_B;
            2'b01: // subtract
                ALU_OUTPUT = IN_A - IN_B;
            2'b10: // and
                ALU_OUTPUT = IN_A & IN_B;
            2'b11: // or
                ALU_OUTPUT = IN_A | IN_B;
        endcase 
    end

    assign ZERO = (ALU_OUTPUT == '0);

    assign OVERFLOW = 0; // set up overflow signal later if needed

endmodule