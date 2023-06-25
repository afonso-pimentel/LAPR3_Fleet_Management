package lapr.project.utils.datastructures;

import lapr.project.utils.utilities.ValidateGraphNodes;
import lapr.project.utils.utilities.Utilities;

import java.util.*;
import java.util.function.BinaryOperator;

/**
 *
 * @author DEI-ISEP
 *
 */
public class Algorithms {
    private Algorithms(){}

    /** Performs breadth-first search of a Graph starting in a vertex
     *
     * @param g Graph instance
     * @param vert vertex that will be the source of the search
     * @return a LinkedList with the vertices of breadth-first search
     */
    public static <V, E> List<V> breadthFirstSearch(Graph<V, E> g, V vert) {
        if (!g.validVertex(vert)) {
            return Collections.<V>emptyList();
        }

        LinkedList<V> qbfs = new LinkedList<>();
        LinkedList<V> qaux = new LinkedList<>();

        qbfs.add(vert);
        qaux.add(vert);

        while (!qaux.isEmpty()) {
            for (V vAdj : g.adjVertices(qaux.getFirst())) {
                if (!qbfs.contains(vAdj)) {
                    qbfs.add(vAdj);
                    qaux.add(vAdj);
                }
            }

            //REMOVE vert from quax
            qaux.removeFirst();
        }

        return qbfs;
    }

    /** Performs depth-first search starting in a vertex
     *
     * @param g Graph instance
     * @param vOrig vertex of graph g that will be the source of the search

     * @param qdfs return LinkedList with vertices of depth-first search
     */
    private static <V, E> void depthFirstSearch(Graph<V, E> g, V vOrig, LinkedList<V> qdfs) {
        if (!qdfs.contains(vOrig)) {
            qdfs.add(vOrig);
        }

        for (V vAdj : g.adjVertices(vOrig)) {
            if (!qdfs.contains(vAdj)) {
                depthFirstSearch(g, vAdj, qdfs);
            }
        }
    }

    /** Performs depth-first search starting in a vertex
     *
     * @param g Graph instance
     * @param vert vertex of graph g that will be the source of the search

     * @return a LinkedList with the vertices of depth-first search
     */
    public static <V, E> List<V> depthFirstSearch(Graph<V, E> g, V vert) {
        if (!g.validVertex(vert)) {
            return Collections.<V>emptyList();
        }

        LinkedList<V> qdfs = new LinkedList<>();
        qdfs.add(vert);

        depthFirstSearch(g, vert, qdfs);

        return qdfs;
    }

    /** Shortest-path between two vertices
     *
     * @param g graph
     * @param vOrig origin vertex
     * @param vDest destination vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */
    @SuppressWarnings("unchecked")
    public static <V, E> E shortestPath(Graph<V, E> g, V vOrig, V vDest,
                                        Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                        LinkedList<V> shortPath) {

        shortPath.clear();

        if (!(g.validVertex(vOrig) && g.validVertex(vDest)))
            return null;

        E maximumValue = zero;

        for(Edge<V,E> edge : g.edges())
            maximumValue = sum.apply(edge.getWeight(), maximumValue);

        int numVertices = g.numVertices();

        ArrayList<V> pathKeys =  new ArrayList<>((Collection<? extends V>) Collections.nCopies(numVertices, 0));
        ArrayList<E> dist = new ArrayList<>((Collection<? extends E>) Collections.nCopies(numVertices, 0));
        boolean[] visited = new boolean[numVertices];

        shortestPathLength(g, vOrig, visited, pathKeys, dist, zero, ce, sum, maximumValue);

        E retValue = dist.get(g.key(vDest));

        getPath(g, vOrig, vDest, pathKeys, shortPath, null);

        if (retValue == maximumValue){
            shortPath.clear();
            return null;
        }

        return retValue;
    }

    /** Shortest-path between a vertex and all other vertices
     *
     * @param g graph
     * @param vOrig start vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param paths returns all the minimum paths
     * @param dists returns the corresponding minimum distances
     * @return if vOrig exists in the graph true, false otherwise
     */
    @SuppressWarnings("unchecked")
    public static <V, E extends Number> boolean shortestPaths(Graph<V, E> g, V vOrig,
                                                              Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                              ArrayList<LinkedList<V>> paths, ArrayList<E> dists, HashMap<V,Long> visitedCount) {
        if (!g.validVertex(vOrig))
            return false;


        E maximumValue = zero;

        for(Edge<V,E> edge : g.edges())
            maximumValue = sum.apply(edge.getWeight(), maximumValue);

        int numVertices = g.numVertices();

        ArrayList<V> pathKeys =  new ArrayList<>((Collection<? extends V>) Collections.nCopies(numVertices, 0));
        ArrayList<E> dist = new ArrayList<>((Collection<? extends E>) Collections.nCopies(numVertices, 0));
        boolean[] visited = new boolean[numVertices];

        for (int i = 0; i < numVertices; i++) {
            dist.set(i, maximumValue);
            pathKeys.set(i, null);
        }

        shortestPathLength(g, vOrig, visited, pathKeys, dist, zero, ce, sum, maximumValue);

        dists.clear();
        paths.clear();

        if (!dists.isEmpty() || !paths.isEmpty())
            return false;

        for (int i = 0; i < numVertices; i++) {
            paths.add(null);
            dists.add(null);
        }

        int i = 0;
        for (V vDest : g.vertices()){

            LinkedList<V> shortPath = new LinkedList<>();
            if (dist.get(i) != maximumValue) {
                getPath(g, vOrig, vDest, pathKeys, shortPath, visitedCount);
                dists.set(i, dist.get(i));

            }else {
                dists.set(i, null);
            }

            paths.set(i, shortPath);
            i++;
        }

        return true;
    }



