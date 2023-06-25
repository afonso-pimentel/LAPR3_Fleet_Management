package lapr.project.mappers.dtos;

import lapr.project.model.enums.LocationType;

/**
 * @author Group 169 LAPRIII
 */
public class ContainerSituationDTO {
    private final String locationName;
    private final LocationType locationType;

    /**
     * Constructor for the ContainerSituationDTO
     * @param cargoSiteName
     * @param cargoSiteType
     */
    public ContainerSituationDTO(String cargoSiteName, LocationType cargoSiteType) {
        this.locationName = cargoSiteName;
        this.locationType = cargoSiteType;
    }

    /**
     * Get's the cargo site name
     * @return CargoSiteName
     */
    public String getLocationName() {
        return locationName;
    }

    /**
     * Gets the location type
     * @return LocationType
     */
    public LocationType getLocationType() {
        return locationType;
    }

}
