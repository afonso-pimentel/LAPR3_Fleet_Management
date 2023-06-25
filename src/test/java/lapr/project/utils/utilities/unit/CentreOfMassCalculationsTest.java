package lapr.project.utils.utilities.unit;

import lapr.project.model.Solid;
import lapr.project.utils.utilities.CentreOfMassCalculations;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

class CentreOfMassCalculationsTest {

    private CentreOfMassCalculations centreOfMassCalculator;

    public CentreOfMassCalculationsTest() {
        this.centreOfMassCalculator = new CentreOfMassCalculations();
    }

    /**
     * Unit test for centreOfMassOfRectangularPrism
     */
    @Test
    void centreOfMassOfRectangularPrism() {
        //Arrange
        float[] origin = {0f,0f,0f};
        Solid solid = new Solid(2f,2f,2f,1f,origin);

        //Act
        float[] result = centreOfMassCalculator.centreOfMassOfRectangularPrism(solid);
        float[] expected = {1f,1f,1f};

        //Assert
        assertEquals(result[0],expected[0]);
        assertEquals(result[1],expected[1]);
        assertEquals(result[2],expected[2]);
    }

    /**
     * Unit test for centreOfMassOfComposedSolid
     */
    @Test
    void centreOfMassOfComposedSolid() {
        //Arrange
        float[] originOne = {0f,0f,0f};
        Solid solidOne = new Solid(2f,2f,2f,1f,originOne);
        float[] originTwo = {0f,0f,2f};
        Solid solidTwo = new Solid(2f,2f,2f,1f,originTwo);
        ArrayList<Solid> listOfSolids = new ArrayList<>();
        listOfSolids.add(solidOne);
        listOfSolids.add(solidTwo);

        //Act
        float[] result = centreOfMassCalculator.centreOfMassOfComposedSolid(listOfSolids);
        float[] expected = {1f,1f,2f};

        //Assert
        assertEquals(result[0],expected[0]);
        assertEquals(result[1],expected[1]);
        assertEquals(result[2],expected[2]);
    }

    /**
     * Unit test for containerUnitPlacement
     */
    @Test
    void containerUnitPlacement() {
        //Arrange
        int xNumContainer = 1;
        int yNumContainer = 1;
        int zNumContainer = 1;
        int n = 1;

        //Act
        int[][][] result = centreOfMassCalculator.containerUnitPlacement(xNumContainer,yNumContainer,zNumContainer,n);
        int[][][] expected = {{{1}}};

        //Assert
        assertEquals(result[0][0][0],expected[0][0][0]);
    }

    /**
     * Unit test for insertContainersInDeck
     *
     */
    @Test
    void insertContainersInDeck() {
        //Arrange
        int[][][] unitMatrix = {{{1}}};
        float[] deckOrigin = {0f,0f,0f};
        float[] originPattern = {1f,1f,1f};
        int xMax = 1;
        int yMax = 1;
        int zMax = 1;

        ArrayList<Solid> listOfSolids = new ArrayList<>();

        //Act
        centreOfMassCalculator.insertContainersInDeck(unitMatrix,deckOrigin,originPattern,xMax,yMax,zMax,listOfSolids);
        float[] originOne = {0f,0f,0f};
        Solid solidOne = new Solid(6.10f,2.44f,2.59f,500f,originOne);

        //Assert
        assertEquals(listOfSolids.get(0),solidOne);
    }

    /**
     * Unit test for volumeCalculator
     */
    @Test
    void volumeCalculator() {
        //Act and Assert
        float result = centreOfMassCalculator.volumeCalculator(1f,1f,1f);
        float expected = 1f;
        assertEquals(result,expected);
    }

    /**
     * Unit test for weightCalculator
     */
    @Test
    void weightCalculator() {
        //Act and Assert
        float result = centreOfMassCalculator.weightCalculator(1f,1f);
        float expected = 1f;
        assertEquals(result,expected);
    }

}