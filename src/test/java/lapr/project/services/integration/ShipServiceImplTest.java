package lapr.project.services.integration;

import lapr.project.mappers.ShipMapperImpl;
import lapr.project.mappers.dtos.*;
import lapr.project.model.PositionData;
import lapr.project.model.PositionDataVelocity;
import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.services.ShipServiceImpl;
import lapr.project.services.ShipServiceLogic;
import lapr.project.services.ShipServiceLogicImpl;
import lapr.project.stores.ShipStoreImpl;
import lapr.project.utils.datastructures.AVL;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.*;
import org.junit.jupiter.api.Test;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

import java.util.Date;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class ShipServiceImplTest {
    private final ShipMapperImpl shipMapperImpl;
    private final ShipServiceImpl shipServiceImpl;
    private ShipServiceLogic shipServiceLogicImpl;
    private ShipStoreImpl shipStoreImpl;
    private FileReaderImpl fileReaderImpl;
    private CsvFileParserImpl csvFileParserImpl;

    public ShipServiceImplTest() throws IOException {
        this.shipMapperImpl = new ShipMapperImpl();
        this.shipServiceLogicImpl = new ShipServiceLogicImpl();
        this.fileReaderImpl = new FileReaderImpl();
        this.csvFileParserImpl = new CsvFileParserImpl();
        this.shipStoreImpl = new ShipStoreImpl(shipMapperImpl, new DatabaseConnectionImpl(new ApplicationPropertiesHelperImpl()));
        this.shipServiceImpl = new ShipServiceImpl(shipStoreImpl, shipMapperImpl, shipServiceLogicImpl);
    }

    /**
     * Tests if a valid file yields the expected objects
     * @throws IOException
     * @throws ParseException
     */
    @Test
    public void valid_InputContent_WithTwoDates_ShouldReturn_ExpectedObjects() throws ParseException, IOException {
        //Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/sships.csv";
        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);
        shipStoreImpl.importShipsFromCsv(csvParsedFileContent);

        Timestamp initDate = Utilities.convertFromDateStringToTimeStamp("30/12/2020 23:59");
        Timestamp endDate = Utilities.convertFromDateStringToTimeStamp("31/12/2020 09:17");

        //Act
        AVL<Ship> filtered = shipServiceImpl.getShipBetweenDateInterval(initDate,endDate);

        for (Ship fShip: filtered.inOrder()) {
            for (PositionData fPosition:fShip.getPositionsData().inOrder()) {
                assertEquals(true, (initDate.before(fPosition.getDateTimeReceived())));
                assertEquals(true, (endDate.after(fPosition.getDateTimeReceived())));
            }
        }

        writeAvlTreeToOutputTestFileAndConsoleOutput(filtered,System.getProperty("user.dir") + "/src/test/resources/output/output_file_DataFilterPeriod_integration_test.csv");
    }

    /**
     * Tests if a valid file yields the expected objects
     * @throws IOException
     * @throws ParseException
     */
    @Test
    public void valid_InputContent_WithOneDate_ShouldReturn_ExpectedObjects() throws ParseException, IOException {
        //Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/sships.csv"; //mine does not identify only by /resources/file.csv
        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);
        shipStoreImpl.importShipsFromCsv(csvParsedFileContent);

        Timestamp initDate = Utilities.convertFromDateStringToTimeStamp("30/12/2020 23:59");
        Timestamp endDate = null;
        Instant instant = Instant.from(initDate.toInstant()).plus(24, ChronoUnit.HOURS);
        Timestamp dayAfter = Timestamp.from(instant);
        //Act
        AVL<Ship> filtered = shipServiceImpl.getShipBetweenDateInterval(initDate,endDate);

        for (Ship fShip: filtered.inOrder()) {
            for (PositionData fPosition:fShip.getPositionsData().inOrder()) {
                assertEquals(true, (initDate.before(fPosition.getDateTimeReceived())));
                assertEquals(true, (dayAfter.after(fPosition.getDateTimeReceived())));
            }
        }

        writeAvlTreeToOutputTestFileAndConsoleOutput(filtered,System.getProperty("user.dir") + "/src/test/resources/output/output_file_DataFilterDate_integration_test.csv");
    }

    /**
     * Prints to the console and writes to a file the content of the AVL Tree for the integration test
     * @param ships AVL Tree containing Ship objects
     * @param newFilePath FilePath of the Output file
     * @throws IOException
     */
    private void writeAvlTreeToOutputTestFileAndConsoleOutput(AVL<Ship> ships, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("MMSI,BaseDateTime,LAT,LON,SOG,COG,Heading,VesselName,IMO,CallSign,VesselType,Length,Width,Draft,Cargo,TranscieverClass\n");

            for(Ship ship : ships.inOrder()){
                for(PositionData positionData: ship.getPositionsData().inOrder()){
                    fileOutputLine.append(ship.getMmsi()+ ",");
                    fileOutputLine.append(positionData.getDateTimeReceived()+ ",");
                    fileOutputLine.append(positionData.getLatitude()+ ",");
                    fileOutputLine.append(positionData.getLongitude()+ ",");
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

    @Test
    public void valid_InputFile_ShouldReturn_ExpectedObject() throws IOException, ParseException {
        // Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/input/inputTestShipMovementSummary.csv";
        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedContent = csvFileParserImpl.parseToCsv(fileContent);
        shipStoreImpl.importShipsFromCsv(csvParsedContent);

        MovementSummaryMetricsDTO movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(19.7f, 17.2f, 157.5f, 151.75f);

        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(43.53f, 110.55f,
                44.39094f, 133.71335f, 4822, 1850);

        MovementSummaryDTO expected = new MovementSummaryDTO(20, 4,
                movementSummaryMetricsDTO, movementSummaryDistancesDTO,
                new Date(1609305000000l), new Date(1609306200000l));

        // Act
        ShipMovementSummaryDTO result = shipServiceImpl.getShipMovementSummary(211331640);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getTotalMovementTime(), result.getMovementSummaryDTO().getTotalMovementTime());
        assertEquals(expected.getMovementSummaryDistancesDTO().getTravelledDistance(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getTravelledDistance(), 1.0f);
        assertEquals(expected.getMovementSummaryDistancesDTO().getDeltaDistance(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDeltaDistance(), 1.0f);
        assertEquals(expected.getMovementSummaryMetricsDTO().getMaxSOG(), result.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMaxSOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMeanSOG(), result.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMeanSOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMaxCOG(), result.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMaxCOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMeanCOG(), result.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMeanCOG());
        assertEquals(expected.getTotalNumberOfMovements(), result.getMovementSummaryDTO().getTotalNumberOfMovements());
        assertEquals(expected.getMovementSummaryDistancesDTO().getDepartureLatitude(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDepartureLatitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getDepartureLongitude(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDepartureLongitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getArrivalLatitude(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getArrivalLatitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getArrivalLongitude(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getArrivalLongitude());
        assertEquals(211331640, result.getMmsi());
        assertEquals("SEOUL EXPRESS", result.getVesselName());
        assertEquals(expected.getStartDate().getTime(), result.getMovementSummaryDTO().getStartDate().getTime());
        assertEquals(expected.getEndDate().getTime(), result.getMovementSummaryDTO().getEndDate().getTime());

        writeShipSummaryOutputToFile(result, System.getProperty("user.dir") + "/src/test/resources/output/output_test_ship_movement_summary.csv");
    }

    @Test
    public void invalid_ShipMMSI_ShouldReturn_NullResponse() throws IOException, ParseException {
        // Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/input/inputTestShipMovementSummary.csv";
        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedContent = csvFileParserImpl.parseToCsv(fileContent);
        shipStoreImpl.importShipsFromCsv(csvParsedContent);

        // Act
        ShipMovementSummaryDTO result = shipServiceImpl.getShipMovementSummary(Integer.MIN_VALUE);

        // Assert
        assertNull(result);
    }

    private void writeShipSummaryOutputToFile(ShipMovementSummaryDTO shipMovementSummaryDTO, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("MMSI,VesselName,TravelledDistance,DeltaDistance,MaxSOG,MeanSOG,MaxCOG,MeanCOG,TotalNumberOfMovements,TotalMovementTime,DepartureLatitude,DepartureLongitude,ArrivalLatitude,ArrivalLongitude\n");

            fileOutputLine.append(shipMovementSummaryDTO.getMmsi() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getVesselName() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getTravelledDistance() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDeltaDistance() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMaxSOG() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMeanSOG() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMaxCOG() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMeanCOG() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getTotalNumberOfMovements() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getTotalMovementTime() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDepartureLatitude() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDepartureLongitude() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getArrivalLatitude() + ",");
            fileOutputLine.append(shipMovementSummaryDTO.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getArrivalLongitude() + ",");

            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }

    @Test
    public void valid_InputFile_ShouldReturn_ExpectedObject_ShipDTO_OrderedMovement() throws IOException, ParseException {
        // Arrange
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputShipDTOOrderMoveTest.csv";
        List<String> fileContent = fileReaderImpl.readFile(filePathInput);
        List<List<String>> csvParsedContent = csvFileParserImpl.parseToCsv(fileContent);
        shipStoreImpl.importShipsFromCsv(csvParsedContent);

        ShipDTO one = shipMapperImpl.mapToShipDTO(210950000,25,58.87491f,58.868515f);
        ShipDTO two = shipMapperImpl.mapToShipDTO(212180000,5,54.07717f,54.033222f);
        ShipDTO three = shipMapperImpl.mapToShipDTO(212351000,1,0,0);

        AVL<ShipDTO> expected = new AVL<>();
        expected.insert(one);
        expected.insert(two);
        expected.insert(three);

        // Act
        AVL<ShipDTO> result = shipServiceImpl.getShipByMovementOrder();

        // Assert
        assertNotNull(result);
        for (ShipDTO ashipResult: result.inOrder()) {
            ShipDTO expectedobj = expected.find(ashipResult);
            assertEquals(expectedobj.getMmsi(), ashipResult.getMmsi());
            assertEquals(expectedobj.getTotalMoves(), ashipResult.getTotalMoves());
            assertEquals(expectedobj.getTravelDistance(), ashipResult.getTravelDistance());
            assertEquals(expectedobj.getDeltaDistance(), ashipResult.getDeltaDistance());
        }


        writeShipDTOOrderedMovOutputToFile(result, System.getProperty("user.dir") + "/src/test/resources/output/output_test_shipDTO_ordered_movement.csv");
    }

    private void writeShipDTOOrderedMovOutputToFile(AVL<ShipDTO> shipDTO, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("MMSI,totalMoves,travelDistance,deltaDistance\n");
            for (ShipDTO aship: shipDTO.inOrder()) {
                fileOutputLine.append(aship.getMmsi() + ",");
                fileOutputLine.append(aship.getTotalMoves() + ",");
                fileOutputLine.append(aship.getTravelDistance() + ",");
                fileOutputLine.append(aship.getDeltaDistance() + ",");

                myWriter.write(fileOutputLine.toString() + "\n");
                System.out.println(fileOutputLine.toString() + "\n");

                fileOutputLine = new StringBuilder();
            }
        }
    }

    @Test
    public void valid_getPairsOfShipsWithCloseOriginAndDestination_ExpectedResults() throws ParseException, IOException {
        // Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/input/inputPairOfShipsTest.csv"; //mine does not identify only by /resources/file.csv

        FileReaderImpl fileReaderImpl = new FileReaderImpl();
        CsvFileParserImpl csvFileParserImpl = new CsvFileParserImpl();
        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);
        shipStoreImpl.importShipsFromCsv(csvParsedFileContent);

        // Act
        Map<ShipDTO, AVL<ShipPairDTO>> result = shipServiceImpl.getPairsOfShipsWithCloseOriginAndDestination();

        // Assert
        assertEquals(2, result.size());
        assertEquals(1, result.get(new ShipDTO(210950000,1,1,1)).size());
        assertEquals(1, result.get(new ShipDTO(210954732,1,1,1)).size());

        //Write Output
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(System.getProperty("user.dir") + "/src/test/resources/output/output_test_getPairsOfShipsWithCloseOriginAndDestination.csv")){
            myWriter.write("Ship1MMSI,Ship1TotalMoves,Ship1TravelDistance,Ship2MMSI,Ship2DistOrigin,Ship2DistDestination,Ship2TotalMoves,Ship2TravelDistance,\n");

            for (Map.Entry<ShipDTO, AVL<ShipPairDTO>> entry : result.entrySet()) {
                for (ShipPairDTO ship:entry.getValue().inOrder()) {
                    //Add ship base
                    fileOutputLine.append(entry.getKey().getMmsi() + "," + entry.getKey().getTotalMoves() + "," + entry.getKey().getTravelDistance() + ",");

                    //Add Ship to compare
                    fileOutputLine.append(ship.getMmsi() + "," + ship.getOriginDistance() + "," + ship.getDestinationDistance() + "," + ship.getTotalMoves() + "," + ship.getTravelDistance() + "\n");
                }
            }
            
            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }

    @Test
    public void validInput_ShouldReturn_TopNShips() throws IOException, ParseException {
        // Arrange
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputTopNShipsTest.csv";
        List<String> InputFileContent = fileReaderImpl.readFile(filePathInput);
        int N = Integer.parseInt(InputFileContent.get(0)); //for this test we considered n = 3
        Timestamp initTime = Utilities.convertFromDateStringToTimeStamp(InputFileContent.get(1));
        Timestamp finalTime = Utilities.convertFromDateStringToTimeStamp(InputFileContent.get(2));

        String filePath = System.getProperty("user.dir") + "/src/test/resources/input/inputTopNShipsData.csv"; //mine does not identify only by /resources/file.csv
        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);
        shipStoreImpl.importShipsFromCsv(csvParsedFileContent);

        String outputFilePath = System.getProperty("user.dir") + "/src/test/resources/output/outputTopNShips.csv";


        ShipTravelDTO one = shipMapperImpl.mapToShipTravelDTO(305373000,138.59425f,7.8f,"70");
        ShipTravelDTO two = shipMapperImpl.mapToShipTravelDTO(228339600,80.89159f,11.727778f,"70");
        ShipTravelDTO three = shipMapperImpl.mapToShipTravelDTO(257881000,78.95917f,12.483334f,"70");

        // Act
        Map<String,List<ShipTravelDTO>> result = (shipServiceImpl.getTopNShipsTravelledDistanceAndMSOG(N,initTime,finalTime));
        writeShipTravelDTOMapOutputToFile(result, outputFilePath);
        ShipTravelDTO one_a = result.entrySet().iterator().next().getValue().get(0);
        ShipTravelDTO two_a = result.entrySet().iterator().next().getValue().get(1);
        ShipTravelDTO three_a = result.entrySet().iterator().next().getValue().get(2);

        // Assert
        assertEquals(one,one_a);
        assertEquals(two,two_a);
        assertEquals(three,three_a);
    }

    @Test
    public void validInput_ShouldReturn_ExpectedPositionData_ForTimeStamp() throws IOException, ParseException {
        // Arrange
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputShipsCallSignNearestPort.csv";
        List<String> InputFileContent = fileReaderImpl.readFile(filePathInput);
        String callSign = InputFileContent.get(0);
        Timestamp givenTime = Utilities.convertFromDateStringToTimeStamp(InputFileContent.get(1));

        String filePathShips = System.getProperty("user.dir") + "/src/test/resources/sships.csv";
        List<String> fileContentShips = fileReaderImpl.readFile(filePathShips);
        List<List<String>> csvParsedFileContentShips = csvFileParserImpl.parseToCsv(fileContentShips);
        shipStoreImpl.importShipsFromCsv(csvParsedFileContentShips);

        String outputFilePath = System.getProperty("user.dir") + "/src/test/resources/output/outputPositionDataForTimeStamp.csv";

        PositionData expected = shipStoreImpl.getShipsCallSign().find(
                new Ship(-1,-1,callSign,null,-1, new ShipCharacteristics( -1,-1,null,-1,-1,-1,-1),null))
                .getPositionsData().find(new PositionData(-1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 00:20"),
                0.0f,0.0f,new PositionDataVelocity(0.0f,	0.0f),0,0, 'B'));


        // Act
        PositionData result = shipServiceImpl.getPositionDataForGivenTime(callSign,givenTime);
        writePositionDataOutputFile(result,outputFilePath);

        // Assert
        assertEquals(expected,result);
    }

    private void writePositionDataOutputFile(PositionData positionData, String outputFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();
        try (FileWriter myWriter = new FileWriter(outputFilePath)){
            myWriter.write("BaseDateTime,LAT,LON,SOG,COG,Heading,TranscieverClass\n");
            fileOutputLine.append(positionData.getDateTimeReceived()+ ",");
            fileOutputLine.append(positionData.getLatitude()+ ",");
            fileOutputLine.append(positionData.getLongitude()+ ",");
            fileOutputLine.append(positionData.getPositionDataVelocity().getSog()+ ",");
            fileOutputLine.append(positionData.getPositionDataVelocity().getCog() + ",");
            fileOutputLine.append(positionData.getHeading() + ",");
            fileOutputLine.append(positionData.getTransceiverClass() + ",");

            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }

    private void writeShipTravelDTOMapOutputToFile(Map<String,List<ShipTravelDTO>> shipTravelDTOMap, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("VesselType,MMSI,travelDistance,MeanSOG\n");
            for (Map.Entry<String,List<ShipTravelDTO>> entry : shipTravelDTOMap.entrySet())
                for (ShipTravelDTO shipT: entry.getValue()) {
                    fileOutputLine.append(entry.getKey() + ",");
                    fileOutputLine.append(shipT.getMmsi() + ",");
                    fileOutputLine.append(shipT.getTravelDistance() + ",");
                    fileOutputLine.append(shipT.getMeanSOG());
                    myWriter.write(fileOutputLine.toString() + "\n");
                    System.out.println(fileOutputLine.toString() + "\n");
                    fileOutputLine = new StringBuilder();
                }
        }
    }
}
