`define l	7
`define w	5
`define n	4

module IntegralBufferTestbench();

	localparam wd  = $clog2(`l + 1);
	localparam wdI = $clog2(`n * `n + 1);
	
	reg		clk,
			rst,
			WE;
	reg		[wd-1:0]Addr;
	reg		data;
	wire	ready;
	wire	[wdI*`n*`n-1:0]IntegralPacked;
	
	/** Block Instantiation **/
	IntegralBuffer #(	.ImageWidth		(`l),
						.ImageHeight	(`w),
						.WindowSize		(`n)
					)
		IntBuff(	.Clock			(clk),
					.Reset			(rst),
					.WriteEnable	(WE),
					.Addr			(Addr),
					.Data			(data),
					.BufferReady	(ready),
					.IntegralPacked	(IntegralPacked)
			   );
	
	/** Clock Generation **/
	always
		#2 clk = ~clk;
		
	/** Send inputs **/
	initial
	begin
		clk		= 1;
		WE		= 0;
		Addr	= 0;
		data	= 1;
		rst		= 1;
		
		#5
		rst	= 0;
		
		#4
		repeat(`w)
		begin
			Addr = 0;
			
			repeat(`l)
			begin
				WE = 1;
				#4
				WE = 0;
				#(2*4)
				Addr = Addr + 1;
			end
		end
		
		Addr = 6;
	
	end

endmodule 