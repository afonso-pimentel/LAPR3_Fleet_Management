package lapr.project.services;

import lapr.project.mappers.dtos.MovementSummaryDTO;
import lapr.project.mappers.dtos.MovementSummaryDistancesDTO;
import lapr.project.mappers.dtos.MovementSummaryMetricsDTO;
import lapr.project.model.PositionData;
import lapr.project.model.PositionDataVelocity;
import lapr.project.model.Ship;
import lapr.project.utils.datastructures.AVL;
import lapr.project.utils.utilities.MathHelper;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Iterator;

/**
 * @author Group 169 LAPRIII
 */
public class ShipServiceLogicImpl implements ShipServiceLogic{
    static final String PARAMS_NULL_MESSAGE = "Parameters cannot be null.";

    /**
     * {@inheritdoc}
     */
    @Override
    public MovementSummaryDTO calculateShipMovementSummary(Iterator<PositionData> shipPositionData) {
        if(shipPositionData == null)
            throw new IllegalArgumentException("List of PositionsData cannot be null");

        float maxCOG = Float.MIN_VALUE;
        float maxSOG = Float.MIN_VALUE;
        float sumCOG = 0;
        float sumSOG = 0;
        int totalNumberOfMovements = 0;
        float travelledDistance = 0;

        PositionData departurePositionData = new PositionData(1, new Timestamp(Long.MAX_VALUE), 0, 0, new PositionDataVelocity(0, 0), 0,0 ,'A');
        PositionData arrivalPositionData = new PositionData(1, new Timestamp(Long.MIN_VALUE), 0, 0, new PositionDataVelocity(0, 0), 0,0 ,'A');
        PositionData currentPositionData;
        PositionData previousPositionData = null;

        while(shipPositionData.hasNext()) {
            currentPositionData = shipPositionData.next();

            if(currentPositionData.getDateTimeReceived().getTime() < departurePositionData.getDateTimeReceived().getTime())
                departurePositionData = currentPositionData;

            if(currentPositionData.getDateTimeReceived().getTime() > arrivalPositionData.getDateTimeReceived().getTime())
                arrivalPositionData = currentPositionData;

            maxCOG = Math.max(currentPositionData.getPositionDataVelocity().getCog(), maxCOG);
            maxSOG = Math.max(currentPositionData.getPositionDataVelocity().getSog(), maxSOG);
            sumCOG += currentPositionData.getPositionDataVelocity().getCog();
            sumSOG += currentPositionData.getPositionDataVelocity().getSog();

            if(previousPositionData != null)
                travelledDistance += MathHelper.calculateDistanceBetweenCoordinates(currentPositionData.getLatitude(), currentPositionData.getLongitude(), previousPositionData.getLatitude(), previousPositionData.getLongitude());

            previousPositionData = currentPositionData;
            totalNumberOfMovements++;
        }

        float meanSOG = sumSOG/totalNumberOfMovements;
        float meanCOG = sumCOG/totalNumberOfMovements;

        long totalMovementTime = MathHelper.calculateDifferenceInMinutes(new Timestamp(departurePositionData.getDateTimeReceived().getTime()), new Timestamp(arrivalPositionData.getDateTimeReceived().getTime()));
        float deltaDistance = MathHelper.calculateDistanceBetweenCoordinates(departurePositionData.getLatitude(), departurePositionData.getLongitude(), arrivalPositionData.getLatitude(), arrivalPositionData.getLongitude());

        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(departurePositionData.getLatitude(), departurePositionData.getLongitude(),
                arrivalPositionData.getLatitude(), arrivalPositionData.getLongitude(),
                travelledDistance, deltaDistance);

        MovementSummaryMetricsDTO movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(maxSOG, meanSOG, maxCOG, meanCOG);

        return new MovementSummaryDTO(totalMovementTime, totalNumberOfMovements,  movementSummaryMetricsDTO, movementSummaryDistancesDTO, new Date(departurePositionData.getDateTimeReceived().getTime()), new Date(arrivalPositionData.getDateTimeReceived().getTime()));
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public float calculateTravelDistance(Iterator<PositionData> shipPositionData) {
        if (shipPositionData == null)
            throw new IllegalArgumentException("PositionData cannot be null");

        float travelledDistance=0;
        PositionData current = shipPositionData.next();
        while(shipPositionData.hasNext()) {
            PositionData next = shipPositionData.next();
            travelledDistance += MathHelper.calculateDistanceBetweenCoordinates(current.getLatitude(),current.getLongitude(), next.getLatitude(),next.getLongitude());
            current = next;
        }
        return travelledDistance;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public float calculateDeltaDistance(PositionData pointAData, PositionData pointBData) {
        if (pointAData == null || pointBData == null)
            throw new IllegalArgumentException("neither pointA or pointB can be null");
        if(pointAData.compareTo(pointBData) == 0){
            return 0;
        }
        return MathHelper.calculateDistanceBetweenCoordinates(pointAData.getLatitude(),pointAData.getLongitude(),pointBData.getLatitude(),pointBData.getLongitude());
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public boolean isValidPairOfShip(Ship ship, Ship shipToCompare) {
        if(ship == null || shipToCompare == null)
            throw new IllegalArgumentException(PARAMS_NULL_MESSAGE);

        return !(ship.getMmsi() == shipToCompare.getMmsi()
                || calculateTravelDistance(ship.getPositionsData().inOrder().iterator()) < 10
                || calculateTravelDistance(shipToCompare.getPositionsData().inOrder().iterator()) < 10
                || calculateDistanceFromOrigins(ship, shipToCompare) > 5
                || calculateDistanceFromDestinations(ship, shipToCompare) > 5);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public float calculateDistanceFromOrigins(Ship ship, Ship shipToCompare) {
        validateShipObjectsForDistanceCalculation(ship, shipToCompare);

        return MathHelper.calculateDistanceBetweenCoordinates(ship.getPositionsData().smallestElement().getLatitude(),ship.getPositionsData().smallestElement().getLongitude(),
                shipToCompare.getPositionsData().smallestElement().getLatitude(),shipToCompare.getPositionsData().smallestElement().getLongitude());
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public float calculateDistanceFromDestinations(Ship ship, Ship shipToCompare) {
        validateShipObjectsForDistanceCalculation(ship, shipToCompare);

        return MathHelper.calculateDistanceBetweenCoordinates(ship.getPositionsData().highestElement().getLatitude(),ship.getPositionsData().highestElement().getLongitude(),
                shipToCompare.getPositionsData().highestElement().getLatitude(),shipToCompare.getPositionsData().highestElement().getLongitude());
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public float calculateMeanSOGInInterval(Iterator<PositionData> positionDataIterator, Timestamp initDate, Timestamp endDate) {
        float sumSog = 0;
        int movementCount = 0;
        boolean intervalStarted = false;

        while (positionDataIterator.hasNext()) {
            PositionData currentPositionData = positionDataIterator.next();
            if (currentPositionData.getDateTimeReceived().after(initDate) && !intervalStarted) {
                intervalStarted = true;
            }
            if (intervalStarted && (currentPositionData.getDateTimeReceived().before(endDate) || currentPositionData.getDateTimeReceived().equals(endDate))) {
                sumSog = sumSog + currentPositionData.getPositionDataVelocity().getSog();
                movementCount++;
            }
            if ((intervalStarted && (currentPositionData.getDateTimeReceived().after(endDate)) || !positionDataIterator.hasNext()) && movementCount != 0) {
                return sumSog / movementCount;
            }
        }
        return 0;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public float calculateTravelDistanceInInterval(Iterator<PositionData> positionDataIterator, Timestamp initDate, Timestamp endDate) {
        boolean intervalStarted = false;
        float sumDistance= 0;
        PositionData currentPositionData = null;

        if (positionDataIterator == null || initDate == null || endDate == null)
            throw new IllegalArgumentException(PARAMS_NULL_MESSAGE);

        if (positionDataIterator.hasNext()){
            currentPositionData = positionDataIterator.next();
        }
        while (positionDataIterator.hasNext()) {
            PositionData nextElem = positionDataIterator.next();

            if (currentPositionData != null && currentPositionData.getDateTimeReceived().after(initDate) && !intervalStarted) {
                intervalStarted = true;
            }

            if (intervalStarted && nextElem.getDateTimeReceived().before(endDate)
                    || nextElem.getDateTimeReceived().equals(endDate)) {
                sumDistance = sumDistance + calculateDeltaDistance(currentPositionData,nextElem);
            }

            if (intervalStarted && (nextElem.getDateTimeReceived().after(endDate))|| !positionDataIterator.hasNext()) {
                return sumDistance;
            }

            currentPositionData = nextElem;
        }
        return 0;
    }

    /**
     *
     * {@inheritdoc}
     */
    @Override
    public PositionData getPositionDataForGivenTimestamp(AVL<PositionData> positionDataAVL, Timestamp timeStamp) {
        PositionData auxPD = new PositionData(0,timeStamp,0,0,new PositionDataVelocity(0,0),0,0,'A');
        return positionDataAVL.closestElement(auxPD);
    }

    private void validateShipObjectsForDistanceCalculation(Ship ship, Ship shipToCompare){
        if (ship == null || shipToCompare == null)
            throw new IllegalArgumentException(PARAMS_NULL_MESSAGE);

        if (ship.getPositionsData() == null || shipToCompare.getPositionsData() == null)
            throw new IllegalArgumentException("Neither PositionsData of ship or shipToCompare can be null");
    }
}
