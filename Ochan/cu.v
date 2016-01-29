module cu(
  clk,
  rst,
  RAM_full,
  finish,
  rst_storage,
  request_dataIn,
  wr_en,
  en
);

input clk;
input rst;
input RAM_full;
input finish;
output reg rst_storage;
output reg request_dataIn;
output reg wr_en;
output reg en;

reg [3:0] CurrentState;
reg [3:0] NextState;

`define IDLE          4'd0
`define FILL_RAM      4'd1
`define DATA_OUTPUT   4'd2
`define NEXT_FRAME    4'd3

initial begin
  NextState     <= `IDLE;
  CurrentState  <= `IDLE;
end

always@(posedge clk) begin
  if(rst) begin
    CurrentState <= `IDLE;
  end
  else begin
    CurrentState <= NextState;
  end
end

always@(posedge clk) begin
  if(rst) begin
    rst_storage     <= 1'd1; 
    request_dataIn  <= 1'd0;
  end
  else begin
    CurrentState <= NextState;
  end
end

always@(posedge clk) begin
  case(CurrentState)
    `IDLE : begin
      if(!rst) begin
        NextState <= `FILL_RAM;
      end
    end
    `FILL_RAM : begin
      if(RAM_full) begin
        NextState <= `DATA_OUTPUT;
      end
    end
    `DATA_OUTPUT : begin
      if(finish) begin
        NextState <= `NEXT_FRAME;
      end
    end
    `NEXT_FRAME : begin
    end
  endcase
end

always@(posedge clk) begin
  case(CurrentState)
    `IDLE : begin
      if(!rst) begin
        rst_storage <= 1'd0;
        en          <= 1'd0;
        wr_en       <= 1'd1;
        request_dataIn <= 1'd1;
      end
    end
    `FILL_RAM : begin
      if(RAM_full) begin
        en <= 1'd1;
        wr_en <= 1'd0;
        request_dataIn <= 1'd0;
      end
    end
    `DATA_OUTPUT : begin
      if(finish)
        NextState <= `NEXT_FRAME;
    end
    `NEXT_FRAME : begin
      rst_storage <= 1'd1;
      NextState   <= `IDLE;
    end
  endcase
end

endmodule