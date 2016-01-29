`timescale 100ns / 10ns
module tb_ImageScaler;
  reg clk;
  reg en;
  reg [4:0] round_scale;
  wire  [18:0] addr_request;
  wire  [18:0] addr_scale;

  ImageScaler dut
  (
    .clk(clk),
    .en(en),
    .round_scale(round_scale),
    .addr_request(addr_request),
    .addr_scale(addr_scale)
  );

  initial begin
    clk            = 1'd1;
    en             = 1'd0;
    round_scale    = 5'd17;
    
    #1 en = 1'd1;
  end

  always #0.5 clk = !clk;
  
endmodule
