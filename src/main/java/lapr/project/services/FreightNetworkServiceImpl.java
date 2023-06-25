package lapr.project.services;

import lapr.project.mappers.dtos.FreightNodeClosenessDTO;
import lapr.project.model.Port;
import lapr.project.model.enums.Continents;
import lapr.project.model.enums.PathType;
import lapr.project.utils.datastructures.*;
import lapr.project.utils.utilities.Utilities;

import java.util.*;
import java.util.Map.Entry;
import java.util.stream.Collectors;


public class FreightNetworkServiceImpl implements FreightNetworkService{
    private final Graph<FreightNetworkNode, Float> freightNetworkGraph;

    public FreightNetworkServiceImpl(Graph<FreightNetworkNode, Float> freightNetworkGraph) {
        this.freightNetworkGraph = freightNetworkGraph;
    }

    /**
     * @inheritDoc
     *
     */
    @Override
    public Map<Continents, ArrayList<FreightNodeClosenessDTO>> getTopNClosenessPlaces(int n) {
        if(n<=0) throw new IllegalArgumentException("N must be a positive number.");
        EnumMap<Continents,Graph<FreightNetworkNode,Float>> graphByContinent= getGraphByContinent(freightNetworkGraph);
        EnumMap<Continents, ArrayList<FreightNodeClosenessDTO>> auxMapClosenessDTO = new EnumMap<>(Continents.class);

        for (Map.Entry<Continents,Graph<FreightNetworkNode,Float>> entry : graphByContinent.entrySet()){
            auxMapClosenessDTO.put(entry.getKey(),new ArrayList<>());
            for (FreightNetworkNode vertex : entry.getValue().vertices()) {
                ArrayList<LinkedList<FreightNetworkNode>> paths = new ArrayList<>();
                ArrayList<Float> dists = new ArrayList<>();

                Algorithms.shortestPaths(entry.getValue(),vertex,Float :: compare,Float :: sum, 0f,paths,dists, null);
                Float pathDistanceAvg = Utilities.sumFloatArrayList(dists)/dists.size(); //Average of pathDistances
                if(vertex instanceof PortNode){
                    FreightNodeClosenessDTO auxFreightDTO = new FreightNodeClosenessDTO(((PortNode) vertex).getPortName(),pathDistanceAvg);
                    auxMapClosenessDTO.get(entry.getKey()).add(auxFreightDTO);
                }else{
                    FreightNodeClosenessDTO auxFreightDTO = new FreightNodeClosenessDTO(((CapitalNode) vertex).getCapitalName(),pathDistanceAvg);
                    auxMapClosenessDTO.get(entry.getKey()).add(auxFreightDTO);
                }
            }
            Collections.sort(auxMapClosenessDTO.get(entry.getKey()));
        }
        for (Map.Entry<Continents, ArrayList<FreightNodeClosenessDTO>> entry : auxMapClosenessDTO.entrySet()) {
            int k = entry.getValue().size();
            entry.getValue().subList(n, k).clear();
        }
        return auxMapClosenessDTO;
    }

    /**
     * This method creates a graph for every continent.
     * It iterates through the "global" graph we have
     * and then inserts the vertices of one continent
     * into a new graph. After that, it adds the edges
     * between the vertices inside a continent.
     *
     * The graph is then inserted into a HashMap ordered by continent.
     *
     * @param freightNetworkGraph
     * @return
     */
    private EnumMap<Continents,Graph<FreightNetworkNode,Float>> getGraphByContinent(Graph<FreightNetworkNode,Float> freightNetworkGraph){
        EnumMap<Continents,Graph<FreightNetworkNode,Float>> graphByContinent = new EnumMap<>(Continents.class);
            for(FreightNetworkNode freightNode : freightNetworkGraph.vertices()){   // Adds the vertices to each continent's graph
                Continents nodeContinent = stringToEnum(freightNode.getCountry().getContinent());
                if(!graphByContinent.containsKey(nodeContinent)){
                    Graph<FreightNetworkNode,Float> continentGraph = new MapGraph<>(false);
                    graphByContinent.put(nodeContinent,continentGraph);
                }
                graphByContinent.get(nodeContinent).addVertex(freightNode);
            }
            for(Edge<FreightNetworkNode, Float> edge : freightNetworkGraph.edges()){    // Adds the edges to each continent's graph
                FreightNetworkNode vOrigin = edge.getVOrig();
                FreightNetworkNode vDest = edge.getVDest();
                if(vOrigin.getCountry().getContinent().equals(vDest.getCountry().getContinent())){
                    Continents nodeContinent = stringToEnum(vOrigin.getCountry().getContinent());
                    graphByContinent.get(nodeContinent).addEdge(vOrigin,vDest, edge.getWeight());
                }
            }
        return graphByContinent;
    }

