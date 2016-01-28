`define	WAIT_V	0
`define	WAIT_H	1
`define READ_CB	2
`define READ_Y0	3
`define READ_CR	4
`define	READ_Y1	5
`define	wdS		3	// log2(5+1)
`define	wdA		19

module OV7670Read
(
	input	PCLK,
	input	Reset,
	input	VSYNC,
	input	HREF,
	input	[7:0]D,
	input	[`wdA-1:0]ReadAddr,
	output	BufferData
);

	reg	[`wdS-1:0]	State,
					NextState;
	
	reg	[7:0]DataIn;
	reg	CurrentBuffer;
	wire	WriteBuffer0,
			WriteBuffer1;
	reg	[`wdA-1:0]Count;
	
	wire	ThresholdD;
	wire	BufferData0,
			BufferData1;
	
	/** VSYNC Reg **/
	reg	VSYNCReg;
	always @(posedge PCLK)
	begin
		VSYNCReg <= VSYNC;
	end
	
	/** HREF Reg **/
	reg	HREFReg;
	always @(posedge PCLK)
	begin
		HREFReg <= HREF;
	end
	
	/** Current State **/
	always @(posedge PCLK)
	begin
		if(Reset)
			State <= `WAIT_V;
		else
			State <= NextState;
	end
	
	/** Next State **/
	always @(State or VSYNC or VSYNCReg or HREF or HREFReg)
	begin
		case(State)
			`WAIT_V:
			begin
				if(!VSYNC && VSYNCReg)
					NextState <= `WAIT_H;
				else
					NextState <= State;
			end
			
			`WAIT_H:
			begin
				if(HREF && !HREFReg)
					NextState <= `READ_CB;
				else if(VSYNC)
					NextState <= `WAIT_V;
				else
					NextState <= State;
			end
			
			`READ_CB:
			begin
				NextState <= `READ_Y0;
			end
			
			`READ_Y0:
			begin
				NextState <= `READ_CR;
			end
			
			`READ_CR:
			begin
				NextState <= `READ_Y1;
			end
			
			`READ_Y1:
			begin
				if(!HREF)
					NextState <= `WAIT_H;
				else
					NextState <= `READ_CB;
			end
			
			default:
				NextState <= `WAIT_V;
		endcase
	end
	
	/** Buffer 0 **/
	OV7670RAM Buffer0(	.Clock			(PCLK),
						.WriteEnable	(WriteBuffer0),
						.WriteAddr		(Count),
						.ReadAddr		(ReadAddr),
						.DataIn			(ThresholdD),
						.DataOut		(BufferData0)
					 );
	
	/** Buffer 1 **/
	OV7670RAM Buffer1(	.Clock			(PCLK),
						.WriteEnable	(WriteBuffer1),
						.WriteAddr		(Count),
						.ReadAddr		(ReadAddr),
						.DataIn			(ThresholdD),
						.DataOut		(BufferData1)
					 );
	
	/** Read D **/
	always @(posedge PCLK)
	begin
		DataIn <= D;
	end
	
	/** Current Buffer selector **/
	always @(posedge PCLK)
	begin
		if(Reset)
			CurrentBuffer <= 0;
		else if(State == `WAIT_V && NextState == `WAIT_H)
			CurrentBuffer <= ~CurrentBuffer;
	end
	
	/** Binarization Block **/
	assign ThresholdD = (DataIn >= 128)? 1'b1 : 1'b0;
	
	/** WriteBuffer0 **/
	assign WriteBuffer0 = ((CurrentBuffer == 1'b0) && (State == `READ_Y0 || State == `READ_Y1));
	
	/** WriteBuffer1 **/
	assign WriteBuffer1 = ((CurrentBuffer == 1'b1) && (State == `READ_Y0 || State == `READ_Y1));
	
	/** Count **/
	always @(posedge PCLK)
	begin
		if(State == `READ_Y0 || State == `READ_Y1)
			Count <= Count + `wdA'b1;
		else if(State == `WAIT_V)
			Count <= 0;
	end
	
	/** Buffer Data Out selector **/
	assign BufferData = (CurrentBuffer)? BufferData0 : BufferData1;
	
endmodule 