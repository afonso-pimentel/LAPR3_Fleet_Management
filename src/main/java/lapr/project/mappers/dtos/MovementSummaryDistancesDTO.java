package lapr.project.mappers.dtos;

public class MovementSummaryDistancesDTO {
    private final float departureLatitude;
    private final float departureLongitude;
    private final float arrivalLatitude;
    private final float arrivalLongitude;

    /**
     * Gets the departure latitude
     * @return float
     */
    public float getDepartureLatitude() {
        return departureLatitude;
    }
    /**
     * Gets the departure longitude
     * @return float
     */
    public float getDepartureLongitude() {
        return departureLongitude;
    }
    /**
     * Gets the arrival latitude
     * @return float
     */
    public float getArrivalLatitude() {
        return arrivalLatitude;
    }
    /**
     * Gets the arrival longitude
     * @return float
     */
    public float getArrivalLongitude() {
        return arrivalLongitude;
    }
    /**
     * Gets the travelled distance
     * @return float
     */
    public float getTravelledDistance() {
        return travelledDistance;
    }
    /**
     * Gets the delta distance between the starting position data and ending position data
     * @return float
     */
    public float getDeltaDistance() {
        return deltaDistance;
    }

    private final float travelledDistance;
    private final float deltaDistance;

    public MovementSummaryDistancesDTO(float departureLatitude, float departureLongitude, float arrivalLatitude, float arrivalLongitude, float travelledDistance, float deltaDistance) {
        this.departureLatitude = departureLatitude;
        this.departureLongitude = departureLongitude;
        this.arrivalLatitude = arrivalLatitude;
        this.arrivalLongitude = arrivalLongitude;
        this.travelledDistance = travelledDistance;
        this.deltaDistance = deltaDistance;
    }
}
