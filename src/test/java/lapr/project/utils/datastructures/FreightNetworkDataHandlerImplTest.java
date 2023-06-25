package lapr.project.utils.datastructures;

import lapr.project.mappers.*;
import lapr.project.model.Country;
import lapr.project.utils.fileoperations.CsvFileParser;
import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.DatabaseConnection;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


/**
 * @author Group 169 LAPRIII
 */
public class FreightNetworkDataHandlerImplTest {
    @Mock
    private Connection mockConnection;
    @Mock
    private ResultSet mockResultSet;
    @Mock
    private PreparedStatement mockPreparedStatement;
    @Mock
    private CapitalMapper mockCapitalMapper;
    @Mock
    private SeadistsMapper mockSeadistsMapper;
    @Mock
    private PortMapper mockPortMapper;
    @Mock
    private FileReader mockFileReader;
    @Mock
    private CsvFileParser mockCSVFileParser;
    @Mock
    private DatabaseConnection mockDatabaseConnection;

    private FreightNetworkDataHandlerImpl freightNetworkDataHandlerImpl;


    public FreightNetworkDataHandlerImplTest() {
    }

    @BeforeEach
    public void createMocks() {
        MockitoAnnotations.openMocks(this);
        freightNetworkDataHandlerImpl = new FreightNetworkDataHandlerImpl(mockCapitalMapper, mockPortMapper, mockSeadistsMapper, mockFileReader, mockCSVFileParser, mockDatabaseConnection);
    }

    @Test
    public void valid_filePath_ShouldReturnExpectedInsertedCapitalNodes() throws IOException {
        // Arrange
        String validFilePath = System.getProperty("user.dir") + "/src/test/resources/countries.csv";

        List<String> validFileContent = getValidCountriesFileContent();
        List<List<String>> validCsvContent = parseToCsvContent(validFileContent);
        Graph<FreightNetworkNode, Float> inputGraph = new MatrixGraph<>(false);
        CapitalNode expectedCapitalNodeOne = new CapitalNode(35.16666667f, 33.366667f, "Nicosia", new Country("Cyprus", "Europe"));
        CapitalNode expectedCapitalNodeTwo= new CapitalNode(35.88333333f, 14.5f, "Valletta", new Country("Malta", "Europe"));

        when(mockFileReader.readFile(validFilePath)).thenReturn(validFileContent);
        when(mockCSVFileParser.parseToCsv(validFileContent)).thenReturn(validCsvContent);
        when(mockCapitalMapper.mapCapitalNodeFromCsvContent(any( new ArrayList<String>().getClass()))).thenReturn(expectedCapitalNodeOne).thenReturn(expectedCapitalNodeTwo);

        // Act
        HashMap<Country, CapitalNode> importedCapitalNodes = freightNetworkDataHandlerImpl.importCapitalNodesFromFileIntoGraph(validFilePath, inputGraph);

        // Assert
        assertNotNull(importedCapitalNodes);
        assertNotNull(importedCapitalNodes.get(expectedCapitalNodeOne.getCountry()));
        assertNotNull(importedCapitalNodes.get(expectedCapitalNodeTwo.getCountry()));
        assertEquals(expectedCapitalNodeOne, importedCapitalNodes.get(expectedCapitalNodeOne.getCountry()));
        assertEquals(expectedCapitalNodeTwo, importedCapitalNodes.get(expectedCapitalNodeTwo.getCountry()));
        assertEquals(2, inputGraph.numVertices());
        assertEquals(expectedCapitalNodeOne, inputGraph.vertex(inputGraph.key(expectedCapitalNodeOne)));
        assertEquals(expectedCapitalNodeTwo, inputGraph.vertex(inputGraph.key(expectedCapitalNodeTwo)));
    }

