package lapr.project.services.unit;

import lapr.project.mappers.PortMapperImpl;
import lapr.project.mappers.ShipMapperImpl;
import lapr.project.services.PortServiceImpl;
import lapr.project.services.ShipServiceImpl;
import lapr.project.services.ShipServiceLogicImpl;
import lapr.project.stores.PortStoreImpl;
import lapr.project.stores.ShipStoreImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import lapr.project.utils.utilities.Utilities;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;

import static org.junit.jupiter.api.Assertions.*;

class PortServiceImplTest {


    private PortServiceImpl portServiceImpl;
    private PortMapperImpl portMapperImpl;
    private PortStoreImpl portStoreImpl;
    private ShipMapperImpl shipMapperImpl;
    private ShipServiceLogicImpl shipServiceLogicImpl;
    private ShipStoreImpl shipStoreImpl;
    private ShipServiceImpl shipServiceImpl;

    public PortServiceImplTest() throws IOException {
        this.portMapperImpl = new PortMapperImpl();
        this.portStoreImpl = new PortStoreImpl(portMapperImpl);
        this.shipMapperImpl = new ShipMapperImpl();
        this.shipServiceLogicImpl = new ShipServiceLogicImpl();
        this.shipStoreImpl = new ShipStoreImpl(shipMapperImpl, new DatabaseConnectionImpl(new ApplicationPropertiesHelperImpl()));
        this.shipServiceImpl = new ShipServiceImpl(shipStoreImpl, shipMapperImpl, shipServiceLogicImpl);
        this.portServiceImpl = new PortServiceImpl(portStoreImpl, shipServiceImpl, portMapperImpl);
    }

    /**
     * Checks if constructor throws IllegalArgument when PortStoreImpl is null
     */
    @Test
    public void invalid_NullPortStoreImpl_ShouldThrow_IllegalArgumentException(){
        // Arrange
        PortStoreImpl nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new PortServiceImpl(nullArgument, shipServiceImpl, portMapperImpl));
    }

    /**
     * Checks if constructor throws IllegalArgument when ShipServiceImpl is null
     */
    @Test
    public void invalid_NullShipServiceImpl_ShouldThrow_IllegalArgumentException(){
        // Arrange
        ShipServiceImpl nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new PortServiceImpl(portStoreImpl, nullArgument, portMapperImpl));
    }

    /**
     * Checks if constructor throws IllegalArgument when PortMapperImpl is null
     */
    @Test
    public void invalid_NullPortMapperImpl_ShouldThrow_IllegalArgumentException(){
        // Arrange
        PortMapperImpl nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new PortServiceImpl(portStoreImpl, shipServiceImpl, nullArgument));
    }

    /**
     * Checks if constructor doesn't throw exception when arguments are valid.
     */
    @Test
    public void valid_DataOnConstructor_ShouldNotThrow_Exception(){
        // Act & Assert
        assertDoesNotThrow(() ->  new PortServiceImpl(portStoreImpl, shipServiceImpl, portMapperImpl));
    }

    /**
     * Checks if getClosestPortToShipInGivenDate throws exception when callSign is null.
     */
    @Test
    public void invalid_NullCalLSign_ShouldThrow_IllegalArgumentException() throws ParseException {
        // Arrange
        String nullArgument = null;
        Timestamp timestamp = Utilities.convertFromDateStringToTimeStamp("31/12/2020 00:25");

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  this.portServiceImpl.getClosestPortToShipInGivenDate(nullArgument,timestamp));
    }

    /**
     * Checks if getClosestPortToShipInGivenDate throws exception when Timestamp is null.
     */
    @Test
    public void invalid_NullTimeStamp_ShouldThrow_IllegalArgumentException() throws ParseException {
        // Arrange
        String callSign = "5BBA4";
        Timestamp nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  this.portServiceImpl.getClosestPortToShipInGivenDate(callSign,nullArgument));
    }


}