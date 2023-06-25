#ifndef US411ALARMNOTENOUGHENERGY_H
#define US411ALARMNOTENOUGHENERGY_H
#include "container_struct.h"
unsigned char alarm_has_enough_energy(Container *ptrContainerArray, int size_of_array, char temp_ambient, float ship_energy, float *required_energy_for_all_containers);
#endif
