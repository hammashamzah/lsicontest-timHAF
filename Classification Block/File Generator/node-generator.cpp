#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <math.h>
#include <iomanip>

using namespace std;

float get_max(float a, float b){
	if(a > b){
		return a;
	}else{
		return b;
	}
}

float get_min(float a, float b){
	if(a < b){
		return a;
	}else{
		return b;
	}
}

int main(int argc, char const *argv[])
{
	FILE *fp;
	fp = fopen("node-threshold-left-right.txt", "r");
	float node_threshold, node_left, node_right;
	float node_threshold_max, node_threshold_min, node_left_max, node_right_max, node_left_min, node_right_min = 5;
	for(int i = 0; i< 2135; i++){
		fscanf(fp, "%f %f %f", &node_threshold, &node_left, &node_right);
		//node_threshold_max = get_max(node_threshold_max, node_threshold*256);
		//node_threshold_min = get_min(node_threshold_min, node_threshold*256);
		//node_left_max = get_max(node_left_max, node_left*256);
		//node_left_min = get_min(node_left_min, node_left*256);
		//node_right_max = get_max(node_right_max, node_right*256);
		//node_right_min = get_min(node_right_min, node_right*256);
		//cout << ((number_of_nodes << 16) + (int)(stage_threshold*256)) << "\n";
		//cout << dec << (int)(node_threshold*256) << " " << (int)(node_left*256) << " " << (int)(node_right*256) << "\n";
			
	//range of node threshold value is from 139.742 to -89.9286 after multiplied by 256, so we need in total of 25 bit, with 1 bit of sign bit 
		cout << hex << setw(8) << setfill('0') << ((int)(node_threshold*256) << 16) +  ((int)(node_left*256) << 8) + (int)(node_right*256) << "\n";
	}
	//cout << "Nilai max min node_threshold:" << node_threshold_max << " " << node_threshold_min << "\n";
	//cout << "Nilai max min node_left:" << node_left_max << " " << node_left_min << "\n";
	//cout << "Nilai max min node_right:" << node_right_max << " " << node_right_min << "\n";
	return 0;
}