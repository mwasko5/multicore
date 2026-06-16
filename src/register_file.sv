`timescale 1ns / 1ps

module register_file (
    input  logic        CLK,

    input  logic [63:0] WRITE_DATA,      // data written to register
    input  logic [4:0]  WRITE_REGISTER,  // which register we are writing to
    input  logic [4:0]  READ_REGISTER_1, // which register we are reading from
    input  logic [4:0]  READ_REGISTER_2, // which register we are reading from

    input  logic        REG_WRITE,       // control signal for writing to register

    output logic [63:0] READ_DATA_1, 
    output logic [63:0] READ_DATA_2
);

    // register 0 is not included since it is physically hardwired to 0
    logic [63:0] register_file_s [31:1];

    // if addressing register 0, output 0
    assign READ_DATA_1 = (READ_REGISTER_1 == 5'b0) ? 64'b0 : register_file_s[READ_REGISTER_1];
    assign READ_DATA_2 = (READ_REGISTER_2 == 5'b0) ? 64'b0 : register_file_s[READ_REGISTER_2];

    // write on positive edge
    always_ff @(posedge CLK) begin
        if (REG_WRITE && (WRITE_REGISTER != 5'b0)) begin
            register_file_s[WRITE_REGISTER] <= WRITE_DATA; 
        end
    end

endmodule