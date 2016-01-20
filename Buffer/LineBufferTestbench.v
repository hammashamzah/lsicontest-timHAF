`define l	7
`define n	3
`define wd	3

module LineBufferTestbench();

	reg	clk,
		WrEn,
		data_in;
	reg	[`wd-1:0]addr;
	
	wire	[`n-2:0]DataOut;

	/** Block Instantiation **/
	LineBuffer #(	.AddrWidth	(`wd),
					.ImageWidth	(`l),
					.WindowSize	(`n))
		Line(	.Clock			(clk),
				.WriteEnable	(WrEn),
				.Addr			(addr),
				.Data			(data_in),
				.LineData		(DataOut)
		);
	
	/** Clock generation **/
	always
		#2 clk = ~clk;
	
	/** Send inputs **/
	initial
	begin
		clk = 1;
		WrEn = 0;
		addr = 0;
		
		#5
		WrEn = 1;
		data_in = 1;
		addr = 0;
		
		#4
		WrEn = 0;
		
		#8
		WrEn = 1;
		addr = 5;
		data_in = 1;
		
		#4
		WrEn = 0;
		
		#8
		WrEn = 1;
		addr = 0;
		data_in = 0;
		
		#4
		WrEn = 0;
	end

endmodule 