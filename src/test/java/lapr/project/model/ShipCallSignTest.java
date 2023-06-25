package lapr.project.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ShipCallSignTest {

    /**
     * Test to check if the comparesTo returns 0
     *
     * The callsign of ship1 is the same as ship2
     */
    @Test
    public void is_equal() {
        //Arrange
        ShipCallSign ship1 = new ShipCallSign(new Ship(0, 0, "AAA", "a", 0, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null));
        ShipCallSign ship2 = new ShipCallSign(new Ship(0, 0, "AAA", "a", 0, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null));

        //Act
        int result = ship1.compareTo(ship2);
        int expected = 0;

        //Assert
        assertEquals(result,expected);

    }

    /**
     * Test to check if the comparesTo returns 1
     *
     * The callsign of ship1 is smaller than ship2
     */
    @Test
    public void is_smaller(){
        //Arrange
        ShipCallSign ship1 = new ShipCallSign(new Ship(0, 0, "AAA", "a", 0, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null));
        ShipCallSign ship2 = new ShipCallSign(new Ship(0, 0, "BBB", "a", 0, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null));

        //Act
        int result = ship1.compareTo(ship2);
        int expected = -1;

        //Assert
        assertEquals(result,expected);
    }

    /**
     * Test to check if the comparesTo returns -1
     *
     * The callsign of ship1 is bigger than ship2
     */
    @Test
    public void is_bigger(){
        //Arrange
        ShipCallSign ship1 = new ShipCallSign(new Ship(0, 0, "BBB", "a", 0, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null));
        ShipCallSign ship2 = new ShipCallSign(new Ship(0, 0, "AAA", "a", 0, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null));

        //Act
        int result = ship1.compareTo(ship2);
        int expected = 1;

        //Assert
        assertEquals(result,expected);
    }

    @Test
    public void valid_InputArguments_ShouldNotThrowException(){
        // Act & Assert
        assertDoesNotThrow(() -> new ShipCallSign(0, 0, "AAA", "a", 0, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null));
    }
}