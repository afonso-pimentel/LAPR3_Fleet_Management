package lapr.project.model;


import java.util.Objects;

/**
 * @author Group 169 LAPRIII
 */
public class Port {
    private final String name;
    private final String continent;
    private final String country;
    private final int idCode;
    private final float latitude;
    private final float longitude;

    /**
     * Constructor for Port
     * @param name
     * @param continent
     * @param country
     * @param idCode
     * @param latitude
     * @param longitude
     */
    public Port(String name, String continent, String country, int idCode, float latitude, float longitude) {
        this.name = name;
        this.continent = continent;
        this.country = country;
        this.idCode = idCode;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public String getName() {
        return name;
    }

    public String getContinent() {
        return continent;
    }

    public String getCountry() {
        return country;
    }

    public int getIdCode() {
        return idCode;
    }

    public float getLatitude() {
        return latitude;
    }

    public float getLongitude() {
        return longitude;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Port port = (Port) o;
        return idCode == port.idCode && Float.compare(port.latitude, latitude) == 0 && Float.compare(port.longitude, longitude) == 0 && Objects.equals(name, port.name) && Objects.equals(continent, port.continent) && Objects.equals(country, port.country);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, continent, country, idCode, latitude, longitude);
    }
}
