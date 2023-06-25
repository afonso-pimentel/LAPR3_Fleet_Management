package lapr.project.services;

import lapr.project.mappers.dtos.ShipMovementSummaryDTO;
import lapr.project.mappers.dtos.ShipDTO;
import lapr.project.mappers.dtos.ShipTravelDTO;
import lapr.project.model.PositionData;
import lapr.project.model.Ship;
import lapr.project.mappers.dtos.ShipPairDTO;
import lapr.project.utils.datastructures.AVL;
import java.util.List;
import java.util.Map;
import java.sql.Timestamp;

/**
 * @author Group 169 LAPRIII
 */
public interface ShipService {
    /**
     * Gets a movement summary from the Ship with the specified MMSI code
     * @param shipMMSI Ship MMSI Code
     * @return ShipMovementSummaryDTO
     */
    ShipMovementSummaryDTO getShipMovementSummary(int shipMMSI);

    /**
     * Return AVL tree with ShipDTO Objects ordered by movement number and travel distance
     * @return AVL tree with ShipDTO Objects
     */
    AVL<ShipDTO> getShipByMovementOrder();

    /**
     * Return a map with the corresponding pairs of ships, that have the same origin and destination
     * @return Map ShipDto with All its pairs in AVL<ShipPairDTO>
     */
    Map<ShipDTO, AVL<ShipPairDTO>> getPairsOfShipsWithCloseOriginAndDestination();

    /**
     * Return AVL tree with Ship Objects and it's positionsData between a chosen period of time
     * @param initDate Start date interval
     * @param endDate End date interval
     * @return AVL ree with Ship Objects
     */
    AVL<Ship> getShipBetweenDateInterval(Timestamp initDate, Timestamp endDate);

    /**
     * Return AVL tree with Ship Objects and it's positionsData between a chosen period of time
     * @param N number of ships user wants to see
     * @param initDate Start date interval
     * @param endDate End date interval
     * @return AVL ree with Ship Objects
     */
    Map<String, List<ShipTravelDTO>> getTopNShipsTravelledDistanceAndMSOG(int n, Timestamp initDate, Timestamp endDate);

    /**
     * Returns either the closest PositionData element for a given Timestamp or the exact one
     * @param callSign
     * @param timeStamp
     * @return
     */
    PositionData getPositionDataForGivenTime(String callSign, Timestamp timeStamp);
}
