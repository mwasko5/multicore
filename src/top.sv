`timescale 1ns / 1ps

module top (
    input logic CLK,
    input logic RST_N,
    
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
  
  always_comb begin
    led_s = 1'b1;
  end
  
endmodule
