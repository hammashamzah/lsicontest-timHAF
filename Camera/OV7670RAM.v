`define wd	19	// Log2(640*480 + 1)

module OV7670RAM
(
	input		Clock,
	input		WriteEnable,
	input		[`wd-1:0]WriteAddr,
	input		[`wd-1:0]ReadAddr,
	input		DataIn,
	output reg	DataOut
);

	reg	RAM[0:307199];
	
/*	initial
	begin
		integer i;
		for(i=0; i<307200; i=i+1)
			RAM[i] <= 0;
	end */
	
	always @(posedge Clock)
	begin
		if(WriteEnable)
			RAM[WriteAddr] <= DataIn;
		
		DataOut <= RAM[ReadAddr];
	end

endmodule 