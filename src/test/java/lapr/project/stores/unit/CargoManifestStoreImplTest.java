package lapr.project.stores.unit;

import lapr.project.mappers.CargoManifestMapper;
import lapr.project.mappers.CargoManifestMapperImpl;
import lapr.project.mappers.dtos.CargoManifestAvgDTO;
import lapr.project.stores.CargoManifestStoreImpl;
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
import java.sql.*;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

/**
 * @author Group 169 LAPRIII
 */
@ExtendWith(MockitoExtension.class)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class CargoManifestStoreImplTest {

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

    private  CargoManifestStoreImpl cargoManifestStoreImpl;

    @BeforeEach
    public void createMocks() {
        MockitoAnnotations.openMocks(this);
        CargoManifestMapper cargoManifestMapper = new CargoManifestMapperImpl();
        cargoManifestStoreImpl = new CargoManifestStoreImpl(mockDatabaseConnection,mockApplicationPropertiesHelper, cargoManifestMapper);
    }

    /**
     * Tests if a IllegalArgumentException is thrown for a null databaseConnection argument
     * @throws IOException
     */
    @Test
    public void invalid_NullDatabaseConnectionConstructor_ShouldThrow_IllegalArgumentException() throws IOException {
        //Arrange
        DatabaseConnection nuller = null;
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        CargoManifestMapper cargoManifestMapper =  new CargoManifestMapperImpl();
        //Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () -> new CargoManifestStoreImpl(nuller, applicationPropertiesHelper, cargoManifestMapper));
    }

    /**
     * Tests if a IllegalArgumentException is thrown for a null ApplicationPropertiesHelperImpl argument
     * @throws IOException
     */
    @Test
    public void invalid_ApplicationPropertiesHelperImplConstructor_ShouldThrow_IllegalArgumentException() throws IOException {
        //Arrange
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection dbconn = new DatabaseConnectionImpl(applicationPropertiesHelper);
        CargoManifestMapper cargoManifestMapper = new CargoManifestMapperImpl();
        //Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () -> new CargoManifestStoreImpl(dbconn, null, cargoManifestMapper));
    }

    /**
     * Tests if a IllegalArgumentException is thrown for a null CargoManifestMapperImpl argument
     * @throws IOException
     */
    @Test
    public void invalid_CargoManifestMapperImplConstructor_ShouldThrow_IllegalArgumentException() throws IOException {
        //Arrange
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection dbconn = new DatabaseConnectionImpl(applicationPropertiesHelper);
        CargoManifestMapper nuller = null;
        //Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () -> new CargoManifestStoreImpl(dbconn,applicationPropertiesHelper, nuller));
    }

    @Test
    public void valid_containerIdentifier_ShouldExecute() throws SQLException, IOException {
        // Arrange
        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt("CARGOMANIFESTNUMBER")).thenReturn(45);
        when(mockResultSet.getFloat("CONTAINERAVERAGE")).thenReturn(300f);

        CargoManifestAvgDTO expected = new CargoManifestAvgDTO(45, 300f);

        // Act
        CargoManifestAvgDTO result = cargoManifestStoreImpl.getCargoManifestsAveragesYear(LocalDate.of(2021,01,01));

        // Assert
        assertNotNull(result);
        assertEquals(expected.getCargoManifestQty(), result.getCargoManifestQty());
        assertEquals(expected.getAvgContainerQty(), result.getAvgContainerQty());
    }
}
