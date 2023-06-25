package lapr.project.mappers;

import lapr.project.mappers.dtos.CargoManifestAvgDTO;

/**
 * @author Group 169 LAPRIII
 */
public interface CargoManifestMapper {

    /**
     * Maps a new cargoManifestAverageDTO
     * @param cargoManifestQty - Number of CargoManifests
     * @param avgContainerQty - Average quantity of container per Cargo Manifest
     * @return object of cargoManifestAverageDTO
     */
    CargoManifestAvgDTO cargoManifestAverageDTO(int cargoManifestQty, float avgContainerQty);
}
