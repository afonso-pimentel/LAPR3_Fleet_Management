package lapr.project.model;

public class ShipCharacteristics {
    private final int numGen;
    private final int genOutput;
    private final String vessalType;
    private final int length;
    private final int width;
    private final int capacity;
    private final float draft;

    public ShipCharacteristics(int numGen, int genOutput, String vessalType, int length, int width, int capacity, float draft) {
        this.numGen = numGen;
        this.genOutput = genOutput;
        this.vessalType = vessalType;
        this.length = length;
        this.width = width;
        this.capacity = capacity;
        this.draft = draft;
    }

    /**
     * Gets the generators number
     * @return int
     */
    public int getNumGen() {
        return numGen;
    }

    /**
     * Gets the generator output number
     * @return int
     */
    public int getGenOutput() {
        return genOutput;
    }

    /**
     * Gets the vessal type of the ship
     * @return String
     */
    public String getVessalType() {
        return vessalType;
    }

    /**
     * Gets the length of the ship
     * @return int
     */
    public int getLength() {
        return length;
    }

    /**
     * Gets the ship width
     * @return int
     */
    public int getWidth() {
        return width;
    }

    /**
     * Gets the ship capacity
     * @return int
     */
    public int getCapacity() {
        return capacity;
    }

    /**
     * Gets the ship draft
     * @return float
     */
    public float getDraft() {
        return draft;
    }
}
