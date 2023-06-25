package lapr.project.services;

import lapr.project.mappers.PortMapperImpl;
import lapr.project.model.Port;
import lapr.project.model.PositionData;
import lapr.project.stores.PortStoreImpl;

import java.sql.Timestamp;

public class PortServiceImpl implements PortService {
    private final PortStoreImpl portStore;
    private final ShipServiceImpl shipService;
    private final PortMapperImpl portMapper;

    public PortServiceImpl(PortStoreImpl portStore, ShipServiceImpl shipService, PortMapperImpl portMapper) {
        if(portStore == null)
            throw new IllegalArgumentException("PortStore can't be null");
        if(shipService == null)
            throw new IllegalArgumentException("ShipService can't be null");
        if(portMapper == null)
            throw new IllegalArgumentException("PortMapper can't be null");
        this.portStore = portStore;
        this.shipService = shipService;
        this.portMapper = portMapper;
    }

    @Override
    public Port getClosestPortToShipInGivenDate(String callSign, Timestamp dateTime) {
        if(callSign==null){
           throw new IllegalArgumentException("CallSign can't be null");
        }
        if(dateTime==null){
            throw new IllegalArgumentException("DateTime can't be null");
        }
        PositionData auxPD = shipService.getPositionDataForGivenTime(callSign,dateTime);
        return getNearestNeighbour(auxPD.getLatitude(),auxPD.getLongitude());
    }

    private Port getNearestNeighbour(float latShip, float lonShip) {
        return portStore.getPorts().findNearestNeighbour(lonShip,latShip);
    }
}