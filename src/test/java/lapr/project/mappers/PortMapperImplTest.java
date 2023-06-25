package lapr.project.mappers;

import lapr.project.mappers.dtos.PortDTO;
import lapr.project.model.Country;
import lapr.project.model.Port;
import lapr.project.utils.datastructures.PortNode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

public class PortMapperImplTest {
    @Mock
    private ResultSet mockResultSet;

    private PortMapperImpl portMapperImpl;

    public PortMapperImplTest(){
        portMapperImpl = new PortMapperImpl();
    }

    @BeforeEach
    public void createMocks() {
        MockitoAnnotations.openMocks(this);
        portMapperImpl = new PortMapperImpl();
    }

    @Test
    public void invalid_NullArgument_ShouldThrow_IllegalArgumentException(){
        // Arrange
        List<List<String>> nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  portMapperImpl.mapPortFromCsvContent(nullArgument));
    }

    @Test
    public void valid_CsvLineContent_ShouldReturn_ExpectedResult() throws ParseException {
        // Arrange
        Port expectedPort = new Port("Liverpool","Europe","United Kingdom",29002,53.46666667f,-3.033333333f);

        // Act
        List<Port> resultPort = portMapperImpl.mapPortFromCsvContent(buildCsvContent(false));

        // Assert

        assertNotNull(resultPort);
        assertEquals(expectedPort.getName(), resultPort.get(0).getName());
        assertEquals(expectedPort.getContinent(), resultPort.get(0).getContinent());
        assertEquals(expectedPort.getCountry(), resultPort.get(0).getCountry());
        assertEquals(expectedPort.getIdCode(), resultPort.get(0).getIdCode());
        assertEquals(expectedPort.getLongitude(), resultPort.get(0).getLongitude());
        assertEquals(expectedPort.getLatitude(), resultPort.get(0).getLatitude());
    }


    @Test
    public void valid_CsvLineContentWithHeaderLine_ShouldReturn_ExpectedResult() throws ParseException {
        // Arrange
        Port expectedPort = new Port("Liverpool","Europe","United Kingdom",29002,53.46666667f,-3.033333333f);

        // Act
        List<Port> resultPort = portMapperImpl.mapPortFromCsvContent(buildCsvContent(true));

        // Assert

        assertNotNull(resultPort);
        assertEquals(expectedPort.getName(), resultPort.get(0).getName());
        assertEquals(expectedPort.getContinent(), resultPort.get(0).getContinent());
        assertEquals(expectedPort.getCountry(), resultPort.get(0).getCountry());
        assertEquals(expectedPort.getIdCode(), resultPort.get(0).getIdCode());
        assertEquals(expectedPort.getLongitude(), resultPort.get(0).getLongitude());
        assertEquals(expectedPort.getLatitude(), resultPort.get(0).getLatitude());
    }


    @Test
    public void valid_InputArguments_ShouldReturn_ExpectedObject(){
        // Arrange
        PortDTO expected = new PortDTO(29002, "Liverpool","Europe","United Kingdom",53.46666667f,-3.033333333f);

        // Act
        PortDTO result = portMapperImpl.mapToPortDTO(29002, "Liverpool","Europe","United Kingdom",53.46666667f,-3.033333333f);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getIdCode(), result.getIdCode());
        assertEquals(expected.getName(), result.getName());
        assertEquals(expected.getContinent(), result.getContinent());
        assertEquals(expected.getCountry(), result.getCountry());
        assertEquals(expected.getLatitude(), result.getLatitude());
        assertEquals(expected.getLongitude(), result.getLongitude());
    }

    @Test
    public void valid_CsvContent_ShouldReturn_ExpectedPortNode(){
        // Arrange
        PortNode expectedPortNode = new PortNode(34.91666667f, 33.65f, "Larnaca", new Country("Cyprus", "Europe"));

        String port = "Europe,Cyprus,10136,Larnaca,34.91666667,33.65";

        // Act
        PortNode result = portMapperImpl.mapPortNodeFromCsvContent(Arrays.asList(port.split(",")));

        // Assert
        assertNotNull(result);
        assertEquals(expectedPortNode.getPortName(), result.getPortName());
        assertEquals(expectedPortNode.getCountry(), result.getCountry());
        assertEquals(expectedPortNode.getLatitude(), result.getLatitude());
        assertEquals(expectedPortNode.getLongitude(), result.getLongitude());
    }

    @Test
    public void valid_InputResultSet_ShouldReturn_ExpectedPortNode() throws SQLException {
        // Arrange
        PortNode expected = new PortNode(33.0f, 31.0f, "PORT FROM DATABASE", new Country("Portugal", ""));

        when(mockResultSet.getFloat("LATITUDE")).thenReturn(33.0f);
        when(mockResultSet.getFloat("LONGITUDE")).thenReturn(31.0f);
        when(mockResultSet.getString("PORT_NAME")).thenReturn("PORT FROM DATABASE");
        when(mockResultSet.getString("PORT_COUNTRY")).thenReturn("Portugal");

        // Act
        PortNode result = portMapperImpl.mapPortNodeFromDatabaseResultSet(mockResultSet);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getLatitude(), result.getLatitude());
        assertEquals(expected.getLongitude(), result.getLongitude());
        assertEquals(expected.getPortName(), result.getPortName());
        assertEquals(expected.getCountry().getName(), result.getCountry().getName());
    }

    private List<List<String>> buildCsvContent(boolean withHeaderLIne){
        ArrayList<List<String>> csvFileContent = new ArrayList<>();

        ArrayList<String> csvLine = new ArrayList<>();

        if(withHeaderLIne){
            ArrayList<String> headerLine = new ArrayList<>();
            headerLine.add("continent");
            headerLine.add("country");
            headerLine.add("code");
            headerLine.add("port");
            headerLine.add("lat");
            headerLine.add("lon");

            csvFileContent.add(headerLine);
        }

        csvLine.add("Europe"); //continent
        csvLine.add("United Kingdom"); //country
        csvLine.add("29002"); //code
        csvLine.add("Liverpool"); //port
        csvLine.add("53.46666667"); //lat
        csvLine.add("-3.033333333"); //lon

        csvFileContent.add(csvLine);

        return csvFileContent;
    }
}
