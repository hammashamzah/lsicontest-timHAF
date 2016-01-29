module tb_BRAM(
  clk,
  rst,
  wr_en,
  data_in,
  en,
  round_scale,
  RAM_full,
  writeAddr,
  data_out,
  x,
  y,
  face_found,
  full,
  face_status,
  wr_En_buffer
);
  input clk;
  input rst;
  input wr_en;
  input data_in;
  input en;
  input [4:0] round_scale;
  output RAM_full;
  output [18:0] writeAddr;
  output data_out;
  
  wire [18:0] addr_request;
  wire [18:0] addr_scale;
  
  output [9:0] x;
  output [8:0] y;
  
  input face_found;
  output full;
  input face_status;
  output wr_En_buffer;
  
  wire finish;
  wire endScale;
  
  BRAM bram(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .data_in(data_in),
    .addr_request(addr_request),
    .addr_scale(addr_scale),
    .endScale(endScale),
    .RAM_full(RAM_full),
    .writeAddr(writeAddr),
    .data_out(data_out),
    .finish(finish)
  );
  
  ImageScaler scaler(
    .clk(clk),
    .en(en),
    .finish(finish),
    .round_scale(round_scale),
    .face_found(face_found),
    .face_status(face_status),
    .addr_request(addr_request),
    .addr_scale(addr_scale),
    .endScale(endScale),
    .x(x),
    .y(y),
    .full(full),
    .wr_En(wr_En_buffer)
  );
  
  endmodule