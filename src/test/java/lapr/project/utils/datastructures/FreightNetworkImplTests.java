package lapr.project.utils.datastructures;

import lapr.project.mappers.*;
import lapr.project.model.Country;
import lapr.project.utils.fileoperations.CsvFileParser;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnection;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


/**
 * @author Group 169 LAPRIII
 */
public class FreightNetworkImplTests {
    @Mock
    private FreightNetworkDataHandler mockFreightNetworkDataHandler;
    @Mock
    private FreightNetworkLogic mockFeightNetworkLogic;

    private FreightNetworkImpl freightNetworkImpl;

    public FreightNetworkImplTests() throws IOException {
    }

    @BeforeEach
    public void setUp() throws IOException {
        MockitoAnnotations.openMocks(this);
        freightNetworkImpl = new FreightNetworkImpl(mockFreightNetworkDataHandler, mockFeightNetworkLogic);
    }

    @Test
    public void testDatabaseDataAccessForFreightNetworkWithMocks_ShouldNotThrowAnyException() throws IOException, SQLException {
        // Arrange
        HashMap<Country, CapitalNode> expectedCapitalNodes = new HashMap<>();
        expectedCapitalNodes.put(new Country("Portugal","Europe"), new CapitalNode(30.0f, 35.0f, "Lisbon", new Country("Portugal","Europe")));
        expectedCapitalNodes.put(new Country("Spain","Europe"), new CapitalNode(55.0f, 55.0f, "Madrid", new Country("Spain","Europe")));

        HashMap<Country, HashMap<PortNodeInfo, PortNode>> expectedPortNodes = new HashMap<>();
        HashMap<PortNodeInfo, PortNode> expectedPortNodesPortugal = new HashMap<>();
        expectedPortNodesPortugal.put(new PortNodeInfo("Leixoes"), new PortNode(33.0f, 35.0f, "Leixoes", new Country("Portugal", "Europe")));
        expectedPortNodesPortugal.put(new PortNodeInfo("Funchal"), new PortNode(33.0f, 55.0f, "Funchal", new Country("Portugal", "Europe")));

        HashMap<PortNodeInfo, PortNode> expectedPortNodesSpain= new HashMap<>();
        expectedPortNodesSpain.put(new PortNodeInfo("Barcelona"), new PortNode(33.0f, 35.0f, "Barcelona", new Country("Spain", "Europe")));
        expectedPortNodesSpain.put(new PortNodeInfo("Madrid"), new PortNode(33.0f, 55.0f, "Madrid", new Country("Spain", "Europe")));

        expectedPortNodes.put(new Country("Portugal", "Europe"), expectedPortNodesPortugal);
        expectedPortNodes.put(new Country("Spain", "Europe"), expectedPortNodesSpain);

        when(mockFreightNetworkDataHandler.importCapitalNodesFromDatabaseIntoGraph(any(new MatrixGraph<FreightNetworkNode, Float>(false).getClass()))).thenReturn(expectedCapitalNodes);
        when(mockFreightNetworkDataHandler.importPortNodesFromDatabaseIntoGraph(any(new MatrixGraph<FreightNetworkNode, Float>(false).getClass()))).thenReturn(expectedPortNodes);
        when(mockFreightNetworkDataHandler.importBordersFromDatabase()).thenReturn(new HashMap<>());
        when(mockFreightNetworkDataHandler.importSeadistsFromDatabase()).thenReturn(new HashMap<>());

        // Act
        assertDoesNotThrow(() -> freightNetworkImpl.initializeNetworkFromDatabase(5));
        verify(mockFeightNetworkLogic).addCapitalConnectionToCapitalsFromBorderCountries(any(new HashMap<Country,CapitalNode>().getClass()), any(new HashMap<Country, List<Country>>().getClass()),any(new MatrixGraph<FreightNetworkNode, Float>(false).getClass()));
        verify(mockFeightNetworkLogic).addClosestPortToCapitalConnection(any(new HashMap<Country,CapitalNode>().getClass()), any(new HashMap<Country,HashMap<PortNodeInfo, PortNode>>().getClass()), any(new HashMap<Country, List<Country>>().getClass()), any(new MatrixGraph<FreightNetworkNode, Float>(false).getClass()));
        verify(mockFeightNetworkLogic).addPortConnectionToNClosestPorts(any(int.class), any(new HashMap<Country,HashMap<PortNodeInfo, PortNode>>().getClass()), any(new HashMap<PortNodeInfo, TreeSet<Seadist>>().getClass()), any(new MatrixGraph<FreightNetworkNode, Float>(false).getClass()));
        verify(mockFeightNetworkLogic).addPortConnectionToPortsFromSameCountry(any(new HashMap<Country,HashMap<PortNodeInfo, PortNode>>().getClass()), any(new HashMap<PortNodeInfo, TreeSet<Seadist>>().getClass()), any(new MatrixGraph<FreightNetworkNode, Float>(false).getClass()));
    }
}
