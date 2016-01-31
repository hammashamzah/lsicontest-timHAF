//state
`define RESET_STATE				4'd0
`define RUN_STATE				4'd1
`define STATE_CHANGING_STATE	4'd2
`define FULL_STATE				4'd3

module control_unit(
	input clk,
	input rst,
	input en,
	input[7:0] number_of_nodes_per_stage,
	input stage_status, //output of comparison of stage
	output reg [4:0] stage_counter,
	output reg [11:0] global_counter,
	output reg rst_local,
	output reg request_new_data,
	output reg face_status
);
	
	reg [3:0] state;
	reg [3:0] next_state;

	reg [7:0] node_in_stage_counter;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state = `RESET_STATE;
		end
		else state <= next_state;
	end

	always @(state or en or stage_counter or number_of_nodes_per_stage or stage_status or stage_counter ) begin
		case (state)
			`RESET_STATE: begin
				next_state <= (en)? `RUN_STATE : state;
			end
			`RUN_STATE: begin
				next_state <= (node_in_stage_counter > number_of_nodes_per_stage) ? 
							   ((stage_counter == 5'd22)? 
							   ((stage_status)? `FULL_STATE : 
							   `STATE_CHANGING_STATE) : `STATE_CHANGING_STATE) : state;
			end
			`STATE_CHANGING_STATE: begin
				next_state <= (stage_status) ? `RUN_STATE : `RESET_STATE;
			end
			`FULL_STATE: begin
				next_state <= `RESET_STATE;
			end
			default:
				next_state <= state;
		endcase
	end

	always @(posedge clk) begin
		case(state)
			`RESET_STATE: begin
				global_counter <= 12'd1;
				node_in_stage_counter <= 8'd1;
				stage_counter <= 5'd1;
				face_status <= 1'd0;
				rst_local <= 1'd1;
				request_new_data <= 1'd1;
			end
			`RUN_STATE: begin
				global_counter <= global_counter + 12'd1;
				node_in_stage_counter <= node_in_stage_counter + 8'd1;
				request_new_data <= 1'b0;
				rst_local <= 1'd0;
				face_status <= 1'b0;
			end
			`STATE_CHANGING_STATE: begin
				node_in_stage_counter <= 8'd1;
				rst_local <= 1'b1;
				stage_counter <= stage_counter + 5'd1;
			end
			`FULL_STATE: begin
				face_status <= 1'b1;
			end
		endcase
	end
endmodule



