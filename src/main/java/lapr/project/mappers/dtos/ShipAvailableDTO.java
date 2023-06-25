package lapr.project.mappers.dtos;

/**
 * @author Group 169 LAPRIII
 */
public class ShipAvailableDTO {
    private final int shipMMSI;
    private final String shipName;
    private final String locationDescription;
    private final float locationLatitude;
    private final float locationLongitude;

    public ShipAvailableDTO(int shipMMSI, String shipName, String locationDescription, float locationLatitude, float locationLongitude) {
        this.shipMMSI = shipMMSI;
        this.shipName = shipName;
        this.locationDescription = locationDescription;
        this.locationLatitude = locationLatitude;
        this.locationLongitude = locationLongitude;
    }

    /**
     * Gets the ship MMSI
     * @return int
     */
    public int getShipMMSI() {
        return shipMMSI;
    }

    /**
     * Gets the ship name
     * @return String
     */
    public String getShipName() {
        return shipName;
    }

    /**
     * Gets location description of the ship
     * @return String
     */
    public String getLocationDescription() {
        return locationDescription;
    }

    /**
     * Gets the ship location latitude
     * @return float
     */
    public float getLocationLatitude() {
        return locationLatitude;
    }

    /**
     * Gets the ship location longitude
     * @return float
     */
    public float getLocationLongitude() {
        return locationLongitude;
    }
}
