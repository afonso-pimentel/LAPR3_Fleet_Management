package lapr.project.mappers.dtos;

import lapr.project.model.enums.ContainerTempType;
import lapr.project.model.enums.LocationType;

public class ContainerToLoadOnPortDTO {

    private final String idContainer;
    private final int payload;
    private final ContainerTempType type;
    private final LocationType cargoSiteType;
    private final String cargoSiteName;
    private final String country;

    /**
     * Constructor for the ContainerToLoadOnPortDTO
     *
     * @param idContainer
     * @param payload
     * @param type
     * @param cargoSiteType
     * @param cargoSiteName
     */
    public ContainerToLoadOnPortDTO(String idContainer, int payload, ContainerTempType type, LocationType cargoSiteType, String cargoSiteName, String country) {
        this.idContainer = idContainer;
        this.payload = payload;
        this.type = type;
        this.cargoSiteType = cargoSiteType;
        this.cargoSiteName = cargoSiteName;
        this.country = country;
    }


    /**
     * Method to get the Container's ID
     *
     * @return
     */
    public String getIdContainer() {
        return idContainer;
    }

    /**
     * Method to get the Container's Payload
     *
     * @return
     */
    public int getPayload() {
        return payload;
    }

    /**
     * Method to get the Container's type
     *
     * @return
     */
    public ContainerTempType getType() {
        return type;
    }

    /**
     * Method to get the CargoSiteType where this container is set to be Unloaded
     *
     * @return
     */
    public LocationType getCargoSiteType() {
        return cargoSiteType;
    }

    /**
     * Method to get the CargoSite's name
     *
     * @return
     */
    public String getCargoSiteName() {
        return cargoSiteName;
    }

    public String getCountry() {
        return country;
    }
}
