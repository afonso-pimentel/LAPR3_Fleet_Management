package lapr.project.mappers;

import lapr.project.mappers.dtos.CargoManifestAvgDTO;

/**
 * @author Group 169 LAPRIII
 */
public class CargoManifestMapperImpl implements CargoManifestMapper{

    /**
     * {@inheritdoc}
     */
    @Override
    public CargoManifestAvgDTO cargoManifestAverageDTO(int cargoManifestQty, float avgContainerQty) {
        if(cargoManifestQty < 0)
            throw new IllegalArgumentException("cargoManifest quantity argument cannot be negative");
        if(avgContainerQty < 0)
            throw new IllegalArgumentException("Average container quantity argument cannot be negative");
        return new CargoManifestAvgDTO(cargoManifestQty,avgContainerQty);
    }
}
