`define wd	19	// Log2(640*480 + 1)

module OV7670RAM
(
	input		WriteClock,
	input		ReadClock,
	input		WriteEnable,
	input		[`wd-1:0]WriteAddr,
	input		[`wd-1:0]ReadAddr,
	input		DataIn,
	output reg	DataOut
);

	reg	RAM[0:307199];
	
/*	initial
	begin
		integer i,j;
		for(i=0; i<480; i=i+1)
		begin
			for(j=0; j<640; j=j+1)
				RAM[i*640+j] = 0;
		end
	end */
	
	always @(posedge WriteClock)
	begin
		if(WriteEnable)
			RAM[WriteAddr] <= DataIn;
	end
	
	always @(posedge ReadClock)
	begin
		DataOut <= RAM[ReadAddr];
	end

endmodule 