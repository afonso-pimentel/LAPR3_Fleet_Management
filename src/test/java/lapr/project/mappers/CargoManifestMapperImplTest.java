package lapr.project.mappers;

import lapr.project.mappers.dtos.CargoManifestAvgDTO;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class CargoManifestMapperImplTest {
    private CargoManifestMapperImpl cargoManifestMapper;


    public CargoManifestMapperImplTest() {
        cargoManifestMapper = new CargoManifestMapperImpl();
    }

    @Test
    public void invalid_NegativeCargoManifestQuantity_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int averageContainerQuantity = 100;
        int cargoManifestQuantity = -1;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  cargoManifestMapper.cargoManifestAverageDTO(cargoManifestQuantity,averageContainerQuantity));
    }

    @Test
    public void invalid_NegativeAverageContainerQuantity_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int averageContainerQuantity = -1;
        int cargoManifestQuantity = 100;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  cargoManifestMapper.cargoManifestAverageDTO(cargoManifestQuantity,averageContainerQuantity));
    }

    @Test
    public void valid_InputArguments_ShouldReturn_ExpectedObject(){
        // Arrange
        CargoManifestAvgDTO expected = new CargoManifestAvgDTO(100, 20);

        // Act
        CargoManifestAvgDTO result = cargoManifestMapper.cargoManifestAverageDTO(100,20);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getCargoManifestQty(), result.getCargoManifestQty());
        assertEquals(expected.getAvgContainerQty(), result.getAvgContainerQty());
    }
}
