`define row(x,w)	(w*(x)+(w-1)):(w*(x))

`define l	ImageWidth
`define n	WindowSize
`define wd	AddrWidth
`define wdI	IntegralWidth
`define wdW	WindowWidth

module IntegralBuffer
#(
	parameter ImageWidth	= 7,
	parameter WindowSize	= 3
)
(
	input	Clock,
	input	Reset,
	input	WriteEnable,
	input	[`wd-1:0]Addr,
	input	Data,
	output	BufferReady,
	output	[`wdI*`n*`n-1:0]IntegralPacked
);

	localparam AddrWidth = $clog2(ImageWidth);
	localparam IntegralWidth = $clog2(`n * `n);
	localparam WindowWidth = $clog2(`n);

	reg		[`wdW*`n-1:0]WindowBuffer	[0:2*`n-1];
	wire	[`wdW*`n-1:0]NextWindow		[0:2*`n-1];
	reg		[`wdI*`n-1:0]IntegralData	[0:  `n-1];
	
	wire	[`n-2:0]LineData;
	
	/** LineBuffer **/
	LineBuffer #(	.ImageWidth	(ImageWidth),
					.WindowSize	(WindowSize)
				)
		Line(	.Clock			(Clock),
				.WriteEnable	(WriteEnable),
				.Addr			(Addr),
				.Data			(Data),
				.LineData		(LineData)
			);

	/** WindowBuffer **/
	generate
		genvar i,j;
		
		for(i=0;i<2*`n;i=i+1)
		begin:WindowColumnIndexLoop
			for(j=0;j<`n;j=j+1)
			begin:WindowRowIndexLoop
				/** NextWindow behavior **/
				if(((2*`n-i)+(`n-j)==`n+1) && j>0)
				begin
					assign NextWindow[i][`row(j,`wdW)] = WindowBuffer[i+1][`row(j-1,`wdW)] + WindowBuffer[i+1][`row(j,`wdW)];
				end
				else if(i == 2*`n-1)
				begin
					if(j == `n-1)
						assign NextWindow[i][`row(j,`wdW)] = Data;
					else
						assign NextWindow[i][`row(j,`wdW)] = LineData[j];
				end
				else
					assign NextWindow[i][`row(j,`wdW)] = WindowBuffer[i+1][`row(j,`wdW)];
			end
			
			/** WindowBuffer register behavior **/
			always @(posedge Clock)
			begin
				if(Reset)
					WindowBuffer[i] <= 0;
				else
					WindowBuffer[i] <= NextWindow[i];
			end
		end
	endgenerate
	
	/** IntegralBuffer **/
	generate
		genvar x,y;
		for(x=0;x<`n;x=x+1)
		begin:IntegralColumnIndexLoop
			for(y=0;y<`n;y=y+1)
			begin:IntegralRowIndexLoop
				always @(posedge Clock)
				begin
					if(Reset)
						IntegralData[x][`row(y,`wdI)] <= 0;
					else
						IntegralData[x][`row(y,`wdI)] <= IntegralData[x][`row(y,`wdI)] + WindowBuffer[x+1][`row(y,`wdW)] - WindowBuffer[0][`row(y,`wdW)];
				end
			end
		end
	endgenerate
	
	/** Output **/
	generate
		for(y=0;y<`n;y=y+1)
		begin:OutputRowLoop
			for(x=0;x<`n;x=x+1)
			begin:OutputColLoop
				assign IntegralPacked[`row(`n*y+x,`wdI)] = IntegralData[x][`row(y,`wdI)];
			end
		end
	endgenerate
	
endmodule 