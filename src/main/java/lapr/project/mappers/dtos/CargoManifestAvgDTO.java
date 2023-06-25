package lapr.project.mappers.dtos;

/**
 * @author Group 169 LAPRIII
 */
public class CargoManifestAvgDTO {
    private final int cargoManifestQty;
    private final float avgContainerQty;

    public CargoManifestAvgDTO(int cargoManifestQty, float avgContainerQty) {
        if(cargoManifestQty < 0)
            throw new IllegalArgumentException("cargoManifest quantity argument cannot be negative");
        if(avgContainerQty < 0)
            throw new IllegalArgumentException("Average container quantity argument cannot be negative");
        this.cargoManifestQty = cargoManifestQty;
        this.avgContainerQty = avgContainerQty;
    }

    public int getCargoManifestQty() {
        return cargoManifestQty;
    }

    public float getAvgContainerQty() {
        return avgContainerQty;
    }
}
