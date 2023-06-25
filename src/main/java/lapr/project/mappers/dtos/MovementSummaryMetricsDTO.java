package lapr.project.mappers.dtos;

public class MovementSummaryMetricsDTO {
    private final float maxSOG;
    private final float meanSOG;
    private final float maxCOG;
    private final float meanCOG;

    public MovementSummaryMetricsDTO(float maxSOG, float meanSOG, float maxCOG, float meanCOG) {
        this.maxSOG = maxSOG;
        this.meanSOG = meanSOG;
        this.maxCOG = maxCOG;
        this.meanCOG = meanCOG;
    }

    /**
     * Gets the maximum Speed Over Ground
     * @return float
     */
    public float getMaxSOG() {
        return maxSOG;
    }

    /**
     * Gets the median Speed Over Ground
     * @return float
     */
    public float getMeanSOG() {
        return meanSOG;
    }

    /**
     * Gets the maximum Course Over Ground
     * @return float
     */
    public float getMaxCOG() {
        return maxCOG;
    }

    /**
     * Gets the median Course Over Ground
     * @return float
     */
    public float getMeanCOG() {
        return meanCOG;
    }
}
