package lapr.project.ui.unit;

import lapr.project.stores.ShipStoreImpl;
import lapr.project.ui.ShipSearch;
import org.junit.jupiter.api.Test;

import static java.lang.Integer.MAX_VALUE;
import static org.junit.jupiter.api.Assertions.*;


/**
 * @author Group 169 LAPRIII
 *
 */
public class ShipSearchTest {
    private final ShipSearch shipSearch;

    /**
     * Constructor for the ShipSearchTest object
     */
    public ShipSearchTest() {
        shipSearch = new ShipSearch();
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a MMSI value under 9 digits.
     */
    @Test
    public void InvalidMMSI_Under(){
        //Arrange
        int mmsi = -1;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipSearch.shipSearchByMMSI(mmsi));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for an IMO value under 7 digits.
     */
    @Test
    public void InvalidIMO_Under(){
        //Arrange
        int imo = -1;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipSearch.shipSearchByIMO(imo));    }

    /**
     * Tests if an IllegalArgumentException is thrown for a MMSI value over 9 digits.
     */
    @Test
    public void InvalidMMSI_Over(){
        //Arrange
        int mmsi = MAX_VALUE;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipSearch.shipSearchByMMSI(mmsi));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for an IMO value over 7 digits.
     */
    @Test
    public void InvalidIMO_Over(){
        //Arrange
        int imo = MAX_VALUE;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipSearch.shipSearchByIMO(imo));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null CallSign.
     */
    @Test
    public void InvalidCallSign_isNull(){
        //Arrange
        String callsign = null;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipSearch.shipSearchByCallSign(callsign));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for non-alphanumeric CallSign.
     */
    @Test
    public void InvalidCallSign_isNotAlphanumeric(){
        //Arrange
        String callsign = "*'$%";

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipSearch.shipSearchByCallSign(callsign));
    }

}