package lapr.project.mappers.dtos;

public class ShipTravelDTO implements Comparable<ShipTravelDTO>{
    private final int mmsi;
    private final float travelDistance;
    private final float meanSOG;
    private final String vesselType;

    /**
     * Constructor for ShipDTO
     * @param mmsi Unique Ship identifier
     * @param travelDistance Total travel distance the ship made in the trip
     * @param meanSOG Mean of the SOG of a ship in an interval of time
     * @param vesselType Ship's vessel type.
     */
    public ShipTravelDTO(int mmsi, float travelDistance, float meanSOG, String vesselType) {
        this.mmsi = mmsi;
        this.travelDistance = travelDistance;
        this.meanSOG = meanSOG;
        this.vesselType = vesselType;
    }

    /**
     * Gets the ship Transport ID
     * @return long
     */
    public int getMmsi() {
        return mmsi;
    }

    /**
     * Total travel distance the ship made in the trip in kms
     * @return float
     */
    public float getTravelDistance() {
        return travelDistance;
    }

    /**
     *
     * MeanSOG of a ship in an interval of Time
     * @return
     */
    public float getMeanSOG() {
        return meanSOG;
    }

    /**
     * Ship's vessel type.
     * @return
     */
    public String getVesselType() {
        return vesselType;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public int compareTo(ShipTravelDTO o) {
        if(o == null)
            throw new IllegalArgumentException("PositionData argument cannot be null");

        if(o.getTravelDistance() > this.travelDistance)
            return 1;

        if(o.getTravelDistance() < this.travelDistance)
            return -1;

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

        final ShipTravelDTO another = (ShipTravelDTO) obj;
        return this.mmsi == another.mmsi;

    }

    /**
     * {@inheritdoc}
     */
    @Override
    public int hashCode(){
        return this.mmsi;
    }
}

