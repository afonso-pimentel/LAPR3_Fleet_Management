#include <stdio.h>
#include "409_import_containers.h"
#include "410_calculate_consumption.h"
#include "411_alarm_not_enough_energy.h"
#include <stdlib.h>

float ship_total_energy = 100000;
float ambient_temperature = 20;
char * fileName = "409_containers.csv";

int main()
{

	// US 409 -  fill a dynamically reserved matrix array in memory with all the container's information

	printf("|US409|\n");

	int size = 0;

	Container *contArray = loadFileIntoContainerArray(fileName, &size);

	printf("PRINT IMPORTED ARRAY FROM CSV FILE:\n");

	printContainerArray(contArray, size);

	//-------------------------------------------------------------------
 
	// US410 - Identify if a container is refrigerated or not and calculate it's consumption //
	printf("\n");
	printf("|US410|\n");

	printf("\n");
	printf("Calculate consumption for container that DOES NOT need to be refrigerated: \n");

	float consumption = calculate_consumption(contArray, size, ambient_temperature, 3,4,1);

	printf("Consumption: %f\n", consumption);

	printf("________________\n");

	printf("Calculate consumption for container that NEEDS to be refrigerated:\n");

	consumption = calculate_consumption(contArray,size, ambient_temperature,1,1,1);

	printf("Consumption: %f\n", consumption);

	printf("______________\n");

	// US411 - Create an alert whenever the ship does not have enough energy to refrigerate all refrigerated containers //
	float total_required_energy = 0;

	unsigned char is_energy_enough = alarm_has_enough_energy(contArray, size, ambient_temperature,ship_total_energy, &total_required_energy);

	printf("\n");
	printf("|US411|\n");

	printf("Does the ship have enough energy for all refrigerated containers? - %s\n", is_energy_enough ? "True": "False");
	printf("Required energy for all containers: %f\n", total_required_energy);
	printf("Ship total energy power:%f\n", ship_total_energy);

	return 0;
}
