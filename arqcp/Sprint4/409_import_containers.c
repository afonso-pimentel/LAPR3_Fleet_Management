#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include "409_import_containers.h"

int validation(int linesMax, int lineNum, int columnNum, int id, unsigned int x, unsigned int y, unsigned int z, float length, float width, float height, float extThickness, float isoThickness, float intThickness, float extThermalCoefi, float isoThermalCoefi, float intThermalCoefi, int temperature);

Container *loadFileIntoContainerArray(char *filePath, int *size)
{

    int lineNum = 1;    // line counter
    char strLine[800];  // line buffer
    int linesMax = 500; // max amount of lines
    int lowest = 0;     // lowest value of z

    // Variables used to hold and validate columns of each line (Container Struct)
    long id;
    float length, width, height, extThickness, isoThickness, intThickness, extThermalCoefi, isoThermalCoefi, intThermalCoefi;
    unsigned int x, y, z;
    int temperature;

    // Open file with read-only permission
    FILE *pToFile = fopen(filePath, "r");

    // Exit if file is empty or not suported
    if (pToFile == NULL)
    {
        printf("File not supported.\n");
        return NULL;
    }

    // Loop through lines of file
    while (fgets(strLine, linesMax, pToFile))
    {
        // Ignore header line
        if (lineNum > 1)
        {
            // Scan current line by columns
            int columnNum = sscanf(strLine, "%ld, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f, %d", &id, &x, &y, &z, &length, &width, &height, &extThickness, &isoThickness, &intThickness, &extThermalCoefi, &isoThermalCoefi, &intThermalCoefi, &temperature);


            // Validates current line and data
            int isValid = validation(linesMax, lineNum, columnNum, id, x, y, z, length, width, height, extThickness, isoThickness, intThickness, extThermalCoefi, isoThermalCoefi, intThermalCoefi, temperature);

            // Exit if not valid
            if (!isValid == 0)
            {
                fclose(pToFile);
                return NULL;
            }

            // Set lowest (used to converte negative coordinates)
            if (lowest > z)
                lowest = z;

            // Increment the size of struct array
            (*size)++;
        }
        lineNum++;
    }

    // Set lowest to positive and reset FILE pointer and line number
    lowest = abs(lowest);
    rewind(pToFile);
    lineNum = 1;

    // Allocate memory now that the array size is known
    Container *contArray = malloc((*size + 1) * sizeof(Container));

    int i = 0; // will be used to get correct index of struct

    // Loop through lines of file
    while (fgets(strLine, linesMax, pToFile))
    {

        // Ignore header line
        if (lineNum > 1)
        {
            // Scan current line by columns to separate variables
            sscanf(strLine, "%ld, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f, %d", &id, &x, &y, &z, &length, &width, &height, &extThickness, &isoThickness, &intThickness, &extThermalCoefi, &isoThermalCoefi, &intThermalCoefi, &temperature);


            // Convert z to positive number taking in account the lowest z
            z = z + lowest;


            Container cont; // Temporary Container struct

            // Bootstrap line to Container Structure
            cont.id = id;
            cont.length = length;
            cont.width = width;
            cont.height = height;
            cont.extThickness = extThickness;
            cont.isoThickness = isoThickness;
            cont.intThickness = intThickness;
            cont.extThermalCoefi = extThermalCoefi;
            cont.isoThermalCoefi = isoThermalCoefi;
            cont.intThermalCoefi = intThermalCoefi;
            cont.x = (char)x;
            cont.y = (char)y;
            cont.z = (char)z;
            cont.temperature = (char)temperature;

            // Add this cont to array
            contArray[i] = cont;

            i++;
        }
        lineNum++;
    }
    // Close File that is being read
    fclose(pToFile);

    /* Free memory */
    free(contArray);

    // Print out success message and return array of structs
    printf("Successfuly read %d lines.\n", lineNum - 2);
    return contArray;
}

// Print out all structures in given array
void printContainerArray(Container contArray[], int size)
{

    for (size_t i = 0; i < size; i++)
    {
        printf("{\n");
        printf("Identification: %ld\n", contArray[i].id);
        printf("length: %.3f\n", contArray[i].length);
        printf("width: %.3f\n", contArray[i].width);
        printf("height: %.3f\n", contArray[i].height);
        printf("extThickness: %.3f\n", contArray[i].extThickness);
        printf("isoThickness: %.3f\n", contArray[i].isoThickness);
        printf("intThickness: %.3f\n", contArray[i].intThickness);
        printf("extThermalCoefi: %.3f\n", contArray[i].extThermalCoefi);
        printf("isoThermalCoefi: %.3f\n", contArray[i].isoThermalCoefi);
        printf("intThermalCoefi: %.3f\n", contArray[i].intThermalCoefi);
        printf("x: %d\n", contArray[i].x);
        printf("y: %d\n", contArray[i].y);
        printf("z: %d\n", contArray[i].z);
        printf("temperature: %d\n", (int)contArray[i].temperature);

        if (i < size - 1)
        {
            printf("},\n");
        }
        else
        {
            printf("}\n");
        }
    }
}

// Validate line of data from file
int validation(int linesMax, int lineNum, int columnNum, int id, unsigned int x, unsigned int y, unsigned int z, float length, float width, float height, float extThickness, float isoThickness, float intThickness, float extThermalCoefi, float isoThermalCoefi, float intThermalCoefi, int temperature)
{
    if (lineNum > linesMax)
    {
        printf("Error: Line %d, exceeding number of Lines - Expects a maximum of %d container identifications.\n", lineNum, linesMax);
        return 1;
    }
    if (columnNum > 14)
    {
        printf("Error: Line %d, exceeding number of columns - Expects precisely 4 columns.\n", lineNum);
        return 1;
    }
    if (id < 0 || id > 99999999999)
    {
        printf("Error: Line %d, column 0 (identification) - Expected range => [0-999999], actual => %d\n", lineNum, id);
        return 1;
    }
    if (id < 0)
    {
        printf("Error: Line %d, column 0 (identification) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if (x < 0)
    {
        printf("Error: Line %d, column 1 (x) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if (y < 0)
    {
        printf("Error: Line %d, column 1 (y) - Negative number not allowed.\n", lineNum);
        return 1;
    }

    if ((int)length < 0)
    {
        printf("Error: Line %d, column 1 (length) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if ((int)width < 0)
    {
        printf("Error: Line %d, column 1 (width) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if ((int)height < 0)
    {
        printf("Error: Line %d, column 1 (height) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if ((int)extThickness < 0)
    {
        printf("Error: Line %d, column 1 (extThickness) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if ((int)isoThickness < 0)
    {
        printf("Error: Line %d, column 1 (isoThickness) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if ((int)intThickness < 0)
    {
        printf("Error: Line %d, column 1 (intThickness) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if ((int)extThermalCoefi < 0)
    {
        printf("Error: Line %d, column 1 (extThermalCoefi) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if ((int)isoThermalCoefi < 0)
    {
        printf("Error: Line %d, column 1 (isoThermalCoefi) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if ((int)intThermalCoefi < 0)
    {
        printf("Error: Line %d, column 1 (intThermalCoefi) - Negative number not allowed.\n", lineNum);
        return 1;
    }

    if (temperature != 7 && temperature != 0 && temperature != -5)
    {
        printf("Error: Line %d, column 1 (temperature) - Only values of 7, 0 and -5 are allowed.\n", lineNum);
        return 1;
    }

    return 0;
}
