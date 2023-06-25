package lapr.project.utils.utilities.unit;

import org.junit.jupiter.api.Test;
import lapr.project.utils.utilities.WetDraftCalculations;

import static org.junit.jupiter.api.Assertions.*;

class WetDraftCalculationsTest {

    private WetDraftCalculations wetDraftCalculations;
    public WetDraftCalculationsTest(){ this.wetDraftCalculations = new WetDraftCalculations();}

    /**
     * Unit test for calculateWetDraft
     */
    @Test
    void calculateWetDraft() {
        //Arrange
        float shipSteelVolume = 1f;
        float shipAirVolume = 0f;
        float steelDensity = 1f;
        float airDensity = 1f;
        int numberOfContainers = 0;
        float shipBaseArea = 1f;
        float seaWaterDensity = 1f;

        //Act
        float result = wetDraftCalculations.calculateWetDraft(shipSteelVolume,shipAirVolume,steelDensity,airDensity,numberOfContainers,shipBaseArea,seaWaterDensity);
        float expected = 1f;

        //Assert
        assertEquals(result,expected);
    }

    /**
     * Unit Test for presureExerted
     */
    @Test
    void pressureExerted() {
        //Arrange
        float shipSteelVolume = 1f;
        float shipAirVolume = 0f;
        float steelDensity = 1f;
        float airDensity = 1f;
        int numberOfContainers = 0;
        float shipBaseArea = 1f;

        //Act
        float result = wetDraftCalculations.pressureExerted(shipSteelVolume,shipAirVolume,steelDensity,airDensity,numberOfContainers,shipBaseArea);
        float expected = 9.81f;

        //Assert
        assertEquals(result,expected);
    }
}