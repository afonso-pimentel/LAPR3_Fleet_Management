package lapr.project.services.integration;

import lapr.project.mappers.*;
import lapr.project.model.PositionData;
import lapr.project.model.PositionDataVelocity;
import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.services.FreightNetworkServiceImpl;
import lapr.project.utils.datastructures.*;
import lapr.project.utils.fileoperations.CsvFileParser;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.*;
import org.junit.jupiter.api.Test;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class FreightNetworkServiceImplTest {
    private FreightNetworkImpl freightNetworkImpl;
    private final FreightNetworkServiceImpl freightNetworkServiceImpl;
    private FileReaderImpl fileReaderImpl;
    private Graph<FreightNetworkNode, Float> testFreightNetworkGraph;

    public FreightNetworkServiceImplTest() throws IOException {
        SeadistsMapper seadistsMapper = new SeadistsMapperImpl();
        PortMapper portMapper = new PortMapperImpl();
        CapitalMapper capitalMapper = new CapitalMapperImpl();
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection databaseConnection = new DatabaseConnectionImpl(applicationPropertiesHelper);
        FileReader fileReader = new FileReaderImpl();
        CsvFileParser csvFileParser = new CsvFileParserImpl();

        FreightNetworkDataHandler freightNetworkDataAccess = new FreightNetworkDataHandlerImpl(capitalMapper, portMapper, seadistsMapper, fileReader, csvFileParser, databaseConnection);
        FreightNetworkLogic freightNetworkLogic = new FreightNetworkLogicImpl();

        String capitalNodesFilePath = System.getProperty("user.dir") + "/src/test/resources/countries.csv";
        String portNodesFilePath = System.getProperty("user.dir") + "/src/test/resources/bports.csv";
        String bordersFilePath = System.getProperty("user.dir") + "/src/test/resources/borders.csv";
        String seadistsFilePath = System.getProperty("user.dir") + "/src/test/resources/seadists.csv";

        freightNetworkImpl = new FreightNetworkImpl(freightNetworkDataAccess, freightNetworkLogic);

        //Test from files
        freightNetworkImpl.initializeNetworkFromFiles(5, capitalNodesFilePath, portNodesFilePath, bordersFilePath, seadistsFilePath);

        //Test from database
        // freightNetworkImpl.initializeNetworkFromDatabase(5);

        testFreightNetworkGraph = freightNetworkImpl.getFreightNetwork();

        this.freightNetworkServiceImpl = new FreightNetworkServiceImpl(testFreightNetworkGraph);

        this.fileReaderImpl = new FileReaderImpl();
    }

    @Test
    public void validInput_ShouldReturn_GetCriticalPortList() throws ParseException, IOException {
        // Arrange
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputGetCriticalPortList.csv";
        List<String> InputFileContent = fileReaderImpl.readFile(filePathInput);
        int n = Integer.parseInt(InputFileContent.get(0));

        String outputFilePath = System.getProperty("user.dir") + "/src/test/resources/output/outputGetCriticalPortList.csv";

        // Act
        LinkedHashMap<PortNode, Long> result = freightNetworkServiceImpl.getCriticalPortList(n);

        try (FileWriter myWriter = new FileWriter(outputFilePath)) {
            myWriter.write("PortName,VisitedNumber\n");
            for (Map.Entry<PortNode, Long> port : result.entrySet()) {
                System.out.println(((PortNode) port.getKey()).getPortName() + " | " + port.getValue().toString());
                myWriter.write(((PortNode) port.getKey()).getPortName() + "," + port.getValue().toString() + "\n");
            }
        }
    }
}
