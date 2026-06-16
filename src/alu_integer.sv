`timescale 1ns / 1ps
module alu_integer (
    input logic [63:0] IN_A, IN_B,

    input logic [1:0] SELECT, // select signal for operation

    output logic [63:0] OUTPUT,
    
    output logic ZERO, // zero signal
    output logic OVERFLOW // overflow signal
);

    always_comb begin
        OUTPUT = '0;

        case (SELECT)
            2'b00: // add
                OUTPUT = IN_A + IN_B;
            2'b01: // subtract
                OUTPUT = IN_A - IN_B;
            2'b10: // and
                OUTPUT = IN_A & IN_B;
            2'b11: // or
                OUTPUT = IN_A | IN_B;
        endcase 
    end

    assign ZERO = (OUTPUT == '0);

    assign OVERFLOW = 0; // set up overflow signal later if needed

endmodule