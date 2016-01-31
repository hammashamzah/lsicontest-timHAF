#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;


int main(int argc, char const *argv[])
{
	FILE *fp;

	fp = fopen("stage-nodes-threshold.txt", "r");
	int number_of_nodes;
	float stage_threshold;
	for(int i = 0; i< 22; i++){
		fscanf(fp, "%d %f", &number_of_nodes, &stage_threshold);
		cout << ((number_of_nodes << 16) + (int)(stage_threshold*256)) << "\n";
		//cout << number_of_nodes << " " << (stage_threshold*256) << "\n";
	}

	return 0;
}