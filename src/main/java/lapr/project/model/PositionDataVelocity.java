package lapr.project.model;

public class PositionDataVelocity {
    private final float sog;
    private final float cog;

    public PositionDataVelocity(float sog, float cog) {
        this.sog = sog;
        this.cog = cog;
    }

    /**
     * Gets the ships Speed Over Ground
     * @return float
     */
    public float getSog() {
        return sog;
    }

    /**
     * Gets the ships Course Over Ground
     * @return float
     */
    public float getCog() {
        return cog;
    }
}
