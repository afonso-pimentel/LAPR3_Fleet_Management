package lapr.project.mappers.dtos;

/**
 * @author Group 169 LAPRIII
 */
public class ShipMovementSummaryDTO {
    private final MovementSummaryDTO movementSummaryDTO;
    private final int mmsi;
    private final String vesselName;

    public ShipMovementSummaryDTO(MovementSummaryDTO movementSummaryDTO, int mmsi, String vesselName) {
        this.movementSummaryDTO = movementSummaryDTO;
        this.mmsi = mmsi;
        this.vesselName = vesselName;
    }

    /**
     * Gets the MovementSummary
     * @return MovementSummaryDTO
     */
    public MovementSummaryDTO getMovementSummaryDTO() {
        return movementSummaryDTO;
    }

    /**
     * Gets the MMSI code
     * @return int
     */
    public int getMmsi() {
        return mmsi;
    }

    /**
     * Gets the ship's vessel name
     * @return float
     */
    public String getVesselName() {
        return vesselName;
    }
}
