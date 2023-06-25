package lapr.project.stores.integration;

import lapr.project.mappers.ShipMapperImpl;
import lapr.project.mappers.dtos.ShipAvailableDTO;
import lapr.project.model.PositionData;
import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.stores.ShipStoreImpl;
import lapr.project.utils.datastructures.AVL;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import org.junit.jupiter.api.Test;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * @author Group 169 LAPRIII
 */
public class ShipStoreImplTest {
    private ShipStoreImpl shipStoreImpl;
    private FileReaderImpl fileReaderImpl;
    private ShipMapperImpl shipMapperImpl;
    private CsvFileParserImpl csvFileParserImpl;

    /**
     * Constructor for the ShipStoreImplTest object
     */
    public ShipStoreImplTest() throws IOException {
        shipMapperImpl = new ShipMapperImpl();
        fileReaderImpl = new FileReaderImpl();
        csvFileParserImpl = new CsvFileParserImpl();
        shipStoreImpl = new ShipStoreImpl(shipMapperImpl, new DatabaseConnectionImpl(new ApplicationPropertiesHelperImpl()));
    }

    /**
     * Tests if a valid file yields the expected objects
     * @throws IOException
     * @throws ParseException
     */
    @Test
    public void valid_InputContent_ShouldReturn_ExpectedObjects() throws IOException, ParseException {
        // Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/sships.csv"; //mine does not identify only by /resources/file.csv

        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);
        List<Ship> expected = shipMapperImpl.mapShipFromCsvContent(csvParsedFileContent);

        // Act
        shipStoreImpl.importShipsFromCsv(csvParsedFileContent);
        AVL<Ship> result = shipStoreImpl.getShips();


        // Assert
        assertNotNull(result); //MMSI