    /**
     * Turns a string with a continent value into the
     * corresponding Enum.
     *
     * @param continentString
     * @return
     */
    private Continents stringToEnum(String continentString){
        switch (continentString){
            case "Africa": return Continents.AFRICA;
            case "America": return Continents.AMERICA;
            case "Antarctica": return Continents.ANTARCTICA;
            case "Asia": return Continents.ASIA;
            case "Oceania": return Continents.OCEANIA;
            default: return Continents.EUROPE;
        }
    }

    /**
     * @inheritDoc
     *
     */
    @Override
    public LinkedHashMap<PortNode,Long> getCriticalPortList(int n) {
        if (n <= 0) throw new IllegalArgumentException("Parameter cannot 0 or negative|");
           HashMap<FreightNetworkNode,Long> nodeVisitedCount = new HashMap<>();

        //Calculate all shortest paths
        for (FreightNetworkNode item : freightNetworkGraph.vertices()) {
            Algorithms.shortestPaths(
                    freightNetworkGraph,
                    item,
                    Float :: compare,
                    Float :: sum,
                    0f,
                    new ArrayList<>(),
                    new ArrayList<>(),
                    nodeVisitedCount);
        }

        //Sort hashMap
        nodeVisitedCount = Utilities.sortMapByValueComparator(nodeVisitedCount, false);

        LinkedHashMap<PortNode,Long> resultNodes = new LinkedHashMap<>();

        //Get top n and convert from FreightNetworkNode to PortNode
        for (Entry<FreightNetworkNode,Long> node: nodeVisitedCount.entrySet()) {
            if (node.getKey() instanceof PortNode){
                resultNodes.put((PortNode) node.getKey(), node.getValue());
                n--;
            }
            if (n==0) break;
        }

        //Get EntrySet, Limit it to n values, then convert to a list
        return resultNodes;
    }

    /**
     * @inheritDoc
     *
     */
    @Override
    public LinkedList<FreightNetworkNode> shortestPathSelected(FreightNetworkNode origin, FreightNetworkNode destination, LinkedList<FreightNetworkNode> passThrough, PathType pt){
        //Checks if any of the arguments are null
        if(origin == null || destination == null || pt == null || freightNetworkGraph == null) throw new IllegalArgumentException("Arguments or Graph can't be null");
        if(passThrough.isEmpty()) {
            //Filtering the shortest path using only land or sea
            //Choosing land can also start/end in a port
            Graph<FreightNetworkNode, Float> theCopy = freightNetworkGraph.clone();
            return shortestPathTerrain(theCopy, origin, destination, pt);
        }else if(passThrough.size() < 6)
            //if the number of places designated to pass are less than 5 than use Brute-Force method to assure the smallestPath O(n!)
            return shortestPathNPlacesBruteForce(passThrough,origin,destination);
        else
            //if the number of places designated to pass are more than 5 than use an efficient method to assure possibly the smallestPath possible while maintaining a good complexity
            return shortestPathNPlaces(origin,destination,passThrough);
    }

