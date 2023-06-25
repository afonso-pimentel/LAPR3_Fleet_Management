package lapr.project.services.unit;

import lapr.project.mappers.ShipMapperImpl;
import lapr.project.services.ShipServiceImpl;
import lapr.project.services.ShipServiceLogic;
import lapr.project.services.ShipServiceLogicImpl;
import lapr.project.stores.ShipStoreImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import lapr.project.utils.utilities.Utilities;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import java.text.ParseException;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.io.IOException;

public class ShipServiceImplTest {
    private ShipServiceImpl shipServiceImpl;
    private ShipMapperImpl shipMapperImpl;
    private ShipServiceLogic shipServiceLogicImpl;
    private ShipStoreImpl shipStoreImpl;

    public ShipServiceImplTest() throws IOException {
        this.shipMapperImpl = new ShipMapperImpl();
        this.shipServiceLogicImpl = new ShipServiceLogicImpl();
        this.shipStoreImpl = new ShipStoreImpl(shipMapperImpl, new DatabaseConnectionImpl(new ApplicationPropertiesHelperImpl()));
        this.shipServiceImpl = new ShipServiceImpl(shipStoreImpl, shipMapperImpl, shipServiceLogicImpl);
    }

    @Test
    public void invalid_NullShipStoreOnConstructor_ShouldThrow_IllegalArgumentException(){
        // Arrange
        ShipStoreImpl nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceImpl(nullArgument, shipMapperImpl, shipServiceLogicImpl));
    }
    @Test
    public void invalid_NullMapperOnConstructor_ShouldThrow_IllegalArgumentException(){
        // Arrange
        ShipMapperImpl nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceImpl(shipStoreImpl, nullArgument, shipServiceLogicImpl));
    }

    @Test
    public void invalid_NullShipServiceLogicONConstructor_ShouldThrow_IllegalArgumentException(){
        // Arrange
        ShipServiceLogic nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceImpl(shipStoreImpl, shipMapperImpl, nullArgument));
    }

    @Test
    public void valid_ArgumentsOnConstructor_ShouldNotThrow_Exception(){
        // Act & Assert
        assertDoesNotThrow(() -> new ShipServiceImpl(shipStoreImpl, shipMapperImpl, shipServiceLogicImpl));
    }

    @Test
    public void invalid_NullArguments_ShouldThrow_Exception(){
        //Arrange
        Timestamp intDate = null;
        Timestamp endDate = null;
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  this.shipServiceImpl.getShipBetweenDateInterval(intDate,endDate));
    }

    @Test
    public void valid_NullArguments_ShouldNotThrow_Exception() throws ParseException {
        //Arrange
        Timestamp intDate = Utilities.convertFromDateStringToTimeStamp("31/12/2020 00:25");
        Timestamp endDate = new Timestamp(System.currentTimeMillis());
        // Act & Assert
        assertDoesNotThrow(() ->  this.shipServiceImpl.getShipBetweenDateInterval(intDate,endDate));
    }

    @Test
    public void invalid_GivenTimeStamps_ShouldReturn_IllegalArgument() {
        // Arrange
        int N = 5;
        Timestamp initTime = null;
        Timestamp finalTime = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipServiceImpl.getTopNShipsTravelledDistanceAndMSOG(N, initTime,finalTime));

    }

    @Test
    public void invalid_GivenNPositions_ShouldReturn_IllegalArgument() {
        // Arrange
        int N = -1;
        Timestamp initTime = null;
        Timestamp finalTime = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipServiceImpl.getTopNShipsTravelledDistanceAndMSOG(N, initTime,finalTime));
        assertThrows(IllegalArgumentException.class, () -> shipServiceImpl.getTopNShipsTravelledDistanceAndMSOG(1, initTime,finalTime));
        assertThrows(IllegalArgumentException.class, () -> shipServiceImpl.getTopNShipsTravelledDistanceAndMSOG(1, new Timestamp(System.currentTimeMillis()),finalTime));
    }

    @Test
    public void invalids_GetPositionDataForGivenTime(){
        //Arrange
        String callSignN = null;
        String callSignA = "!asd";

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  shipServiceImpl.getPositionDataForGivenTime(callSignN,new Timestamp(System.currentTimeMillis())));
        assertThrows(IllegalArgumentException.class, () ->  shipServiceImpl.getPositionDataForGivenTime(callSignA,new Timestamp(System.currentTimeMillis())));
    }
}