    @Test
    public void valid_filePath_ShouldReturnExpectedInsertedPortNodes() throws IOException {
        // Arrange
        String validFilePath = System.getProperty("user.dir") + "/src/test/resources/bports.csv";

        List<String> validFileContent = getValidPortsFileContent();
        List<List<String>> validCsvContent = parseToCsvContent(validFileContent);
        Graph<FreightNetworkNode, Float> inputGraph = new MatrixGraph<>(false);
        PortNode expectedPortNodeOne = new PortNode(34.91666667f, 33.65f, "Larnaca", new Country("Cyprus", "Europe"));
        PortNode expectedPortNodeTwo= new PortNode(35.84194f, 14.54306f, "Marsaxlokk", new Country("Malta", "Europe"));

        when(mockFileReader.readFile(validFilePath)).thenReturn(validFileContent);
        when(mockCSVFileParser.parseToCsv(validFileContent)).thenReturn(validCsvContent);
        when(mockPortMapper.mapPortNodeFromCsvContent(any( new ArrayList<String>().getClass()))).thenReturn(expectedPortNodeOne).thenReturn(expectedPortNodeTwo);

        // Act
        HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes = freightNetworkDataHandlerImpl.importPortNodesFromFileIntoGraph(validFilePath, inputGraph);

        // Assert
        assertNotNull(importedPortNodes);
        assertNotNull(importedPortNodes.get(expectedPortNodeOne.getCountry()));
        assertNotNull(importedPortNodes.get(expectedPortNodeTwo.getCountry()));
        assertEquals(expectedPortNodeOne, importedPortNodes.get(expectedPortNodeOne.getCountry()).get(new PortNodeInfo(expectedPortNodeOne.getPortName())));
        assertEquals(expectedPortNodeTwo, importedPortNodes.get(expectedPortNodeTwo.getCountry()).get(new PortNodeInfo(expectedPortNodeTwo.getPortName())));
        assertEquals(2, inputGraph.numVertices());
        assertEquals(expectedPortNodeOne, inputGraph.vertex(inputGraph.key(expectedPortNodeOne)));
        assertEquals(expectedPortNodeTwo, inputGraph.vertex(inputGraph.key(expectedPortNodeTwo)));
    }

    @Test
    public void valid_filePath_ShouldReturnExpectedBorders() throws IOException {
        // Arrange
        String validFilePath = System.getProperty("user.dir") + "/src/test/resources/borders.csv";

        List<String> validFileContent = getValidBordersFileContent();
        List<List<String>> validCsvContent = parseToCsvContent(validFileContent);
        Country countryOneBorderOne = new Country("Belize", "America");
        Country countryTwoBorderOne = new Country("Mexico", "America");

        Country countryOneBorderTwo = new Country("Canada", "America");
        Country countryTwoBorderTwo = new Country("United States of America", "America");

        when(mockFileReader.readFile(validFilePath)).thenReturn(validFileContent);
        when(mockCSVFileParser.parseToCsv(validFileContent)).thenReturn(validCsvContent);

        // Act
        HashMap<Country, List<Country>> importedBorders = freightNetworkDataHandlerImpl.importBordersFromFile(validFilePath);

        // Assert
        assertNotNull(importedBorders);
        assertEquals(2, importedBorders.size());
        assertNotNull(importedBorders.get(countryOneBorderOne));
        assertNotNull(importedBorders.get(countryOneBorderTwo));
        assertEquals(1, importedBorders.get(countryOneBorderOne).size());
        assertEquals(1, importedBorders.get(countryOneBorderTwo).size());
        assertEquals(countryTwoBorderOne, importedBorders.get(countryOneBorderOne).get(0));
        assertEquals(countryTwoBorderTwo, importedBorders.get(countryOneBorderTwo).get(0));
    }

    @Test
    public void valid_filePath_ShouldReturnExpectedSeadists() throws IOException {
        // Arrange
        String validFilePath = System.getProperty("user.dir") + "/src/test/resources/seadists.csv";

        List<String> validFileContent = getValidSeadistsFileContent();
        List<List<String>> validCsvContent = parseToCsvContent(validFileContent);
        Seadist seadistOne = new Seadist(new Country("Denmark", "Europe"), "Aarhus", new Country("Turkey", "Europe"), "Ambarli", 3673);
        Seadist seadistTwo = new Seadist(new Country("Denmark", "Europe"), "Aarhus", new Country("Greece", "Europe"), "Aspropyrgos", 3377);

        when(mockFileReader.readFile(validFilePath)).thenReturn(validFileContent);
        when(mockCSVFileParser.parseToCsv(validFileContent)).thenReturn(validCsvContent);
        when(mockSeadistsMapper.mapSeadistFromCsvContent(any(new ArrayList<String>().getClass()))).thenReturn(seadistOne).thenReturn(seadistTwo);
        // Act
        HashMap<PortNodeInfo, TreeSet<Seadist>> importedSeadist = freightNetworkDataHandlerImpl.importSeadistsFromFile(validFilePath);

        // Assert
        assertNotNull(importedSeadist);
        assertEquals(3, importedSeadist.size());
        assertEquals(seadistTwo, importedSeadist.get(new PortNodeInfo("Aarhus")).pollFirst());
        assertEquals(seadistOne, importedSeadist.get(new PortNodeInfo("Aarhus")).pollFirst());
    }