    /**
     * Returns a Linked list with the shortest path when there's obligatory between stops - Efficient Method
     * @param origin starting location
     * @param destination arrival location
     * @param passHere obligatory places to stop
     * @return linkedlist with the shortest path if it exists
     */
    private LinkedList<FreightNetworkNode> shortestPathNPlaces(FreightNetworkNode origin,FreightNetworkNode destination,LinkedList<FreightNetworkNode> passHere){
        //Necessary Variable Initialization
        LinkedList<FreightNetworkNode> finalPathN = new LinkedList<>();
        LinkedList<FreightNetworkNode> path = new LinkedList<>();

        //Loops until there is no designated paths left to go through
        while (passHere.size()>0) {
            LinkedList<LinkedList<FreightNetworkNode>> pathMaster = new LinkedList<>();
            //Finds the shortest path between one designated point to all other that haven't been passed through yet
            for (FreightNetworkNode freightNetworkNode : passHere) {
                path.clear();
                Algorithms.shortestPath(freightNetworkGraph, origin, freightNetworkNode, Float::compare, Float::sum, 0f, path);
                pathMaster.add(path);
            }
            //Removes unnecessary duplication
            passHere.remove(pathMaster.getLast().getLast());
            //Adds the shortest path between two designated stops to the final path
            finalPathN.addAll(findShortestTrip(pathMaster));
            origin = finalPathN.getLast();
            //Removes unnecessary duplication
            finalPathN.removeLast();
        }
        //Find the shortest path between the last designated place and the destination
        Algorithms.shortestPath(freightNetworkGraph, origin, destination, Float::compare, Float::sum, 0f, path);
        finalPathN.addAll(path);

        //Returns the shortest path passing through all designated stops in the most efficient way
        return finalPathN;
    }

    /**
     * Returns a Linked list with the shortest path when there's obligatory between stops - Brute-Force Method
     * @param passHere obligatory places to stop
     * @param start arrival location
     * @param end starting location
     * @return linkedlist with the shortest path if it exists
     */
    private LinkedList<FreightNetworkNode> shortestPathNPlacesBruteForce(LinkedList<FreightNetworkNode> passHere, FreightNetworkNode start, FreightNetworkNode end){
        //Necessary Variable Initialization
        List<LinkedList<FreightNetworkNode>> combinations = new LinkedList<>();
        LinkedList<LinkedList<FreightNetworkNode>> pathMaster = new LinkedList<>();

        LinkedList<FreightNetworkNode> path = new LinkedList<>();
        LinkedList<FreightNetworkNode> pathCompletion = new LinkedList<>();

        //Creates all possible sequences for the designated paths
        permute(combinations,passHere,0, passHere.size()-1);

        //Completes paths for each sequence
        for (LinkedList<FreightNetworkNode> trace: combinations){
            //Adds necessary starting and ending point to each sequence
            trace.addFirst(start);
            trace.addLast(end);
            for(int i= 0; i < trace.size()-1;i++){
                    //Finds shortestPath between two points from the sequence, respecting its order
                    Algorithms.shortestPath(freightNetworkGraph, trace.get(i), trace.get(i+1), Float::compare, Float::sum, 0f, path);
                    pathCompletion.addAll(path);
                    //Removes unnecessary duplication
                    pathCompletion.removeLast();
            }
            Algorithms.shortestPath(freightNetworkGraph, trace.getLast(), end, Float::compare, Float::sum, 0f, path);
            pathCompletion.addAll(path);
            //Adds Complete sequence's path to a list that keeps paths from all sequences
            pathMaster.add(new LinkedList<>(pathCompletion));
            pathCompletion.clear();
        }

        //Returns the smallest path found from all sequences possible
        return findShortestTrip(pathMaster);
    }

    /**
     * Returns the shortest trip given a List made of trips
     * @param pathMaster List with trips of FreightNetworkNodes inside
     * @return List with the shortest trip found
     */
    private LinkedList<FreightNetworkNode> findShortestTrip(LinkedList<LinkedList<FreightNetworkNode>> pathMaster){
        //Necessary Variable Initialization
        LinkedList<FreightNetworkNode> shortestPath = new LinkedList<>();
        float minDistance = Float.MAX_VALUE;
        //Finds the smallest path from all the sequence's paths
        for (LinkedList<FreightNetworkNode> options : pathMaster){
            float totalDistance = 0f;
            for(int i= 0; i < options.size()-1;i++){
                totalDistance += freightNetworkGraph.edge(options.get(i), options.get(i+1)).getWeight();
            }
            //If totalDistance is smaller than current Minimum Distance then assign a new shortestPath
            if (totalDistance<minDistance){
                minDistance= totalDistance;
                shortestPath = options;
            }
        }

        return shortestPath;
    }

