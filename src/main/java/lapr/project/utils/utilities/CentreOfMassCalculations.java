package lapr.project.utils.utilities;

import lapr.project.model.Solid;

import java.util.List;

public class CentreOfMassCalculations {


    public static final String exceptionNegative = "Negative values.";
    /**
     * Returns solid's centre of mass
     *
     * @param solid
     * @return
     */
    public float[] centreOfMassOfRectangularPrism(Solid solid) {
        float[] coordinates = new float[3];
        coordinates[0] = (solid.getLength() / 2) + solid.getOrigin()[0]; //X
        coordinates[1] = (solid.getWidth() / 2) + solid.getOrigin()[1]; //Y
        coordinates[2] = (solid.getHeight() / 2) + solid.getOrigin()[2]; //Z
        return coordinates;
    }

    /**
     * Since all containers will have the same
     * dimensions and weight,
     * this method returns a Solid with the characteristics of a standard
     * 20 foot container. the 500 kg weight is due to the established half
     * a ton value of weight for every container.
     * <p>
     * The only thing that changes for every container is its origin coordinates,
     * each must be defined in the algorithm of container placement when this
     * method is called.
     *
     * @param origin
     * @return
     */
    private Solid containerSolid(float[] origin) {
        float containerLength = 6.10f;
        float containerWidth = 2.44f;
        float containerHeight = 2.59f;
        float containerWeight = 500f;
        return new Solid(containerLength, containerWidth, containerHeight, containerWeight, origin);
    }

    /**
     * Σ miri
     * Center of mass = _______
     * M
     * Calculates the above formula for a system composed by
     * many solids. In this case, rectangular prisms.
     *
     * @param listOfComposingSolids
     * @return
     */
    public float[] centreOfMassOfComposedSolid(List<Solid> listOfComposingSolids) {
        if(listOfComposingSolids==null) throw new IllegalArgumentException("Null List.");
        float oM = 0f;
        float[] systemCentre = new float[3];
        for (Solid solid : listOfComposingSolids) {
            float m = solid.getWeight();
            oM += m;
            float[] solidCentre = centreOfMassOfRectangularPrism(solid);
            float x = solidCentre[0];
            float y = solidCentre[1];
            float z = solidCentre[2];
            systemCentre[0] += (m * x); // Σ mixi
            systemCentre[1] += (m * y); // Σ miyi
            systemCentre[2] += (m * z); // Σ mizi
        }
        if (floatIsZero(oM)) {
            return systemCentre;
        }else{
            systemCentre[0] = systemCentre[0] / oM; // xcom = Σ mixi / M
            systemCentre[1] = systemCentre[1] / oM; // ycom = Σ miyi / M
            systemCentre[2] = systemCentre[2] / oM; // zcom = Σ mizi / M
        }


        return systemCentre;
    }

