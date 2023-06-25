package lapr.project.mappers.dtos;

/**
 * @author Group 169 LAPRIII
 */
public class PortDTO {
    private final int idCode;
    private final String name;
    private final String continent;
    private final String country;
    private final Float latitude;
    private final Float longitude;


    /**
     * Constructor for PortDTO
     *
     * @param idCode    Unique Port identifier
     * @param name      port name
     * @param continent
     * @param country
     * @param latitude
     * @param longitude
     */
    public PortDTO(int idCode, String name, String continent, String country, Float latitude, Float longitude) {
        this.idCode = idCode;
        this.name = name;
        this.continent = continent;
        this.country = country;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public int getIdCode() {
        return idCode;
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

    public Float getLatitude() {
        return latitude;
    }

    public Float getLongitude() {
        return longitude;
    }
}




