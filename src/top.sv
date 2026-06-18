`timescale 1ns / 1ps

module top (
    input logic CLK,
    input logic RST_N,
    
    output logic [63:0] ALU_OUT,
    output logic LED
);
    
  (* keep = "true" *) logic sync_rst_n_s;
  
  (* keep = "true" *) logic led_s;
  
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
  
  (* keep = "true" *) logic [31:0] pc_result_s;
  (* keep = "true" *) logic [31:0] pc_adder_out_s;

  adder #(
    .DATA_WIDTH(32)
  ) pc_adder (
    .INPUT_A(pc_result_s), 
    .INPUT_B(32'd4),

    .ADDER_OUTPUT(pc_adder_out_s)
  );

  program_counter program_counter1 (
    .CLK(CLK), // input  logic        
    .RST_N(sync_rst_n_s), // input  logic        
    .EN(1'b1), // input  logic
    
    .ADDRESS(pc_adder_out_s), // input  logic [31:0]
    
    .PC_RESULT(pc_result_s) // output logic [31:0]
  );

  logic [31:0] instruction_s;

  instruction_memory instruction_memory1 (
    .ADDRESS(pc_result_s), // input  logic [31:0] // Input Address from PC
    .INSTRUCTION(instruction_s) // output logic [31:0] // Output Instruction word
  );

  (* keep = "true" *) logic [63:0] read_data1_s;
  (* keep = "true" *) logic [63:0] read_data2_s;

  (* keep = "true" *) logic [1:0] controller_alu_select_s;
  (* keep = "true" *) logic controller_reg_write_s;
  (* keep = "true" *) logic controller_mem_read_s;
  (* keep = "true" *) logic controller_mem_write_s;
  
  controller controller1 (
    .CLK(CLK), // input logic 
    .INSTRUCTION(instruction_s), // input logic [31:0] 
  
    .REG_WRITE(controller_reg_write_s), // output logic 
    .ALU_OP(controller_alu_select_s), // output logic [1:0]
    .MEM_WRITE(controller_mem_write_s), // output logic 
    .MEM_READ(controller_mem_read_s) // output logic 
  );

  multiplexer_2x1 # (
    .DATA_WIDTH(5)
  ) write_register_mux (
    .INPUT_A(instruction_s[20:16]), // input logic [63:0] 
    .INPUT_B(instruction_s[15:11]), // input logic [63:0]
    
    .SELECT(1'b0), // input logic 

    .MUX_OUTPUT(instruction_mux_s) // output logic [63:0]
  );

  register_file register_file1(
    .CLK(CLK),

    .WRITE_DATA(data_memory_s), // input  logic [63:0] // data written to register
    .WRITE_REGISTER(instruction_mux_s), //  input  logic [4:0] // which register we are writing to
    .READ_REGISTER_1(instruction_s[25:21]), // input  logic [4:0] // which register we are reading from
    .READ_REGISTER_2(instruction_s[20:16]), // input  logic [4:0] // which register we are reading from

    .REG_WRITE(controller_reg_write_s), // input  logic // control signal for writing to register

    .READ_DATA_1(read_data1_s), // output logic [63:0] 
    .READ_DATA_2(read_data2_s) // output logic [63:0] 
  );

  (* keep = "true" *) logic [63:0] alu_out_s;
  (* keep = "true" *) logic alu_zero_s;
  (* keep = "true" *) logic alu_overflow_s;

  alu_integer alu (
    .IN_A(read_data1_s), // input logic [63:0] 
    .IN_B(read_data2_s), // input logic [63:0]

    .SELECT(controller_alu_select_s), // input logic [1:0] // select signal for operation

    .ALU_OUTPUT(ALU_OUT), // .OUTPUT(alu_out_s), // output logic [63:0]
    
    .ZERO(alu_zero_s),  // output logic // zero signal
    .OVERFLOW(alu_overflow_s) // output logic // overflow signal
  );

  (* keep = "true" *) logic [63:0] read_data_memory_s;

  data_memory data_memory1 (
    .CLK(CLK), // input logic

    .MEM_WRITE(controller_mem_write_s), // input logic 
    .MEM_READ(controller_mem_read_s), // input logic
    .ADDRESS(ALU_OUT), // input logic [63:0]
    .WRITE_DATA(read_data2_s), // input logic [63:0]

    .READ_DATA(read_data_memory_s) // output logic [63:0] 
  );

  multiplexer_2x1 data_memory_mux (
    .INPUT_A(ALU_OUT), // input logic [63:0] 
    .INPUT_B(read_data_memory_s), // input logic [63:0]
    
    .SELECT(1'b0), // input logic 

    .MUX_OUTPUT(data_memory_s) // output logic [63:0]
  );

  always_comb begin
    led_s = 1'b1;
  end
  
endmodule
