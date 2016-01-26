`define l	ImageWidth
`define wd	AddrWidth

module RAM
#(
	parameter ImageWidth = 640
)
(
	Clock,
	WriteEnable,
	DataIn,
	Addr,
	DataOut
);

	localparam AddrWidth = $clog2(ImageWidth + 1);
	
	input	Clock;
	input	WriteEnable;
	input	DataIn;
	input	[`wd-1:0]Addr;
	output reg	DataOut;

	reg	Buffer[0:`l-1];
	reg	[`wd-1:0]AddrReg;
	reg	WriteEnableReg;
	
	// Init
	initial
	begin:init
		integer i;
		for(i=0; i<`l; i=i+1)
			Buffer[i] <= 1'b0;
	end
	
	always @(posedge Clock)
	begin
		AddrReg <= Addr;
		WriteEnableReg <= WriteEnable;
		
		if(WriteEnableReg)
			Buffer[AddrReg] <= DataIn;
		
		DataOut <= Buffer[Addr];
	end
	
endmodule 