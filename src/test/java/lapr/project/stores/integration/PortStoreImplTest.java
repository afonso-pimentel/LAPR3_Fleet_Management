package lapr.project.stores.integration;

import lapr.project.model.Port;
import lapr.project.utils.datastructures.KdTree;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import org.junit.jupiter.api.Test;

import java.io.FileWriter;
import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;


import lapr.project.mappers.PortMapperImpl;
import lapr.project.stores.PortStoreImpl;

public class PortStoreImplTest {
    private PortStoreImpl portStoreImpl;
    private FileReaderImpl fileReaderImpl;
    private PortMapperImpl portMapperImpl;
    private CsvFileParserImpl csvFileParserImpl;

    public PortStoreImplTest() throws IOException {
        portMapperImpl = new PortMapperImpl();
        fileReaderImpl = new FileReaderImpl();
        csvFileParserImpl = new CsvFileParserImpl();
        portStoreImpl = new PortStoreImpl(portMapperImpl);

    }

    /**
     * Tests if a valid file yields the expected objects
     *
     * @throws IOException
     * @throws ParseException
     */
    @Test
    public void valid_InputContent_ShouldReturn_ExpectedObjects() throws IOException, ParseException {
        // Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/sports.csv"; //mine does not identify only by /resources/file.csv

        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);
        List<Port> expected = portMapperImpl.mapPortFromCsvContent(csvParsedFileContent);

        // Act
        portStoreImpl.importPortsFromCsv(csvParsedFileContent);
        KdTree<Port> result = portStoreImpl.getPorts();


        // Assert
        assertNotNull(result);

        List<Port> resultPorts = result.getAll();

        for (Port expectedPort : expected) {

            for (Port resultPort : resultPorts) {
                if (resultPort.getLongitude() == expectedPort.getLongitude()) {
                    assertEquals(expectedPort.getContinent(), resultPort.getContinent());
                    assertEquals(expectedPort.getCountry(), resultPort.getCountry());
                    assertEquals(expectedPort.getLatitude(), resultPort.getLatitude());
                    assertEquals(expectedPort.getLongitude(), resultPort.getLongitude());
                    assertEquals(expectedPort.getIdCode(), resultPort.getIdCode());
                    assertEquals(expectedPort.getName(), resultPort.getName());
                }
            }


        }

        writeKdTreeToOutputTestFileAndConsoleOutput(resultPorts, System.getProperty("user.dir") + "/src/test/resources/output/output_kdtree_ports_test.csv");
    }

    /**
     * Prints to the console and writes to a file the content of the KD-Tree for the integration test
     * @param ports List of Port objects
     * @param newFilePath FilePath of the Output file
     * @throws IOException
     */
    private void writeKdTreeToOutputTestFileAndConsoleOutput(List<Port> ports, String newFilePath) throws IOException {
        //newFilePath = System.getProperty("user.dir") + "/resources/output_file_integration_test.csv";
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(newFilePath)) {
            myWriter.write("continent,country,code,port,lat,lon\n");

            for (Port port : ports) {

                fileOutputLine.append(port.getContinent() + ",");
                fileOutputLine.append(port.getCountry() + ",");
                fileOutputLine.append(port.getIdCode() + ",");
                fileOutputLine.append(port.getName() + ",");
                fileOutputLine.append(port.getLatitude() + ",");
                fileOutputLine.append(port.getLongitude());

                myWriter.write(fileOutputLine.toString() + "\n");
                System.out.println(fileOutputLine.toString() + "\n");

                fileOutputLine = new StringBuilder();
            }
        }
    }


}
