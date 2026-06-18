`timescale 1ns / 1ps

module data_memory (
    input logic CLK,

    input logic MEM_WRITE, MEM_READ,
    input logic [63:0] ADDRESS, WRITE_DATA,

    output logic [63:0] READ_DATA
);

  logic [63:0] mem [0:1023];

  // Initialize memory (perfect for simulation or hardcoded FPGA bitstreams)
    initial begin
      // Clear everything to NOPs first
      for (int i = 0; i < 1024; i++) begin
          mem[i] = '0;
      end
  end

  always_ff @(posedge CLK) begin
    if (MEM_READ) begin
      READ_DATA <= mem[ADDRESS[11:2]];
    end
    else begin
      READ_DATA <= '0;
    end

    if (MEM_WRITE) begin
      mem[ADDRESS[11:2]] <= WRITE_DATA;
    end
  end
endmodule 