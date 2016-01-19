`define l	ImageWidth
`define wd	AddrWidth

module RAM
#(
	parameter AddrWidth = 10,
	parameter ImageWidth = 640
)
(
	input	Clock,
	input	WriteEnable,
	input	DataIn,
	input	[`wd-1:0]Addr,
	output reg	DataOut
);

	reg	Buffer[0:`l-1];
	
	// Init
	initial
	begin:init
		integer i;
		for(i=0; i<`l; i=i+1)
			Buffer[i] <= 1'b0;
	end
	
	always @(posedge Clock)
	begin
		if(WriteEnable)
			Buffer[Addr] <= DataIn;
		
		DataOut <= Buffer[Addr];
	end
	
endmodule 