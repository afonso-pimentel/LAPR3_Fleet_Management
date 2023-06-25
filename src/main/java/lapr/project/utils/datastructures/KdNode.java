package lapr.project.utils.datastructures;
import java.awt.geom.Point2D;

/**
 * @author Group 169 LAPRIII
 */
public class KdNode<T> {

    protected Point2D.Float coords;
    protected KdNode<T> left;
    protected KdNode<T> right;
    protected T object;

    /**
     * Default Constructor for KdNode
     */
    public KdNode() {
    }

    /**
     * Constructor for KdNode
     * @param object
     * @param x
     * @param y
     */
    public KdNode(T object, float x, float y) {
        this.coords = new Point2D.Float(x,y);
        this.object = object;
    }

    public T getObject() {
        return object;
    }

    public void setObject(T object) {
        this.object = object;
    }

    public Point2D.Float getCoords() {
        return coords;
    }

    public Float getX() {
        return coords.x;
    }

    public Float getY() {
        return coords.y;
    }

}

