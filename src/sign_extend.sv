`timescale 1ns / 1ps

module sign_extend (
  input logic [15:0] IN,

  output logic [31:0] OUT
);


  always_comb begin
    OUT = 16'h0000 & IN;
  end
endmodule 