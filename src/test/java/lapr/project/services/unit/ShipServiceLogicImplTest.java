package lapr.project.services.unit;

import lapr.project.mappers.dtos.MovementSummaryDTO;
import lapr.project.mappers.dtos.MovementSummaryDistancesDTO;
import lapr.project.mappers.dtos.MovementSummaryMetricsDTO;
import lapr.project.model.PositionData;
import lapr.project.model.PositionDataVelocity;
import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.services.ShipServiceLogic;
import lapr.project.services.ShipServiceLogicImpl;
import lapr.project.utils.datastructures.AVL;
import org.junit.jupiter.api.Test;

import java.sql.*;

import lapr.project.utils.utilities.Utilities;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

/**
 * @author Group 169 LAPRIII
 */
class ShipServiceLogicImplTest {
    private final ShipServiceLogic shipServiceLogicImpl;

    public ShipServiceLogicImplTest() {
        shipServiceLogicImpl = new ShipServiceLogicImpl();
    }
    @Test
    public void invalid_NullpositionData_TravelledDistance_ShouldThrow_IllegalArgumentException() throws ParseException {
        // Arrange
        PositionData nullArgument = null;
        PositionData positionData1 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDeltaDistance(positionData1,nullArgument));
    }

    @Test
    public void invalid_NullpositionData_DeltaDistance_ShouldThrow_IllegalArgumentException(){
        // Arrange
        Iterator<PositionData> nullArgument = null;
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateTravelDistance(nullArgument));
    }

    @Test
    public void valid_ArgumentsOnFuntion_TravelledDistance_ShouldNotThrow_Exception(){
        // Arrange
        Iterator<PositionData> validPositionalData = new Iterator<PositionData>() {
            @Override
            public boolean hasNext() {
                return false;
            }

            @Override
            public PositionData next() {
                return null;
            }
        };
        // Act & Assert
        assertDoesNotThrow(() -> new ShipServiceLogicImpl().calculateTravelDistance(validPositionalData));
    }

    @Test
    public void valid_ArgumentsOnFuntion_DeltaDistance_ShouldNotThrow_Exception() throws ParseException {
        // Arrange
        PositionData positionData1 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:10"),
                39.39094f, -120.71335f, new PositionDataVelocity(14.7f, 150.5f), 143, 0, 'B');

        PositionData positionData2 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');
        // Act & Assert
        assertDoesNotThrow(() -> new ShipServiceLogicImpl().calculateDeltaDistance(positionData1,positionData2));
    }

    @Test
    public void valid_FunctionTravelledDistance_ShouldReturnExpectedResults() throws ParseException {
        // Arrange
        List<PositionData> positionList = new ArrayList<>();
        PositionData positionData1 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:10"),
                43.53f, 110.55f, new PositionDataVelocity(14.7f, 150.5f), 143, 0, 'B');

        PositionData positionData2 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, 122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionData3 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                40.39094f, 100.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        positionList.add(positionData1);
        positionList.add(positionData2);
        positionList.add(positionData3);

        List<PositionData> positionListWithOnePosition = new ArrayList<>();
        positionListWithOnePosition.add(positionData1);
        //Act & Assert
        assertEquals(3266.1392f, new ShipServiceLogicImpl().calculateTravelDistance(positionList.iterator()));
        assertEquals(0f, new ShipServiceLogicImpl().calculateTravelDistance(positionListWithOnePosition.iterator()));
    }

    @Test
    public void valid_FunctionDeltaDistance_ShouldReturnExpectedResults() throws ParseException {
        // Arrange
        PositionData positionData1 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:10"),
                43.53f, 110.55f, new PositionDataVelocity(14.7f, 150.5f), 143, 0, 'B');

        PositionData positionData2 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, 122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionDataDifferentButSameExactDate = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:10"),
                43.53f, 110.55f, new PositionDataVelocity(14.7f, 150.5f), 143, 0, 'B');

        //Act & Assert
        assertEquals(1303.406f, new ShipServiceLogicImpl().calculateDeltaDistance(positionData1,positionData2));
        assertEquals(0f, new ShipServiceLogicImpl().calculateDeltaDistance(positionData1,positionDataDifferentButSameExactDate));
    }

    @Test
    void invalid_NullShips_isValidPairOfShip_ShouldThrow_IllegalArgumentException() throws ParseException {
        // Arrange
        AVL<PositionData> positions = new AVL<>();
        positions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
               36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        positions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
             46.39094f, -132.71335f,    new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        Ship nullArgument = null;
        Ship shipValid = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), positions);

        ;
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().isValidPairOfShip(nullArgument,nullArgument));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().isValidPairOfShip(shipValid,nullArgument));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().isValidPairOfShip(nullArgument,shipValid));
        assertDoesNotThrow(() ->  new ShipServiceLogicImpl().calculateDistanceFromDestinations(shipValid,shipValid));
    }
    @Test
    void valid_isValidPairOfShip_ShouldReturnExpectedResults() throws ParseException {
        // Arrange
        AVL<PositionData> shipPositionsSmallTravelDistance = new AVL<>();
        shipPositionsSmallTravelDistance.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
               36.39096f, -122.71336f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        shipPositionsSmallTravelDistance.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
                39.49096f, -132.81336f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        Ship shipSmallTravelDistance = new Ship(0, 987654321, "AA", "a", 1111111,  new ShipCharacteristics(0, 0, "00",
                1, 1, 1, 1.0f), shipPositionsSmallTravelDistance);

        AVL<PositionData> shipPositions = new AVL<>();
        shipPositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        shipPositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
                39.49094f, -132.81335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        Ship shipValid = new Ship(0, 123456789, "AA", "a", 1111111,  new ShipCharacteristics(0, 0, "00",
                1, 1, 1, 1.0f), shipPositions);

        AVL<PositionData> shipToComparePositions = new AVL<>();
        shipToComparePositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
               36.39095f, -122.71336f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        shipToComparePositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
               39.49095f, -132.81336f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        Ship shipToCompareValid = new Ship(0, 987654321, "AA", "a", 1111111,  new ShipCharacteristics(0, 0, "00",
                1, 1, 1, 1.0f), shipToComparePositions);

        AVL<PositionData> shipOriginPositions = new AVL<>();
        shipToComparePositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                30.39095f, -112.71336f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        shipToComparePositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
               39.49095f, -132.81336f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));



        // Act & Assert
        assertEquals(false, shipServiceLogicImpl.isValidPairOfShip(shipValid, shipValid));
        assertEquals(false, shipServiceLogicImpl.isValidPairOfShip(shipSmallTravelDistance, shipToCompareValid));
        assertEquals(false, shipServiceLogicImpl.isValidPairOfShip(shipToCompareValid, shipSmallTravelDistance));
        assertEquals(true, shipServiceLogicImpl.isValidPairOfShip(shipValid, shipToCompareValid));
    }

    @Test
    void invalid_calculateDistanceFromOrigins_IllegalArgumentException() throws ParseException {
        // Arrange
        AVL<PositionData> positions = new AVL<>();
        positions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
              36.39094f, -122.71335f,   new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        positions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
              46.39094f, -132.71335f,   new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        Ship nullArgument = null;
        Ship shipNullPosition = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null);
        Ship shipValid = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), positions);

                ;
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromOrigins(nullArgument,nullArgument));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromOrigins(shipValid,nullArgument));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromOrigins(nullArgument,shipValid));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromOrigins(shipValid,shipNullPosition));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromOrigins(shipNullPosition,shipValid));
        assertDoesNotThrow(() ->  new ShipServiceLogicImpl().calculateDistanceFromOrigins(shipValid,shipValid));
    }
    @Test
    void invalid_calculateDistanceFromDestinations_IllegalArgumentException() throws ParseException {
        // Arrange
        AVL<PositionData> positions = new AVL<>();
        positions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        positions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
             46.39094f, -132.71335f,    new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        Ship nullArgument = null;
        Ship shipNullPosition = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), null);
        Ship shipValid = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), positions);

        ;
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromDestinations(nullArgument,nullArgument));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromDestinations(shipValid,nullArgument));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromDestinations(nullArgument,shipValid));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromDestinations(shipValid,shipNullPosition));
        assertThrows(IllegalArgumentException.class, () ->  new ShipServiceLogicImpl().calculateDistanceFromDestinations(shipNullPosition,shipValid));
        assertDoesNotThrow(() ->  new ShipServiceLogicImpl().calculateDistanceFromDestinations(shipValid,shipValid));
    }

    @Test
    void valid_calculateDistanceFromDestinations_ShouldReturnExpectedResults() throws ParseException {
        // Arrange
        AVL<PositionData> shipPositions = new AVL<>();
        shipPositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
               36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        shipPositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
                46.39094f, -132.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        AVL<PositionData> shipToComparePositions = new AVL<>();
        shipToComparePositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                46.39094f, -132.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        shipToComparePositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        Ship shipValid = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), shipPositions);
        Ship shipToCompareValid = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), shipToComparePositions);


        // Act & Assert
        assertEquals(1387.6802f, shipServiceLogicImpl.calculateDistanceFromDestinations(shipValid, shipToCompareValid));
    }
    @Test
    void valid_calculateDistanceFromOrigins_ShouldReturnExpectedResults() throws ParseException {
        // Arrange
        AVL<PositionData> shipPositions = new AVL<>();
        shipPositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
              36.39094f, -122.71335f,   new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        shipPositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
                46.39094f, -132.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        AVL<PositionData> shipToComparePositions = new AVL<>();
        shipToComparePositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 01:25"),
                46.39094f, -132.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));
        shipToComparePositions.insert(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 02:25"),
               36.39094f, -122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        Ship shipValid = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), shipPositions);
        Ship shipToCompareValid = new Ship(0, 0, "AA", "a", 1111111, new ShipCharacteristics(0, 0, "00", 1, 1, 1, 1.0f), shipToComparePositions);

        // Act & Assert
        assertEquals(1387.6802f, shipServiceLogicImpl.calculateDistanceFromOrigins(shipValid, shipToCompareValid));
    }

    @Test
    public void valid_ListOfPositionsDataInAscendingOrder_ShouldReturn_ExpectedMovementSummaryObject() throws ParseException {
        // Arrange
        List<PositionData> inputPositionsData = buildPositionsDataAscendingOrder();

        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(43.53f, 110.55f,
                44.39094f, 133.71335f, 4822, 1850);

        MovementSummaryMetricsDTO  movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(19.7f, 17.2f, 157.5f, 151.75f);

        MovementSummaryDTO expected = new MovementSummaryDTO(20, 4,
                                                            movementSummaryMetricsDTO, movementSummaryDistancesDTO,
                                                            new Date(1609305000000l), new Date(1609306200000l));
        // Act
        MovementSummaryDTO result = shipServiceLogicImpl.calculateShipMovementSummary(inputPositionsData.iterator());

        // Assert
        assertNotNull(result);
        assertEquals(expected.getTotalMovementTime(), result.getTotalMovementTime());
        assertEquals(expected.getTotalNumberOfMovements(), result.getTotalNumberOfMovements());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMaxSOG(), result.getMovementSummaryMetricsDTO().getMaxSOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMeanSOG(), result.getMovementSummaryMetricsDTO().getMeanSOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMaxCOG(), result.getMovementSummaryMetricsDTO().getMaxCOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMeanCOG(), result.getMovementSummaryMetricsDTO().getMeanCOG());
        assertEquals(expected.getMovementSummaryDistancesDTO().getDepartureLatitude(), result.getMovementSummaryDistancesDTO().getDepartureLatitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getDepartureLongitude(), result.getMovementSummaryDistancesDTO().getDepartureLongitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getArrivalLatitude(), result.getMovementSummaryDistancesDTO().getArrivalLatitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getArrivalLongitude(), result.getMovementSummaryDistancesDTO().getArrivalLongitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getDeltaDistance(), result.getMovementSummaryDistancesDTO().getDeltaDistance(), 1.0f);
        assertEquals(expected.getMovementSummaryDistancesDTO().getTravelledDistance(), result.getMovementSummaryDistancesDTO().getTravelledDistance(), 1.0f);
        assertEquals(expected.getStartDate().getTime(), result.getStartDate().getTime());
        assertEquals(expected.getEndDate().getTime(), result.getEndDate().getTime());
    }

    @Test
    public void valid_ListOfPositionsDataInDescendingOrder_ShouldReturn_ExpectedMovementSummaryObject() throws ParseException {
        // Arrange
        List<PositionData> inputPositionsData = buildPositionsDataDescendingOrder();

        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(43.53f, 110.55f,
                44.39094f, 133.71335f, 4822, 1850);

        MovementSummaryMetricsDTO movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(19.7f, 17.2f, 157.5f, 151.75f);

        MovementSummaryDTO expected = new MovementSummaryDTO(20, 4,
                movementSummaryMetricsDTO, movementSummaryDistancesDTO,
                new Date(1609305000000l), new Date(1609306200000l));
        // Act
        MovementSummaryDTO result = shipServiceLogicImpl.calculateShipMovementSummary(inputPositionsData.iterator());

        // Assert
        assertNotNull(result);
        assertEquals(expected.getTotalMovementTime(), result.getTotalMovementTime());
        assertEquals(expected.getTotalNumberOfMovements(), result.getTotalNumberOfMovements());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMaxSOG(), result.getMovementSummaryMetricsDTO().getMaxSOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMeanSOG(), result.getMovementSummaryMetricsDTO().getMeanSOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMaxCOG(), result.getMovementSummaryMetricsDTO().getMaxCOG());
        assertEquals(expected.getMovementSummaryMetricsDTO().getMeanCOG(), result.getMovementSummaryMetricsDTO().getMeanCOG());
        assertEquals(expected.getMovementSummaryDistancesDTO().getDepartureLatitude(), result.getMovementSummaryDistancesDTO().getDepartureLatitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getDepartureLongitude(), result.getMovementSummaryDistancesDTO().getDepartureLongitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getArrivalLatitude(), result.getMovementSummaryDistancesDTO().getArrivalLatitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getArrivalLongitude(), result.getMovementSummaryDistancesDTO().getArrivalLongitude());
        assertEquals(expected.getMovementSummaryDistancesDTO().getDeltaDistance(), result.getMovementSummaryDistancesDTO().getDeltaDistance(), 1.0f);
        assertEquals(expected.getMovementSummaryDistancesDTO().getTravelledDistance(), result.getMovementSummaryDistancesDTO().getTravelledDistance(), 1.0f);
        assertEquals(expected.getStartDate().getTime(), result.getStartDate().getTime());
        assertEquals(expected.getEndDate().getTime(), result.getEndDate().getTime());
    }

    @Test
    public void invalid_NullListArgument_ShouldThrow_IllegalArgumentException(){
        // Arrange
        Iterator<PositionData> inputPositionsData = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipServiceLogicImpl.calculateShipMovementSummary(inputPositionsData));
    }

    @Test
    public void invalid_NullPositionDataA_ShouldThrow_IllegalArgumentException() throws ParseException {
        // Arrange
        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:10"),
              43.53f, 110.55f,   new PositionDataVelocity(14.7f, 150.5f), 143, 0, 'B');

        PositionData nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipServiceLogicImpl.calculateDeltaDistance(nullArgument, positionData));
    }

    @Test
    public void invalid_NullPositionDataB_ShouldThrow_IllegalArgumentException() throws ParseException {
        // Arrange
        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:10"),
               43.53f, 110.55f,  new PositionDataVelocity(14.7f, 150.5f), 143, 0, 'B');

        PositionData nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipServiceLogicImpl.calculateDeltaDistance(positionData, nullArgument));
    }

    private List<PositionData> buildPositionsDataAscendingOrder() throws ParseException {
        List<PositionData> listOfPositionsData = new ArrayList<>();

        listOfPositionsData.add(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:10"),
            43.53f, 110.55f,     new PositionDataVelocity(14.7f, 150.5f), 143, 0, 'B'));

        listOfPositionsData.add(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:15"),
               36.39094f, 122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        listOfPositionsData.add(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:25"),
             54.66f, 120.55f,    new PositionDataVelocity(16.7f, 153.5f), 147, 0, 'B'));

        listOfPositionsData.add(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:30"),
               44.39094f, 133.71335f,   new PositionDataVelocity(17.7f, 157.5f), 147, 0, 'B'));

        return listOfPositionsData;
    }

    private List<PositionData> buildPositionsDataDescendingOrder() throws ParseException {
        List<PositionData> listOfPositionsData = new ArrayList<>();

        listOfPositionsData.add(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:30"),
            44.39094f, 133.71335f,      new PositionDataVelocity(17.7f, 157.5f), 147, 0, 'B'));

        listOfPositionsData.add(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:25"),
             54.66f, 120.55f,    new PositionDataVelocity(16.7f, 153.5f), 147, 0, 'B'));

        listOfPositionsData.add(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:15"),
               36.39094f, 122.71335f,  new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B'));

        listOfPositionsData.add(new PositionData(1, Utilities.convertFromDateStringToTimeStamp("30/12/2020 05:10"),
                43.53f, 110.55f, new PositionDataVelocity(14.7f, 150.5f), 143, 0, 'B'));

        return listOfPositionsData;
    }

    @Test
    public void invalid_calculateTravelDistanceInInterval_ShouldThrow_IllegalArgumentException(){
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        Iterator<PositionData> positionDataIterator = new ArrayList<PositionData>().iterator();
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> shipServiceLogicImpl.calculateTravelDistanceInInterval(null, null, null));
        assertThrows(IllegalArgumentException.class, () -> shipServiceLogicImpl.calculateTravelDistanceInInterval(null, timestamp, timestamp));
        assertThrows(IllegalArgumentException.class, () -> shipServiceLogicImpl.calculateTravelDistanceInInterval(positionDataIterator, null, timestamp));
        assertThrows(IllegalArgumentException.class, () -> shipServiceLogicImpl.calculateTravelDistanceInInterval(positionDataIterator, timestamp, null));
        assertDoesNotThrow(() -> shipServiceLogicImpl.calculateTravelDistanceInInterval(positionDataIterator, timestamp, timestamp));
    }
}