package lapr.project.utils.utilities.integration;

import lapr.project.model.Solid;
import static org.junit.jupiter.api.Assertions.*;

import lapr.project.utils.utilities.CentreOfMassCalculations;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;

public class CentreOfMassCalculationsTest {

    private CentreOfMassCalculations centreOfMassCalculator;

    public CentreOfMassCalculationsTest() {
        this.centreOfMassCalculator = new CentreOfMassCalculations();
    }

    /**
     * Checks if the function calculating the centre of mass of a rectangular Prism
     * is working.
     */
    @Test
    public void validRectangularPrismShouldReturnValidCentreOfMass(){
        //Arrange
        float[] origin = {0f,0f,0f};
        Solid solid = new Solid(10f,5f,2f,10f,origin);

        //Act
        float[] result = centreOfMassCalculator.centreOfMassOfRectangularPrism(solid);
        float[] expected = {5f,2.5f,1f};

        //Assert
        assertEquals(result[0],expected[0]);
        assertEquals(result[1],expected[1]);
        assertEquals(result[2],expected[2]);
    }

    /**
     * This test checks if two equal prisms, one of top of the other,
     * have the centre of mass where expected.
     * It should return a point exactly in the middle.
     *
     */
    @Test
    public void validTwoSolidSystemShouldReturnValidCentreOfMass(){
        //Arrange
        float[] originSolidOne = {0f,0f,0f};
        Solid solidOne = new Solid(10f,5f,2f,10f, originSolidOne);
        float[] originSolidTwo = {0f,0f,solidOne.getHeight()};
        Solid solidTwo = new Solid(10f,5f,2f,10f, originSolidTwo);
        ArrayList<Solid> listOfComposingSolids = new ArrayList<>();
        listOfComposingSolids.add(solidOne);
        listOfComposingSolids.add(solidTwo);

        //Act
        float[] result = centreOfMassCalculator.centreOfMassOfComposedSolid(listOfComposingSolids);
        float[] expected = {5f,2.5f,2f};

        //Assert
        assertEquals(result[0],expected[0]);
        assertEquals(result[1],expected[1]);
        assertEquals(result[2],expected[2]);
    }

    /**
     * Tests if the Ship's centre of mass
     * with the considered bridge and base
     * is equal to the previously calculated
     * value.
     *
     */
    @Test
    public void emptyCargoShipCentreOfMassCalculationShouldReturnValidValue(){
        //Arrange
        float steelDensity = 7000; // 7000 kg/m3
        float[] shipBaseDimensions = {300f,32f,30f};
        float[] controlBridgeDimensions = {20f,32f,20f};
        ArrayList<Solid> listOfComposingSolids = new ArrayList<>();

        //Act
        float[] result = emptyCargoShipCentreOfMassCalculation(shipBaseDimensions,steelDensity,controlBridgeDimensions,listOfComposingSolids);
        float[] expected = {144.04256f,16f,16.06383f};

        //Assert
        assertEquals(result[0],expected[0]);
        assertEquals(result[1],expected[1]);
        assertEquals(result[2],expected[2]);

    }

    /**
     * Returns the centre of mass of the ship+bridge system.
     *
     */
    private float[] emptyCargoShipCentreOfMassCalculation(float[] shipBaseDimensions,float steelDensity, float[] controlBridgeDimensions,ArrayList<Solid> listOfComposingSolids){
        //Arrange

        //Ship base
        float[] originShipBase = {0f,0f,0f};
        float shipWeight = centreOfMassCalculator.weightCalculator(steelDensity,centreOfMassCalculator.volumeCalculator(shipBaseDimensions[0],shipBaseDimensions[1],shipBaseDimensions[2]));
        Solid shipBase = new Solid(shipBaseDimensions[0],shipBaseDimensions[1],shipBaseDimensions[2],shipWeight, originShipBase);

        //Control bridge
        float[] originControlBridge = {0f,0f,shipBaseDimensions[2]};
        float controlBridgeWeight = centreOfMassCalculator.weightCalculator(steelDensity,centreOfMassCalculator.volumeCalculator(controlBridgeDimensions[0],controlBridgeDimensions[1],controlBridgeDimensions[2]));
        Solid controlBridge = new Solid(controlBridgeDimensions[0],controlBridgeDimensions[1],controlBridgeDimensions[2],controlBridgeWeight, originControlBridge);
        listOfComposingSolids.add(shipBase);
        listOfComposingSolids.add(controlBridge);

        //Act
        float[] result = centreOfMassCalculator.centreOfMassOfComposedSolid(listOfComposingSolids);

        return result;
    }

