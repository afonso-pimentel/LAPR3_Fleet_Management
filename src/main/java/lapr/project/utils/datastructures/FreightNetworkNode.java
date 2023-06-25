package lapr.project.utils.datastructures;

import lapr.project.model.Country;

/**
 * @author Group 169 LAPRIII
 */
public class FreightNetworkNode {
    private final float latitude;
    private final float longitude;
    private final Country country;

    public FreightNetworkNode(float latitude, float longitude, Country country) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.country = country;
    }

    public float getLatitude() {
        return latitude;
    }

    public float getLongitude() {
        return longitude;
    }

    public Country getCountry() {
        return country;
    }
}
