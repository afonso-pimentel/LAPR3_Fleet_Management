package lapr.project.stores.unit;

import lapr.project.mappers.ShipMapper;
import lapr.project.mappers.ShipMapperImpl;
import lapr.project.mappers.dtos.ShipAvailableDTO;
import lapr.project.stores.ShipStoreImpl;
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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

/**
 * @author Group 169 LAPRIII
 */
@ExtendWith(MockitoExtension.class)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class ShipStoreImplTest {
    @Mock
    private DatabaseConnection mockDatabaseConnection;
    @Mock
    private Connection mockConnection;
    @Mock
    private ResultSet mockResultSet;
    @Mock
    private PreparedStatement mockPreparedStatement;
    private ShipStoreImpl shipStoreImpl;

    @BeforeEach
    public void createMocks() {
        MockitoAnnotations.openMocks(this);
        ShipMapper containerMapper = new ShipMapperImpl();
        shipStoreImpl = new ShipStoreImpl(new ShipMapperImpl(), mockDatabaseConnection);
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null mapper argument
     */
    @Test
    public void invalid_NullMapperOnConstructor_ShouldThrow_IllegalArgumentException() throws IOException {
        // Arrange
        ShipMapperImpl nullArgument = null;
        DatabaseConnection databaseConnection = new DatabaseConnectionImpl(new ApplicationPropertiesHelperImpl());

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipStoreImpl(nullArgument, databaseConnection));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null database connection argument
     */
    @Test
    public void invalid_NullDatabaseConnection_ShouldThrow_IllegalArgumentException(){
        // Arrange
        ShipMapperImpl shipMapper = new ShipMapperImpl();

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipStoreImpl(shipMapper, null));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null file content argument
     */
    @Test
    public void invalid_NullArgumentOnImportShips_ShouldThrow_IllegalArgumentException(){
        // Arrange
        List<List<String>> nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipStoreImpl.importShipsFromCsv(nullArgument));
    }

    @Test
    public void valid_AvailableShipsRequest_ShouldReturnExpected_Object() throws SQLException, IOException {
        // Arrange
        ShipAvailableDTO expectedShipAvailableDTO = new ShipAvailableDTO(123456789, "TEST SHIP", "TEST PORT", 90.0f, 91.0f);

        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true).thenReturn(false);
        when(mockResultSet.getInt("SHIPMMSI")).thenReturn(expectedShipAvailableDTO.getShipMMSI());
        when(mockResultSet.getString("SHIPNAME")).thenReturn(expectedShipAvailableDTO.getShipName());
        when(mockResultSet.getString("LOCATIONDESCRIPTION")).thenReturn(expectedShipAvailableDTO.getLocationDescription());
        when(mockResultSet.getFloat("LOCATIONLATITUDE")).thenReturn(expectedShipAvailableDTO.getLocationLatitude());
        when(mockResultSet.getFloat("LOCATIONLONGITUDE")).thenReturn(expectedShipAvailableDTO.getLocationLongitude());

        List<ShipAvailableDTO> expected = new ArrayList<>();
        expected.add(expectedShipAvailableDTO);

        // Act
        List<ShipAvailableDTO> result = shipStoreImpl.getAvailableShipsNextWeek();

        // Assert
        assertNotNull(result);
        assertEquals(expected.get(0).getShipMMSI(), result.get(0).getShipMMSI());
        assertEquals(expected.get(0).getShipName(), result.get(0).getShipName());
        assertEquals(expected.get(0).getLocationDescription(), result.get(0).getLocationDescription());
        assertEquals(expected.get(0).getLocationLatitude(), result.get(0).getLocationLatitude());
        assertEquals(expected.get(0).getLocationLongitude(), result.get(0).getLocationLongitude());
    }

    @Test
    public void invalid_NullShip_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int invalidID = -1;
        int cargoManifestID = 1;
        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  shipStoreImpl.occupancyRate(invalidID,cargoManifestID));
    }

    @Test
    public void invalid_cargoManifestID_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int shipID = 10;
        int invalidID = -1;
        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  shipStoreImpl.occupancyRate(shipID,invalidID));
    }

    @Test
    public void valid_containerIdentifier_ShouldExecute() throws IOException, SQLException {
        // Arrange
        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getFloat("OCCUPANCY_PERC")).thenReturn(14.3f);
        float expected = 14.3f;

        // Act
        float result = shipStoreImpl.occupancyRate(43,20);

        // Assert
        assertEquals(expected, result);
        assertEquals(expected, result);

    }

    @Test
    public void invalid_getOccupancyRateAtGivenMoment_NullShip_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int invalidID = -1;
        LocalDate moment = LocalDate.now();
        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  shipStoreImpl.getOccupancyRateAtGivenMoment(invalidID,moment));
    }

    @Test
    public void invalid_getOccupancyRateAtGivenMoment_moment_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int shipID = 1;
        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  shipStoreImpl.getOccupancyRateAtGivenMoment(shipID,null));
    }

    @Test
    public void valid_getOccupancyRateAtGivenMoment_ShouldExecute() throws IOException, SQLException {
        // Arrange
        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getFloat("OccupancyPercentage")).thenReturn(2f);
        float expected = 2f;

        // Act
        float result = shipStoreImpl.getOccupancyRateAtGivenMoment(1,LocalDate.of(2021,12,04));

        // Assert
        assertEquals(expected, result);
        assertEquals(expected, result);
    }
}
