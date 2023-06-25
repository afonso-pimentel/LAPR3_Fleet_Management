/*
 * main.c
 * 
 * Copyright 2021 Unknown <guest@antix-dev>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */

#include <stdio.h>
#include "slot_status.h"
#include "check_position.h"
#include "total_occupied_array.h"
#include "fill_matrix.h"

#define X 3
#define Y 3
#define Z 3
#define A 2
#define B 3
#define C 3

int positions[A][B][C] = {
	{{0, 0, 0}, {0, 0, 2}, {0, 1, 0}},
	{{0, 1, 2}, {2, 1, 0}, {2, 2, 2}}};

int matrix[X][Y][Z] = {0};

char filePath[20] = "S.csv";

int main(void)
{

	//load file into matrix
	int res = loadFileIntoMatrix(filePath, &matrix[0][0][0], X, Y, Z);

	//print matrix if successfull
	if (res != 1) printMatrix(&matrix[0][0][0], X, Y, Z);

	int *ptr1 = &matrix[0][0][0];

	long result = slot_status(ptr1, 27);
	printf("%lx \n", result);
	if (result == 0xc0f) printf("US314 : TEST PASSED\n");

	char check = check_position(ptr1, 2, 2, 2);
	printf("%d \n", check);
	if (check == 0x1) printf("US315 : TEST PASSED\n");

	int *pos = &positions[0][0][0];
	int total = total_occupied_array(ptr1, pos, 6);
	printf("%d \n", total);
	if (total == 0x6) printf("US316 : TEST PASSED\n");
}