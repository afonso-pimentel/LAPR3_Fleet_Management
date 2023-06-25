package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import java.util.*;

/**
 * @author Group 169 LAPRIII
 */
public interface FreightNetworkLogic {
    /**
     * Adds the connection between a capital and all the capitals from the countries in which it borders, for each capital.
     * Acceptance Criteria: The capital of a country has a direct connection with the capitals of the
     * countries with which it borders.
     * @param importedCapitalNodes imported capital nodes
     * @param borders borders of each country
     * @param freightNetworkGraph the input graph to add the connections to
     */
    void addCapitalConnectionToCapitalsFromBorderCountries(HashMap<Country, CapitalNode> importedCapitalNodes, HashMap<Country, List<Country>> borders, Graph<FreightNetworkNode,Float> freightNetworkGraph);

    /**
     * Adds the connection between a port and all the ports from the same country, for each port.
     * Acceptance Criteria: The ports of a country should be connected with all the ports of the same country
     * @param importedPortNodes imported port nodes
     * @param seadists seadists between ports
     * @param freightNetworkGraph the input graph to add the connections to
     */
    void addPortConnectionToPortsFromSameCountry(HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes,  HashMap<PortNodeInfo, TreeSet<Seadist>> seadists, Graph<FreightNetworkNode,Float> freightNetworkGraph);

    /**
     * Adds a connection between the closest port to a capital and the capital, for each capital.
     * Acceptance Criteria: The port closest to the capital of the country connects with it.
     * @param importedCapitalNodes imported capital nodes
     * @param importedPortNodes imported port nodes
     * @param borders borders of each country
     * @param freightNetworkGraph the input graph to add the connections to
     */
    void addClosestPortToCapitalConnection(HashMap<Country, CapitalNode> importedCapitalNodes, HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes, HashMap<Country, List<Country>> borders, Graph<FreightNetworkNode,Float> freightNetworkGraph);

    /**
     * Adds connections between a port and all the N closest ports to it, for each port.
     * Acceptance Criteria: Each port of a country connects with the n closest ports of any other country.
     * @param numberOfClosestPortsToConnectTo number of closest ports that any port should connect to
     * @param importedPortNodes imported port nodes
     * @param seadists seadists between ports
     * @param freightNetworkGraph the input graph to add the connections to
     */
    void addPortConnectionToNClosestPorts(int numberOfClosestPortsToConnectTo, HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes, HashMap<PortNodeInfo, TreeSet<Seadist>> seadists, Graph<FreightNetworkNode,Float> freightNetworkGraph);
}
