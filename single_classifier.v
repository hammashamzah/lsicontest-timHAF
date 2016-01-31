module single_classifier
(
	input clk,
	input rst,
	input en,
	input[8:0] ii_a_1,
	input[8:0] ii_b_1,
	input[8:0] ii_c_1,
	input[8:0] ii_d_1,
	input[8:0] ii_a_2,
	input[8:0] ii_b_2,
	input[8:0] ii_c_2,
	input[8:0] ii_d_2,
	input[8:0] ii_a_3,
	input[8:0] ii_b_3,
	input[8:0] ii_c_3,
	input[8:0] ii_d_3,
	input[2:0] weight_1,
	input[2:0] weight_2,
	input[2:0] weight_3,
	input[7:0] right_value,
	input[7:0] left_value,
	input[15:0] feature_threshold,
	input[15:0] stage_threshold,
	output stage_status
);

	wire signed [11:0] feature;
	wire signed [10:0]  feature1;
	wire signed [10:0]  feature2;
	wire signed [10:0]  feature3;
	wire [7:0]  accum_inp;
	wire [15:0] stagethreshold;
	wire signed [7:0] featurethreshold;
	
	wire signed [10:0] rect1;
	wire signed [10:0] rect2;
	wire signed [10:0] rect3;
	wire signed [3:0] weight_1_a;
	
	reg signed[15:0] accum;

	always @(posedge clk or posedge rst) begin
			if (rst) begin
				accum <= 0;
			end
			else if (en) begin 
				accum <= accum + accum_inp;
			end
		end	

	assign stagethreshold = stage_threshold;
	assign featurethreshold = featurethreshold;
	assign weight_1_a = weight_1;
	assign rect1 = ((ii_a_1 + ii_d_1) - (ii_b_1 + ii_c_1)); 	
	assign rect2 = ((ii_a_2 + ii_d_2) - (ii_b_2 + ii_c_2));
	assign rect3 = ((ii_a_3 + ii_d_3) - (ii_b_3 + ii_c_3));

	assign feature1 = rect1 * 4'sb1111; 	
	assign feature2 = rect2 * weight_2;
	assign feature3 = rect2 * weight_3;

	assign feature = feature1 + feature2 + feature3;

	assign accum_inp = ($signed(feature) > $signed(feature_threshold))? right_value : left_value;
	assign stage_status = (accum > stagethreshold)? 1 : 0;
	
endmodule