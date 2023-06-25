package lapr.project.stores.unit;

import lapr.project.mappers.ContainerMapper;
import lapr.project.mappers.ContainerMapperImpl;
import lapr.project.mappers.dtos.ContainerSituationDTO;
import lapr.project.mappers.dtos.ContainerToLoadOnPortDTO;
import lapr.project.mappers.dtos.ContainerWithNextPortDTO;
import lapr.project.model.enums.ContainerTempType;
import lapr.project.model.enums.LocationType;
import lapr.project.stores.ContainerStoreImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnection;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

/**
 * @author Group 169 LAPRIII
 */
@ExtendWith(MockitoExtension.class)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class ContainerStoreImplTest {
    @Mock
    private DatabaseConnection mockDatabaseConnection;
    @Mock
    private ApplicationPropertiesHelper mockApplicationPropertiesHelper;
    @Mock
    private Connection mockConnection;
    @Mock
    private ResultSet mockResultSet;
    @Mock
    private PreparedStatement mockPreparedStatement;

    private ContainerStoreImpl containerStoreImpl;

    @BeforeEach
    public void createMocks() {
        MockitoAnnotations.openMocks(this);
        ContainerMapper containerMapper = new ContainerMapperImpl();
        containerStoreImpl = new ContainerStoreImpl(mockDatabaseConnection, mockApplicationPropertiesHelper, containerMapper);
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null databaseConnection argument
     */
    @Test
    public void invalid_NullDatabaseConnectionOnConstructor_ShouldThrow_IllegalArgumentException() throws IOException {
        // Arrange
        DatabaseConnection nullArgument = null;
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        ContainerMapper containerMapper = new ContainerMapperImpl();

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  new ContainerStoreImpl(nullArgument, applicationPropertiesHelper, containerMapper));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null applicationPropertiesHelper argument
     */
    @Test
    public void invalid_NullApplicationPropertiesHelperOnConstructor_ShouldThrow_IllegalArgumentException() throws IOException {
        // Arrange
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection databaseConnection = new DatabaseConnectionImpl(applicationPropertiesHelper);
        ContainerMapper containerMapper = new ContainerMapperImpl();

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  new ContainerStoreImpl(databaseConnection, null, containerMapper));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null mapper argument
     */
    @Test
    public void invalid_NullMapperOnConstructor_ShouldThrow_IllegalArgumentException() throws IOException {
        // Arrange
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection databaseConnection = new DatabaseConnectionImpl(applicationPropertiesHelper);
        ContainerMapper nullArgument = null;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  new ContainerStoreImpl(databaseConnection, applicationPropertiesHelper, nullArgument));
    }

    /**
     * Test if an IllegalArgumentException is thrown for a null container identifier
     */
    @Test
    public void invalid_NullContainerIdentifier_ShouldThrow_IllegalArgumentException(){
        // Arrange
        String nullContainerIdentifier = null;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerStoreImpl.getContainerCurrentSituation(nullContainerIdentifier));
    }

    /**
     * Test if an IllegalArgumentException is thrown for an invalid MMSI number
     */
    @Test
    public void invalid_MMSINumber_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int mmsi = 20;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerStoreImpl.getContainersToBeOffloadedNextPort(mmsi));
    }


    /**
     * Test if an IllegalArgumentException is thrown for an invalid MMSI number for loading container
     */
    @Test
    public void invalid_MMSINumber_ShouldThrow_IllegalArgumentExceptionContainersToLoad(){
        // Arrange
        int mmsi = 20;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerStoreImpl.getContainersToBeLoadedNextPort(mmsi));
    }

    /**
     * Test if a valid MMSI returns an expected list, in this case, only one Container
     * @throws SQLException
     * @throws IOException
     */
    @Test
    public void valid_MMSI_ShouldReturnExpected_Object() throws SQLException, IOException {
        // Arrange
        int i=0;

        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true,false);
        when(mockResultSet.getString("CONTAINER_ID")).thenReturn("123456789");
        when(mockResultSet.getString("CONTAINER_LOAD")).thenReturn("100");
        when(mockResultSet.getString("CONTAINER_TYPE")).thenReturn("7");
        when(mockResultSet.getString("CONTAINER_POSITION")).thenReturn("TEST_CONTAINER_POSITION");
        when(mockResultSet.getString("CARGO_SITE_TYPE")).thenReturn("Port");
        when(mockResultSet.getString("CARGO_SITE_NAME")).thenReturn("TEST_CARGO_SITE_NAME");
        ContainerWithNextPortDTO expected = new ContainerWithNextPortDTO("123456789",100,ContainerTempType.MAX_TEMP_7_DEGREES,"TEST_CONTAINER_POSITION",LocationType.PORT,"TEST_CARGO_SITE_NAME");

        // Act
        List<ContainerWithNextPortDTO> result = containerStoreImpl.getContainersToBeOffloadedNextPort(123456789);
        ContainerWithNextPortDTO resultContainer = result.get(0);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getIdContainer(), resultContainer.getIdContainer());
        assertEquals(expected.getPayload(), result.get(0).getPayload());
        assertEquals(expected.getType(), result.get(0).getType());
        assertEquals(expected.getXyzPosition(), result.get(0).getXyzPosition());
        assertEquals(expected.getCargoSiteType(), result.get(0).getCargoSiteType());
        assertEquals(expected.getCargoSiteName(), result.get(0).getCargoSiteName());

        //Assert first Condition
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerStoreImpl.getContainersToBeLoadedNextPort(99999999));
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerStoreImpl.getContainersToBeLoadedNextPort(1000000000));
    }

    @Test
    public void valid_ContainerIdentifier_ShouldReturnExpected_Object() throws SQLException, IOException {
        // Arrange
        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("LOCATION_NAME")).thenReturn("TEST_LOCATION_NAME");
        when(mockResultSet.getString("LOCATION_TYPE")).thenReturn("Truck");

        ContainerSituationDTO expected = new ContainerSituationDTO("TEST_LOCATION_NAME", LocationType.TRUCK);

        // Act
        ContainerSituationDTO result = containerStoreImpl.getContainerCurrentSituation("TEST");

        // Assert
        assertNotNull(result);
        assertEquals(expected.getLocationName(), result.getLocationName());
        assertEquals(expected.getLocationType(), result.getLocationType());
    }

    /**
     * Test if a valid MMSI returns an expected list, in this case, only one Container
     * @throws SQLException
     * @throws IOException
     */
    @Test
    public void valid_Data_ShouldReturnExpected_Object() throws SQLException, IOException {
        // Arrange
        int i=0;

        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true,false);
        when(mockResultSet.getString("CONTAINER_ID")).thenReturn("123456789");
        when(mockResultSet.getInt("CONTAINER_LOAD")).thenReturn(100);
        when(mockResultSet.getInt("CONTAINER_TYPE")).thenReturn(7);
        when(mockResultSet.getString("CARGO_SITE_TYPE")).thenReturn("Port");
        when(mockResultSet.getString("CARGO_SITE_NAME")).thenReturn("TEST_CARGO_SITE_NAME");
        when(mockResultSet.getString("CARGO_SITE_COUNTRY")).thenReturn("TEST_CONTAINER_COUNTRY");
        ContainerToLoadOnPortDTO expected = new ContainerToLoadOnPortDTO("123456789",100,ContainerTempType.MAX_TEMP_7_DEGREES,LocationType.PORT,"TEST_CARGO_SITE_NAME","TEST_CONTAINER_COUNTRY");

        // Act
        List<ContainerToLoadOnPortDTO> result = containerStoreImpl.getContainersToBeLoadedNextPort(123456789);
        ContainerToLoadOnPortDTO resultContainer = result.get(0);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getIdContainer(), resultContainer.getIdContainer());
        assertEquals(expected.getPayload(), result.get(0).getPayload());
        assertEquals(expected.getType(), result.get(0).getType());
        assertEquals(expected.getCargoSiteType(), result.get(0).getCargoSiteType());
        assertEquals(expected.getCargoSiteName(), result.get(0).getCargoSiteName());
        assertEquals(expected.getCountry(), result.get(0).getCountry());

        //Assert first Condition
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerStoreImpl.getContainersToBeLoadedNextPort(99999999));
        assertThrowsExactly(IllegalArgumentException.class, () ->  containerStoreImpl.getContainersToBeLoadedNextPort(1000000000));

    }
}
