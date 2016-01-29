`define	wdA		19

module OV7670Hardware
(
	input	Clock,
	input	NotReset,
	input	CAM_PCLK,
	input	CAM_VSYNC,
	input	CAM_HREF,
	input	[7:0]CAM_D,
	output	VGA_HS,
	output	VGA_VS,
	output	VGA_BLANK,
	output	VGA_SYNC,
	output	[9:0]VGA_R,
	output	[9:0]VGA_G,
	output	[9:0]VGA_B,
	output	CAM_XCLK
);

	wire	DivClock,
			Data,
			Read;
	wire	[`wdA-1:0]Addr;

	wire Reset = ~NotReset;

	vga640x480 vga(	.dclk		(DivClock),
					.clr		(Reset),
					.Data		(Data),
					.hsync		(VGA_HS),
					.vsync		(VGA_VS),
					.vga_blank	(VGA_BLANK),
					.vga_sync	(VGA_SYNC),
					.red		(VGA_R),
					.green		(VGA_G),
					.blue		(VGA_B),
					.Read		(Read),
					.Addr		(Addr)
				  );
	
	OV7670Read OV7670(	.Clock		(Clock),
						.PCLK		(CAM_PCLK),
						.Reset		(Reset),
						.VSYNC		(CAM_VSYNC),
						.HREF		(CAM_HREF),
						.D			(CAM_D),
						.Read		(Read),
						.ReadAddr	(Addr),
						.XCLK		(CAM_XCLK),
						.BufferData	(Data)
					 );

	clockDIV #(	.Divider	(2)
			  )
		VGAClock(	.reset		(Reset),
					.clock		(Clock),
					.newClock	(DivClock)
				);

endmodule 