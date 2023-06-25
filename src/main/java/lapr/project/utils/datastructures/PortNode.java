package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import java.util.StringJoiner;

/**
 * @author Group 169 LAPRIII
 */
public class PortNode extends FreightNetworkNode{
    private final String portName;

    public PortNode(float latitude, float longitude, String portName, Country country) {
        super(latitude, longitude, country);
        this.portName = portName;
    }

    public String getPortName() {
        return portName;
    }

    @Override
    public boolean equals(Object o) {

        if (o == this)
            return true;

        if (!(o instanceof PortNode))
            return false;

        return this.getPortName().compareTo(((PortNode) o).getPortName()) == 0;
    }

    @Override
    public int hashCode()
    {
        return this.getPortName().hashCode();
    }

    @Override
    public String toString ()
    {
        return new StringJoiner(
                " | " ,
                "Port Node => " ,
                ""
                 )
                .add( "Port Name = " + this.getPortName() )
                .add( "Country = " + this.getCountry().getName() )
                .add( "Latitude = " + this.getLatitude() )
                .add( "Longitude = " + this.getLongitude() )
                .toString();
    }
}
