package lapr.project.services.integration;

import lapr.project.mappers.PortMapperImpl;
import lapr.project.mappers.ShipMapperImpl;
import lapr.project.model.Port;
import lapr.project.services.PortServiceImpl;
import lapr.project.services.ShipServiceImpl;
import lapr.project.services.ShipServiceLogicImpl;
import lapr.project.stores.PortStoreImpl;
import lapr.project.stores.ShipStoreImpl;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import lapr.project.utils.utilities.Utilities;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PortServiceImplTest {



    private PortServiceImpl portServiceImpl;
    private PortMapperImpl portMapperImpl;
    private PortStoreImpl portStoreImpl;
    private FileReaderImpl fileReaderImpl;
    private CsvFileParserImpl csvFileParserImpl;
    private ShipMapperImpl shipMapperImpl;
    private ShipServiceLogicImpl shipServiceLogicImpl;
    private ShipStoreImpl shipStoreImpl;
    private ShipServiceImpl shipServiceImpl;

    public PortServiceImplTest() throws IOException {
        this.portMapperImpl = new PortMapperImpl();
        this.portStoreImpl = new PortStoreImpl(portMapperImpl);
        this.fileReaderImpl = new FileReaderImpl();
        this.csvFileParserImpl = new CsvFileParserImpl();
        this.shipMapperImpl = new ShipMapperImpl();
        this.shipServiceLogicImpl = new ShipServiceLogicImpl();
        this.shipStoreImpl = new ShipStoreImpl(shipMapperImpl, new DatabaseConnectionImpl(new ApplicationPropertiesHelperImpl()));
        this.shipServiceImpl = new ShipServiceImpl(shipStoreImpl, shipMapperImpl, shipServiceLogicImpl);
        this.portServiceImpl = new PortServiceImpl(portStoreImpl, shipServiceImpl, portMapperImpl);
    }


    /**
     *
     */
    @Test
    public void valid_InputContent_ShouldReturn_ExpectedObjects() throws IOException, ParseException {
        //Arrange
        String filePathShips = System.getProperty("user.dir") + "/src/test/resources/sships.csv";
        List<String> fileContentShips = fileReaderImpl.readFile(filePathShips);
        List<List<String>> csvParsedFileContentShips = csvFileParserImpl.parseToCsv(fileContentShips);
        shipStoreImpl.importShipsFromCsv(csvParsedFileContentShips);

        String filePathPorts = System.getProperty("user.dir") + "/src/test/resources/sports.csv"; //mine does not identify only by /resources/file.csv
        List<String> fileContentPorts = fileReaderImpl.readFile(filePathPorts);
        List<List<String>> csvParsedFileContentPorts = csvFileParserImpl.parseToCsv(fileContentPorts);
        portStoreImpl.importPortsFromCsv(csvParsedFileContentPorts);

        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputShipsCallSignNearestPort.csv"; //mine does not identify only by /resources/file.csv
        List<String> fileInput = fileReaderImpl.readFile(filePathInput);

        //Act
        Port result = portServiceImpl.getClosestPortToShipInGivenDate(fileInput.get(0),Utilities.convertFromDateStringToTimeStamp(fileInput.get(1)));
        Port expected = new Port("New Jersey","America","United States",25007,40.66666667f,-74.16666667f);

        //Assert
        assertEquals(expected,result);

    }



}