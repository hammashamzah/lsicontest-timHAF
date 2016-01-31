#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;


int main(int argc, char const *argv[])
{
	FILE *fp;
	FILE *file1;
	FILE *file2;
	FILE *file3;
	fp = fopen("features.txt", "r");
	file1 = fopen("rect1.txt", "w");
	file2 = fopen("rect2.txt", "w");
	file3 = fopen("rect3.txt", "w");
	int x1,y1, length1, width1, weight1;
	int x2,y2, length2, width2, weight2;
	int x3,y3, length3, width3, weight3;
	int add_a_1,add_b_1,add_c_1,add_d_1;
	int add_a_2,add_b_2,add_c_2,add_d_2;
	int add_a_3,add_b_3,add_c_3,add_d_3;

	for(int i = 0; i< 2135; i++){
		fscanf(fp, "%d %d %d %d %d", &x1, &y1, &length1, &width1, &weight1);
		fscanf(fp, "%d %d %d %d %d", &x2, &y2, &length2, &width2, &weight2);
		fscanf(fp, "%d %d %d %d %d", &x3, &y3, &length3, &width3, &weight3);
		
		//fprintf(file1, "%d %d %d %d %d\n", weight1, x1, y1, length1, width1);
		//fprintf(file2, "%d %d %d %d %d\n", weight2, x2, y2, length2, width2);
		//fprintf(file3, "%d %d %d %d %d\n", weight3, x3, y3, length3, width3);

		fprintf(file1, "%05x\n", (x1 << 15) + (y1 << 10) + (length1 << 5) + width1); //weight is always -1
		fprintf(file2, "%06x\n", (weight2 << 20) + (x2 << 15) + (y2 << 10) + (length2 << 5) + width2);
		fprintf(file3, "%06x\n", (weight3 << 20) + (x3 << 15) + (y3 << 10) + (length3 << 5) + width3);
	}

	return 0;

}
