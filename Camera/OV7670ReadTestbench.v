`define	wdA		19

`define	tp		2
`define Tline	784*`tp

module OV7670ReadTestbench();

	reg 	clk,
			rst,
			vsync,
			href;
	reg		[7:0]d;
	reg		[`wdA-1:0]readAddr;
	wire	dataout;

	OV7670Read toplevel(	.PCLK		(clk),
							.Reset		(rst),
							.VSYNC		(vsync),
							.HREF		(href),
							.D			(d),
							.ReadAddr	(readaddr),
							.BufferData	(dataout)
					   );
	
	always
		#2 clk = ~clk;
	
	initial
	begin
		clk = 1;
		rst = 1;
		vsync = 1;
		href = 0;
		d = 0;
		
		#5
		rst = 0;
		d = $random;
		
		repeat(3*`tp)
		begin
			#4
			d = $random;
		end
		
		vsync = 0;
		repeat(17*`tp)
		begin
			#4
			d = $random;
		end
		
		repeat(480)
		begin
			href = 1;
			repeat(640*`tp)
			begin
				#4
				d = $random;
			end
			
			href = 0;
			repeat(144*`tp)
			begin
				#4
				d = $random;
			end
		end
		
		repeat(10*`tp)
		begin
			#4
			d = $random;
		end
		
		vsync = 1;
	end
	
endmodule 