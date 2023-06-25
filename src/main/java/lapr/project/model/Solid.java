package lapr.project.model;

import java.util.Arrays;
import java.util.Objects;

public class Solid {

    private final float length;
    private final float width;
    private final float height;
    private final float weight;
    private final float[] origin;
    /**
     * rectangular prism solid
     * the origin is the point of the system
     * where the solid begins.
     *
     * @param length
     * @param width
     * @param height
     * @param weight
     * @param origin
     */
    public Solid(float length, float width, float height, float weight, float[] origin) {
        if (floatIsNegative(length) || floatIsNegative(width) || floatIsNegative(height) || floatIsNegative(weight) || floatIsNegative(origin[0]) || floatIsNegative(origin[1]) || floatIsNegative(origin[2])) {
            throw new IllegalArgumentException("Dimensions or origin under 0");
        }else{
            this.length = length;
            this.width = width;
            this.height = height;
            this.weight = weight;
            this.origin = origin.clone();
        }
    }

    public Solid(float length, float width, float height, float weight, float originX, float originY, float originZ) {
        if (floatIsNegative(length) || floatIsNegative(width) || floatIsNegative(height) || floatIsNegative(weight) || floatIsNegative(originX) || floatIsNegative(originY) || floatIsNegative(originZ)){
            throw new IllegalArgumentException("Dimensions or origin are negative.");
        }else{
            this.length = length;
            this.width = width;
            this.height = height;
            this.weight = weight;
            float[] originClone = {originX, originY, originZ};
            this.origin = originClone.clone();
        }
    }

    public float getLength() {
        return length;
    }

    public float getWidth() {
        return width;
    }

    public float getHeight() {
        return height;
    }

    public float getWeight() {
        return weight;
    }

    public float[] getOrigin() {
        return origin.clone();
    }

    @Override
    public String toString() {
        return "origin:"+this.origin;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Solid solid = (Solid) o;
        return Float.compare(solid.length, length) == 0 && Float.compare(solid.width, width) == 0 && Float.compare(solid.height, height) == 0 && Float.compare(solid.weight, weight) == 0 && Arrays.equals(origin, solid.origin);
    }

    @Override
    public int hashCode() {
        int result = Objects.hash(length);
        result = 31 * result;
        return result;
    }

    private boolean floatIsNegative(float num){
        return num < 0f;
    }
}