    /**
     * Extracts from pathKeys the minimum path between voInf and vdInf
     * The path is constructed from the end to the beginning
     *
     * @param g        Graph instance
     * @param vOrig    information of the Vertex origin
     * @param vDest    information of the Vertex destination
     * @param pathKeys minimum path vertices keys
     * @param path     stack with the minimum path (correct order)
     * @param visitedCount   list of vertices with the number of times they are visited in the path
     */
    private static <V, E> void getPath(Graph<V, E> g, V vOrig, V vDest,
                                       ArrayList<V> pathKeys, LinkedList<V> path, HashMap<V,Long> visitedCount)  {

        if ((vOrig != vDest) && (pathKeys.get(g.key(vDest)) == null))
            return;

        path.push(vDest);

        if(visitedCount != null)
            Utilities.addItemToMapAndIncrementOneOnValue(visitedCount, vDest);

        V vControl = pathKeys.get(g.key(vDest));

        while(vControl != null){

            path.push(vControl);

            if(visitedCount != null)
                Utilities.addItemToMapAndIncrementOneOnValue(visitedCount, vControl);

            int key = g.key(vControl);

            if(key < 0 ){
                path.removeFirst();
                return;
            }
            vControl = pathKeys.get(g.key(vControl));
        }
    }

    protected static <V, E> void shortestPathLength(Graph<V, E> g, V vOrig,
                                                    boolean[] visited, ArrayList<V> pathKeys, ArrayList<E> dist, E zero, Comparator<E> ce, BinaryOperator<E> sum, E maximumValue) {

        HashMap<Integer, V> vIndex = new HashMap<>();
        int index = 0;
        int minDist = 0;

        for (V vert : g.vertices()){
            index = g.key(vert);

            if (vert == vOrig){
                visited[index] = true;
                dist.set(index, zero);
                minDist = index;
            }else{
                visited[index] = false;
                dist.set(index, maximumValue);
            }

            vIndex.put(index, vert);
        }


        V vControl = vOrig;
        while(minDist != -1){

            visited[minDist] = true;

            for (V vAdj : g.adjVertices(vControl)){
                    Edge<V, E> ed = g.edge(vControl, vAdj);

                    if (!visited[g.key(vAdj)] && ce.compare(dist.get(g.key(vAdj)), sum.apply(dist.get(minDist), ed.getWeight())) > 0) {

                        dist.set(g.key(vAdj), sum.apply(dist.get(minDist), ed.getWeight()));
                        pathKeys.set(g.key(vAdj), vControl);

                    }
            }

            minDist = findMinDistance(dist, visited, ce, maximumValue);

            if (minDist != -1)
                vControl = vIndex.get(minDist);
        }
    }

    private static<E> int findMinDistance(ArrayList<E> distance, boolean[] visitedVertex, Comparator<E> ce, E maximumValue) {
        E minDistance = maximumValue;

        int minDistanceVertex = -1;
        for (int i = 0; i < distance.size(); i++) {
            if (!visitedVertex[i] && ce.compare(distance.get(i), minDistance) < 0) {
                minDistance = distance.get(i);
                minDistanceVertex = i;
            }
        }
        return minDistanceVertex;
    }

    /**
     * Calculates the minimum number of colors needed to color a graph.
     * It colors the adjecent vertices with different colors
     * @param g graph to color
     * @param <V> type of value of vertice
     * @param <E> type of value of edge
     * @return returns HashMap filled with the key being the vertice and the value the color
     */
    public static <V,E> Map colorMapGraph(Graph<V,E> g) {
        HashMap<V, Integer> collected = new HashMap<>();
        int max = 0;
        for (V vertice: g.vertices()) {
            int color = 0;
            for (V adjvertice: g.adjVertices(vertice)) {
                if(collected.containsKey(adjvertice))
                    color++;
            }
            max = Math.max(max, color);
            System.out.println("Minimum color number: "+ (Math.addExact(max,1)));
            collected.put(vertice,color);
        }
        return collected;
    }
}