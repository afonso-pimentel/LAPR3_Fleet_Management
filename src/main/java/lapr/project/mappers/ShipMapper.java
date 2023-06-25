package lapr.project.mappers;

import lapr.project.mappers.dtos.*;
import lapr.project.model.Ship;
import java.text.ParseException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface ShipMapper {
    /**
     * Maps the contents of a csv file to a list of Ship objects
     * @param csvParsedContent CSV parsed content has a matrix of strings
     * @return List of Ships
     * @throws ParseException
     */
    List<Ship> mapShipFromCsvContent(List<List<String>> csvParsedContent) throws ParseException;

    /**
     * Maps from ship atributes and movement summary to a ShipMovementSummaryDTO
     * @param mmsi Ship MMSI code
     * @param vesselName Ship Vessel Name
     * @param movementSummaryDTO MovementSummary
     * @return ShipMovementSummaryDTO
     */
    ShipMovementSummaryDTO mapToShipMovementSummary(int mmsi, String vesselName, MovementSummaryDTO movementSummaryDTO);

    /**
     * Maps the content to a ShipDTO object
     * @param mmsi unique ship identifier
     * @param totalMoves number of moves made my the ship
     * @param travelDistance distance traveled by the ship in kms
     * @param deltaDistance delta distance that ship made in kms
     * @return ShipDTO object
     */
    ShipDTO mapToShipDTO(int mmsi,int totalMoves, float travelDistance, float deltaDistance);

    /**
     *
     * @param mmsi
     * @param totalMoves
     * @param travelDistance
     * @param originDistance
     * @param destinationDistance
     * @return
     */
    ShipPairDTO mapToShipPairDTO(int mmsi, int totalMoves, float travelDistance, float originDistance, float destinationDistance);

    /**
     *
     * @param mmsi
     * @param travelDistance
     * @param meanSOG
     * @param vesselType
     * @return
     */
    ShipTravelDTO mapToShipTravelDTO(int mmsi, float travelDistance, float meanSOG, String vesselType);

    /**
     * Maps the parameters to their corresponding DTO
     * @param shipMMSI
     * @param shipName
     * @param locationDescription
     * @param locationLatitude
     * @param locationLongitude
     * @return ShipAvailableDTO
     */
    ShipAvailableDTO mapToShipAvailableDTO(int shipMMSI, String shipName, String locationDescription, float locationLatitude, float locationLongitude);
}