    /**
     * permutation function
     * @param combos all saved permutations
     * @param places places to create permutations
     * @param l starting index
     * @param r end index
     */
    private void permute(List<LinkedList<FreightNetworkNode>> combos,LinkedList<FreightNetworkNode> places, int l, int r) {
        if (l == r) {
            combos.add(places);
        }else{
            for (int i = l; i <= r; i++)
            {
                places = stirPot(places,l,i);
                permute(combos,places, l+1, r);
                places = stirPot(places,l,i);
            }
        }
    }

    /**
     * Mix places at position
     * @param a place list
     * @param i position 1
     * @param j position 2
     * @return swapped string
     */
    private LinkedList<FreightNetworkNode> stirPot(LinkedList<FreightNetworkNode> a, int i, int j) {
        FreightNetworkNode temp;
        LinkedList<FreightNetworkNode> places = new LinkedList<>(a);
        temp = places.get(i) ;
        places.set(i,places.get(j));
        places.set(j,temp);
        return places;
    }

    /**
     * Return a list with the shortest path when there is no in between stops, and it's only by sea, land or both terrains
     * @param origin starting location
     * @param destination arrival location
     * @param pt type of terrain
     * @return return linkedList with the shortest path if it exists
     */
    private LinkedList<FreightNetworkNode> shortestPathTerrain(Graph<FreightNetworkNode,Float> graph,FreightNetworkNode origin,FreightNetworkNode destination, PathType pt){
        LinkedList<FreightNetworkNode> path = new LinkedList<>();

        for (FreightNetworkNode cNode: graph.vertices()) {
            if(pt==PathType.SEA){
                if (cNode instanceof CapitalNode) graph.removeVertex(cNode);
            } else if(pt == PathType.LAND){
                if (cNode instanceof PortNode && cNode != origin && cNode != destination)
                    graph.removeVertex(cNode);
            }
        }


        Algorithms.shortestPath(graph,origin,destination,Float::compare, Float::sum,0f,path);
        return path;
    }

    /**
     * @inheritDoc
     *
     */
    public LinkedList<FreightNetworkNode> graphCircuit(FreightNetworkNode origin){
        //Turn UserInput String into FreightNetworkNode
        //FreightNetworkNode startingPoint = transformStringtoFreightNetworkNode(freightNetworkGraph,origin,type);
        if (origin == null) throw new IllegalArgumentException("Location not found please verify if it exists in the current graph.");

        LinkedList<FreightNetworkNode> circuit = new LinkedList<>();
        HashMap<FreightNetworkNode, Boolean> visitedFlag = new HashMap<>();

        //If the number of adjacent vertex is less than 2 than it's not possible to make a circuit
        if(freightNetworkGraph.adjVertices(origin).size()>=2)
            theCircuit(origin,nearestNeighbor(origin,visitedFlag), circuit,visitedFlag);
        else
            return null;

        return circuit;
    }

