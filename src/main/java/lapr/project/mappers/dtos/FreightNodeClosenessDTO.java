package lapr.project.mappers.dtos;

import java.util.Objects;

public class FreightNodeClosenessDTO implements Comparable{
    private final String name;
    private final float pathDistanceAvg;

    /**
     * Constructor of a FreightNodeClosenessDTO.
     *
     * This DTO class is needed in order to get the best results in US303.
     * This probably should not be called a DTO as it does not implement the FreightNode interface but
     * it could not implement it due to the fact that only its child classes have the name as an attribute.
     *
     * @param name
     * @param pathDistanceAvg
     */
    public FreightNodeClosenessDTO(String name, float pathDistanceAvg){
        this.name = name;
        this.pathDistanceAvg = pathDistanceAvg;
    }

    public String getName() {
        return name;
    }

    public float getPathDistance() {
        return pathDistanceAvg;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FreightNodeClosenessDTO that = (FreightNodeClosenessDTO) o;
        return Float.compare(that.pathDistanceAvg, pathDistanceAvg) == 0 && name.equals(that.name);
    }

    /**
     * Comparator which returns difference between pathDistanceAvg
     * of a FreightNodeClosenessDTO
     *
     * @param o
     * @return
     */
    @Override
    public int compareTo(Object o){
        FreightNodeClosenessDTO that = (FreightNodeClosenessDTO) o;
        return Float.compare(this.pathDistanceAvg,that.pathDistanceAvg);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name,pathDistanceAvg);
    }

    public String toString(){
        return this.getName() + " has path distance average of " + this.getPathDistance();
    }
}