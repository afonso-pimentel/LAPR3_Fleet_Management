package lapr.project.utils.datastructures;

/**
 * @author Group 169 LAPRIII
 */
public class PortNodeInfo {
    private final String portName;

    public PortNodeInfo(String portName) {
        this.portName = portName;
    }

    public String getPortName() {
        return portName;
    }

    @Override
    public boolean equals(Object o) {

        if (o == this)
            return true;

        if (!(o instanceof PortNodeInfo))
            return false;

        return this.getPortName().compareTo(((PortNodeInfo) o).getPortName()) == 0;
    }

    @Override
    public int hashCode()
    {
        return this.getPortName().hashCode();
    }
}
