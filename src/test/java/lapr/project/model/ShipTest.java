package lapr.project.model;

import lapr.project.mappers.dtos.ShipPairDTO;
import lapr.project.model.Ship;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ShipTest {

    @Test
    public void CompareTo_Test() {
        // Arrange
        Ship ship= new Ship(1, 211331639, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        Ship shipWithBiggerMMSI = new Ship(1, 211331640, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        Ship shipWithSmallerMMSI = new Ship(1, 211331410, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        Ship shipWithSameMMSI = new Ship(1, 211331639, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        Ship validShip = new Ship(1, 211331640, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        //Act & Assert
        //ThrowException
        assertThrowsExactly(NullPointerException.class, () -> ship.compareTo(null));
        //Shouldn't ThrowException
        assertDoesNotThrow(() -> ship.compareTo(validShip));
        //Bigger
        assertEquals(-1, ship.compareTo(shipWithBiggerMMSI));
        //Smaller
        assertEquals(1, ship.compareTo(shipWithSmallerMMSI));
        //Same
        assertEquals(0, ship.compareTo(shipWithSameMMSI));
    }

    @Test
    public void Equals_Test(){
        // Arrange
        Ship ship= new Ship(1, 211331639, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        Ship nullShip = null;

        Ship diffMMSIShip= new Ship(1, 211333459, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        Ship MMSIDiffRest = new Ship(1, 211333459, "DBBN", "SHIPNOME", 9156305,
                new ShipCharacteristics(2, 30, "20", 224, 22, 99, 19.6f), null);

        Ship equalShip = new Ship(1, 211331639, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);

        ShipPairDTO shipPairDTO = new ShipPairDTO(211331639, 1, 93.3f, 93.3f,93.3f);
        // Act & Assert
        assertEquals(false, ship.equals(nullShip));
        assertEquals(false, ship.equals(null));
            //Different
        assertEquals(false, ship.equals(diffMMSIShip));
        assertEquals(false, ship.equals(MMSIDiffRest));
        assertEquals(false, ship.equals(shipPairDTO));
            //Equal
        assertEquals(true, ship.equals(equalShip));
    }

    @Test
    public void HashCode_Test(){
        // Arrange
        Ship ship= new Ship(1, 211331639, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);
        Ship difShip= new Ship(1, 211333459, "DH1N", "SHIQNAME", 9195305,
                new ShipCharacteristics(0, 0, "70", 234, 32, 79, 13.6f), null);
        Ship equalShip = new Ship(1, 211331639, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), null);
        // Act & Assert

        //DifferentHashCode
        assertFalse(ship.hashCode() == difShip.hashCode());
        //EqualHashCode
        assertTrue(ship.hashCode() == equalShip.hashCode());
        //Different Class HashCode
        assertFalse(ship.equals(new Integer(5)));
    }
}
