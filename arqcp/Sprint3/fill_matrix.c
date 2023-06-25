#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

int validation(int columnNum, int id, int x, int y, int z, int xMax, int yMax, int zMax, int lineNum);

int loadFileIntoMatrix(char *filePath, int *matrix, int xLen, int yLen, int zLen)
{

    //open file with read-only permission
    FILE *pToFile = fopen(filePath, "r");

    //exit if file is empty or not suported
    if (pToFile == NULL)
        return 1;

    char w;
    int lineNum = 1;
    char strLine[200];
    int linesMax = 500;
    int id, x, y, z;
    int lowest = 0;

    //loop through lines of file
    while (fgets(strLine, linesMax, pToFile))
    {
        if (lineNum > 1) //ignore header line
        {
            //scan current line by columns to separate variables: id, x, y, z, w(used to check validity of line)
            int columnNum = sscanf(strLine, "%d,%d,%d,%d,%c", &id, &x, &y, &z, &w);

            //validates current line and data
            if (validation(columnNum, id, x, y, z, xLen, yLen, zLen, lineNum) == 1)
            {
                fclose(pToFile);
                return 1;
            }

            if (lowest > z)
            {
                lowest = z;
            }
        }
        lineNum++;
    }

    //set lowest to positive and reset FILE pointer
    lowest = abs(lowest);
    rewind(pToFile);
    lineNum = 1;

    //loop through lines of file
    while (fgets(strLine, linesMax, pToFile))
    {

        if (lineNum > 1) //ignore header line
        {
            //scan current line by columns to separate variables: id, x, y, z, w(used to check validity of line)
            sscanf(strLine, "%d,%d,%d,%d,%c", &id, &x, &y, &z, &w);

            z = z + lowest;

            //places identification in 3d matrix by x,y,z positon
            *(matrix + (x * yLen * zLen) + (y * zLen) + z) = id;
            //*(matrix + (x * yLen * zLen) + (y * zLen) + z) = id;
        }
        lineNum++;
    }
    fclose(pToFile);

    printf("Successfuly read %d lines.\n", lineNum - 2);
    return 0;
}

void printMatrix(int *mat, int x, int y, int z)
{
    printf("US 313 Resulting 3d array:\n");

    int i, j, k;
    for (i = 0; i < x; i++)
    {
        printf("{");
        for (j = 0; j < y; j++)
        {
            if (j > 0) printf(" ");
            printf("{");

            for (k = 0; k < z; k++)
            {

                if (k > 0) printf(" ");
                printf("%d", *(mat + (i * y * z) + (j * z) + k));

                if (k < z - 1) printf(",");
            }
            printf("}");
            if (j < y - 1) printf(",");
        }
        printf("}");
        if (i < x - 1) printf(",");
        printf("\n");
    }
}

int validation(int columnNum, int id, int x, int y, int z, int xMax, int yMax, int zMax, int lineNum)
{
    if (lineNum > (xMax * yMax * zMax) + 1)
    {
        printf("Error: Line %d, exceeding number of Lines - Expects a maximum of %d container identifications.\n", lineNum, (xMax * yMax * zMax));
        return 1;
    }
    if (columnNum > 4)
    {
        printf("Error: Line %d, exceeding number of columns - Expects precisely 4 columns.\n", lineNum);
        return 1;
    }
    if (id < 0 || id > 999999)
    {
        printf("Error: Line %d, column 0 (identification) - Expected range => [0-999999], actual => %d\n", lineNum, id);
        return 1;
    }
    if (id < 0)
    {
        printf("Error: Line %d, column 0 (identification) - Negative number not allowed.\n", lineNum);
        return 1;
    }
    if (x < 0 || x > xMax)
    {
        printf("Error: Line %d, column 1 (x) - Expected range => [0-%d], actual => %d\n", lineNum, xMax, x);
        return 1;
    }
    if (y < 0 || y > yMax)
    {
        printf("Error: Line %d, column 1 (y) - Expected range => [0-%d], actual => %d\n", lineNum, yMax, y);
        return 1;
    }
    if (z > zMax)
    {
        printf("Error: Line %d, column 1 (z) - Expected range => [> %d], actual => %d\n", lineNum, zMax, z);
        return 1;
    }

    return 0;
}
