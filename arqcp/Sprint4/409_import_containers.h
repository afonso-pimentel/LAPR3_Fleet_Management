#ifndef US409IMPORTCONTAINERS_H
#define US409IMPORTCONTAINERS_H
#include "container_struct.h"

Container *loadFileIntoContainerArray(char *filePath, int *size);
void printContainerArray(Container *contArray, int size);

#endif 
