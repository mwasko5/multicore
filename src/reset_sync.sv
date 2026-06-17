`timescale 1ns / 1ps

module reset_sync (
  input logic CLK,
  input logic RST_N,

  output logic SYNC_RST_N
);

  (* keep = 1 *) logic reset_sync1_s; 
  (* keep = 1 *) logic reset_sync2_s;

  always_ff @(posedge CLK or negedge RST_N) begin
    if (!RST_N) begin
      reset_sync1_s <= 1'b0;
      reset_sync2_s <= 1'b0;
    end
    else begin
      reset_sync1_s <= 1'b1;
      reset_sync2_s <= reset_sync1_s;
    end   

    assign SYNC_RST_N = reset_sync2;
    
  end
  
endmodule