    /**
     * Test with the defined dimensions of the ship.
     * As in the research document is explained,
     * we have considered a ship divided into two
     * rectangular prisms.
     * One represents the top of the control bridge
     * and the other represents the rest of the ship.
     *
     * The dimensions were rounded up.
     *
     * The control bridge's prism has:
     * Length: 20 m
     * Width: 32 m
     * Height: 20 m
     * Weight: 7000 kg/m3 * 20*32*20 m3
     *
     * The rest of the ship has:
     * Length: 300 m
     * Width: 32 m
     * Height: 30 m
     * Weight: 7000 kg/m3 * 300*32*30 m3
     *
     * The control bridge's prism sits in the top of
     * the other prism and starts in the point 0,0,30.
     * Where 30 is the height of the boat's prism.
     */
    @Test
    public void validArgumentsShouldReturnValidFilledSolidArray(){
        //Arrange
        float steelDensity = 7000; // 7000 kg/m3
        float[] shipBaseDimensions = {300f,32f,30f};
        float[] controlBridgeDimensions = {20f,32f,20f};
        float[] containerDimensions = {6.10f,2.44f,2.59f};
        ArrayList<Solid> listOfComposingSolids = new ArrayList<>();
        float[] shipCentreOfMass = emptyCargoShipCentreOfMassCalculation(shipBaseDimensions,steelDensity,controlBridgeDimensions,listOfComposingSolids);
        float[] deckOrigin = {controlBridgeDimensions[0]+2f,2f,shipBaseDimensions[2]};
        float[] deckLimits = {(2f*shipCentreOfMass[0]-2f),(shipBaseDimensions[1]-2f),(shipBaseDimensions[2] + (controlBridgeDimensions[2]*0.75f))};
        int[] matrixSize = {(int)((deckLimits[0]-deckOrigin[0])/containerDimensions[0]),
                            (int)((deckLimits[1]-deckOrigin[1])/containerDimensions[1]),
                            (int)((deckLimits[2]-deckOrigin[2])/containerDimensions[2])};
        int n = 100;
        int[][][] result = centreOfMassCalculator.containerUnitPlacement(matrixSize[0],matrixSize[1],matrixSize[2],n);
        printIntMatrix(result);
        centreOfMassCalculator.insertContainersInDeck(result,deckOrigin,containerDimensions,matrixSize[0],matrixSize[1],matrixSize[2],listOfComposingSolids);
        float[] systemCentreOfMass=centreOfMassCalculator.centreOfMassOfComposedSolid(listOfComposingSolids);
        System.out.println("System centre of mass:\n");
        for (int i = 0; i < 3; i++) {
            System.out.println(systemCentreOfMass[i]);
        }
    }

    /**
     * Tests if the method throws an expection when N is larger than the capacity of the ship.
     */
    @Test
    public void invalidNSizeShouldReturnIllegalArgument(){
        int[] matrixSize = {1,1,1};
        int n = 200;
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.containerUnitPlacement(matrixSize[0],matrixSize[1],matrixSize[2],n));
    }

    @Test
    void invalidContainerValuesShouldThrowException(){
        //Act and assert
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.containerUnitPlacement(-1,1,1,1));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.containerUnitPlacement(1,-1,1,1));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.containerUnitPlacement(1,1,-1,1));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.containerUnitPlacement(1,1,1,-1));
    }

    @Test
    void invalidMaxValuesShouldThrowException(){
        //Act and assert
        int[][][] validUnitMatrix = {{{1}}};
        float[] validDeckOrigin = {0f,0f,0f};
        float[] validOriginPattern = {1f,1f,1f};
        Solid solidOne = new Solid(1f,1f,1f,1f,validDeckOrigin);
        ArrayList<Solid> validListOfComposingSolids = new ArrayList<>();
        validListOfComposingSolids.add(solidOne);
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.insertContainersInDeck(null, validDeckOrigin, validOriginPattern, 1,1,1,validListOfComposingSolids));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.insertContainersInDeck(validUnitMatrix, null, validOriginPattern, 1,1,1,validListOfComposingSolids));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.insertContainersInDeck(validUnitMatrix, validDeckOrigin, null, 1,1,1,validListOfComposingSolids));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.insertContainersInDeck(validUnitMatrix, validDeckOrigin, validOriginPattern, -1,1,1,validListOfComposingSolids));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.insertContainersInDeck(validUnitMatrix, validDeckOrigin, validOriginPattern, 1,-1,1,validListOfComposingSolids));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.insertContainersInDeck(validUnitMatrix, validDeckOrigin, validOriginPattern, 1,1,-1,validListOfComposingSolids));
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.insertContainersInDeck(validUnitMatrix, validDeckOrigin, validOriginPattern, 1,1,1,null));
    }

    @Test
    void nullListShouldThrowExpcetion(){
        //Act and assert
        assertThrows(IllegalArgumentException.class, () ->  centreOfMassCalculator.centreOfMassOfComposedSolid(null));
    }


    private void printIntMatrix(int[][][] matrix){
        for (int i = 0; i < matrix[0][0].length; i++) {
            System.out.println("For z = "+i+"\n");
            for (int j = 0; j < matrix[0].length; j++) {
                System.out.println("");
                for (int k = 0; k < matrix.length; k++) {
                    if (matrix[k][j][i]!=0){
                        System.out.print("|1|");
                    }else{
                        System.out.print("|0|");
                    }
                }
            }
            System.out.println("\n");
        }
    }



}