package lapr.project.mappers;

import lapr.project.mappers.dtos.ContainerSituationDTO;
import lapr.project.mappers.dtos.ContainerToLoadOnPortDTO;
import lapr.project.mappers.dtos.ContainerWithNextPortDTO;
import lapr.project.model.enums.ContainerTempType;
import lapr.project.model.enums.LocationType;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * @author Group 169 LAPRIII
 */
public class ContainerMapperImplTest {
    private final ContainerMapper containerMapperImpl;

    public ContainerMapperImplTest(){
        containerMapperImpl = new ContainerMapperImpl();
    }

    /**
     * Tests if an IllegalArgumentException is thrown when a null cargo site type argument is specified
     */
    @Test
    public void illegal_NullCargoSiteType_Should_Throw_IllegalArgumentException(){
        // Arrange
        String cargoSiteName = "Leixões";
        String cargoSiteType = null;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerSituationDTO(cargoSiteName, cargoSiteType));
    }

    /**
     * Tests if an IllegalArgumentException is thrown when an unsupported cargo type argument is specified
     */
    @Test
    public void illegal_UnsupportedCargoSiteType_Should_Throw_IllegalArgumentException(){
        // Arrange
        String cargoSiteName = "Leixões";
        String cargoSiteType = "InvalidCargoSiteType";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerSituationDTO(cargoSiteName, cargoSiteType));
    }

    /**
     * Tests if an expected object is returned with valid port input type specified
     */
    @Test
    public void valid_InputArgumentsWithPortType_Should_Return_ExpectedObject(){
        // Arrange
        String cargoSiteName = "Leixões";
        String cargoSiteType = "Port";

        ContainerSituationDTO expected = new ContainerSituationDTO(cargoSiteName, LocationType.PORT);

        // Act
        ContainerSituationDTO result = containerMapperImpl.mapToContainerSituationDTO(cargoSiteName, cargoSiteType);

        // Arrange
        assertNotNull(result);
        assertEquals(expected.getLocationName(), result.getLocationName());
        assertEquals(expected.getLocationType(), result.getLocationType());
    }

    /**
     * Tests if an expected object is returned with valid warehouse input type specified
     */
    @Test
    public void valid_InputArgumentsWithWarehouseType_Should_Return_ExpectedObject(){
        // Arrange
        String cargoSiteName = "Leixões";
        String cargoSiteType = "Warehouse";

        ContainerSituationDTO expected = new ContainerSituationDTO(cargoSiteName, LocationType.WAREHOUSE);

        // Act

        ContainerSituationDTO result = containerMapperImpl.mapToContainerSituationDTO(cargoSiteName, cargoSiteType);

        assertNotNull(result);
        assertEquals(expected.getLocationName(), result.getLocationName());
        assertEquals(expected.getLocationType(), result.getLocationType());
    }

    /**
     * Tests if an expected object is returned with valid warehouse input type specified
     */
    @Test
    public void valid_InputArgumentsWithTruckType_Should_Return_ExpectedObject(){
        // Arrange
        String cargoSiteName = "Leixões";
        String cargoSiteType = "Truck";

        ContainerSituationDTO expected = new ContainerSituationDTO(cargoSiteName, LocationType.TRUCK);

        // Act

        ContainerSituationDTO result = containerMapperImpl.mapToContainerSituationDTO(cargoSiteName, cargoSiteType);

        assertNotNull(result);
        assertEquals(expected.getLocationName(), result.getLocationName());
        assertEquals(expected.getLocationType(), result.getLocationType());
    }

    /**
     * Tests if an expected object is returned with valid warehouse input type specified
     */
    @Test
    public void valid_InputArgumentsWithShipType_Should_Return_ExpectedObject(){
        // Arrange
        String cargoSiteName = "Leixões";
        String cargoSiteType = "Ship";

        ContainerSituationDTO expected = new ContainerSituationDTO(cargoSiteName, LocationType.SHIP);

        // Act

        ContainerSituationDTO result = containerMapperImpl.mapToContainerSituationDTO(cargoSiteName, cargoSiteType);

        assertNotNull(result);
        assertEquals(expected.getLocationName(), result.getLocationName());
        assertEquals(expected.getLocationType(), result.getLocationType());
    }

    //FOR US205
    @Test
    public void invalid_ContainerID_Should_Throw_IllegalArgument() {
        // Arrange
        String containerId = null;
        int containerLoad = 10;
        int containerType = 7;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () -> containerMapperImpl.mapToContainerWithNextPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteType, cargoSiteName));
    }

        /**
         * Tests if IllegalArgumentException is thrown with illegal ContainerLoad argument.
         */
    @Test
    public void invalid_ContainerLoad_Should_Throw_IllegalArgument(){
        // Arrange
        String containerId = "10";
        int containerLoad = -10;
        int containerType = 7;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerWithNextPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteType, cargoSiteName));
    }
    /**
     * Tests if IllegalArgumentException is thrown with illegal ContainerType argument.
     */
    @Test
    public void invalid_ContainerType_Should_Throw_IllegalArgument(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 0;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerWithNextPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteType, cargoSiteName));
    }
    /**
     * Tests if IllegalArgumentException is thrown with illegal containerPosition argument.
     */
    @Test
    public void invalid_ContainerPosition_Should_Throw_IllegalArgument(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String containerPosition = null;
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerWithNextPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteType, cargoSiteName));
    }
    /**
     * Tests if IllegalArgumentException is thrown with null CargoSiteType argument.
     */
    @Test
    public void null_CargoSiteType_Should_Throw_IllegalArgument(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = null;
        String cargoSiteName = "Leixões";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerWithNextPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteType, cargoSiteName));
    }
    /**
     * Tests if ValueException is thrown with illegal CargoSiteType argument.
     */
    @Test
    public void invalid_CargoSiteType_Should_Throw_IllegalArgument(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = "aaaaa";
        String cargoSiteName = "Leixões";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerWithNextPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteType, cargoSiteName));
    }

    @Test
    public void invalid_CargoSiteName_Should_Throw_IllegalArgument(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = "Port";
        String cargoSiteName = null;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerWithNextPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteType, cargoSiteName));
    }

    /**
     * Tests if an expected object is returned with valid port input type specified
     */
    @Test
    public void valid_InputArguments_Should_Return_ExpectedObject(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";

        ContainerWithNextPortDTO expected = new ContainerWithNextPortDTO(containerId,containerLoad, ContainerTempType.MAX_TEMP_7_DEGREES,containerPosition,LocationType.PORT,cargoSiteName);
        // Act
        ContainerWithNextPortDTO result = containerMapperImpl.mapToContainerWithNextPortDTO(containerId,containerLoad,containerType,containerPosition,cargoSiteType,cargoSiteName);

        // Arrange
        assertNotNull(result);
        assertEquals(expected.getIdContainer(), result.getIdContainer());
        assertEquals(expected.getPayload(), result.getPayload());
        assertEquals(expected.getType(), result.getType());
        assertEquals(expected.getXyzPosition(), result.getXyzPosition());
        assertEquals(expected.getCargoSiteType(), result.getCargoSiteType());
        assertEquals(expected.getCargoSiteName(), result.getCargoSiteName());
    }

    //FOR US206

    /**
     * Tests if IllegalArgumentException is thrown with illegal ContainerLoad argument.
     */
    @Test
    public void invalid_ContainerLoad_Should_Throw_IllegalArgumentContainerToLoad(){
        // Arrange
        String containerId = "10";
        int containerLoad = -10;
        int containerType = 7;
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";
        String country = "Portugal";


        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerToLoadOnPortDTO(containerId, containerLoad, containerType, cargoSiteType, cargoSiteName, country));
    }
    /**
     * Tests if IllegalArgumentException is thrown with illegal ContainerType argument.
     */
    @Test
    public void invalid_ContainerType_Should_Throw_IllegalArgumentContainerToLoad(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 0;
        String cargoSiteType = null;
        String cargoSiteName = "Leixões";
        String country = "Portugal";


        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerToLoadOnPortDTO(containerId, containerLoad, containerType, cargoSiteType, cargoSiteName, country));
    }
    /**
     * Tests if IllegalArgumentException is thrown with illegal containerPosition argument.
     */
    @Test
    public void invalid_ContainerCountry_Should_Throw_IllegalArgumentContainerToLoad(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";
        String country = null;


        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerToLoadOnPortDTO(containerId, containerLoad, containerType, cargoSiteType, cargoSiteName, country));
    }
    /**
     * Tests if IllegalArgumentException is thrown with null CargoSiteType argument.
     */
    @Test
    public void null_CargoSiteType_Should_Throw_IllegalArgumentContainerToLoad(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String cargoSiteType = null;
        String cargoSiteName = "Leixões";
        String country = "Portugal";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerToLoadOnPortDTO(containerId, containerLoad, containerType, cargoSiteType, cargoSiteName, country));
    }
    /**
     * Tests if ValueException is thrown with illegal CargoSiteType argument.
     */
    @Test
    public void invalid_CargoSiteType_Should_Throw_IllegalArgumentContainerToLoad(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String cargoSiteType = "aaaaa";
        String cargoSiteName = "Leixões";
        String country = "Portugal";


        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerToLoadOnPortDTO(containerId, containerLoad, containerType, cargoSiteType, cargoSiteName, country));
    }

    @Test
    public void invalid_CargoSiteName_Should_Throw_IllegalArgumentContainerToLoad(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = "Port";
        String cargoSiteName = null;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerMapperImpl.mapToContainerToLoadOnPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteName,cargoSiteType));
    }

    @Test
    public void invalid_ContainerID_Should_Throw_IllegalArgumentContainerToLoad() {
        // Arrange
        String containerId = null;
        int containerLoad = 10;
        int containerType = 7;
        String containerPosition = "10 - 10 - 7";
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () -> containerMapperImpl.mapToContainerToLoadOnPortDTO(containerId, containerLoad, containerType, containerPosition, cargoSiteType, cargoSiteName));
    }

    /**
     * Tests if an expected object is returned with valid port input type specified
     */
    @Test
    public void valid_InputArguments_Should_Return_ExpectedObjectContainerToLoad(){
        // Arrange
        String containerId = "10";
        int containerLoad = 10;
        int containerType = 7;
        String cargoSiteType = "Port";
        String cargoSiteName = "Leixões";
        String country = "Portugal";


        ContainerToLoadOnPortDTO expected = new ContainerToLoadOnPortDTO(containerId,containerLoad, ContainerTempType.MAX_TEMP_7_DEGREES,LocationType.PORT,cargoSiteName, country);
        // Act
        ContainerToLoadOnPortDTO result = containerMapperImpl.mapToContainerToLoadOnPortDTO(containerId,containerLoad,containerType,cargoSiteType,cargoSiteName, country);

        // Arrange
        assertNotNull(result);
        assertEquals(expected.getIdContainer(), result.getIdContainer());
        assertEquals(expected.getPayload(), result.getPayload());
        assertEquals(expected.getType(), result.getType());
        assertEquals(expected.getCargoSiteType(), result.getCargoSiteType());
        assertEquals(expected.getCargoSiteName(), result.getCargoSiteName());
        assertEquals(expected.getCountry(), result.getCountry());

    }
}
