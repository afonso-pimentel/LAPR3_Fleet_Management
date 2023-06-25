package lapr.project.services;

import lapr.project.mappers.ShipMapper;
import lapr.project.mappers.dtos.*;
import lapr.project.model.PositionData;
import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.stores.ShipStore;
import lapr.project.utils.datastructures.AVL;

import java.util.*;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Group 169 LAPRIII
 */
public class ShipServiceImpl implements ShipService{
    private final ShipStore shipStore;
    private final ShipMapper shipMapper;
    private final ShipServiceLogic shipServiceLogic;

    public ShipServiceImpl(ShipStore shipStore, ShipMapper shipMapper, ShipServiceLogic shipServiceLogic) {
        if(shipStore == null)
            throw new IllegalArgumentException("ShipStore can't be null");
        if(shipMapper == null)
            throw new IllegalArgumentException("ShipMapper can't be null");
        if(shipServiceLogic == null)
            throw new IllegalArgumentException("ShipServiceLogic can't be null");

        this.shipStore = shipStore;
        this.shipMapper = shipMapper;
        this.shipServiceLogic = shipServiceLogic;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public ShipMovementSummaryDTO getShipMovementSummary(int shipMMSI) {
        Ship ship = shipStore.getShipByMMSI(shipMMSI);

        if(ship == null)
            return null;

        MovementSummaryDTO movementSummaryDTO = shipServiceLogic.calculateShipMovementSummary(ship.getPositionsData().inOrder().iterator());

        return shipMapper.mapToShipMovementSummary(ship.getMmsi(), ship.getName(), movementSummaryDTO);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public AVL<ShipDTO> getShipByMovementOrder() {
        AVL<ShipDTO> shipDTOAVL = new AVL<>();
        for (Ship aShip : shipStore.getShips().inOrder()){
            ShipDTO mappedDTO = shipMapper.mapToShipDTO(aShip.getMmsi(),aShip.getPositionsData().size(),
                                shipServiceLogic.calculateTravelDistance(aShip.getPositionsData().inOrder().iterator()),
                                shipServiceLogic.calculateDeltaDistance(aShip.getPositionsData().highestElement(),
                                aShip.getPositionsData().smallestElement()));

            shipDTOAVL.insert(mappedDTO);
        }
        return shipDTOAVL;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public AVL<Ship> getShipBetweenDateInterval(Timestamp initDate, Timestamp endDate) {
        if (initDate == null)
            throw new IllegalArgumentException("InitDate can't be null");

        if (endDate == null){
            Instant instant = Instant.from(initDate.toInstant()).plus(24, ChronoUnit.HOURS);
            endDate = Timestamp.from(instant);
        }
        AVL<Ship> shipDateAVL = new AVL<>();

        for (Ship aShip : shipStore.getShips().inOrder()) {
            AVL<PositionData> shipPositionDate = new AVL<>();
            for (PositionData pD : aShip.getPositionsData().inOrder()){
                if(pD.getDateTimeReceived().after(initDate) && pD.getDateTimeReceived().before(endDate))
                    shipPositionDate.insert(pD);
            }
            if (!(shipPositionDate.isEmpty()))
                shipDateAVL.insert(new Ship(aShip.getIdTransport(),aShip.getMmsi(),aShip.getCallSign(),aShip.getName()
                        ,aShip.getImoNumber(),new ShipCharacteristics(aShip.getShipCharacteristics().getNumGen(),aShip.getShipCharacteristics().getGenOutput(),aShip.getShipCharacteristics().getVessalType(),aShip.getShipCharacteristics().getLength()
                        ,aShip.getShipCharacteristics().getWidth(),aShip.getShipCharacteristics().getCapacity(),aShip.getShipCharacteristics().getDraft()),shipPositionDate));
        }
        return shipDateAVL;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public Map<ShipDTO, AVL<ShipPairDTO>> getPairsOfShipsWithCloseOriginAndDestination() {
        Map<ShipDTO, AVL<ShipPairDTO>> shipHashMap = new HashMap<>();
        Iterable<Ship> ships = shipStore.getShips().inOrder();

        for (Ship ship : ships){
            AVL<ShipPairDTO> shipsWithCloseTrips = new AVL<>();

            for (Ship shipToCompare :ships) {
                if(shipServiceLogic.isValidPairOfShip(ship, shipToCompare))
                {
                    ShipPairDTO mappedDTO = shipMapper.mapToShipPairDTO(
                            shipToCompare.getMmsi(),
                            shipToCompare.getPositionsData().size(),
                            shipServiceLogic.calculateTravelDistance(shipToCompare.getPositionsData().inOrder().iterator()),
                            shipServiceLogic.calculateDistanceFromOrigins(ship, shipToCompare),
                            shipServiceLogic.calculateDistanceFromDestinations(ship, shipToCompare)
                    );
                    shipsWithCloseTrips.insert(mappedDTO);
                }
            }
            if(shipsWithCloseTrips.size() > 0) {
                ShipDTO shipDTO = shipMapper.mapToShipDTO(ship.getMmsi(), ship.getPositionsData().size(),
                        shipServiceLogic.calculateTravelDistance(ship.getPositionsData().inOrder().iterator()),
                        shipServiceLogic.calculateDeltaDistance(ship.getPositionsData().highestElement(),
                                ship.getPositionsData().smallestElement()));

                shipHashMap.put(shipDTO, shipsWithCloseTrips);
            }
        }
        return shipHashMap;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public Map<String, List<ShipTravelDTO>> getTopNShipsTravelledDistanceAndMSOG(int n, Timestamp initDate, Timestamp endDate) {
        if(n<=0)
            throw new IllegalArgumentException("N positions must be bigger than 0.");

        if (initDate == null)
            throw new IllegalArgumentException("initDate can't be null");

        if (endDate == null){
            throw new IllegalArgumentException("endDate can't be null");
        }
        AVL<ShipTravelDTO> shipTravelDTOAVL = new AVL<>();
        for (Ship aShip : shipStore.getShips().inOrder()) { //this in order is actually from the biggest travel distance to the smallest, we didn't change the inOrder method, we changed the compareTo method
            ShipTravelDTO mappedDTO = shipMapper.mapToShipTravelDTO(aShip.getMmsi(),
                    shipServiceLogic.calculateTravelDistanceInInterval(aShip.getPositionsData().inOrder().iterator(), initDate,endDate),
                    shipServiceLogic.calculateMeanSOGInInterval(aShip.getPositionsData().inOrder().iterator(), initDate, endDate),
                    aShip.getShipCharacteristics().getVessalType());
            shipTravelDTOAVL.insert(mappedDTO);
        }
        Map<String, List<ShipTravelDTO>> mapShipTravel = new HashMap<>();
        int i = 0;
        for (ShipTravelDTO shipT : shipTravelDTOAVL.inOrder()){
            if(i==n) break;
            if (mapShipTravel.containsKey(shipT.getVesselType())){
                List<ShipTravelDTO> aux = mapShipTravel.get(shipT.getVesselType());
                aux.add(shipT);
                mapShipTravel.put(shipT.getVesselType(),aux);
            }else{
                mapShipTravel.put(shipT.getVesselType(), new ArrayList<>(Arrays.asList(shipT)));
            }
            i++;
        }
        return mapShipTravel;
    }

    /**
     *
     * {@inheritdoc}
     */
    @Override
    public PositionData getPositionDataForGivenTime(String callSign, Timestamp timeStamp) {
        if(callSign==null)
            throw new IllegalArgumentException("Invalid Call Sign. It can not be null.");

        Pattern p = Pattern.compile("[^a-z0-9 ]", Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(callSign);
        if(m.find())
            throw new IllegalArgumentException("Invalid Call Sign. Code isn't alphanumeric.");
        Ship auxShip = shipStore.getShipsCallSign().find(new Ship(-1,-1,callSign,null,-1, new ShipCharacteristics(-1,-1,null,-1,-1,-1,-1),null));
        return shipServiceLogic.getPositionDataForGivenTimestamp(auxShip.getPositionsData(),timeStamp);
    }
}
