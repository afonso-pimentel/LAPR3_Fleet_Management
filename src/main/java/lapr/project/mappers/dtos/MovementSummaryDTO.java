package lapr.project.mappers.dtos;

import java.util.Date;

/**
 * @author Group 169 LAPRIII
 */
public class MovementSummaryDTO {
    private final long totalMovementTime;
    private final int totalNumberOfMovements;
    private final Date startDate;
    private final Date endDate;
    private final MovementSummaryDistancesDTO movementSummaryDistancesDTO;
    private final MovementSummaryMetricsDTO movementSummaryMetricsDTO;

    public MovementSummaryDTO(long totalMovementTime, int totalNumberOfMovements, MovementSummaryMetricsDTO movementSummaryMetricsDTO, MovementSummaryDistancesDTO movementSummaryDistancesDTO, Date startDate, Date endDate) {
        if(startDate == null)
            throw new IllegalArgumentException("StartDate argument cannot be null");

        if(endDate == null)
            throw new IllegalArgumentException("EndDate argument cannot be null");

        this.totalMovementTime = totalMovementTime;
        this.totalNumberOfMovements = totalNumberOfMovements;
        this.movementSummaryDistancesDTO = movementSummaryDistancesDTO;
        this.movementSummaryMetricsDTO = movementSummaryMetricsDTO;
        this.startDate = (Date)startDate.clone();
        this.endDate = (Date)endDate.clone();
    }

    /**
     * Gets movement summary metrics DTO
     * @return MovementSummaryMetricsDTO
     */
    public MovementSummaryMetricsDTO getMovementSummaryMetricsDTO() {
        return movementSummaryMetricsDTO;
    }

    /**
     * Gets the total movement time
     * @return long
     */
    public long getTotalMovementTime() {
        return totalMovementTime;
    }

    /**
     * Gets the total number of movements
     * @return int
     */
    public int getTotalNumberOfMovements() {
        return totalNumberOfMovements;
    }

    /**
     * Gets the start date of the positions data
     * @return Date
     */
    public Date getStartDate() {
        return (Date)startDate.clone();
    }

    /**
     * Gets the end date of the positions data
     * @return Date
     */
    public Date getEndDate() {
        return (Date)endDate.clone();
    }

    /**
     * Gets the movement summary of distances travelled
     * @return MovementSummaryDistancesDTO
     */
    public MovementSummaryDistancesDTO getMovementSummaryDistancesDTO() {
        return movementSummaryDistancesDTO;
    }
}
