package lapr.project.mappers;

import lapr.project.mappers.dtos.*;
import lapr.project.model.PositionData;
import lapr.project.model.PositionDataVelocity;
import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.utils.datastructures.AVL;
import lapr.project.utils.utilities.Utilities;
import org.junit.jupiter.api.Test;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class ShipMapperImplTest {
    private ShipMapperImpl shipMapperImpl;

    public ShipMapperImplTest(){
        shipMapperImpl = new ShipMapperImpl();
    }

    @Test
    public void invalid_NullArgument_ShouldThrow_IllegalArgumentException(){
        // Arrange
        List<List<String>> nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  shipMapperImpl.mapShipFromCsvContent(nullArgument));
    }

    @Test
    public void valid_CsvLineContent_ShouldReturn_ExpectedResult() throws ParseException {
        // Arrange
        PositionData expectedPositionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        AVL<PositionData> positionDataAVL = new AVL<>();
        positionDataAVL.insert(expectedPositionData);

        Ship expectedShip = new Ship(1, 211331640, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), positionDataAVL);

        // Act
        List<Ship> resultShip = shipMapperImpl.mapShipFromCsvContent(buildCsvContent(false));
        PositionData resultPositionData = resultShip.get(0).getPositionsData().find(expectedPositionData);

        // Assert

        assertNotNull(resultShip);
        assertEquals(expectedShip.getShipCharacteristics().getDraft(), resultShip.get(0).getShipCharacteristics().getDraft(), 0.0f);
        assertEquals(expectedShip.getIdTransport(), resultShip.get(0).getIdTransport());
        assertEquals(expectedShip.getCallSign(), resultShip.get(0).getCallSign());
        assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.get(0).getShipCharacteristics().getCapacity());
        assertEquals(expectedShip.getShipCharacteristics().getGenOutput(), resultShip.get(0).getShipCharacteristics().getGenOutput());
        assertEquals(expectedShip.getImoNumber(), resultShip.get(0).getImoNumber());
        assertEquals(expectedShip.getShipCharacteristics().getLength(), resultShip.get(0).getShipCharacteristics().getLength());
        assertEquals(expectedShip.getMmsi(), resultShip.get(0).getMmsi());
        assertEquals(expectedShip.getShipCharacteristics().getNumGen(), resultShip.get(0).getShipCharacteristics().getNumGen());
        assertEquals(expectedShip.getShipCharacteristics().getVessalType(), resultShip.get(0).getShipCharacteristics().getVessalType());
        assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.get(0).getShipCharacteristics().getCapacity());
        assertEquals(expectedShip.getShipCharacteristics().getWidth(), resultShip.get(0).getShipCharacteristics().getWidth());
        assertNotNull(resultShip.get(0).getPositionsData());
        assertEquals(expectedPositionData.getPositionDataVelocity().getCog(), resultPositionData.getPositionDataVelocity().getCog(), 0.0f);
        assertEquals(expectedPositionData.getDateTimeReceived(), resultPositionData.getDateTimeReceived());
        assertEquals(expectedPositionData.getHeading(), resultPositionData.getHeading());
        assertEquals(expectedPositionData.getLatitude(), resultPositionData.getLatitude(), 0.0f);
        assertEquals(expectedPositionData.getLongitude(), resultPositionData.getLongitude(), 0.0f);
        assertEquals(expectedPositionData.getIdShip(), resultPositionData.getIdShip());
        assertEquals(expectedPositionData.getPositionDataVelocity().getSog(), resultPositionData.getPositionDataVelocity().getSog(), 0.0f);
        assertEquals(expectedPositionData.getTransceiverClass(), resultPositionData.getTransceiverClass());
    }

    @Test
    public void valid_CsvLineContentWithHeaderLine_ShouldReturn_ExpectedResult() throws ParseException {
        // Arrange
        PositionData expectedPositionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        AVL<PositionData> positionDataAVL = new AVL<>();
        positionDataAVL.insert(expectedPositionData);

        Ship expectedShip = new Ship(1, 211331640, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), positionDataAVL);

        // Act
        List<Ship> resultShip = shipMapperImpl.mapShipFromCsvContent(buildCsvContent(true));
        PositionData resultPositionData = resultShip.get(0).getPositionsData().find(expectedPositionData);

        // Assert

        assertNotNull(resultShip);
        assertEquals(expectedShip.getShipCharacteristics().getDraft(), resultShip.get(0).getShipCharacteristics().getDraft(), 0.0f);
        assertEquals(expectedShip.getIdTransport(), resultShip.get(0).getIdTransport());
        assertEquals(expectedShip.getCallSign(), resultShip.get(0).getCallSign());
        assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.get(0).getShipCharacteristics().getCapacity());
        assertEquals(expectedShip.getShipCharacteristics().getGenOutput(), resultShip.get(0).getShipCharacteristics().getGenOutput());
        assertEquals(expectedShip.getImoNumber(), resultShip.get(0).getImoNumber());
        assertEquals(expectedShip.getShipCharacteristics().getLength(), resultShip.get(0).getShipCharacteristics().getLength());
        assertEquals(expectedShip.getMmsi(), resultShip.get(0).getMmsi());
        assertEquals(expectedShip.getShipCharacteristics().getNumGen(), resultShip.get(0).getShipCharacteristics().getNumGen());
        assertEquals(expectedShip.getShipCharacteristics().getVessalType(), resultShip.get(0).getShipCharacteristics().getVessalType());
        assertEquals(expectedShip.getShipCharacteristics().getCapacity(), resultShip.get(0).getShipCharacteristics().getCapacity());
        assertEquals(expectedShip.getShipCharacteristics().getWidth(), resultShip.get(0).getShipCharacteristics().getWidth());
        assertNotNull(resultShip.get(0).getPositionsData());
        assertEquals(expectedPositionData.getPositionDataVelocity().getCog(), resultPositionData.getPositionDataVelocity().getCog(), 0.0f);
        assertEquals(expectedPositionData.getDateTimeReceived(), resultPositionData.getDateTimeReceived());
        assertEquals(expectedPositionData.getHeading(), resultPositionData.getHeading());
        assertEquals(expectedPositionData.getLatitude(), resultPositionData.getLatitude(), 0.0f);
        assertEquals(expectedPositionData.getLongitude(), resultPositionData.getLongitude(), 0.0f);
        assertEquals(expectedPositionData.getIdShip(), resultPositionData.getIdShip());
        assertEquals(expectedPositionData.getPositionDataVelocity().getSog(), resultPositionData.getPositionDataVelocity().getSog(), 0.0f);
        assertEquals(expectedPositionData.getTransceiverClass(), resultPositionData.getTransceiverClass());
    }

    @Test
    public void valid_InputMovementSummaryDTO_ShouldReturn_ExpectedShipMovementSummaryDTO() throws ParseException {
        // Arrange
        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(43.53f, 110.55f,
                44.39094f, 133.71335f, 2789, 1849);

        MovementSummaryMetricsDTO movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(19.7f, 17.2f, 157.5f, 151.75f);

        MovementSummaryDTO movementSummary = new MovementSummaryDTO(20, 4,
                movementSummaryMetricsDTO,movementSummaryDistancesDTO,
                new Date(1609305000000l), new Date(1609306200000l));

        // Act
        ShipMovementSummaryDTO result = shipMapperImpl.mapToShipMovementSummary(211331640, "SEOUL EXPRESS", movementSummary);

        // Assert
        assertNotNull(result);
        assertEquals(movementSummary.getTotalMovementTime(), result.getMovementSummaryDTO().getTotalMovementTime());
        assertEquals(movementSummary.getMovementSummaryDistancesDTO().getTravelledDistance(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getTravelledDistance());
        assertEquals(movementSummary.getMovementSummaryDistancesDTO().getDeltaDistance(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDeltaDistance());
        assertEquals(movementSummary.getMovementSummaryMetricsDTO().getMaxSOG(), result.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMaxSOG());
        assertEquals(movementSummary.getMovementSummaryMetricsDTO().getMeanSOG(), result.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMeanSOG());
        assertEquals(movementSummary.getMovementSummaryMetricsDTO().getMaxCOG(), result.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMaxCOG());
        assertEquals(movementSummary.getMovementSummaryMetricsDTO().getMeanCOG(), result.getMovementSummaryDTO().getMovementSummaryMetricsDTO().getMeanCOG());
        assertEquals(movementSummary.getTotalNumberOfMovements(), result.getMovementSummaryDTO().getTotalNumberOfMovements());
        assertEquals(movementSummary.getMovementSummaryDistancesDTO().getDepartureLatitude(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDepartureLatitude());
        assertEquals(movementSummary.getMovementSummaryDistancesDTO().getDepartureLongitude(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getDepartureLongitude());
        assertEquals(movementSummary.getMovementSummaryDistancesDTO().getArrivalLatitude(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getArrivalLatitude());
        assertEquals(movementSummary.getMovementSummaryDistancesDTO().getArrivalLongitude(), result.getMovementSummaryDTO().getMovementSummaryDistancesDTO().getArrivalLongitude());
        assertEquals(movementSummary.getStartDate().getTime(), result.getMovementSummaryDTO().getStartDate().getTime());
        assertEquals(movementSummary.getEndDate().getTime(), result.getMovementSummaryDTO().getEndDate().getTime());
        assertEquals(211331640, result.getMmsi());
        assertEquals("SEOUL EXPRESS", result.getVesselName());
    }

    @Test
    public void Invalid_NullMovementSummaryArgument_ShouldThrow_IllegalArgumentException(){
        // Arrange
        MovementSummaryDTO nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipMapperImpl.mapToShipMovementSummary(1, "T", nullArgument));
    }

    @Test
    public void valid_InputArguments_ShouldReturn_ExpectedObject(){
        // Arrange
        ShipDTO expected = new ShipDTO(12222, 1, 1f, 2f);

        // Act
        ShipDTO result = shipMapperImpl.mapToShipDTO(12222,1,1f,2f);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getMmsi(), result.getMmsi());
        assertEquals(expected.getTotalMoves(), result.getTotalMoves());
        assertEquals(expected.getTravelDistance(), result.getTravelDistance());
        assertEquals(expected.getDeltaDistance(), result.getDeltaDistance());
    }
    @Test
    public void Invalid_NullShipName_ShouldThrow_IllegalArgumentException(){
        // Arrange
        String nullArgument = null;

        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(43.53f, 110.55f,
                44.39094f, 133.71335f, 2789, 1849);

        MovementSummaryMetricsDTO movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(19.7f, 17.2f, 157.5f, 151.75f);

        MovementSummaryDTO movementSummary = new MovementSummaryDTO(20, 4,
                movementSummaryMetricsDTO, movementSummaryDistancesDTO,
                new Date(), new Date());

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipMapperImpl.mapToShipMovementSummary(1, nullArgument, movementSummary));
    }

    private AVL<Ship> buildAVLContent() throws ParseException {
        AVL<Ship> shipBinarySearchTreeMMSI = new AVL<>();

        PositionData PositionData1 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 17:19"),
                42.97875f, -66.97001f,  new PositionDataVelocity(12.9f, 13.1f), 355, 0, 'B');


        PositionData PositionData2 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 17:03"),
                42.92236f, -66.97243f,  new PositionDataVelocity(12.5f, 2.4f), 358, 0, 'B');

        AVL<PositionData> positionDataAVL = new AVL<>();
        positionDataAVL.insert(PositionData1);
        positionDataAVL.insert(PositionData2);

        Ship Ship = new Ship(1, 211331640, "DHBN", "SHIPNAME", 9193305,
                new ShipCharacteristics(0, 0, "70", 294, 32, 79, 13.6f), positionDataAVL);

        shipBinarySearchTreeMMSI.insert(Ship);

        return shipBinarySearchTreeMMSI;
    }

    private List<List<String>> buildCsvContent(boolean withHeaderLIne){
        ArrayList<List<String>> csvFileContent = new ArrayList<>();

        ArrayList<String> csvLine = new ArrayList<>();

        if(withHeaderLIne){
            ArrayList<String> headerLine = new ArrayList<>();

            headerLine.add("MMSI");
            headerLine.add("BaseDateTime");
            headerLine.add("LAT");
            headerLine.add("LOG");

            csvFileContent.add(headerLine);
        }

        csvLine.add("211331640"); //MMSI
        csvLine.add("31/12/2020 01:25,36.39094"); //BaseDateTime
        csvLine.add("36.39094"); //Latitude
        csvLine.add("-122.71335"); //Longitude
        csvLine.add("19.7"); // Speed Over Ground
        csvLine.add("145.5"); // Course Over Ground
        csvLine.add("147"); // Heading
        csvLine.add("SEOUL EXPRESS"); // Vessel Name
        csvLine.add("IMO9193305"); // IMO
        csvLine.add("DHBN"); // Call Sign
        csvLine.add("70"); // Vessel Type
        csvLine.add("294"); // Length
        csvLine.add("32"); // Width
        csvLine.add("13.6"); // Draft
        csvLine.add("79"); // Cargo
        csvLine.add("B"); // Transceiver Class

        csvFileContent.add(csvLine);

        return csvFileContent;
    }

    @Test
    public void valid_mapToShipDTO_ExpectedResult(){
        // Arrange
        ShipDTO expectedShipDTO = new ShipDTO(645343460,334,44.5f,30.7f);

        // Act
        ShipDTO resultShipDTO = shipMapperImpl.mapToShipDTO(645343460,334,44.5f,30.7f);

        // Assert
        assertNotNull(resultShipDTO);
        assertEquals(expectedShipDTO.getMmsi(), resultShipDTO.getMmsi());
        assertEquals(expectedShipDTO.getTotalMoves(), resultShipDTO.getTotalMoves());
        assertEquals(expectedShipDTO.getDeltaDistance(), resultShipDTO.getDeltaDistance());
        assertEquals(expectedShipDTO.getTravelDistance(), resultShipDTO.getTravelDistance());
    }

    @Test
    public void valid_mapToShipPairDTO_ExpectedResult(){
        // Arrange
        ShipPairDTO expectedShipPairDTO = new ShipPairDTO(645343460,334,44.5f,4.7f,3.3f);

        // Act
        ShipPairDTO resultShipPairDTO = shipMapperImpl.mapToShipPairDTO(645343460,334,44.5f,4.7f,3.3f);

        // Assert
        assertNotNull(resultShipPairDTO);
        assertEquals(expectedShipPairDTO.getMmsi(), resultShipPairDTO.getMmsi());
        assertEquals(expectedShipPairDTO.getTotalMoves(), resultShipPairDTO.getTotalMoves());
        assertEquals(expectedShipPairDTO.getTravelDistance(), resultShipPairDTO.getTravelDistance());
        assertEquals(expectedShipPairDTO.getOriginDistance(), resultShipPairDTO.getOriginDistance());
        assertEquals(expectedShipPairDTO.getDestinationDistance(), resultShipPairDTO.getDestinationDistance());
    }

    @Test
    public void valid_mapToShipAvailableDTO_ShouldReturn_ExpectedResult(){
        // Arrange
        int shipMMSI = 123456789;
        String shipName = "TestShip";
        String locationDescription = "TestPort";
        float locationLatitude = 90.0f;
        float locationLongitude = 93.0f;

        ShipAvailableDTO expected = new ShipAvailableDTO(shipMMSI, shipName, locationDescription, locationLatitude, locationLongitude);

        // Act
        ShipAvailableDTO result = shipMapperImpl.mapToShipAvailableDTO(shipMMSI,shipName,locationDescription,locationLatitude,locationLongitude);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getShipMMSI(), result.getShipMMSI());
        assertEquals(expected.getShipName(), result.getShipName());
        assertEquals(expected.getLocationDescription(), result.getLocationDescription());
        assertEquals(expected.getLocationLatitude(), result.getLocationLatitude());
        assertEquals(expected.getLocationLongitude(), result.getLocationLongitude());
    }
}
