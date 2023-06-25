package lapr.project.model;

import lapr.project.utils.datastructures.AVL;

/**
 * @author Group 169 LAPRIII
 */
public class Ship implements Comparable<Ship> {
    private final long idTransport;
    private final int mmsi;
    private final String callSign;
    private final String name;
    private final int imoNumber;
    private final ShipCharacteristics shipCharacteristics;
    private AVL<PositionData> positionsData;

    /**
     * Constructor for Ship Object
     * @param idTransport
     * @param mmsi
     * @param callSign
     * @param shipName
     * @param imoNumber
     * @param positionsData
     */
    public Ship(long idTransport, int mmsi, String callSign, String shipName, int imoNumber, ShipCharacteristics shipCharacteristics, AVL<PositionData> positionsData) {
        this.idTransport = idTransport;
        this.mmsi = mmsi;
        this.callSign = callSign;
        this.name = shipName;
        this.imoNumber = imoNumber;
        this.shipCharacteristics = shipCharacteristics;
        this.positionsData = positionsData;
    }

    /**
     * Gets the ship Transport ID
     * @return long
     */
    public long getIdTransport() {
        return idTransport;
    }

    /**
     * Gets the ship MMSI
     * @return int
     */
    public int getMmsi() {
        return mmsi;
    }

    /**
     * Gets the ship call sign
     * @return String
     */
    public String getCallSign() {
        return callSign;
    }

    /**
     * Gets the name of the ship
     * @return String
     */
    public String getName() {
        return name;
    }

    /**
     * Gets the IMO Number of the Ship
     * @return int
     */
    public int getImoNumber() {
        return imoNumber;
    }

    /**
     * Gets the ship positions data information
     * @return AVL Tree of PositionData objects
     */
    public AVL<PositionData> getPositionsData() {
        return positionsData;
    }

    /**
     * Gets the Ship Characteristics
     * @return ShipCharacteristics
     */
    public ShipCharacteristics getShipCharacteristics() {
        return shipCharacteristics;
    }
    /**
     * Sets the ship position data
     * @param positionsData AVL Tree containing the ship positions data
     */
    public void setPositionsData(AVL<PositionData> positionsData) {
        this.positionsData = positionsData;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public int compareTo(Ship o) {
        return Integer.compare(mmsi, o.mmsi);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null)
            return false;

        if (obj.getClass() != this.getClass())
            return false;

        final Ship another = (Ship) obj;
        return this.mmsi == another.mmsi;
    }

    @Override
    public int hashCode(){
        return this.mmsi;
    }
}
