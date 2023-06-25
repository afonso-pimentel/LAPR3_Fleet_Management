package lapr.project.mappers;

import lapr.project.mappers.dtos.ContainerSituationDTO;
import lapr.project.mappers.dtos.ContainerToLoadOnPortDTO;
import lapr.project.mappers.dtos.ContainerWithNextPortDTO;

/**
 * @author Group 169 LAPRIII
 */
public interface ContainerMapper {

    /**
     * Maps the name and type of the location to a ContainerSituationDTO
     * @param locationName Name of the location
     * @param locationType Type of the location
     * @return ContainerSituationDTO
     */
    ContainerSituationDTO mapToContainerSituationDTO(String locationName, String locationType);

    /**
     * Maps values into a ContainerWithNextPortDTO
     * @param containerId
     * @param containerLoad
     * @param containerType
     * @param containerPosition
     * @param cargoSiteType
     * @param cargoSiteName
     * @return
     */
    ContainerWithNextPortDTO mapToContainerWithNextPortDTO(String containerId, int containerLoad, int containerType, String containerPosition, String cargoSiteType, String cargoSiteName);


    /**
     * Maps values into a ContainerToLoadOnPortDTO
     * @param containerId
     * @param containerLoad
     * @param containerType
     * @param country
     * @param cargoSiteType
     * @param cargoSiteName
     * @return
     */
    ContainerToLoadOnPortDTO mapToContainerToLoadOnPortDTO(String containerId, int containerLoad, int containerType, String cargoSiteType, String cargoSiteName, String country);



}
