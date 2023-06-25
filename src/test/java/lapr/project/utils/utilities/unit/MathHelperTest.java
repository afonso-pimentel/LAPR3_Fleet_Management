package lapr.project.utils.utilities.unit;

import lapr.project.utils.utilities.MathHelper;
import lapr.project.utils.utilities.Utilities;
import org.junit.jupiter.api.Test;

import java.sql.Timestamp;

import static org.junit.jupiter.api.Assertions.*;

class MathHelperTest {

    /**
     * Tests if an IllegalArgumentException is thrown for a set of invalid coordinates
     */
    @Test
    public void invalid_Coordinates_ShouldThrow_IllegalArgumentException(){
        // Arrange
        float latitude1 = 91;
        float longitude1 = 181;
        float longitude2= 181;
        float latitude2 = 91;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  MathHelper.calculateDistanceBetweenCoordinates(latitude1,longitude1,latitude2,longitude2));
    }


    /**
     * Test if valid inputs return expected result
     */
    @Test
    public void valid_Coordinates_ShouldReturn_ExpectedValue(){
        // Arrange
        float latitude1 = 43.53f;
        float longitude1 = 110.55f;
        float longitude2= 100.10f;
        float latitude2 = 30.23f;

        //Act & Assert
        assertEquals(1743.4741f, MathHelper.calculateDistanceBetweenCoordinates(latitude1,longitude1,latitude2,longitude2));
    }

    /**
     * Test if valid inputs return expected result
     */
    @Test
    public void invalid_Latitude1_ShouldThrow_IllegalArgumentException(){
        // Arrange
        float latitude1 = 91f;
        float longitude1 = 110.55f;
        float longitude2= 100.10f;
        float latitude2 = 30.23f;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> MathHelper.calculateDistanceBetweenCoordinates(latitude1,longitude1,latitude2,longitude2));
    }

    /**
     * Test if valid inputs return expected result
     */
    @Test
    public void invalid_Latitude2_ShouldThrow_IllegalArgumentException(){
        // Arrange
        float latitude1 = 43.53f;
        float longitude1 = 110.55f;
        float longitude2= 100.10f;
        float latitude2 = 91f;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> MathHelper.calculateDistanceBetweenCoordinates(latitude1,longitude1,latitude2,longitude2));
    }

    /**
     * Test if valid inputs return expected result
     */
    @Test
    public void invalid_Longitude1_ShouldThrow_IllegalArgumentException(){
        // Arrange
        float latitude1 = 43.53f;
        float longitude1 = 181f;
        float longitude2= 100.10f;
        float latitude2 = 30.23f;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> MathHelper.calculateDistanceBetweenCoordinates(latitude1,longitude1,latitude2,longitude2));
    }

    /**
     * Test if valid inputs return expected result
     */
    @Test
    public void invalid_Longitude2_ShouldThrow_IllegalArgumentException(){
        // Arrange
        float latitude1 = 43.53f;
        float longitude1 = 100.10f;
        float longitude2= 181f;
        float latitude2 = 30.23f;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> MathHelper.calculateDistanceBetweenCoordinates(latitude1,longitude1,latitude2,longitude2));
    }

    /**
     * Test if valid inputs return expected result
     */
    @Test
    public void valid_TimeStampsArguments_ShouldThrow_ReturnExpectedResult(){
        // Arrange
        float expected = 50.0f;

        // Act
        float result = MathHelper.calculateDifferenceInMinutes(new Timestamp(1609305000000l), new Timestamp(16093062000000l));

        // Assert

        assertEquals(expected, result);
    }
}