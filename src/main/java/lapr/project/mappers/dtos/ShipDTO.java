package lapr.project.mappers.dtos;

/**
 * @author Group 169 LAPRIII
 */
public class ShipDTO implements Comparable<ShipDTO>{
    private final int mmsi;
    private final long totalMoves;
    private final float travelDistance;
    private final float deltaDistance;

    /**
     * Constructor for ShipDTO
     * @param mmsi Unique Ship identifier
     * @param totalMoves Total number of movements the ship made
     * @param travelDistance Total travel distance the ship made in the trip
     * @param deltaDistance Distance between the first point and last point of the trip the ship made
     */
    public ShipDTO(int mmsi, long totalMoves, float travelDistance, float deltaDistance) {
        this.mmsi = mmsi;
        this.totalMoves = totalMoves;
        this.travelDistance = travelDistance;
        this.deltaDistance = deltaDistance;
    }

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
    public long getTotalMoves() {
        return totalMoves;
    }

    /**
     * Total travel distance the ship made in the trip in kms
     * @return float
     */
    public float getTravelDistance() {
        return travelDistance;
    }

    /**
     * Distance between the first point and last point of the trip the ship made in kms
     * @return float
     */
    public float getDeltaDistance() {
        return deltaDistance;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public int compareTo(ShipDTO o) {
        if(o == null)
            throw new IllegalArgumentException("Ship argument cannot be null");

        if(o.getTravelDistance() > this.travelDistance)
            return 1;

        if(o.getTravelDistance() < this.travelDistance)
            return -1;

        if(o.getTotalMoves() > this.totalMoves)
            return -1;

        if(o.getTotalMoves() < this.totalMoves)
            return 1;

        return 0;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null)
            return false;

        if (obj.getClass() != this.getClass())
            return false;

        final ShipDTO another = (ShipDTO) obj;
        return this.mmsi == another.mmsi;

    }

    @Override
    public int hashCode(){
        return this.mmsi;
    }
}
