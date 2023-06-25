package lapr.project.services;

import lapr.project.mappers.dtos.MovementSummaryDTO;
import lapr.project.model.PositionData;
import lapr.project.model.Ship;
import lapr.project.utils.datastructures.AVL;

import java.sql.Timestamp;
import java.util.Iterator;

/**
 * @author Group 169 LAPRIII
 */
public interface ShipServiceLogic {
    /**
     * Calculates a summary of all the ship movements
     * @param shipPositionData list of movement's information the ship made
     * @return MovementSummaryDTO
     */
    MovementSummaryDTO calculateShipMovementSummary(Iterator<PositionData> shipPositionData);

    /**
     * Calculates the distance traveled by a Ship
     * @param shipPositionData list of movement's information the ship made
     * @return float
     */
    float calculateTravelDistance(Iterator<PositionData> shipPositionData);

    /**
     * Calculates the delta distance of a Ship
     * @param pointAData Start point information of ship's trip
     * @param pointBData End point information of ship's trip
     * @return float
     */
    float calculateDeltaDistance(PositionData pointAData,PositionData pointBData);

    /***
     * Verifies if the ships are a pair or not
     * @param ship The first ship to be compared
     * @param shipToCompare The second ship to compare with the first
     * @return boolean
     */
    boolean isValidPairOfShip(Ship ship, Ship shipToCompare);

    /**
     * Calculate de distance between the origin of two ships
     * @param ship The first ship
     * @param shipToCompare The second ship to
     * @return float
     */
    float calculateDistanceFromOrigins(Ship ship, Ship shipToCompare);

    /**
     * Calculate de distance between the Destination of two ships
     * @param ship The first ship
     * @param shipToCompare The second ship to
     * @return float
     */
    float calculateDistanceFromDestinations(Ship ship, Ship shipToCompare);

    /**
     *
     * @param positionDataIterator
     * @param initDate
     * @param endDate
     * @return
     */
    float calculateMeanSOGInInterval(Iterator<PositionData> positionDataIterator, Timestamp initDate, Timestamp endDate);

    /**
     *
     * @param positionDataIterator
     * @param initDate
     * @param endDate
     * @return
     */
    float calculateTravelDistanceInInterval(Iterator<PositionData> positionDataIterator, Timestamp initDate, Timestamp endDate);


    /**
     *
     * @param positionDataAVL
     * @param timestamp
     * @return
     */
    PositionData getPositionDataForGivenTimestamp(AVL<PositionData> positionDataAVL, Timestamp timestamp);

}
