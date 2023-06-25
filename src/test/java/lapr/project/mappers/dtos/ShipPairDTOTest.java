package lapr.project.mappers.dtos;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ShipPairDTOTest {

    @Test
    void compareTo_Test() {
        ShipPairDTO ship = new ShipPairDTO(123456789,10,20.1123f,12f,45.12f);
        ShipPairDTO shipSame = new ShipPairDTO(123456789,10,20.1123f,12f,45.12f);
        ShipPairDTO shipBiggerTravelDistance = new ShipPairDTO(123456789,10,30f,12f,45.12f);
        ShipPairDTO shipBiggerMMSI = new ShipPairDTO(923456789,10,20.1123f,12f,45.12f);
        ShipPairDTO shipSmallerTravelDistance = new ShipPairDTO(123456789,10,10.1123f,12f,45.12f);
        ShipPairDTO shipSmallerMMSI = new ShipPairDTO(123056789,10,20.1123f,12f,45.12f);
        ShipPairDTO nullShip = null;

        //Act & Assert
        //ThrowException
        assertThrowsExactly(IllegalArgumentException.class, () -> ship.compareTo(nullShip));
        //Shouldn't ThrowException
        assertDoesNotThrow(() -> ship.compareTo(ship));
        //Bigger
        assertEquals(1, ship.compareTo(shipBiggerTravelDistance));
        assertEquals(-1, ship.compareTo(shipBiggerMMSI));
        //Smaller
        assertEquals(-1, ship.compareTo(shipSmallerTravelDistance));
        assertEquals(1, ship.compareTo(shipSmallerMMSI));
        //Same
        assertEquals(0, ship.compareTo(shipSame));
    }


    @Test
    void Equals_Test() {
        ShipPairDTO ship = new ShipPairDTO(123456789,10,20.1123f,12f,45.12f);
        ShipPairDTO shipSame = new ShipPairDTO(123456789,10,20.1123f,12f,45.12f);
        ShipPairDTO shipDiffMMSI = new ShipPairDTO(923456789,10,20.1123f,12f,45.12f);
        ShipPairDTO nullShip = null;

        // Act & Assert
        assertEquals(false, ship.equals(nullShip));
        assertEquals(false, ship.equals(null));
        //Different
        assertEquals(false, ship.equals(shipDiffMMSI));
        assertEquals(false, ship.equals(new Integer(5)));
        //Equal
        assertEquals(true, ship.equals(shipSame));
    }

    @Test
    void testHashCode() {
        ShipPairDTO ship = new ShipPairDTO(123456789,10,20.1123f,12f,45.12f);
        ShipPairDTO shipSame = new ShipPairDTO(123456789,10,20.1123f,12f,45.12f);
        ShipPairDTO shipDiffMMSI = new ShipPairDTO(923456789,10,20.1123f,12f,45.12f);

        //DifferentHashCode
        assertFalse(ship.hashCode() == shipDiffMMSI.hashCode());
        //EqualHashCode
        assertTrue(ship.hashCode() == shipSame.hashCode());
        //Different Class HashCode
        assertFalse(ship.equals(new Integer(5)));
    }
}