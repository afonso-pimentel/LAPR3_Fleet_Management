package lapr.project.model;

import lapr.project.utils.datastructures.AVL;

public class ShipCallSign extends Ship{

    /**
     * Constructor for Ship Object
     *
     * @param idTransport
     * @param mmsi
     * @param callSign
     * @param shipName
     * @param positionsData
     */
    public ShipCallSign(long idTransport, int mmsi, String callSign, String shipName, int imoNumber, ShipCharacteristics shipCharacteristics,  AVL<PositionData> positionsData) {
        super(idTransport, mmsi, callSign, shipName, imoNumber, shipCharacteristics, positionsData);
    }

    /**
     *
     * @param ship
     *
     * Constructor of a ShipCallSign by Ship Object.
     *
     */
    public ShipCallSign(Ship ship){
        super(ship.getIdTransport(),
                ship.getMmsi(),
                ship.getCallSign(),
                ship.getName(),
                ship.getImoNumber(),
                ship.getShipCharacteristics(),
                ship.getPositionsData());
    }

    /**
     *
     * @param o
     *
     * CompareTo by CallSign number.
     *
     */
    @Override
    public int compareTo(Ship o) {
        return super.getCallSign().compareTo(o.getCallSign());
    }


}
