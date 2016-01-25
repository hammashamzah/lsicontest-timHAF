`define l	ImageWidth
`define n	WindowSize
`define wd	AddrWidth

module LineBuffer
#(
	parameter ImageWidth = 7,
	parameter WindowSize = 3
)
(
	input	Clock,
	input	WriteEnable,
	input	[`wd-1:0]Addr,
	input	Data,
	output	[`n-2:0]LineData
);

	localparam AddrWidth = $clog2(ImageWidth);

	wire	[`n-2:0]ShiftData;
	
	assign ShiftData[`n-3:0] = LineData[`n-2:1];
	assign ShiftData[`n-2] = Data;

	generate
		genvar i;
		for(i=0; i<`n-1; i=i+1)
		begin:Line
			RAM #(	.ImageWidth			(ImageWidth))
				LineRAM(.Clock			(Clock),
						.WriteEnable	(WriteEnable),
						.DataIn			(ShiftData[i]),
						.Addr			(Addr),
						.DataOut		(LineData[i]));
		end
	endgenerate

endmodule 