/*	Timing Setup
 *	SIO_C = 400 kHz
 *	Clock = 4*400 kHz
 */

`define	IDLE	0
`define	PREPARE	1
`define PHASE1	2
`define	PHASE2	3
`define	PHASE3	4
`define	wdS		3

`define	IDAddr		8'd42
`define	NumOfProgs
`define wdP			ProgWidth

module OV7670Setup
(
	input	Clock,
	input	Reset,
	output	SIO_C,
	inout	SIO_D
	output	CamReset
);

	localparam ProgWidth = $clog2(`NumOfProgs);

	reg	ClockDiv4;
	reg	[1:0]DivCount = 0;
	
	reg	SIO_D_OE = 0;
	reg	DataOut = 0;
	
	reg	[3:0]BitCount = 0;
	reg	[`wdS-1:0]Phase = `IDLE;
	reg	[`wdP-1:0]ProgramCount = 0;
	reg	[7:0]RegAddr = 0;
	reg	[7:0]WriteData = 0;

	/** Register Reset **/
	assign CamReset = Reset;
	
	/** SIO_D Direction Controller **/
	assign SIO_D = SIO_D_OE? DataOut : 1'bZ;
	
	/** Phase **/
	always @(posedge Clock)
	begin
		if(Reset)
			
	end
	
	/** Program ROM **/
	always @(ProgramCount)
	begin
		case(ProgramCount)
			0:
			begin
				RegAddr <=
			end
		endcase
	end

endmodule 