#ifndef CONTAINER_STRUCT_H 
#define CONTAINER_STRUCT_H

// Declaration of Struct in order to use in other files by #include "ContainerStruct.h"
typedef struct {
    unsigned long id;       //8
    float length;           //4
    float width;            //4
    float height;           //4
    float extThickness;     //4
    float isoThickness;     //4
    float intThickness;     //4
    float extThermalCoefi;  //4
    float isoThermalCoefi;  //4
    float intThermalCoefi;  //4
    unsigned char x;       //1
    unsigned char y;       //1
    unsigned char z;       //1
    char temperature;              //1
                            //total 48 of 48

} Container;

#endif 
