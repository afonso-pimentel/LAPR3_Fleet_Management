package lapr.project.utils.datastructures;

import java.util.*;


/**
 * @param <V> Vertex value type
 * @param <E> Edge value type
 * @author DEI-ESINF
 */
public class MapGraph<V, E> extends CommonGraph<V, E> {
    private final Map<V, MapVertex<V, E>> mapVertices;  // all the Vertices of the graph
    private static final String VERTEX_NULLMESSAGE = "Vertices cannot be null!";
    
    // Constructs an empty graph (either undirected or directed)
    public MapGraph(boolean directed) {
        super(directed);
        mapVertices = new LinkedHashMap<>();
    }

    public MapGraph(Graph<V,E> g) {
        this(g.isDirected());
        copy(g, this);
    }

    @Override
    public boolean validVertex(V vert) { return (mapVertices.get(vert) != null);   }

    @Override
    public Collection<V> adjVertices(V vert) {
        if (!validVertex(vert))
            return Collections.<V>emptyList();

        return mapVertices.get(vert).getAllAdjVerts();
    }

    @Override
    public Collection<Edge<V, E>> edges() {

        ArrayList<Edge<V, E>> le = new ArrayList<>(numEdges);

        for (MapVertex<V, E> mv : mapVertices.values())
            le.addAll(mv.getAllOutEdges());

        return le;
    }

    @Override
    public Edge<V, E> edge(V vOrig, V vDest) {

        if (!validVertex(vOrig) || !validVertex(vDest))
            return null;

        MapVertex<V, E> mv = mapVertices.get(vOrig);

        return mv.getEdge(vDest);
    }

    @Override
    public Edge<V, E> edge(int vOrigKey, int vDestKey) {
        V vOrig = vertex(vOrigKey);
        V vDest = vertex(vDestKey);

        return edge(vOrig, vDest);
    }

    @Override
    public int outDegree(V vert) {

        if (!validVertex(vert))
            return -1;

        MapVertex<V, E> mv = mapVertices.get(vert);

        return mv.numAdjVerts();
    }

    @Override
    public int inDegree(V vert) {

        if (!validVertex(vert))
            return -1;

        int degree = 0;
        for (V otherVert : mapVertices.keySet())
            if (edge(otherVert, vert) != null)
                degree++;

        return degree;
    }

    @Override
    public Collection<Edge<V, E>> outgoingEdges(V vert) {

        if (!validVertex(vert))
            return Collections.<Edge<V, E>>emptyList();

        MapVertex<V, E> mv = mapVertices.get(vert);

        return mv.getAllOutEdges();
    }

    @Override
    public Collection<Edge<V, E>> incomingEdges(V vert) {
        List<Edge<V,E>> incomingEdges = new ArrayList<>();

        if (!validVertex(vert))
            return Collections.<Edge<V, E>>emptyList();

        for (MapVertex<V, E> vertex : mapVertices.values()){
            Edge<V,E> edge = vertex.getEdge(vert);

            if(edge != null)
                incomingEdges.add(edge);
        }

        return incomingEdges;
    }

    @Override
    public boolean addVertex(V vert) {

        if (vert == null) throw new RuntimeException(VERTEX_NULLMESSAGE);
        if (validVertex(vert))
            return false;

        MapVertex<V, E> mv = new MapVertex<>(vert);
        vertices.add(vert);
        mapVertices.put(vert, mv);
        numVerts++;

        return true;
    }

    @Override
    public boolean addEdge(V vOrig, V vDest, E weight) {

        if (vOrig == null || vDest == null) throw new RuntimeException(VERTEX_NULLMESSAGE);
        if (edge(vOrig, vDest) != null)
            return false;

        if (!validVertex(vOrig))
            addVertex(vOrig);

        if (!validVertex(vDest))
            addVertex(vDest);

        MapVertex<V, E> mvo = mapVertices.get(vOrig);
        MapVertex<V, E> mvd = mapVertices.get(vDest);

        Edge<V, E> newEdge = new Edge<>(mvo.getElement(), mvd.getElement(), weight);
        mvo.addAdjVert(mvd.getElement(), newEdge);
        numEdges++;

        // if vDest different vOrig
        if (edge(vDest, vOrig) == null && !isDirected) {
            Edge<V, E> otherEdge = new Edge<>( mvd.getElement(), mvo.getElement(), weight);
            mvd.addAdjVert(mvo.getElement(), otherEdge);
            numEdges++;
        }

        return true;
    }

    @Override
    public boolean removeVertex(V vert) {

        if (vert == null) throw new RuntimeException(VERTEX_NULLMESSAGE);
        if (!validVertex(vert))
            return false;

        //remove all edges that point to vert
        for (Edge<V, E> edge : incomingEdges(vert)) {
            removeEdge(edge.getVOrig(), vert);
        }

        MapVertex<V, E> mv = mapVertices.get(vert);

        //The edges that live from vert are removed with the vertex
        numEdges -= mv.numAdjVerts();
        mapVertices.remove(vert);
        vertices.remove(vert);

        numVerts--;

        return true;
    }

    @Override
    public boolean removeEdge(V vOrig, V vDest) {

        if (vOrig == null || vDest == null) throw new RuntimeException(VERTEX_NULLMESSAGE);
        if (!validVertex(vOrig) || !validVertex(vDest))
            return false;

        Edge<V, E> edge = edge(vOrig, vDest);

        if (edge == null)
            return false;

        MapVertex<V, E> mvo = mapVertices.get(vOrig);

        mvo.remAdjVert(vDest);
        numEdges--;

        //if graph is not directed
        if (!isDirected) {
            edge = edge(vDest, vOrig);
            if (edge != null) {
                MapVertex<V, E> mvd = mapVertices.get(vDest);
                mvd.remAdjVert(vOrig);
                numEdges--;
            }
        }
        return true;
    }

    //Returns a clone of the graph
    @Override
    public MapGraph<V, E> clone() {

        MapGraph<V, E> g = new MapGraph<>(this.isDirected);

        copy(this,g);

        return g;
    }

    //string representation
    @Override
    public String toString() {
        StringBuilder s = new StringBuilder();

        if (numVerts == 0) {
            s.append("\nGraph not defined!!");
        } else {
            s.append("Graph: " + numVerts + " vertices, " + numEdges + " edges\n");
            for (MapVertex<V, E> mv : mapVertices.values())
                s.append(mv + "\n");
        }
        return s.toString();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }

        if (obj.getClass() != this.getClass()) {
            return false;
        }

        final MapGraph<V,E> other = (MapGraph<V, E>) obj;

        return this.isDirected == other.isDirected && this.edges().equals(other.edges());
    }
}