package lapr.project.mappers.dtos;

import lapr.project.model.PositionData;
import lapr.project.services.ShipServiceImpl;
import lapr.project.utils.utilities.Utilities;
import org.junit.jupiter.api.Test;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class MovementSummaryDTOTest {

    @Test
    public void invalid_NulLStartDate_ShouldThrow_IllegalArgumentException(){
        // Arrange
        Date nullArgument = null;
        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(43.53f, 110.55f,
                44.39094f, 133.71335f, 4822, 1850);

        MovementSummaryMetricsDTO movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(19.7f, 17.2f, 157.5f, 151.75f);

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> new MovementSummaryDTO(20, 4,
                movementSummaryMetricsDTO,movementSummaryDistancesDTO,
                nullArgument, new Date(1609306200000l)));
    }

    @Test
    public void invalid_NulLEndDate_ShouldThrow_IllegalArgumentException(){
        // Arrange
        Date nullArgument = null;
        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(43.53f, 110.55f,
                44.39094f, 133.71335f, 4822, 1850);

        MovementSummaryMetricsDTO movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(19.7f, 17.2f, 157.5f, 151.75f);

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> new MovementSummaryDTO(20, 4,
                movementSummaryMetricsDTO,movementSummaryDistancesDTO,
                new Date(1609306200000l), nullArgument));
    }

    @Test
    public void valid_Arguments_ShouldNotThrowException(){
        // Act & Assert
        MovementSummaryDistancesDTO movementSummaryDistancesDTO = new MovementSummaryDistancesDTO(43.53f, 110.55f,
                44.39094f, 133.71335f, 4822, 1850);

        MovementSummaryMetricsDTO movementSummaryMetricsDTO = new MovementSummaryMetricsDTO(19.7f, 17.2f, 157.5f, 151.75f);

        assertDoesNotThrow(() -> new MovementSummaryDTO(20, 4,
                movementSummaryMetricsDTO, movementSummaryDistancesDTO,
                new Date(1609306200000l), new Date(1609306200000l)));
    }
}
