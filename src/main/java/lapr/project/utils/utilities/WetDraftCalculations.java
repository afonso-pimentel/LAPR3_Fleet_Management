package lapr.project.utils.utilities;

public class WetDraftCalculations {

    /**
     *
     * It calculates the following formula:
     * Fvessel+Fcontainers=B
     *
     * Where B is the Buoyant force.
     * The Buoyant force is responsible
     * for countering the weight of a given
     * object that is floating or even submerse.
     *
     * In this case, the ship will be floating,
     * then, it will be in contact with its base and the surrounding
     * areas of the prism up to a certain height.
     *
     * That height is called wet Draft, it is the height
     * up to where a ship is sunk.
     *
     * Weight = Density * Volume
     *
     * And Weight always implies the existence of a
     * gravitational force pulling down:
     *
     * Fg = Weight * g (constant of gravitational acceleration);
     *
     * The Vessel, in realistic terms, cannot all be considered as
     * a homogeneous material. A huge part of it must be filled with
     * only air. The thickness of the ship's walls must be around 30 cms probably,
     * otherwise the ship would be so extremely dense that it would immediately sink.
     *
     * The air will balance out the steel's density and allow the ship to float.
     *
     * FgVessel = FgSteel + FgAir
     * FgSystem = FgVessel + FgContainers
     * FgSystem = B
     * B = Density Of Sea Water * Ship base's area * wet Draft * g
     *
     * wet Draft = FgSystem / (density of sea Water * Ship base's area * g)
     *
     * @param shipSteelVolume
     * @param shipAirVolume
     * @param steelDensity
     * @param airDensity
     * @param numberOfContainers
     * @param shipBaseArea
     * @param seaWaterDensity
     * @return
     */
    public float calculateWetDraft(float shipSteelVolume, float shipAirVolume, float steelDensity, float airDensity, int numberOfContainers,float shipBaseArea, float seaWaterDensity){
        float g = 9.81f;
        float airWeightForce = shipAirVolume*airDensity*g;
        float steelWeightForce = shipSteelVolume*steelDensity*g;
        float containerWeightForce = ((float)numberOfContainers)*500f*g; //each container weights 0.5 tons
        return (airWeightForce+steelWeightForce+containerWeightForce)/(seaWaterDensity*shipBaseArea*g);
    }

    /**
     * P = F * A
     * @param shipSteelVolume
     * @param shipAirVolume
     * @param steelDensity
     * @param airDensity
     * @param numberOfContainers
     * @param shipBaseArea
     * @return
     */
    public float pressureExerted(float shipSteelVolume, float shipAirVolume, float steelDensity, float airDensity, int numberOfContainers,float shipBaseArea){
        float g = 9.81f;
        float airWeightForce = shipAirVolume*airDensity*g;
        float steelWeightForce = shipSteelVolume*steelDensity*g;
        float containerWeightForce = ((float)numberOfContainers)*500f*g; //each container weights 0.5 tons
        return (airWeightForce+steelWeightForce+containerWeightForce)*shipBaseArea;
    }
}
