#include <stdio.h>
#include "410_calculate_consumption.h"
#include "411_alarm_not_enough_energy.h"

unsigned char alarm_has_enough_energy(Container *ptrContainerArray, int size_of_array, char temp_ambient, float ship_energy, float *required_energy_for_all_containers){
	for (int i = 0; i < size_of_array; i++){
		float container_consumption = calculate_consumption(ptrContainerArray, size_of_array, temp_ambient, ptrContainerArray[i].x, ptrContainerArray[i].y, ptrContainerArray[i].z);
		(*required_energy_for_all_containers) += container_consumption;
	}
	if((*required_energy_for_all_containers) > ship_energy){
		return 0;
	}

	return 1;
}
