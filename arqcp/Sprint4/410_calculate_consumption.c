#include <stdio.h>
#include "410_is_container_refrigerated.h"

float calculate_consumption(Container *container_array, int size_of_array, char temp_ambient, unsigned char x, unsigned char y, unsigned char z){
   
    unsigned char is_refrigerated = is_container_refrigerated(container_array, size_of_array, x, y, z);

    if( is_refrigerated == 0 )
    {   
        return 0;
    }
    
    Container selected;

    for (int i = 0; i < size_of_array; i++)
    {
       if(container_array[i].x == x && container_array[i].y == y && container_array[i].z == z)
        {
            selected = container_array[i];
            break;
        }
    }

//Calculate total area

    //a area is width x height
    float a = selected.width * selected.height;
    //b area is length x height
    float b = selected.length * selected.height;
    //c area is length x width
    float c = selected.length * selected.width;

    //Total area is 2 x (a + b + c)
    float total_area = 2 * (a + b + c);

//Calculate Resistance

    //R exterior = extThickness / extThermalCoefi * total_area
    float r_exterior =  selected.extThickness / (selected.extThermalCoefi * total_area);

    //R isolate = isoThickness / isoThermalCoefi * total_area
    float r_isolate =  selected.isoThickness / (selected.isoThermalCoefi * total_area);

    //R interior = intThickness / intThermalCoefi * total_area
    float r_interior =  selected.intThickness / (selected.intThermalCoefi * total_area);

    //total resistance = r_exterior + r_isolate + r_interior
    float total_resistance = r_exterior + r_isolate + r_interior;


//Calculate Consumption
    float temp_dif = (float)temp_ambient - (float)selected.temperature;

    //return total consumption
    return (temp_dif / total_resistance)*3600;
    //Returns value in J, since what we want is Energy

}
