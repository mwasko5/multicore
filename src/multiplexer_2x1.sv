module multiplexer_2x1 #(
    parameter int DATA_WIDTH = 64 // default width of 64
) (
    input logic [DATA_WIDTH - 1:0] INPUT_A, INPUT_B,
    
    input logic SELECT,

    output logic [DATA_WIDTH - 1:0] OUTPUT
);

    // select = 0: INPUT_A
    // select = 1: INPUT_B
    assign OUTPUT = SELECT ? INPUT_B : INPUT_A;

endmodule