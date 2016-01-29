module BRAM(
  clk,
  rst,
  wr_en,
  data_in,
  addr_request,
  addr_scale,
  endScale,
  data_out,
  RAM_full,
  writeAddr,
  finish
);
  input clk;
  input rst;
  input wr_en;
  input data_in;
  input [18:0] addr_request;
  input [18:0] addr_scale;
  input endScale;
  output data_out;
  output RAM_full;
  output finish;
  
  wire buffer_full; 
  reg RAM   [0:307199];
  reg image [0:307199];
  reg data_out;
  reg data_out_reg;
  reg	temp;
  reg [4:0] addr_endScale;
  
  wire [18:0] addr;
  output reg [18:0] writeAddr;
  
  assign RAM_full = (writeAddr == 307200);
  assign addr = wr_en? writeAddr : addr_scale;
  assign finish = (addr_endScale==5'd20);
	
	/** RAM **/
	always @(posedge clk)
	begin		
		if(wr_en)
			RAM[addr] <= data_in;
	end
  
  /** writeAddr counter **/
	always@(posedge clk) begin
		if(rst) begin
			writeAddr <= 0;
		end
		else if( !RAM_full && wr_en )    
			writeAddr <= writeAddr + 18'd1;
	end
 
  /** write output **/
  always @(posedge clk) begin
    if(rst) begin
		addr_endScale <=0;
	end
    else if(!wr_en) begin
	  if(endScale && !finish) begin
		addr_endScale <= addr_endScale+5'd1;
	  end
    end
  end
  
  always @(posedge clk) begin
	data_out_reg <= RAM[addr_scale];
  end
  
  always @(data_out_reg or endScale or finish) begin
	if(endScale && !finish)
		data_out <= 0;
	else
		data_out <= data_out_reg;
  end
  /*
  always @(posedge clk) begin
    if(endScale && !finish) begin
      addr_endScale <= addr_endScale+5'd1;
      data_out <= 0;
    end
  end
	*/
 
endmodule