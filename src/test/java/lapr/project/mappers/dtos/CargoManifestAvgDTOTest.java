package lapr.project.mappers.dtos;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class CargoManifestAvgDTOTest {


    @Test
    public void invalid_NegativeCargoManifestQuantity_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int averageContainerQuantity = 100;
        int cargoManifestQuantity = -1;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  new CargoManifestAvgDTO(cargoManifestQuantity,averageContainerQuantity));
    }

    @Test
    public void invalid_NegativeAverageContainerQuantity_ShouldThrow_IllegalArgumentException(){
        // Arrange
        int averageContainerQuantity = -1;
        int cargoManifestQuantity = 100;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () ->  new CargoManifestAvgDTO(cargoManifestQuantity,averageContainerQuantity));
    }

    @Test
    public void valid_InputArguments_ShouldReturn_ExpectedObject(){
        // Act & Arrange
        CargoManifestAvgDTO result = new CargoManifestAvgDTO(100, 20);

        // Assert
        assertNotNull(result);
        assertEquals(100,result.getCargoManifestQty());
        assertEquals(20,result.getAvgContainerQty());
    }
}
