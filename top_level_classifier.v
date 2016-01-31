module top_level_classifier#(parameter WIDTH = 20, parameter BITSIZE = 9)
(
	input clk,
	input rst,
	input en,
	input[WIDTH*WIDTH*BITSIZE - 1:0] image,
	output face_status,
	//output[4:0] scale_status,
	output request_new_data
);
	
	wire [4:0] stage_counter; //current stage
	wire [11:0] global_counter; //number of global selector for all nodes
	wire [23:0] data_nnodes_stagethreshold;
	wire [27:0] data_nnodes_left_right;
	wire [19:0] data_rect1;
	wire [22:0] data_rect2;
	wire [22:0] data_rect3;
	wire rst_local; //reset signal from internal control unit
	wire stage_status;

	wire [8:0] ii_a_1;
	wire [8:0] ii_b_1;
	wire [8:0] ii_c_1;
	wire [8:0] ii_d_1;
	wire [8:0] ii_a_2;
	wire [8:0] ii_b_2;
	wire [8:0] ii_c_2;
	wire [8:0] ii_d_2;
	wire [8:0] ii_a_3;
	wire [8:0] ii_b_3;
	wire [8:0] ii_c_3;
	wire [8:0] ii_d_3;

	wire [8:0] address_of_a_1;
	wire [8:0] address_of_b_1;
	wire [8:0] address_of_c_1;
	wire [8:0] address_of_d_1;
	wire [8:0] address_of_a_2;
	wire [8:0] address_of_b_2;
	wire [8:0] address_of_c_2;
	wire [8:0] address_of_d_2;
	wire [8:0] address_of_a_3;
	wire [8:0] address_of_b_3;
	wire [8:0] address_of_c_3;
	wire [8:0] address_of_d_3;

	//rect1 rom
	wire[4:0] width_1;
	wire[4:0] x_1;
	wire[4:0] y_1;
	wire[4:0] height_1;

	//rect2 rom
	wire[4:0] width_2;
	wire[4:0] x_2;
	wire[4:0] y_2;
	wire[4:0] height_2;
	wire[2:0] weight_2;
	
	//rect3 rom
	wire[4:0] width_3;
	wire[4:0] x_3;
	wire[4:0] y_3;
	wire[4:0] height_3;
	wire[2:0] weight_3;

	//nnodes_threshold_stage
	wire[7:0] number_of_nodes_per_stage;
	wire[15:0] stage_threshold;

	//nodes threshold
	wire[7:0] feature_threshold;
	wire[7:0] left_value;
	wire[7:0] right_value;


	nnodes_stagethreshold_rom nnodes_stagethreshold(
		.clk(clk),
		.addr(stage_counter),
		.out(data_nnodes_stagethreshold)
		);

	nnodes_left_right_rom nnodes_left_right(
		.clk(clk),
		.addr(global_counter),
		.out(data_nnodes_left_right)
		);

	rect1_rom rect1(
		.clk(clk),
		.addr(global_counter),
		.out(data_rect1)
		);

	rect2_rom rect2(
		.clk(clk),
		.addr(global_counter),
		.out(data_rect2)		
		);

	rect3_rom rect3(
		.clk(clk),
		.addr(global_counter),
		.out(data_rect3)		
		);

	single_classifier classifier(
		.clk(clk),
		.rst(rst|rst_local),
		.en(en),
		.ii_a_1(ii_a_1),
		.ii_b_1(ii_b_1),
		.ii_c_1(ii_c_1),
		.ii_d_1(ii_d_1),
		.ii_a_2(ii_a_2),
		.ii_b_2(ii_b_2),
		.ii_c_2(ii_c_2),
		.ii_d_2(ii_d_2),
		.ii_a_3(ii_a_3),
		.ii_b_3(ii_b_3),
		.ii_c_3(ii_c_3),
		.ii_d_3(ii_d_3),

		.weight_1(3'sh7), //hard coded, because all nodes in 1st rectangle have -1 weight
		.weight_2(weight_2),
		.weight_3(weight_3),

		.right_value(right_value),
		.left_value(left_value),
		.feature_threshold({{8{feature_threshold[7]}},feature_threshold[7:0]}),

		.stage_threshold(stage_threshold),
		.stage_status(stage_status)
		);

	control_unit controlunit(
		.clk(clk),
		.rst(rst),
		.en(en),
		.number_of_nodes_per_stage(number_of_nodes_per_stage),
		.stage_status(stage_status),
		.stage_counter(stage_counter),
		.global_counter(global_counter),
		.rst_local(rst_local),
		.request_new_data(request_new_data),
		.face_status(face_status)
		);
	
	mux_400_to_1_9bit a_1(
		.address(address_of_a_1), 
		.image(image),
		.out(ii_a_1)
	);

	mux_400_to_1_9bit b_1(
		.address(address_of_b_1), 
		.image(image),
		.out(ii_b_1)
	);

	mux_400_to_1_9bit c_1(
		.address(address_of_c_1), 
		.image(image),
		.out(ii_c_1)
	);

	mux_400_to_1_9bit d_1(
		.address(address_of_d_1), 
		.image(image),
		.out(ii_d_1)
	);

	mux_400_to_1_9bit a_2(
		.address(address_of_a_2), 
		.image(image),
		.out(ii_a_2)
	);

	mux_400_to_1_9bit b_2(
		.address(address_of_b_2), 
		.image(image),
		.out(ii_b_2)
	);

	mux_400_to_1_9bit c_2(
		.address(address_of_c_2), 
		.image(image),
		.out(ii_c_2)
	);

	mux_400_to_1_9bit d_2(
		.address(address_of_d_2), 
		.image(image),
		.out(ii_d_2)
	);

	mux_400_to_1_9bit a_3(
		.address(address_of_a_3), 
		.image(image),
		.out(ii_a_3)
	);

	mux_400_to_1_9bit b_3(
		.address(address_of_b_3), 
		.image(image),
		.out(ii_b_3)
	);

	mux_400_to_1_9bit c_3(
		.address(address_of_c_3), 
		.image(image),
		.out(ii_c_3)
	);

	mux_400_to_1_9bit d_3(
		.address(address_of_d_3), 
		.image(image),
		.out(ii_d_3)
	);


	assign x_1 = data_rect1[19:15];
	assign y_1 = data_rect1[14:10];
	assign width_1 = data_rect1[9:5];
	assign height_1 = data_rect1[4:0];

	assign weight_2 = data_rect2[22:20];
	assign x_2 = data_rect2[19:15];
	assign y_2 = data_rect2[14:10];
	assign width_2 = data_rect2[9:5];
	assign height_2 = data_rect2[4:0];	

	assign weight_3 = data_rect3[22:20];
	assign x_3 = data_rect3[19:15];
	assign y_3 = data_rect3[14:10];
	assign width_3 = data_rect3[9:5];
	assign height_3 = data_rect3[4:0];

	assign number_of_nodes_per_stage = data_nnodes_stagethreshold[23:16];
	assign stage_threshold = data_nnodes_stagethreshold[15:0];

	assign feature_threshold = data_nnodes_left_right[27:16];
	assign left_value = data_nnodes_left_right[15:8];
	assign right_value = data_nnodes_left_right[7:0];

	assign address_of_a_1 = y_1*WIDTH + x_1;
	assign address_of_b_1 = address_of_a_1 + width_1;
	assign address_of_c_1 = address_of_a_1 + height_1*WIDTH;
	assign address_of_d_1 = address_of_b_1 + height_1*WIDTH;

	assign address_of_a_2 = y_2*WIDTH + x_2;
	assign address_of_b_2 = address_of_a_2 + width_2;
	assign address_of_c_2 = address_of_a_2 + height_2*WIDTH;
	assign address_of_d_2 = address_of_b_2 + height_2*WIDTH;

	assign address_of_a_3 = y_3*WIDTH + x_3;
	assign address_of_b_3 = address_of_a_3 + width_3;
	assign address_of_c_3 = address_of_a_3 + height_3*WIDTH;
	assign address_of_d_3 = address_of_b_3 + height_3*WIDTH;

endmodule