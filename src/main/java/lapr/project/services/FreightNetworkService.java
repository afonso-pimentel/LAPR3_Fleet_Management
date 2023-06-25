package lapr.project.services;

import lapr.project.mappers.dtos.FreightNodeClosenessDTO;
import lapr.project.model.Port;
import lapr.project.model.enums.Continents;
import lapr.project.utils.datastructures.FreightNetworkNode;
import lapr.project.utils.datastructures.PortNode;
import java.lang.reflect.Array;
import lapr.project.model.enums.PathType;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;


public interface FreightNetworkService {

    /**
     * Firstly, the getGraphByContinent method is called.
     * We will be working on each continent's graph, so that
     * we can easily analyze the ShortestPath distances of every
     * vertex inside the graph.
     * After that, a DTO is created. It is important for us to store
     * the Place's name and pathDistanceAvg. We will store the DTO of every corresponding
     * vertex inside an ArrayList. Every continent will have a designated
     * ArrayList with those DTOs.
     *
     * Finally, every ArrayList will be ordered in a descending order by its
     * pathDistanceAvg and then "trimmed" to the wanted N size.
     *
     * @param n
     * @return
     */
    public Map<Continents, ArrayList<FreightNodeClosenessDTO>> getTopNClosenessPlaces(int n);


    /**
     * This function will return the shortest path possible depending on the type of terrain the user chooses
     * or the shortest path possible passing through N indicated places.
     * @param origin Starting location
     * @param destination Arrival location
     * @param passThrough Places it should pass inbetween locations
     * @param pt Type of terrain it should use
     * @return linkedlist with the shortest path possible, if it exists
     */
    public LinkedList<FreightNetworkNode> shortestPathSelected(FreightNetworkNode origin, FreightNetworkNode destination, LinkedList<FreightNetworkNode> passThrough, PathType pt);

    /**
     * This function will create a graph circuit given a Starting point (specifying it's type[Capital/Port])
     * @param origin Starting Point
     * @return LinkedList with the nodes that make up the circuit
     */
    public LinkedList<FreightNetworkNode> graphCircuit(FreightNetworkNode origin);
    /**
     * Get the top n vertex with greater centrality in the FreightNetwork
     * @param n
     * @return
     */
    public Map<PortNode,Long> getCriticalPortList(int n);
}
