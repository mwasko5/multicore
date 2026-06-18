`timescale 1ns / 1ps

module top (
    input logic CLK,
    input logic RST_N,
    
    output logic [31:0] ALU_OUT,
    output logic LED
);
    
  logic sync_rst_n_s;
  
  logic led_s;
  
  reset_sync reset_synchronizer (
    .CLK(CLK),
    .RST_N(RST_N),
    
    .SYNC_RST_N(sync_rst_n_s)
  );  
  
  io_sync led_io_synchronizer (
    .CLK(CLK),
    .RST_N(sync_rst_n_s),  
    
    .IO_IN(led_s),
    .IO_OUT(LED)
  );
  
  logic [31:0] address_s;
  logic [31:0] pc_result_s;

  program_counter program_counter1 (
    .CLK(CLK), // input  logic        
    .RST_N(sync_rst_n_s), // input  logic        
    .EN(1'b1), // input  logic
    
    .ADDRESS(address_s), // input  logic [31:0]
    
    .PC_RESULT(pc_result_s) // output logic [31:0]
  );

  logic [31:0] instruction_s;

  instruction_memory instruction_memory1 (
    .ADDRESS(pc_result_s), // input  logic [31:0] // Input Address from PC
    .INSTRUCTION(instruction_s) // output logic [31:0] // Output Instruction word
  );

  logic [63:0] read_data1_s;
  logic [63:0] read_data2_s;

  register_file register_file1(
    .CLK(CLK),

    .WRITE_DATA(data_memory_s), // input  logic [63:0] // data written to register
    .WRITE_REGISTER(instruction_mux_s), //  input  logic [4:0] // which register we are writing to
    .READ_REGISTER_1(instruction_s[25:21]), // input  logic [4:0] // which register we are reading from
    .READ_REGISTER_2(instruction_s[20:16]), // input  logic [4:0] // which register we are reading from

    .REG_WRITE(1'b0), // input  logic // control signal for writing to register

    .READ_DATA_1(read_data1_s), // output logic [63:0] 
    .READ_DATA_2(read_data2_s) // output logic [63:0] 
  );

  logic [63:0] alu_out_s;
  logic alu_zero_s;
  logic alu_overflow_s;

  alu_integer alu (
    .IN_A(read_data1_s), // input logic [63:0] 
    .IN_B(read_data2_s), // input logic [63:0]

    .SELECT(2'b00), // input logic [1:0] // select signal for operation

    .ALU_OUTPUT(ALU_OUT), // .OUTPUT(alu_out_s), // output logic [63:0]
    
    .ZERO(alu_zero_s),  // output logic // zero signal
    .OVERFLOW(alu_overflow_s) // output logic // overflow signal
  );

  always_comb begin
    led_s = 1'b1;
  end
  
endmodule
