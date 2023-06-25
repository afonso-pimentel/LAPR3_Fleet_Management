package lapr.project.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class PortTest {

    /**
     * Asserts if the equals method works
     */
    @Test
    void testIsEqual() {
        //Arrange
        Port port1 = new Port("Leixoes","Europa","Portugal",22222,10.0f,12.0f);
        Port port2 = new Port("Leixoes","Europa","Portugal",22222,10.0f,12.0f);

        //Act
        Boolean result = port1.equals(port2);

        //Assert
        assertTrue(result);
    }

    /**
     * Asserts if the equals method works
     */
    @Test
    void testIsDifferent() {
        //Arrange
        Port port1 = new Port("Leixoes","Europa","Portugal",22222,10.0f,12.0f);
        Port port2 = new Port("Los Angeles","America","United States",12345,15.0f,13.0f);

        //Act
        Boolean result = port1.equals(port2);

        //Assert
        assertFalse(result);
    }

    @Test
    public void testHashCode(){
        Port port1 = new Port("Leixoes","Europa","Portugal",22222,10.0f,12.0f);
        Port port2 = new Port("Leixoes","Europa","Portugal",22222,10.0f,12.0f);
        Port port3 = new Port("Los Angeles","America","United States",12345,15.0f,13.0f);

        //Assert
        assertEquals(port1.hashCode(),port2.hashCode());
        assertNotEquals(port1.hashCode(),port3.hashCode());
    }
}