package lapr.project.utils.utilities.integration;

import lapr.project.utils.utilities.WetDraftCalculations;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class WetDraftCalculationsTest {

    private WetDraftCalculations wetDraftCalculations;

    public WetDraftCalculationsTest(){ this.wetDraftCalculations = new WetDraftCalculations();}


    /**
     * Calculates the wetDraft given our ship's details.
     *
     */
    public float filledWithContainersWetDraft(){
        //Arrange
        float[] shipBaseDimensions = {300f,32f,30f};
        float[] bridgeDimensions = {20f,32f,20f};
        float[] shipInteriorDimensions = {shipBaseDimensions[0]-1f,shipBaseDimensions[1]-1f,shipBaseDimensions[2]-1f};
        float shipBrigeVolume = bridgeDimensions[0]*bridgeDimensions[1]*bridgeDimensions[2];
        float shipTotalVolume = shipBaseDimensions[0]*shipBaseDimensions[1]*shipBaseDimensions[2];
        float shipAirVolume = shipInteriorDimensions[0]*shipInteriorDimensions[1]*shipInteriorDimensions[2];
        float shipSteelVolume = shipTotalVolume - shipAirVolume + shipBrigeVolume;
        float steelDensity = 7000f; // 7000 kg/m3
        float airDensity = 1f; // 1 kg/m3
        float seaWaterDensity = 1026f; // 1026 kg/m3
        int numberOfContainers = 3000;
        float shipBaseArea = shipBaseDimensions[0]*shipBaseDimensions[1];

        //Act
        float result = wetDraftCalculations.calculateWetDraft(shipSteelVolume, shipAirVolume, steelDensity, airDensity, numberOfContainers,shipBaseArea, seaWaterDensity);
        return result;

    }

    /**
     * Calculates the wetDraft given our ship's details.
     *
     */

    public float emptyShipWetDraft(){
        //Arrange
        float[] shipBaseDimensions = {300f,32f,30f};
        float[] bridgeDimensions = {20f,32f,20f};
        float[] shipInteriorDimensions = {shipBaseDimensions[0]-1f,shipBaseDimensions[1]-1f,shipBaseDimensions[2]-1f};
        float shipBrigeVolume = bridgeDimensions[0]*bridgeDimensions[1]*bridgeDimensions[2];
        float shipTotalVolume = shipBaseDimensions[0]*shipBaseDimensions[1]*shipBaseDimensions[2];
        float shipAirVolume = shipInteriorDimensions[0]*shipInteriorDimensions[1]*shipInteriorDimensions[2];
        float shipSteelVolume = shipTotalVolume - shipAirVolume + shipBrigeVolume;
        float steelDensity = 7000f; // 7000 kg/m3
        float airDensity = 1f; // 1 kg/m3
        float seaWaterDensity = 1026f; // 1026 kg/m3
        int numberOfContainers = 0;
        float shipBaseArea = shipBaseDimensions[0]*shipBaseDimensions[1];

        //Act
        float result = wetDraftCalculations.calculateWetDraft(shipSteelVolume, shipAirVolume, steelDensity, airDensity, numberOfContainers,shipBaseArea, seaWaterDensity);
        return result;

    }

    /**
     * Calculates the height difference between filled and empty ship.
     *
     */
    @Test
    public void differenceInHeightWithAndWithoutContainers(){
        float result = filledWithContainersWetDraft() - emptyShipWetDraft();
        System.out.println("The Ship has sunk "+result+ " meters.");
    }

    /**
     *
     * Application of the formula:
     * P = F * A
     *
     * F = FgVessel
     * A = Ship Base's Area
     * P = Pressure
     *
     *
     */
    @Test
    public void validValuesShouldReturnValidPressure(){
        //Arrange
        float[] shipBaseDimensions = {300f,32f,30f};
        float[] bridgeDimensions = {20f,32f,20f};
        float[] shipInteriorDimensions = {shipBaseDimensions[0]-1f,shipBaseDimensions[1]-1f,shipBaseDimensions[2]-1f};
        float shipBrigeVolume = bridgeDimensions[0]*bridgeDimensions[1]*bridgeDimensions[2];
        float shipTotalVolume = shipBaseDimensions[0]*shipBaseDimensions[1]*shipBaseDimensions[2];
        float shipAirVolume = shipInteriorDimensions[0]*shipInteriorDimensions[1]*shipInteriorDimensions[2];
        float shipSteelVolume = shipTotalVolume - shipAirVolume + shipBrigeVolume;
        float steelDensity = 7000f; // 7000 kg/m3
        float airDensity = 1f; // 1 kg/m3
        int numberOfContainers = 2000;
        float shipBaseArea = shipBaseDimensions[0]*shipBaseDimensions[1];

        //Act
        float result = wetDraftCalculations.pressureExerted(shipSteelVolume, shipAirVolume, steelDensity, airDensity, numberOfContainers,shipBaseArea);
        System.out.println(result/1000000000 + " GPa");
    }

    /**
     * If the height is over the object's height, it means it is submerged.
     */
    @Test
    public void superiorShipWeightShouldReturnWetDraftHigherThanHeight(){
        //Arrange
        float[] shipBaseDimensions = {100f,100f,5f};
        float[] bridgeDimensions = {1f,1f,1f};
        float[] shipInteriorDimensions = {0f,0f,0f};
        float shipBrigeVolume = bridgeDimensions[0]*bridgeDimensions[1]*bridgeDimensions[2];
        float shipTotalVolume = shipBaseDimensions[0]*shipBaseDimensions[1]*shipBaseDimensions[2];
        float shipAirVolume = shipInteriorDimensions[0]*shipInteriorDimensions[1]*shipInteriorDimensions[2];
        float shipSteelVolume = shipTotalVolume - shipAirVolume + shipBrigeVolume;
        float steelDensity = 7000f; // 7000 kg/m3
        float airDensity = 1f; // 1 kg/m3
        float seaWaterDensity = 1026f; // 1026 kg/m3
        int numberOfContainers = 1;
        float shipBaseArea = shipBaseDimensions[0]*shipBaseDimensions[1];

        //Act
        float result = wetDraftCalculations.calculateWetDraft(shipSteelVolume, shipAirVolume, steelDensity, airDensity, numberOfContainers,shipBaseArea, seaWaterDensity);
        System.out.println(result);

        //Assert
        assertTrue(result>shipBaseDimensions[2]);
    }

    /**
     *
     * Fvessel = 10*10*10*10*9,81
     * B = 1000*100*h*9.81
     * Fvessel - B = 0
     * 10000*9.81 = 100000*9.81*h
     * 10000=100000*h
     * h=10000/100000
     * h=0.1
     *
     */
    @Test
    public void validValueShouldReturnExpectedResult(){
        //Arrange
        float[] shipBaseDimensions = {10f,10f,10f};
        float[] shipInteriorDimensions = {0f,0f,0f};
        float shipTotalVolume = shipBaseDimensions[0]*shipBaseDimensions[1]*shipBaseDimensions[2];
        float shipAirVolume = shipInteriorDimensions[0]*shipInteriorDimensions[1]*shipInteriorDimensions[2];
        float shipSteelVolume = shipTotalVolume - shipAirVolume;
        float steelDensity = 10f;
        float airDensity = 1;
        float seaWaterDensity = 1000f;
        int numberOfContainers = 0;
        float shipBaseArea = shipBaseDimensions[0]*shipBaseDimensions[1];

        //Act
        float result = wetDraftCalculations.calculateWetDraft(shipSteelVolume, shipAirVolume, steelDensity, airDensity, numberOfContainers,shipBaseArea, seaWaterDensity);
        float expected = 0.1f;
        System.out.println(result);

        //Assert
        assertEquals(result,expected);
    }


}