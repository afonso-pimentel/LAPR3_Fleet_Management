package lapr.project.mappers.dtos;

public class ShipPairDTO implements Comparable<ShipPairDTO> {
    private final int mmsi;
    private final int totalMoves;
    private final float travelDistance;
    private final float originDistance;
    private final float destinationDistance;

    /**
     * Gets the ship Transport ID
     * @return long
     */
    public int getMmsi() {
        return mmsi;
    }

    /**
     * Total number of movements the ship made
     * @return long
     */
    public int getTotalMoves() {
        return totalMoves;
    }

    /**
     * Total travel distance the ship made in the trip in kms
     * @return float
     */
    public float getTravelDistance() {
        return travelDistance;
    }

    /***
     * Gets the ship distance between the origin point
     * @return float
     */
    public float getOriginDistance() {
        return originDistance;
    }
    /***
     * Gets the ship distance between the destination point
     * @return float
     */
    public float getDestinationDistance() {
        return destinationDistance;
    }

    /**
     * Constructor for ShipPairDTO
     *  @param mmsi           Unique Ship identifier
     * @param totalMoves     Total number of movements the ship made
     * @param travelDistance Total travel distance the ship made in the trip
     * @param originDistance Distance between the origin point of two ships
     * @param destinationDistance Distance between the destination point of two ships
     */
    public ShipPairDTO(int mmsi, int totalMoves, float travelDistance, float originDistance, float destinationDistance) {
        this.mmsi = mmsi;
        this.totalMoves = totalMoves;
        this.travelDistance = travelDistance;
        this.originDistance = originDistance;
        this.destinationDistance = destinationDistance;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public int compareTo(ShipPairDTO o) {
        if(o == null)
            throw new IllegalArgumentException("Ship pair argument cannot be null");

        if(o.getTravelDistance() > this.travelDistance)
            return 1;

        if(o.getTravelDistance() < this.travelDistance)
            return -1;

        if(o.getMmsi() > this.mmsi)
            return -1;

        if(o.getMmsi() < this.mmsi)
            return 1;

        return 0;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public boolean equals(Object obj) {
        if (obj == null)
            return false;

        if (obj.getClass() != this.getClass())
            return false;

        final ShipPairDTO another = (ShipPairDTO) obj;
        return this.mmsi == another.mmsi;
    }

    @Override
    public int hashCode(){
        return this.mmsi;
    }

}
