`define OFF		2'd0
`define HIGH	2'd1
`define LOW		2'd2

`define wdC		CounterWidth

module clockDIV
#(
	parameter Divider = 2
)
(
	input		reset,
	input		clock,
	output reg	newClock
);

	localparam CounterWidth = $clog2(Divider);

	reg	[`wdC-1:0]counter;
	reg	[1:0]	state,
				nextState;
	
	/** nextState handling **/
	always @(reset or state or counter)
	begin
		if(reset)
			nextState <= `OFF;
		else
		begin
			case(state)
				`OFF :		nextState <= `HIGH;
				`HIGH:		nextState <= (counter >= Divider-1)? `LOW  : state;
				`LOW :		nextState <= (counter >= Divider-1)? `HIGH : state;
				default:	nextState <= `OFF;
			endcase
		end
	end
	
	/** state handling **/
	always @(posedge clock)
	begin
		state <= nextState;
	end

	/** Counter handling **/
	always @(posedge clock)
	begin
		if(reset || (nextState != state))
			counter <= 0;
		else
		begin
			counter <= counter + 1;
		end
	end
	
	/** Output handling **/
	always @(state)
	begin
		case(state)
			`HIGH:		newClock <= 1'b1;
			`LOW:		newClock <= 1'b0;
			default:	newClock <= 1'b0;
		endcase
	end
	
endmodule 