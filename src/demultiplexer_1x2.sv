module demultiplexer_1x2 #(
    parameter int DATA_WIDTH = 64 // default width of 64
) (
    input logic [DATA_WIDTH - 1:0] INPUT,
    
    input logic SELECT,

    output logic [DATA_WIDTH - 1:0] OUTPUT_A, OUTPUT_B
);

    // select = 0: OUTPUT_A selected, OUTPUT_B is all zeros
    // select = 1: OUTPUT_B selected, OUTPUT_A is all zeros
    assign OUTPUT_A = SELECT ? '0 : INPUT;
    assign OUTPUT_B = SELECT ? INPUT : '0;

endmodule