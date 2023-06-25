package lapr.project.mappers.dtos;

import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import org.junit.jupiter.api.Test;
import java.text.ParseException;

import static org.junit.jupiter.api.Assertions.*;

class ShipDTOTest {
    @Test
    public void valid_TravelDistance_WithLessTravelDistance_ShouldReturn_ExpectedCompareValue() throws ParseException {
        // Arrange
        ShipDTO shipWithLessTravelDistance = new ShipDTO(211331639,10,500,500);

        ShipDTO ship= new ShipDTO( 211331640, 20, 1000,1100);

        int expected= -1;

        // Act
        int result = ship.compareTo(shipWithLessTravelDistance);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void valid_TravelDistance_WithMoreTravelDistance_ShouldReturn_ExpectedCompareValue() throws ParseException {
        // Arrange
        ShipDTO shipWithMoreTravelDistance = new ShipDTO(211331639,10,1000,500);

        ShipDTO ship= new ShipDTO( 211331640, 20, 750,1100);

        int expected= 1;

        // Act
        int result = ship.compareTo(shipWithMoreTravelDistance);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void valid_MoveNum_WithMoreMoves_ShouldReturn_ExpectedCompareValue() throws ParseException {
        // Arrange
        ShipDTO ship = new ShipDTO(211331639,10,750,500);

        ShipDTO shipWithMoreMoves= new ShipDTO( 211331640, 20, 750,1100);

        int expected= -1;

        // Act
        int result = ship.compareTo(shipWithMoreMoves);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void valid_MoveNum_WithLessMoves_ShouldReturn_ExpectedCompareValue() throws ParseException {
        // Arrange
        ShipDTO  ship = new ShipDTO(211331639,30,1750,1000);

        ShipDTO shipWithLessMoves= new ShipDTO( 211331640, 15, 1750,750);

        int expected= 1;

        // Act
        int result = ship.compareTo(shipWithLessMoves);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void valid_MoveNum_TravelledDistance_WithSame_ShouldReturn_ExpectedCompareValue() throws ParseException {
        // Arrange
        ShipDTO shipWithSameMoves = new ShipDTO( 211331640, 30, 1750,1200);

        ShipDTO ship= new ShipDTO(211331639,30,1750,1000);

        int expected= 0;

        // Act
        int result = ship.compareTo(shipWithSameMoves);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void invalid_NullShip_ShouldThrow_IllegalArgumentException() throws ParseException {
        // Arrange
        ShipDTO ship= new ShipDTO(211331639,30,1750,1000);

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> ship.compareTo(null));
    }

    @Test
    public void valid_Ship_ShouldNotThrowException() throws ParseException {
        // Arrange
        ShipDTO validShip = new ShipDTO( 211331640, 30, 1800,1200);

        ShipDTO ship= new ShipDTO(211331639,10,750,500);

        // Act & Assert
        assertDoesNotThrow(() -> ship.compareTo(validShip));
    }

    @Test
    public void invalid_NullEquals_ShouldReturn_False(){
        // Arrange
        ShipDTO ship= new ShipDTO(211331639,10,750,500);
        ShipDTO nullShip = null;

        // Act & Assert
        assertEquals(false, ship.equals(nullShip));
    }

    @Test
    public void invalid_DiffMMSIEquals_ShouldReturn_False(){
        // Arrange
        ShipDTO ship= new ShipDTO(211331639,10,750,500);
        ShipDTO mmsiShip = new ShipDTO(211331640,10,750,500);

        // Act & Assert
        assertEquals(false, ship.equals(mmsiShip));
    }

    @Test
    public void invalid_DifferentEquals_ShouldReturn_False(){
        // Arrange
        ShipDTO ship= new ShipDTO(211331639,10,750,500);
        ShipDTO difShip = new ShipDTO( 211331640, 30, 1800,1200);

        // Act & Assert
        assertEquals(false, ship.equals(difShip));
    }

    @Test
    public void valid_Equals_ShouldReturn_True(){
        // Arrange
        ShipDTO ship= new ShipDTO(211331639,10,750,500);
        ShipDTO equalShip = new ShipDTO(211331639,10,750,500);

        // Act & Assert
        assertEquals(true, ship.equals(equalShip));
    }

    @Test
    public void invalid_DifferentHasCode_ShouldReturn_False(){
        // Arrange
        ShipDTO ship= new ShipDTO(211331639,10,750,500);
        ShipDTO diffShip = new ShipDTO(211331659,10,750,500);
        // Act & Assert
        assertEquals(false, ship.hashCode()==diffShip.hashCode());
    }

    @Test
    public void valid_SameHasCode_ShouldReturn_True(){
        // Arrange
        ShipDTO ship= new ShipDTO(211331639,10,750,500);
        ShipDTO equalShip = new ShipDTO(211331639,10,750,500);
        // Act & Assert
        assertEquals(true, ship.hashCode()==equalShip.hashCode());
    }

    @Test
    public void invalid_DifferentClass_ShouldReturn_False(){
        // Arrange
        ShipDTO ship = new ShipDTO(211331639,10,750,500);

        // Act & Assert
        assertEquals(false, ship.equals(new Integer(5)));
    }

    @Test
    public void testShipTravelDTO(){
        ShipTravelDTO std = new ShipTravelDTO(19199191,200,30,"small");
        ShipTravelDTO stb = new ShipTravelDTO(19197191,2020,430,"big");
        Ship ship= new Ship(1, 211331639, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> std.compareTo(null));
        assertEquals(1, std.compareTo(stb));
        assertEquals(0, std.compareTo(std));
        assertEquals(-1, stb.compareTo(std));

        assertTrue(std.equals(std));
        assertFalse(std.equals(stb));
        assertFalse(std.equals(null));
        assertFalse(std.equals(ship));

        assertEquals(std.hashCode(),std.hashCode());
        assertNotEquals(std.hashCode(),ship.hashCode());

    }
}