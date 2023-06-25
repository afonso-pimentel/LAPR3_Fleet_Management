package lapr.project.mappers.dtos;

import lapr.project.model.enums.ContainerTempType;
import lapr.project.model.enums.LocationType;

public class ContainerWithNextPortDTO{
    private final String idContainer;
    private final int payload;
    private final ContainerTempType type;
    private final String xyzPosition;
    private final LocationType cargoSiteType;
    private final String cargoSiteName;

    /**
     * Constructor for the ContainerWithNextPortDTO
     * @param idContainer
     * @param payload
     * @param type
     * @param xyzPosition
     * @param cargoSiteType
     * @param cargoSiteName
     */
    public ContainerWithNextPortDTO(String idContainer, int payload, ContainerTempType type, String xyzPosition, LocationType cargoSiteType, String cargoSiteName) {
        this.idContainer = idContainer;
        this.payload = payload;
        this.type = type;
        this.xyzPosition = xyzPosition;
        this.cargoSiteType = cargoSiteType;
        this.cargoSiteName = cargoSiteName;

    }

    /**
     * Method to get the Container's ID
     * @return
     */
    public String getIdContainer() {
        return idContainer;
    }

    /**
     * Method to get the Container's Payload
     * @return
     */
    public int getPayload() {
        return payload;
    }

    /**
     * Method to get the Container's Position in the Ship
     * @return
     */
    public String getXyzPosition() {
        return xyzPosition;
    }

    /**
     * Method to get the Container's type
     * @return
     */
    public ContainerTempType getType() {
        return type;
    }

    /**
     * Method to get the CargoSiteType where this container is set to be Unloaded
     * @return
     */
    public LocationType getCargoSiteType() {
        return cargoSiteType;
    }

    /**
     * Method to get the CargoSite's name
     * @return
     */
    public String getCargoSiteName() {
        return cargoSiteName;
    }

}
