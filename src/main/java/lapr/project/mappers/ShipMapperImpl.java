package lapr.project.mappers;

import lapr.project.mappers.dtos.*;
import lapr.project.model.PositionData;
import lapr.project.model.PositionDataVelocity;
import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.utils.datastructures.AVL;
import lapr.project.utils.utilities.Utilities;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Group 169 LAPRIII
 */
public class ShipMapperImpl implements ShipMapper{

    /**
     * {@inheritdoc}
     */
    @Override
    public List<Ship> mapShipFromCsvContent(List<List<String>> csvParsedContent) throws ParseException {
        if(csvParsedContent == null)
            throw new IllegalArgumentException("csvParsedLine argumment cannot be null");

        if(isFirstLineHeaderLine(csvParsedContent.get(0)))
            csvParsedContent.remove(0);

        long shipIdTransportIndex = 1;
        Integer lastKnownMMSI = Integer.parseInt(csvParsedContent.get(0).get(0));
        Ship firstShip = mapShip(csvParsedContent.get(0), shipIdTransportIndex);

        Map<Integer, Ship> shipMappings = new HashMap<>();
        AVL<PositionData> shipPositionsData = new AVL<>();

        shipMappings.put(firstShip.getMmsi(), firstShip);

        for(List<String> line: csvParsedContent){
            Integer currentMMSI = Integer.parseInt(line.get(0));

            if(currentMMSI.compareTo(lastKnownMMSI) != 0){
                shipMappings.get(lastKnownMMSI).setPositionsData(shipPositionsData);
                shipMappings.put(currentMMSI, mapShip(line, shipIdTransportIndex));

                shipIdTransportIndex++;
                shipPositionsData = new AVL<>();
                lastKnownMMSI = currentMMSI;
            }

            shipPositionsData.insert(mapPositionData(line, shipIdTransportIndex));
        }

        shipMappings.get(lastKnownMMSI).setPositionsData(shipPositionsData);

        return shipMappings.values().stream().collect(Collectors.toList());
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public ShipMovementSummaryDTO mapToShipMovementSummary(int mmsi, String vesselName, MovementSummaryDTO movementSummaryDTO) {
        if(vesselName == null)
            throw new IllegalArgumentException("VesselName argument cannot be null");

        if(movementSummaryDTO == null)
            throw new IllegalArgumentException("MovementSummaryDTO cannot be null");

        return new ShipMovementSummaryDTO(movementSummaryDTO, mmsi, vesselName);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public ShipDTO mapToShipDTO(int mmsi,int totalMoves, float travelDistance, float deltaDistance) {
        return new ShipDTO(mmsi,totalMoves,travelDistance,deltaDistance);
    }

    /**
     * Maps the content to a ShipDTO object
     * @param mmsi unique ship identifier
     * @param totalMoves number of moves made my the ship
     * @param travelDistance distance traveled by the ship in kms
     * @return ShipDTO object
     */
    @Override
    public ShipPairDTO mapToShipPairDTO(int mmsi, int totalMoves, float travelDistance, float originDistance, float destinationDistance) {
        return new ShipPairDTO(mmsi, totalMoves, travelDistance, originDistance, destinationDistance);
    }

    /**
     * Determines if the line is the header line from the ship files csv
     * @param line composed of it's columns distributed through of type List<String></String>
     * @return Boolean
     */
    private boolean isFirstLineHeaderLine(List<String> line){
        return line.contains("MMSI");
    }

    /**
     * Maps a CSV line with its columns to a Ship object
     * @param columns Columns of the CSV line
     * @param idTransport TransportID associated with the ship to be mapped
     * @return Ship
     * @throws ParseException
     */
    private Ship mapShip(List<String> columns, long idTransport) {
        String vesselName = columns.get(7);
        int mmsi = Integer.parseInt(columns.get(0));
        int imo = Integer.parseInt(columns.get(8).replace("IMO",""));
        String callSign = columns.get(9);
        String vesselType = columns.get(10);
        int length = Integer.parseInt(columns.get(11));
        int width = Integer.parseInt(columns.get(12));
        float draft = Float.parseFloat(columns.get(13));
        int cargo = columns.get(14).equals("NA") ? 0 : Integer.parseInt(columns.get(14));

        return new Ship(idTransport, mmsi, callSign, vesselName, imo, new ShipCharacteristics(0,0,
                    vesselType, length, width, cargo, draft), null);
    }

    /**
     * Maps a CSV line with its columns to a PositionData object
     * @param columns Columns of the CSV line
     * @param idTransport TransportID associated with the ship to be mapped
     * @return PositionData
     * @throws ParseException
     */
    private PositionData mapPositionData(List<String> columns, long idTransport) throws ParseException {
        char transceiverClass = columns.get(15).charAt(0);
        Timestamp dateTimeReceived = Utilities.convertFromDateStringToTimeStamp(columns.get(1));
        float latitude = Float.parseFloat(columns.get(2));
        float longitude = Float.parseFloat(columns.get(3));
        float speedOverGround = Float.parseFloat(columns.get(4));
        float courseOverGround = Float.parseFloat(columns.get(5));
        int heading = Integer.parseInt(columns.get(6));

        return new PositionData(idTransport, dateTimeReceived, latitude, longitude,
                new PositionDataVelocity(speedOverGround, courseOverGround), heading, 0, transceiverClass);
    }

    /**
     *
     * @param mmsi unique ship identifier
     * @param travelDistance distance traveled by the ship in kms in a given time
     * @param meanSOG Mean of the ships SOG in a given time
     * @param vesselType ship's vessel type
     * @return
     */
    @Override
    public ShipTravelDTO mapToShipTravelDTO(int mmsi, float travelDistance, float meanSOG, String vesselType) {
        return new ShipTravelDTO(mmsi, travelDistance, meanSOG, vesselType);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public ShipAvailableDTO mapToShipAvailableDTO(int shipMMSI, String shipName, String locationDescription, float locationLatitude, float locationLongitude) {
        return new ShipAvailableDTO(shipMMSI, shipName, locationDescription, locationLatitude, locationLongitude);
    }
}
