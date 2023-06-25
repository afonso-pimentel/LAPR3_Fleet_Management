package lapr.project.model;


import lapr.project.utils.utilities.Utilities;
import org.junit.jupiter.api.Test;
import java.text.ParseException;
import static org.junit.jupiter.api.Assertions.*;

public class PositionDataTest {
    //CompareTo
    @Test
    public void valid_PositionData_WithMoreRecenteDate_ShouldReturn_ExpectedCompareValue() throws ParseException {
        // Arrange
        PositionData positionDataWithRecentDate = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 07:25"),
            36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
               36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        int expected= -1;

        // Act
        int result = positionData.compareTo(positionDataWithRecentDate);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void valid_PositionData_WithOlderDate_ShouldReturn_ExpectedCompareValue() throws ParseException {
        // Arrange
        PositionData positionDataWithOlderDate = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 00:25"),
           36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        int expected= 1;

        // Act
        int result = positionData.compareTo(positionDataWithOlderDate);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void valid_PositionData_WithSameDate_ShouldReturn_ExpectedCompareValue() throws ParseException {
        // Arrange
        PositionData positionDataWithSameDate = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        int expected= 0;

        // Act
        int result = positionData.compareTo(positionDataWithSameDate);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void invalid_NullPositionData_ShouldThrow_IllegalArgumentException() throws ParseException {
        // Arrange
        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
           36.39094f, -122.71335f,      new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        // Act & Assert
        assertThrowsExactly(NullPointerException.class, () -> positionData.compareTo(null));
    }

    //Constructor
    @Test
    public void invalid_NullDateTimeReceived_OnConstructor_Should_ThrowIllegalArgumentException() throws ParseException {
        // Act & Assert
        IllegalArgumentException exception =  assertThrowsExactly(IllegalArgumentException.class, () -> new PositionData(1, null,
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        assertEquals("DateTimeReceived argument cannot be null", exception.getMessage());
    }

    @Test
    public void valid_PositionDataInitialization_ShouldNotThrowException() throws ParseException {
        // Act & Assert
        assertDoesNotThrow(() -> new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
               36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
    }

    //Equals
    @Test
    public void invalid_DifferentDate_OnEquals_ShouldReturn_False() throws ParseException {
        // Arrange
        PositionData positionData1 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionData2 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        // Act & Assert
        assertFalse(positionData1.equals(positionData2));
    }

    @Test
    public void valid_EqualDate_OnEquals_ShouldReturn_True() throws ParseException {
        // Arrange
        PositionData positionData1 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
                36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionData2 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
               36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        // Act & Assert
        assertTrue(positionData1.equals(positionData2));
    }

    @Test
    public void invalid_DifferentObject_OnEquals_ShouldReturn_False() throws ParseException {
        // Arrange
        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        // Act & Assert
        assertFalse(positionData.equals(new Integer(3)));
    }


    @Test
    public void HashCode_Tests() throws ParseException {
        // Arrange
        PositionData positionDataWithDifferentHashCode = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 07:25"),
                36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionDataWithSameHashCode = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 01:25"),
               36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 01:25"),
               36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        // Act & Assert
            //Same HashCode
        assertTrue(positionDataWithSameHashCode.hashCode() == positionData.hashCode());
            //Different HashCode
        assertFalse(positionDataWithDifferentHashCode.hashCode() == positionData.hashCode());
            //Different Class HashCode
        assertFalse(positionData.equals(new Integer(5)));
    }


}
