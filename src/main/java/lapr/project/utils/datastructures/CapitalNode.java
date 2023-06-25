package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import java.util.StringJoiner;

/**
 * @author Group 169 LAPRIII
 */
public class CapitalNode extends FreightNetworkNode{
    private final String capitalName;

    public CapitalNode(float latitude, float longitude, String capitalName, Country country) {
        super(latitude, longitude, country);
        this.capitalName = capitalName;
    }

    public String getCapitalName() {
        return capitalName;
    }

    @Override
    public boolean equals(Object o) {

        if (o == this)
            return true;

        if (!(o instanceof CapitalNode))
            return false;

        return this.getCapitalName().compareTo(((CapitalNode) o).getCapitalName()) == 0;
    }

    @Override
    public int hashCode()
    {
        return this.capitalName.hashCode();
    }

    @Override
    public String toString ()
    {
        return new StringJoiner(
                " | " ,
                "Capital Node => " ,
                ""
        )
                .add( "Capital Name = " + this.getCapitalName() )
                .add( "Country = " + this.getCountry().getName() )
                .add( "Latitude = " + this.getLatitude() )
                .add( "Longitude = " + this.getLongitude() )
                .toString();
    }
}