    @Test
    public void valid_RequestForImportCapitalNodesFromDatabase_ShouldReturnExpectedCapitalNodes() throws SQLException, IOException {
        // Arrange
        Graph<FreightNetworkNode, Float> inputGraph = new MatrixGraph<>(false);
        CapitalNode expectedCapitalNodeOne = new CapitalNode(35.16666667f, 33.366667f, "Nicosia", new Country("Cyprus", "Europe"));
        CapitalNode expectedCapitalNodeTwo= new CapitalNode(35.88333333f, 14.5f, "Valletta", new Country("Malta", "Europe"));

        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any(String.class))).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);
        when(mockCapitalMapper.mapCapitalNodeFromDatabaseResultSet(any(ResultSet.class))).thenReturn(expectedCapitalNodeOne).thenReturn(expectedCapitalNodeTwo);

        // Act
        HashMap<Country, CapitalNode> importedCapitalNodes = freightNetworkDataHandlerImpl.importCapitalNodesFromDatabaseIntoGraph(inputGraph);

        // Assert
        assertNotNull(importedCapitalNodes);
        assertNotNull(importedCapitalNodes.get(expectedCapitalNodeOne.getCountry()));
        assertNotNull(importedCapitalNodes.get(expectedCapitalNodeTwo.getCountry()));
        assertEquals(expectedCapitalNodeOne, importedCapitalNodes.get(expectedCapitalNodeOne.getCountry()));
        assertEquals(expectedCapitalNodeTwo, importedCapitalNodes.get(expectedCapitalNodeTwo.getCountry()));
        assertEquals(2, inputGraph.numVertices());
        assertEquals(expectedCapitalNodeOne, inputGraph.vertex(inputGraph.key(expectedCapitalNodeOne)));
        assertEquals(expectedCapitalNodeTwo, inputGraph.vertex(inputGraph.key(expectedCapitalNodeTwo)));
        verify(mockDatabaseConnection).closeDatabaseResources(any(Connection.class), any(ResultSet.class), any(PreparedStatement.class));
    }

    @Test
    public void valid_RequestForImportPortNodesFromDatabase_ShouldReturnExpectedPortNodes() throws SQLException, IOException {
        // Arrange
        Graph<FreightNetworkNode, Float> inputGraph = new MatrixGraph<>(false);
        PortNode expectedPortNodeOne = new PortNode(34.91666667f, 33.65f, "Larnaca", new Country("Cyprus", "Europe"));
        PortNode expectedPortNodeTwo= new PortNode(35.84194f, 14.54306f, "Marsaxlokk", new Country("Malta", "Europe"));

        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any(String.class))).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);
        when(mockResultSet.getString("PORT_COUNTRY")).thenReturn("Cyprus").thenReturn("Malta");
        when(mockResultSet.getString("PORT_CONTINENT")).thenReturn("Europe").thenReturn("Europe");
        when(mockPortMapper.mapPortNodeFromDatabaseResultSet(any(ResultSet.class))).thenReturn(expectedPortNodeOne).thenReturn(expectedPortNodeTwo);

        // Act
        HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes  = freightNetworkDataHandlerImpl.importPortNodesFromDatabaseIntoGraph(inputGraph);

        // Assert
        assertNotNull(importedPortNodes);
        assertNotNull(importedPortNodes.get(expectedPortNodeOne.getCountry()));
        assertNotNull(importedPortNodes.get(expectedPortNodeTwo.getCountry()));
        assertEquals(expectedPortNodeOne, importedPortNodes.get(expectedPortNodeOne.getCountry()).get(new PortNodeInfo(expectedPortNodeOne.getPortName())));
        assertEquals(expectedPortNodeTwo, importedPortNodes.get(expectedPortNodeTwo.getCountry()).get(new PortNodeInfo(expectedPortNodeTwo.getPortName())));
        assertEquals(2, inputGraph.numVertices());
        assertEquals(expectedPortNodeOne, inputGraph.vertex(inputGraph.key(expectedPortNodeOne)));
        assertEquals(expectedPortNodeTwo, inputGraph.vertex(inputGraph.key(expectedPortNodeTwo)));
        verify(mockDatabaseConnection).closeDatabaseResources(any(Connection.class), any(ResultSet.class), any(PreparedStatement.class));
    }

    @Test
    public void valid_RequestForImportSeadistsFromDatabase_ShouldReturnExpectedSeadists() throws SQLException, IOException {
        // Arrange
        Seadist expectedSeadistOne = new Seadist(new Country("Denmark", "Europe"), "Aarhus", new Country("Turkey", "Europe"), "Ambarli", 3673);
        Seadist expectedSeadistTwo = new Seadist(new Country("Portugal", "Europe"), "Leixoes", new Country("Spain", "Europe"), "Barcelona", 1000);

        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any(String.class))).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);
        when(mockResultSet.getString("FROM_PORT")).thenReturn("Aarhus").thenReturn("Leixoes");
        when(mockResultSet.getString("TO_PORT")).thenReturn("Ambarli").thenReturn("Barcelona");
        when(mockSeadistsMapper.mapSeadistFromDatabaseResultSet(any(ResultSet.class))).thenReturn(expectedSeadistOne).thenReturn(expectedSeadistTwo);

        // Act
        HashMap<PortNodeInfo, TreeSet<Seadist>> result = freightNetworkDataHandlerImpl.importSeadistsFromDatabase();

        // Assert
        assertNotNull(result);
        assertEquals(4, result.size());
        assertNotNull(result.get(new PortNodeInfo("Aarhus")));
        assertNotNull(result.get(new PortNodeInfo("Leixoes")));
        assertNotNull(result.get(new PortNodeInfo("Ambarli")));
        assertNotNull(result.get(new PortNodeInfo("Barcelona")));
        assertEquals(1, result.get(new PortNodeInfo("Aarhus")).size());
        assertEquals(1, result.get(new PortNodeInfo("Leixoes")).size());
        assertEquals(1, result.get(new PortNodeInfo("Ambarli")).size());
        assertEquals(1, result.get(new PortNodeInfo("Barcelona")).size());

        Seadist resultAarhusSeaDist = result.get(new PortNodeInfo("Aarhus")).first();

        assertEquals(expectedSeadistOne.getFromCountry(), resultAarhusSeaDist.getFromCountry());
        assertEquals(expectedSeadistOne.getToCountry(), resultAarhusSeaDist.getToCountry());
        assertEquals(expectedSeadistOne.getFromPort(), resultAarhusSeaDist.getFromPort());
        assertEquals(expectedSeadistOne.getToPort(), resultAarhusSeaDist.getToPort());
        assertEquals(expectedSeadistOne.getDistance(), resultAarhusSeaDist.getDistance());

        Seadist resultLeixoesSeaDist =  result.get(new PortNodeInfo("Leixoes")).first();

        assertEquals(expectedSeadistTwo.getFromCountry(), resultLeixoesSeaDist.getFromCountry());
        assertEquals(expectedSeadistTwo.getToCountry(), resultLeixoesSeaDist.getToCountry());
        assertEquals(expectedSeadistTwo.getFromPort(), resultLeixoesSeaDist.getFromPort());
        assertEquals(expectedSeadistTwo.getToPort(), resultLeixoesSeaDist.getToPort());
        assertEquals(expectedSeadistTwo.getDistance(), resultLeixoesSeaDist.getDistance());

        Seadist resultAmbarliSeaDist =  result.get(new PortNodeInfo("Ambarli")).first();

        assertEquals(expectedSeadistOne.getFromCountry(), resultAmbarliSeaDist.getFromCountry());
        assertEquals(expectedSeadistOne.getToCountry(), resultAmbarliSeaDist.getToCountry());
        assertEquals(expectedSeadistOne.getFromPort(), resultAmbarliSeaDist.getFromPort());
        assertEquals(expectedSeadistOne.getToPort(), resultAmbarliSeaDist.getToPort());
        assertEquals(expectedSeadistOne.getDistance(), resultAmbarliSeaDist.getDistance());

        Seadist resultBarcelonaSeaDist = result.get(new PortNodeInfo("Barcelona")).first();

        assertEquals(expectedSeadistTwo.getFromCountry(), resultBarcelonaSeaDist.getFromCountry());
        assertEquals(expectedSeadistTwo.getToCountry(), resultBarcelonaSeaDist.getToCountry());
        assertEquals(expectedSeadistTwo.getFromPort(), resultBarcelonaSeaDist.getFromPort());
        assertEquals(expectedSeadistTwo.getToPort(), resultBarcelonaSeaDist.getToPort());
        assertEquals(expectedSeadistTwo.getDistance(), resultBarcelonaSeaDist.getDistance());
        verify(mockDatabaseConnection).closeDatabaseResources(any(Connection.class), any(ResultSet.class), any(PreparedStatement.class));
    }

    @Test
    public void valid_RequestForImportBorders_ShouldReturnExpectedBorders() throws SQLException, IOException {
        // Arrange
        Country countryOneBorderOne = new Country("Spain", "Europe");
        Country countryTwoBorderOne = new Country("Portugal", "Europe");

        Country countryOneBorderTwo = new Country("Argentina", "America");
        Country countryTwoBorderTwo = new Country("Brasil", "America");

        when(mockDatabaseConnection.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(any(String.class))).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);
        when(mockResultSet.getString("COUNTRY_ONE")).thenReturn(countryOneBorderOne.getName()).thenReturn(countryOneBorderTwo.getName());
        when(mockResultSet.getString("COUNTRY_TWO")).thenReturn(countryTwoBorderOne.getName()).thenReturn(countryTwoBorderTwo.getName());

        // Act
        HashMap<Country, List<Country>> result = freightNetworkDataHandlerImpl.importBordersFromDatabase();

        // Assert
        assertNotNull(result);
        assertEquals(2, result.size());
        assertEquals(1, result.get(countryOneBorderOne).size());
        assertEquals(1, result.get(countryOneBorderTwo).size());

        Country resultCountryBorderOne = result.get(countryOneBorderOne).get(0);
        Country resultCountryBorderTwo = result.get(countryOneBorderTwo).get(0);

        assertEquals(countryTwoBorderOne, resultCountryBorderOne);
        assertEquals(countryTwoBorderTwo, resultCountryBorderTwo);
        verify(mockDatabaseConnection).closeDatabaseResources(any(Connection.class), any(ResultSet.class), any(PreparedStatement.class));
    }

    private List<String>  getValidCountriesFileContent(){
        List<String> fileContent = new ArrayList<>();

        fileContent.add("Europe,Cyprus,10136,Larnaca,34.91666667,33.65");
        fileContent.add("Europe,Malta,10138,Marsaxlokk,35.84194,14.54306");

        return fileContent;
    }

    private List<String> getValidPortsFileContent(){
        List<String> fileContent = new ArrayList<>();

        fileContent.add("Europe,Cyprus,10136,Larnaca,34.91666667,33.65");
        fileContent.add("Europe,Malta,10138,Marsaxlokk,35.84194,14.54306");

        return fileContent;
    }

    private List<String> getValidBordersFileContent(){
        List<String> fileContent = new ArrayList<>();

        //fileContent.add("Country1,Country2");
        fileContent.add("Belize,Mexico");
        fileContent.add("Canada,United States of America");

        return fileContent;
    }

    private List<String> getValidSeadistsFileContent(){
        List<String> fileContent = new ArrayList<>();

        //fileContent.add("from_country,from_port_id,from_port,to_country,to_port_id,to_port,sea_distance");
        fileContent.add("Denmark,10358,Aarhus,Turkey,246265,Ambarli,3673");
        fileContent.add("Denmark,10358,Aarhus,Greece,21863,Aspropyrgos,3377");

        return fileContent;
    }

    private List<List<String>> parseToCsvContent(List<String> fileContent){

        List<List<String>> csvParsedFileContent = new ArrayList<>();

        for(String line : fileContent)
            csvParsedFileContent.add(
                    Arrays.stream(line.replace(',',';')
                            .split(";")).collect(Collectors.toList()));

        return csvParsedFileContent;
    }
}
