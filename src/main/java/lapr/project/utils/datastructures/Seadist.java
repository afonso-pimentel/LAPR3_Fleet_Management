package lapr.project.utils.datastructures;

import lapr.project.model.Country;

/**
 * @author Group 169 LAPRIII
 */
public class Seadist implements Comparable<Seadist>{
    private final Country fromCountry;
    private final String fromPort;
    private final Country toCountry;
    private final String toPort;
    private final float distance;

    public Seadist(Country fromCountry, String fromPort, Country toCountry, String toPort, float distance) {
        this.fromCountry = fromCountry;
        this.fromPort = fromPort;
        this.toCountry = toCountry;
        this.toPort = toPort;
        this.distance = distance;
    }

    public Country getFromCountry() {
        return fromCountry;
    }

    public Country getToCountry() {
        return toCountry;
    }

    public String getFromPort() {
        return fromPort;
    }

    public String getToPort() {
        return toPort;
    }

    public float getDistance() {
        return distance;
    }

    @Override
    public int compareTo(Seadist o)
    {
        if (this.distance > o.distance)
            return 1;

        if (this.distance < o.distance)
            return -1;

        return 0;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }

        if (obj.getClass() != this.getClass()) {
            return false;
        }

        final Seadist other = (Seadist) obj;

        return this.getFromCountry().equals(other.getFromCountry()) && this.getToCountry().equals(other.getToCountry())
                && this.getFromPort().equals(other.getFromPort()) && this.getToPort().equals(other.getToPort());
    }

    @Override
    public int hashCode(){
        return this.getFromCountry().hashCode() + this.getToCountry().hashCode() + this.getFromPort().hashCode() + this.getToPort().hashCode();
    }
}
