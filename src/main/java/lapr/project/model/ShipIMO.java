package lapr.project.model;

import lapr.project.utils.datastructures.AVL;

public class ShipIMO extends Ship{
    /**
     * Constructor for Ship Object
     *
     * @param idTransport
     * @param mmsi
     * @param callSign
     * @param shipName
     * @param imoNumber
     * @param positionsData
     */
    public ShipIMO(long idTransport, int mmsi, String callSign, String shipName, int imoNumber, ShipCharacteristics shipCharacteristics, AVL<PositionData> positionsData) {
        super(idTransport, mmsi, callSign, shipName, imoNumber, shipCharacteristics, positionsData);
    }

    /**
     *
     * @param ship
     *
     * Constructor of a ShipIMO by Ship Object.
     *
     */
    public ShipIMO(Ship ship){
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
     * CompareTo by IMO number.
     *
     */
    @Override
    public int compareTo(Ship o) {
        if (o.getImoNumber()>super.getImoNumber()){
                return -1;
        }else if(o.getImoNumber()<super.getImoNumber()){
            return 1;
        }
        return 0;

    }


}
