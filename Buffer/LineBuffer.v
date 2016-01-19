`define l	ImageWidth
`define n	WindowSize
`define wd	AddrWidth

module LineBuffer
#(
	parameter AddrWidth = 3,
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

	wire	[`n-2:0]ShiftData;
	
	assign ShiftData[`n-2:1] = LineData[`n-3:0];
	assign ShiftData[0] = Data;

	generate
		genvar i;
		for(i=0; i<`n-1; i=i+1)
		begin:Line
			RAM #(	.AddrWidth			(AddrWidth),
					.ImageWidth			(ImageWidth))
				LineRAM(.Clock			(Clock),
						.WriteEnable	(WriteEnable),
						.DataIn			(ShiftData[i]),
						.Addr			(Addr),
						.DataOut		(LineData[i]));
		end
	endgenerate

endmodule 