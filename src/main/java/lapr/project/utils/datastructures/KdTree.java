package lapr.project.utils.datastructures;


import java.awt.geom.Point2D;
import java.util.*;

/**
 * @author Group 169 LAPRIII
 */
public class KdTree<T> {

    private KdNode<T> root;

    /**
     * Default Constructor for the KdTree object
     */
    public KdTree() {
    }

    /**
     * Constructor for the KdTree object
     * @param nodes
     */
    public KdTree(List<KdNode<T>> nodes) {
        buildTree(nodes);
    }

    /**
     * Entry point for building kd-tree
     * @param nodes
     */
    public void buildTree(List<KdNode<T>> nodes) {
        root = buildTree(true, nodes);
    }

    /**
     * builds the kd-tree (recursive)
     * Takes a list of nodes, sorts them and splits it by its median into two,
     * that are used to as arguments in the recursive call.
     * @param divX
     * @param nodes
     * @return
     */
    private KdNode<T> buildTree(boolean divX, List<KdNode<T>> nodes) {
        if (nodes == null || nodes.isEmpty())
            return null;
        // sort list of nodes
        Collections.sort(nodes, divX ? (p1,p2) -> Double.compare(p1.getX(), p2.getX()) : (p1,p2) -> Double.compare(p1.getY(), p2.getY()) );

        //get median index
        int medianIndex = nodes.size() / 2;

        KdNode<T> node = new KdNode<>();
        node.coords = nodes.get(medianIndex).getCoords();
        node.object = nodes.get(medianIndex).getObject();

        //send first half of list to left side of tree
        node.left = buildTree(!divX, nodes.subList(0, medianIndex));

        //if at there is at least one node in the second half send it to right side of tree
        node.right = buildTree(!divX, nodes.subList(medianIndex+1, nodes.size()));

        return node;
    }

    /**
     * Entry point for inserting element into kd-tree
     * If tree is not empty calls the recursive insert
     * @param object
     * @param x
     * @param y
     */
    public void insert(T object, float x, float y) {
        KdNode<T> node = new KdNode<>(object, x, y);
        if (root == null)
            root = node;
        else
            insert(node, root, true);
    }

    /**
     * Inserts element into kd-tree (recursive)
     * @param node
     * @param currentNode
     * @param divX
     */
    private void insert(KdNode<T> node, KdNode<T> currentNode, boolean divX) {
        int cmpResult = divX ? Double.compare(node.getX(), currentNode.getX()) : Double.compare(node.getY(), currentNode.getY());

        if (cmpResult == -1)
            if (currentNode.left == null)
                currentNode.left = node;
            else
                insert(node, currentNode.left, !divX);
        else if (currentNode.right == null)
            currentNode.right = node;
        else
            insert(node, currentNode.right, !divX);
    }

    /**
     * Get list of generic objects in kd-tree
     * @return
     */
    public List<T> getAll() {
        final List<T> objecTList = new LinkedList<>();
        fillObjectList(root, objecTList);

        return objecTList;
    }

    /**
     * Populates list of objects (recursive)
     * @param node
     * @param objectList
     */
    private void fillObjectList(KdNode<T> node, List<T> objectList) {
        if (node == null)
            return;

        objectList.add(node.getObject());

        if (node.left != null)
            fillObjectList(node.left, objectList);

        if (node.right != null)
            fillObjectList(node.right, objectList);
    }

    /**
     * Method caller to find the nearest neighbour of a given longitude and latitude
     * @param longitude
     * @param latitude
     * @return
     */
    public T findNearestNeighbour(float longitude, float latitude) {
        return findNearestNeighbour(root, longitude, latitude,true);
    }

    /**
     * Method to find the Nearest Neighbour of a given longitude and latitude.
     * It goes on calculating the squared distance between two points between the given info
     * and the tree's node values.
     * It keeps comparing and changing the value of the comparator in case it finds an inferior distance.
     * The fact that in KdTree's the comparing coordenate must exachange in every change of depth.
     * @param fromNode
     * @param x
     * @param y
     * @param divX
     * @return
     */
    private T findNearestNeighbour(KdNode<T> fromNode, final float x, final float y, boolean divX) {
        return new Object() {

            float closestDist = Float.POSITIVE_INFINITY;

            T closestNode = null;

            T findNearestNeighbour(KdNode<T> node, boolean divX) {
                if (node == null)
                    return null;
                float d = (float) Point2D.distanceSq(node.coords.x, node.coords.y, x, y);
                if (closestDist > d) {
                    closestDist = d;
                    closestNode = node.object;
                }
                float delta = divX ? x - node.coords.x : y - node.coords.y;
                float delta2 = (float) Math.pow(delta,2);
                KdNode<T> node1 = delta < 0 ? node.left : node.right;
                KdNode<T> node2 = delta < 0 ? node.right : node.left;
                findNearestNeighbour(node1, !divX);
                if (compareToNum(closestDist,delta2)) {
                    findNearestNeighbour(node2, !divX);
                }
                return closestNode;
            }
        }.findNearestNeighbour(fromNode, divX);
        }

        public boolean compareToNum(float a,float b){
            return a > b;
        }
    }