        for(Ship expectedShip : expected){
            Ship resultShip = result.find(expectedShip);

            assertNotNull(resultShip);

            AVL<PositionData> expectedPositionsData = expectedShip.getPositionsData();
            AVL<PositionData> resultPositionsData = resultShip.getPositionsData();

            assertEquals(expectedShip.getShipCharacteristics().getDraft(), resultShip.getShipCharacteristics().getDraft(), 0.0f);
            assertEquals(expectedShip.getIdTransport(), resultShip.getIdTransport());
            assertEquals(expectedShip.getCallSign(), resultShip.getCallSign());
            assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.getShipCharacteristics().getCapacity());
            assertEquals(expectedShip.getShipCharacteristics().getGenOutput(), resultShip.getShipCharacteristics().getGenOutput());
            assertEquals(expectedShip.getImoNumber(), resultShip.getImoNumber());
            assertEquals(expectedShip.getShipCharacteristics().getLength(), resultShip.getShipCharacteristics().getLength());
            assertEquals(expectedShip.getMmsi(), resultShip.getMmsi());
            assertEquals(expectedShip.getShipCharacteristics().getNumGen(), resultShip.getShipCharacteristics().getNumGen());
            assertEquals(expectedShip.getShipCharacteristics().getVessalType(), resultShip.getShipCharacteristics().getVessalType());
            assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.getShipCharacteristics().getCapacity());
            assertEquals(expectedShip.getShipCharacteristics().getWidth(), resultShip.getShipCharacteristics().getWidth());
            assertNotNull(resultShip.getPositionsData());

            for(PositionData expectedPositionData : expectedPositionsData.inOrder()){
                PositionData resultPositionData = resultPositionsData.find(expectedPositionData);

                assertNotNull(resultPositionData);
                assertEquals( expectedPositionData.getDateTimeReceived(), resultPositionData.getDateTimeReceived());
                assertEquals(expectedPositionData.getPositionDataVelocity().getCog(), resultPositionData.getPositionDataVelocity().getCog(), 0.0f);
                assertEquals(expectedPositionData.getHeading(), resultPositionData.getHeading());
                assertEquals( expectedPositionData.getLatitude(), resultPositionData.getLatitude(), 0.0f);
                assertEquals(expectedPositionData.getLongitude(), resultPositionData.getLongitude(), 0.0f);
                assertEquals(expectedPositionData.getIdShip(), resultPositionData.getIdShip());
                assertEquals(expectedPositionData.getPositionDataVelocity().getSog(), resultPositionData.getPositionDataVelocity().getSog(), 0.0f);
                assertEquals(expectedPositionData.getTransceiverClass(), resultPositionData.getTransceiverClass());
            }

        }

        writeAvlTreeToOutputTestFileAndConsoleOutput(result,System.getProperty("user.dir") + "/src/test/resources/output/output_file_integration_test.csv");
    }

    /**
     * Prints to the console and writes to a file the content of the AVL Tree for the integration test
     * @param ships AVL Tree containing Ship objects
     * @param newFilePath FilePath of the Output file
     * @throws IOException
     */
    private void writeAvlTreeToOutputTestFileAndConsoleOutput(AVL<Ship> ships, String newFilePath) throws IOException {
        //newFilePath = System.getProperty("user.dir") + "/resources/output_file_integration_test.csv";
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("MMSI,BaseDateTime,LAT,LON,SOG,COG,Heading,VesselName,IMO,CallSign,VesselType,Length,Width,Draft,Cargo,TranscieverClass\n");

            for(Ship ship : ships.inOrder()){
                for(PositionData positionData: ship.getPositionsData().inOrder()){
                    fileOutputLine.append(ship.getMmsi()+ ",");
                    fileOutputLine.append(positionData.getDateTimeReceived()+ ",");
                    fileOutputLine.append(positionData.getLatitude()+ ",");
                    fileOutputLine.append(positionData.getLatitude()+ ",");
                    fileOutputLine.append(positionData.getPositionDataVelocity().getSog()+ ",");
                    fileOutputLine.append(positionData.getPositionDataVelocity().getCog() + ",");
                    fileOutputLine.append(positionData.getHeading() + ",");
                    fileOutputLine.append(ship.getName() + ",");
                    fileOutputLine.append("IMO" + ship.getImoNumber() + ",");
                    fileOutputLine.append(ship.getCallSign() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getVessalType() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getLength() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getWidth() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getDraft() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getCapacity() + ",");
                    fileOutputLine.append(positionData.getTransceiverClass() + ",");

                    myWriter.write(fileOutputLine.toString() + "\n");
                    System.out.println(fileOutputLine.toString() + "\n");

                    fileOutputLine = new StringBuilder();
                }
            }
        }
    }

    /**
     * As the above test, this one checks if the AVLs
     * ordered by IMO and by CallSign are created.
     *
     * @throws IOException
     * @throws ParseException
     */
    @Test
    public void validInput_ShouldBuild_TwoAVLs() throws IOException, ParseException {
        // Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/sships.csv"; //mine does not identify only by /resources/file.csv

        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);
        List<Ship> expected = shipMapperImpl.mapShipFromCsvContent(csvParsedFileContent);

        // Act
        shipStoreImpl.importShipsFromCsv(csvParsedFileContent);
        AVL<Ship> resultIMO = shipStoreImpl.getShipsIMO(); //IMO
        AVL<Ship> resultCallSign = shipStoreImpl.getShipsCallSign(); //CallSign

        // Assert
        assertNotNull(resultIMO); //IMO
        assertNotNull(resultCallSign); //CallSign

        //Asserts for the IMO AVL Tree
        for(Ship expectedShip : expected){
            Ship resultShip = resultIMO.find(expectedShip);

            assertNotNull(resultShip);

            AVL<PositionData> expectedPositionsData = expectedShip.getPositionsData();
            AVL<PositionData> resultPositionsData = resultShip.getPositionsData();

            assertEquals(expectedShip.getShipCharacteristics().getDraft(), resultShip.getShipCharacteristics().getDraft(), 0.0f);
            assertEquals(expectedShip.getIdTransport(), resultShip.getIdTransport());
            assertEquals(expectedShip.getCallSign(), resultShip.getCallSign());
            assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.getShipCharacteristics().getCapacity());
            assertEquals(expectedShip.getShipCharacteristics().getGenOutput(), resultShip.getShipCharacteristics().getGenOutput());
            assertEquals(expectedShip.getImoNumber(), resultShip.getImoNumber());
            assertEquals(expectedShip.getShipCharacteristics().getLength(), resultShip.getShipCharacteristics().getLength());
            assertEquals(expectedShip.getMmsi(), resultShip.getMmsi());
            assertEquals(expectedShip.getShipCharacteristics().getNumGen(), resultShip.getShipCharacteristics().getNumGen());
            assertEquals(expectedShip.getShipCharacteristics().getVessalType(), resultShip.getShipCharacteristics().getVessalType());
            assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.getShipCharacteristics().getCapacity());
            assertEquals(expectedShip.getShipCharacteristics().getWidth(), resultShip.getShipCharacteristics().getWidth());
            assertNotNull(resultShip.getPositionsData());

            for(PositionData expectedPositionData : expectedPositionsData.inOrder()){
                PositionData resultPositionData = resultPositionsData.find(expectedPositionData);

                assertNotNull(resultPositionData);
                assertEquals( expectedPositionData.getDateTimeReceived(), resultPositionData.getDateTimeReceived());
                assertEquals(expectedPositionData.getPositionDataVelocity().getCog(), resultPositionData.getPositionDataVelocity().getCog(), 0.0f);
                assertEquals(expectedPositionData.getHeading(), resultPositionData.getHeading());
                assertEquals( expectedPositionData.getLatitude(), resultPositionData.getLatitude(), 0.0f);
                assertEquals(expectedPositionData.getLongitude(), resultPositionData.getLongitude(), 0.0f);
                assertEquals(expectedPositionData.getIdShip(), resultPositionData.getIdShip());
                assertEquals(expectedPositionData.getPositionDataVelocity().getSog(), resultPositionData.getPositionDataVelocity().getSog(), 0.0f);
                assertEquals(expectedPositionData.getTransceiverClass(), resultPositionData.getTransceiverClass());
            }

        }

        writeAvlTreeToOutputTestFileAndConsoleOutput(resultIMO,System.getProperty("user.dir") + "/src/test/resources/output/output_file_integration_test_AVL_IMO.csv");

        //Asserts for the CallSign AVL Tree
        for(Ship expectedShip : expected){
            Ship resultShip = resultCallSign.find(expectedShip);

            assertNotNull(resultShip);

            AVL<PositionData> expectedPositionsData = expectedShip.getPositionsData();
            AVL<PositionData> resultPositionsData = resultShip.getPositionsData();

            assertEquals(expectedShip.getShipCharacteristics().getDraft(), resultShip.getShipCharacteristics().getDraft(), 0.0f);
            assertEquals(expectedShip.getIdTransport(), resultShip.getIdTransport());
            assertEquals(expectedShip.getCallSign(), resultShip.getCallSign());
            assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.getShipCharacteristics().getCapacity());
            assertEquals(expectedShip.getShipCharacteristics().getGenOutput(), resultShip.getShipCharacteristics().getGenOutput());
            assertEquals(expectedShip.getImoNumber(), resultShip.getImoNumber());
            assertEquals(expectedShip.getShipCharacteristics().getLength(), resultShip.getShipCharacteristics().getLength());
            assertEquals(expectedShip.getMmsi(), resultShip.getMmsi());
            assertEquals(expectedShip.getShipCharacteristics().getNumGen(), resultShip.getShipCharacteristics().getNumGen());
            assertEquals(expectedShip.getShipCharacteristics().getVessalType(), resultShip.getShipCharacteristics().getVessalType());
            assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.getShipCharacteristics().getCapacity());
            assertEquals(expectedShip.getShipCharacteristics().getWidth(), resultShip.getShipCharacteristics().getWidth());
            assertNotNull(resultShip.getPositionsData());

            for(PositionData expectedPositionData : expectedPositionsData.inOrder()){
                PositionData resultPositionData = resultPositionsData.find(expectedPositionData);

                assertNotNull(resultPositionData);
                assertEquals( expectedPositionData.getDateTimeReceived(), resultPositionData.getDateTimeReceived());
                assertEquals(expectedPositionData.getPositionDataVelocity().getCog(), resultPositionData.getPositionDataVelocity().getCog(), 0.0f);
                assertEquals(expectedPositionData.getHeading(), resultPositionData.getHeading());
                assertEquals( expectedPositionData.getLatitude(), resultPositionData.getLatitude(), 0.0f);
                assertEquals(expectedPositionData.getLongitude(), resultPositionData.getLongitude(), 0.0f);
                assertEquals(expectedPositionData.getIdShip(), resultPositionData.getIdShip());
                assertEquals(expectedPositionData.getPositionDataVelocity().getSog(), resultPositionData.getPositionDataVelocity().getSog(), 0.0f);
                assertEquals(expectedPositionData.getTransceiverClass(), resultPositionData.getTransceiverClass());
                assertEquals(expectedPositionData.getPosition(), resultPositionData.getPosition());
            }

        }

        writeAvlTreeToOutputTestFileAndConsoleOutput(resultCallSign,System.getProperty("user.dir") + "/src/test/resources/output/output_file_integration_test_AVL_CallSign.csv");
    }

    @Test
    public void valid_InputMMSI_ShouldReturn_ExpectedObject() throws IOException, ParseException {
        // Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/sships.csv"; //mine does not identify only by /resources/file.csv

        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);

        Ship expected = new Ship(1, 210950000, "C4SQ2", "VARAMO", 9395044, new ShipCharacteristics(0,0, "70", 166,25, 0, 9.5f), null);

        // Act
        shipStoreImpl.importShipsFromCsv(csvParsedFileContent);
        Ship result = shipStoreImpl.getShipByMMSI(expected.getMmsi());


        // Assert
        assertNotNull(result);
        assertEquals(expected.getShipCharacteristics().getDraft(), result.getShipCharacteristics().getDraft(), 0.0f);
        assertEquals(expected.getIdTransport(), result.getIdTransport());
        assertEquals(expected.getCallSign(), result.getCallSign());
        assertEquals(expected.getShipCharacteristics().getCapacity(), result.getShipCharacteristics().getCapacity());
        assertEquals(expected.getShipCharacteristics().getGenOutput(), result.getShipCharacteristics().getGenOutput());
        assertEquals(expected.getImoNumber(), result.getImoNumber());
        assertEquals(expected.getShipCharacteristics().getLength(), result.getShipCharacteristics().getLength());
        assertEquals(expected.getMmsi(), result.getMmsi());
        assertEquals(expected.getShipCharacteristics().getNumGen(), result.getShipCharacteristics().getNumGen());
        assertEquals(expected.getShipCharacteristics().getVessalType(), result.getShipCharacteristics().getVessalType());
        assertEquals(expected.getShipCharacteristics().getCapacity(), result.getShipCharacteristics().getCapacity());
        assertEquals(expected.getShipCharacteristics().getWidth(), result.getShipCharacteristics().getWidth());
    }

    /*
    @Test
    public void valid_requestForAvailableShipsNextWeek_ShouldExecute() throws SQLException, IOException {
        // Arrange
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_query_availableships_nextweek.csv";

        //Act
        List<ShipAvailableDTO> result = shipStoreImpl.getAvailableShipsNextWeek();

        // Assert
        writeContainerSituationOutputToFile(result, filePathOutput);
    }

    private void writeContainerSituationOutputToFile(List<ShipAvailableDTO> listOfAvailableShips, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("SHIPMMSI, SHIPNAME, LOCATIONDESCRIPTION, LOCATIONLATITUDE, LOCATIONLONGITUDE\n");

            for(ShipAvailableDTO availableShip : listOfAvailableShips){
                fileOutputLine.append(availableShip.getShipMMSI() + ",");
                fileOutputLine.append(availableShip.getShipName() + ",");
                fileOutputLine.append(availableShip.getLocationDescription()+ ",");
                fileOutputLine.append(availableShip.getLocationLatitude()+ ",");
                fileOutputLine.append(availableShip.getLocationLongitude());
                myWriter.write(fileOutputLine.toString() + "\n");
                System.out.println(fileOutputLine.toString() + "\n");
                fileOutputLine = new StringBuilder();
            }
        }
    }*/

    /*
    @Test
    public void valid_OccupancyRate_ShouldExecute() throws SQLException, IOException, SQLException {
        // Arrange
        FileReader fileReaderImpl = new FileReaderImpl();
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputQueryOccupancyRateWithoutDate.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_query_Occupancy_Rate_Without_Date.csv";
        String shipID = fileReaderImpl.readFile(filePathInput).get(0);
        String cargoManifestID = fileReaderImpl.readFile(filePathInput).get(1);

        //Act
        float result = shipStoreImpl.occupancyRate(Integer.parseInt(shipID),Integer.parseInt(cargoManifestID));

        // Assert
        writeOccupancyRateOutputToFile(result, filePathOutput);
    }*/
    /*
    @Test
    public void valid_getOccupancyRateAtGivenMoment_ShouldExecute() throws SQLException, IOException, SQLException {
        // Arrange
        FileReader fileReaderImpl = new FileReaderImpl();
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputQueryOccupancyRateWithDate.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_query_Occupancy_Rate_With_Date.csv";
        String shipID = fileReaderImpl.readFile(filePathInput).get(0);
        String[] moment = fileReaderImpl.readFile(filePathInput).get(1).split("/");

        //Act
        float result = shipStoreImpl.getOccupancyRateAtGivenMoment(Integer.parseInt(shipID), LocalDate.of(Integer.parseInt(moment[2]),Integer.parseInt(moment[1]),Integer.parseInt(moment[0])));

        // Assert
        writeOccupancyRateOutputToFile(result, filePathOutput);
    }*/
    /*
    private void writeOccupancyRateOutputToFile(float result, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();
        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("OccupancyPercentage\n");
            fileOutputLine.append(result);

            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }*/
}