    /**
     * n is the number of containers to be positioned.
     * The deck's limits are set to coordinate where there shouldn't be any more
     * containers positioned.
     * <p>
     * In terms of x coordinate, the last container should be
     * positioned up to (2 * ship's centre of mass  - control bridge's length - 2 m
     * <p>
     * In terms of y coordinate, a small margin can be considered, for example
     * (ship's width - 2 m)
     * <p>
     * In terms of z coordinate, the containers shouldn't go over the control bridge's
     * window. If we consider it to be at 3/4 of the bridge's height, we'll have
     * (ship base's height + 3/4 control bridge's height)
     * <p>
     * The deck's origin starts in the x coordinate of ship's control bridge + 2 m
     * <p>
     * Reminder: the origin of a given solid is the left inferior point of it.
     * Check the documentation with the drawings regarding it.
     * <p>
     * <p>
     * Fills a 3D matrix with n containers as a spiral.
     *
     * @param xNumContainer
     * @param yNumContainer
     * @param zNumContainer
     * @param n
     * @return
     */
    public int[][][] containerUnitPlacement(int xNumContainer, int yNumContainer, int zNumContainer, int n) {
        if (intIsNegative(xNumContainer) || intIsNegative(yNumContainer) || intIsNegative(zNumContainer) || intIsNegative(n))
            throw new IllegalArgumentException(exceptionNegative);
        if (xNumContainer * yNumContainer * zNumContainer < n)
            throw new IllegalArgumentException("N over limit of ship capacity.");
        int x = 0;
        int y = 0;
        int z = 0;
        int containerCounter = 0;
        int dx = 0;
        int dy = -1;
        int t = Math.max(xNumContainer, yNumContainer);
        int[][][] filledMatrix = new int[xNumContainer][yNumContainer][zNumContainer];
        if (fillMatrixWithZero(filledMatrix)) {
            int maxI = t * t;
            while (z < zNumContainer) {
                for (int i = 0; i < maxI; i++) {
                    if ((-xNumContainer / 2 <= x) && (x <= xNumContainer / 2) && (-yNumContainer / 2 <= y) && (y <= yNumContainer / 2) && (containerCounter < n)) {
                        filledMatrix[x + (xNumContainer / 2)][y + (yNumContainer / 2)][z] = 1;
                        containerCounter++;
                    }
                    if ((x == y) || ((x < 0) && (x == -y)) || ((x > 0) && (x == 1 - y))) {
                        t = dx;
                        dx = -dy;
                        dy = t;
                    }
                    x += dx;
                    y += dy;
                }
                z++;
                x = y = dx = 0;
                dy = -1;
            }
        }
        return filledMatrix;
    }

    /**
     * This method picks up the unitary Matrix filled with zeros and ones
     * where each 1 is representing a container occupying that position.
     * The last piece we need to create a Solid object is its origin in
     * respect to the system's origin. Since we know the origin of the
     * deck we considered, we can find out through the multiplication
     * of it by the indexes of each position where a container is positioned.
     * <p>
     * We can then create an object and fill an ArrayList with it for further
     * use in centre of mass calculations.
     *
     * @param unitMatrix
     * @param originPattern
     * @param xMax
     * @param yMax
     * @param zMax
     * @return
     */
    public void insertContainersInDeck(int[][][] unitMatrix, float[] deckOrigin, float[] originPattern, int xMax, int yMax, int zMax, List<Solid> listOfComposingSolids) {
        if (intIsNegative(xMax) ||intIsNegative(yMax) || intIsNegative(zMax) || unitMatrix == null || deckOrigin == null || originPattern == null || listOfComposingSolids == null) throw new IllegalArgumentException("Negative or null values.");
        for (int i = 0; i < xMax; i++) {
            for (int j = 0; j < yMax; j++) {
                for (int k = 0; k < zMax; k++) {
                    if (unitMatrix[i][j][k] == 1) {
                        float[] containerOrigin = {deckOrigin[0] + originPattern[0] * i, deckOrigin[1] + originPattern[1] * j, deckOrigin[2] + originPattern[2] * k};
                        Solid container = containerSolid(containerOrigin);
                        listOfComposingSolids.add(container);
                    }
                }
            }
        }
    }

    /**
     * Fills the matrix with zeros
     *
     * @param matrix
     */
    private boolean fillMatrixWithZero(int[][][] matrix) {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[0].length; j++) {
                for (int k = 0; k < matrix[0][0].length; k++) {
                    matrix[i][j][k] = 0;
                }
            }
        }
        return true;
    }

    /**
     * Calculates volume of a rectangular prism
     *
     * @param length
     * @param width
     * @param height
     * @return
     */
    public float volumeCalculator(float length, float width, float height) {
        if (floatIsNegative(length) || floatIsNegative(width)|| floatIsNegative(height )) throw new IllegalArgumentException(exceptionNegative);
        return length * width * height;
    }

    /**
     * Calculates weight through the volume and density of the material of a given object
     *
     * @param density
     * @param volume
     * @return
     */
    public float weightCalculator(float density, float volume) {
        if (floatIsNegative(density) || floatIsNegative(volume)) throw new IllegalArgumentException(exceptionNegative);
        return density * volume;
    }

    private boolean intIsNegative(int num){
        return num < 0;
    }

    private boolean floatIsNegative(float num){
        return num < 0f;
    }

    private boolean floatIsZero(float num){
        return num == 0f;
    }



}
