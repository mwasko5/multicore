`timescale 1ns / 1ps

module controller (
  input logic CLK,
  input logic [31:0] INSTRUCTION,
  
  output logic REG_WRITE,
  output logic [1:0] ALU_OP,
  output logic MEM_WRITE,
  output logic MEM_READ
);
  
  logic [31:0] instruction_stage1_s;
  logic [31:0] instruction_stage2_s;
  logic [31:0] instruction_s; // stabilized instruction signal

  always_ff @(posedge CLK) begin
      instruction_stage1_s <= INSTRUCTION;
      instruction_stage2_s <= instruction_stage1_s;
  end
  
  assign instruction_s = instruction_stage2_s;

  // Assembly syntax: add rd, rs1, rs2 -> rd = rs1 + rs2
  // Fields: 
  // 31:25 = funct7
  // 24:20 = rs2
  // 19:15 = rs1
  // 14:12 = funct3
  // 11:7  = rd
  // 6:0   = opcode
 
  always_comb begin
      // CRITICAL FIX 1: Provide safe, default values to prevent latch creation
      REG_WRITE = 1'b0;
      ALU_OP    = 2'b00;
      MEM_WRITE = 1'b0;
      MEM_READ  = 1'b0;

      // Decode logic (Using blocking assignments '=' for combinational logic)
      if (instruction_s[31:25] == 7'b0000000 && instruction_s[14:12] == 3'b000 && instruction_s[6:0] == 7'b0110011) begin 
          // ADD ($add rd, rs1, rs2)
          REG_WRITE = 1'b1;
          ALU_OP    = 2'b00;
      end
      else if (instruction_s[31:25] == 7'b0100000 && instruction_s[14:12] == 3'b000 && instruction_s[6:0] == 7'b0110011) begin 
          // SUB ($sub rd, rs1, rs2)
          REG_WRITE = 1'b1;
          ALU_OP    = 2'b01;
      end
      else if (instruction_s[6:0] == 7'b0010011) begin
          // ADDI (I-Type Opcode matched with your instruction_memory.sv test vectors)
          REG_WRITE = 1'b1;
          ALU_OP    = 2'b00; // ALU performs addition
      end
  end

endmodule