module adder #(
    parameter int DATA_WIDTH = 64 // default width of 64
) (
    input logic [DATA_WIDTH - 1:0] INPUT_A, INPUT_B,

    output logic [DATA_WIDTH - 1:0] ADDER_OUTPUT
);

    assign ADDER_OUTPUT = INPUT_A + INPUT_B;

endmodule