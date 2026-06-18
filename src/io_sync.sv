`timescale 1ns / 1ps

module io_sync #(
  parameter int DATA_WIDTH = 1 // default to 1 bits wide I/O
)(
  input logic CLK,
  input logic RST_N,

  input logic [DATA_WIDTH - 1:0] IO_IN,
  output logic [DATA_WIDTH - 1:0] IO_OUT
);

  logic [DATA_WIDTH - 1:0] stage1_s;
  logic [DATA_WIDTH - 1:0] stage2_s;

  always_ff @(posedge CLK or negedge RST_N) begin
    if (!RST_N) begin
      stage1_s <= '0;
      stage2_s <= '0;
    end
    else begin
      stage1_s <= IO_IN;
      stage2_s <= stage1_s;
    end
  end

  always_comb begin
    IO_OUT = stage2_s;
  end
  
endmodule