    /**
     * Main Recursive function that will construct the graph circuit
     * @param origin Starting point vertex
     * @param passage Current next vertex being analysed
     * @param circuit LinkedList with the current vertex that make up the circuit
     * @param visitedFlag HashMap storing the visited vertex
     */
    private void theCircuit(FreightNetworkNode origin, FreightNetworkNode passage, LinkedList<FreightNetworkNode> circuit, HashMap<FreightNetworkNode,Boolean> visitedFlag){
        //If it's the beginning of the circuit we need to add the start as visited and to the circuit
        if (circuit.size() == 0){
            circuit.add(origin);
            visitedFlag.put(origin,true);
        }
        //if passage comes out null it means that there's no nearestNeighbor from the vertex in the passage before
        if (passage== null){
            //removes the last vertex in the circuit because it doesn't have any neighbor left
            circuit.removeLast();
            passage = circuit.getLast();
        }
        //Flag the current passage as visited
        visitedFlag.put(passage,true);
        //If it's the first time its passing this vertex add it to the circuit
        if (!circuit.contains(passage))
            circuit.add(passage);

        //If there's no vertex left to visit
        if(visitedFlag.size() == freightNetworkGraph.vertices().size()){
            //Remove every vertex that is not in the circuit from the visitedFlag HashMap
            visitedFlag.keySet().removeIf(o -> !circuit.contains(o));

            findingNemo(circuit, origin, visitedFlag);
            return;
        }

        //Recursive call
        theCircuit(origin,nearestNeighbor(passage,visitedFlag),circuit,visitedFlag);
    }

    /**
     * Transforms the user-input string into freightNetworkNode
     * @param freightGraph FreightNetworkGraph
     * @param str string input by the user
     * @return FreightNetworkNode
     */
    public FreightNetworkNode transformStringtoFreightNetworkNode(Graph<FreightNetworkNode,Float> freightGraph,String str,String type){
        for (FreightNetworkNode node: freightGraph.vertices()) {
            if (node instanceof CapitalNode){
                CapitalNode cN = (CapitalNode) node;
                if (cN.getCapitalName().equals(str) && type.toLowerCase(Locale.ROOT).equals("capital"))
                    return node;
            }else if (node instanceof PortNode){
                PortNode pN = (PortNode) node;
                if (pN.getPortName().equals(str) && type.toLowerCase(Locale.ROOT).equals("port"))
                    return node;
            }
        }
        return null;
    }

    /**
     * Return the nearestNeighbor of a Vertex
     * @param v FreightNetworkNode actual vertex
     * @return returns nearest FreightNetworkNode
     */
    private FreightNetworkNode nearestNeighbor(FreightNetworkNode v, HashMap<FreightNetworkNode, Boolean> p){
        //This map has a float value as key to make it O(1) to find the nearest point after the cycle
        Map<Float ,FreightNetworkNode> dist = new HashMap<>();
        float min = Float.MAX_VALUE;

            for (FreightNetworkNode adjNode: freightNetworkGraph.adjVertices(v)) {
                if (freightNetworkGraph.edge(v, adjNode).getWeight() < min) {
                    if(!(p.containsKey(adjNode))){
                        min = freightNetworkGraph.edge(v, adjNode).getWeight();
                        dist.put(min,adjNode);
                    }
                }
            }
        return dist.get(min);
    }

    /**
     * Analise the current circuit after visiting the all nodes, going backwards until the circuit completes itself
     * @param circuit List with current vertex that make the circuit
     * @param origin Starting point
     * @param visitedFlag HashMap with visited vertex
     * @return LinkedList when the circuit is complete or non-existent
     */
    private LinkedList<FreightNetworkNode> findingNemo(LinkedList<FreightNetworkNode> circuit, FreightNetworkNode origin, HashMap<FreightNetworkNode,Boolean> visitedFlag){
        //If the last vertex inside the circuit if the same as the origin then the circuit is complete
        if (circuit.getLast().equals(origin))
            return circuit;

        //If any of the adjacent vertex of the last node is the origin vertex then connect to it and end the circuit
        if(freightNetworkGraph.adjVertices(circuit.getLast()).contains(origin)) {
                circuit.addLast(origin);
                return circuit;
        }
        //Get the nearest neighbor of the last vertex of the circuit
        circuit.addLast(nearestNeighbor(circuit.getLast(),visitedFlag));
        //if the last node is null then it means the previous nearest neighbor didn't find anything, remove both from circuit
        if (circuit.getLast() == null){
            circuit.removeLast();
            visitedFlag.put(circuit.getLast(),true);
            circuit.removeLast();
        }else
            visitedFlag.put(circuit.getLast(),true);

        //Recursive call
        return findingNemo(circuit,origin,visitedFlag);
    }
     
}

