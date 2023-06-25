package lapr.project.mappers;

import lapr.project.mappers.dtos.ContainerSituationDTO;
import lapr.project.mappers.dtos.ContainerToLoadOnPortDTO;
import lapr.project.mappers.dtos.ContainerWithNextPortDTO;
import lapr.project.model.enums.ContainerTempType;
import lapr.project.model.enums.LocationType;

import java.util.Locale;

/**
 * @author Group 169 LAPRIII
 */
public class ContainerMapperImpl implements ContainerMapper {

    /**
     * {@inheritdoc}
     */
    @Override
    public ContainerSituationDTO mapToContainerSituationDTO(String locationName, String locationType) {

        if (locationType == null)
            throw new IllegalArgumentException("cargoSiteType argument cannot be null");

        return new ContainerSituationDTO(locationName, LocationType.valueOf(locationType.toUpperCase(Locale.ROOT)));
    }

    @Override
    public ContainerWithNextPortDTO mapToContainerWithNextPortDTO(String containerId, int containerLoad, int containerType, String containerPosition, String cargoSiteType, String cargoSiteName) {

        if (containerId == null) {
            throw new IllegalArgumentException("Container_Id argument cannot be null");
        }

        if (containerLoad <= 0) {
            throw new IllegalArgumentException("Container_load argument must be over 0");
        }

        if (containerType != 7 && containerType != -5) {
            throw new IllegalArgumentException("Container_type argument cannot be different than 7 or -5");
        }

        if (containerPosition == null) {
            throw new IllegalArgumentException("Container_position argument cannot be null");
        }

        if (cargoSiteType == null) {
            throw new IllegalArgumentException("Cargo_site_type argument cannot be null");
        }

        if (!cargoSiteType.equalsIgnoreCase("Port")) {
            throw new IllegalArgumentException("Cargo Site can not be any other than Port.");
        }

        if (cargoSiteName == null) {
            throw new IllegalArgumentException("Cargo Site Name argument cannot be null");
        }

        LocationType cargoSiteTypeEnumValue = LocationType.PORT;
        ContainerTempType containerTempType = ContainerTempType.MAINTAIN_MINUS_5_DEGREES;

        if (containerType == 7) {
            containerTempType = ContainerTempType.MAX_TEMP_7_DEGREES;
        }

        return new ContainerWithNextPortDTO(containerId, containerLoad, containerTempType, containerPosition, cargoSiteTypeEnumValue, cargoSiteName);
    }

    @Override
    public ContainerToLoadOnPortDTO mapToContainerToLoadOnPortDTO(String containerId, int containerLoad, int containerType, String cargoSiteType, String cargoSiteName, String country) {

        if (cargoSiteType == null) {
            throw new IllegalArgumentException("Cargo_site_type argument cannot be null");
        }

        if (cargoSiteName == null) {
            throw new IllegalArgumentException("Cargo Site Name argument cannot be null");
        }

        if (country == null) {
            throw new IllegalArgumentException("Country argument cannot be null");
        }

        if (containerId == null) {
            throw new IllegalArgumentException("Container_Id argument cannot be null");
        }

        if (containerLoad <= 0) {
            throw new IllegalArgumentException("ContainerLoad arguments must be over 0");
        }

        if (!cargoSiteType.equalsIgnoreCase("Port")) {
            throw new IllegalArgumentException("Cargo Site can not be any other than Port.");
        }

        LocationType cargoSiteTypeEnumValue = LocationType.PORT;
        ContainerTempType containerTempType = ContainerTempType.MAINTAIN_MINUS_5_DEGREES;

        if (containerType == 7) {
            containerTempType = ContainerTempType.MAX_TEMP_7_DEGREES;
        }

        return new ContainerToLoadOnPortDTO(containerId, containerLoad, containerTempType, cargoSiteTypeEnumValue, cargoSiteName, country);
    }
}
