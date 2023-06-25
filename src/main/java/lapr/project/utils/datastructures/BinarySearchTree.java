package lapr.project.utils.datastructures;

/**
 * @author Group 169 LAPRIII
 */
public interface BinarySearchTree<E> {

    /**
     * Verifies if BinarySearchTree is empty or not
     * @return boolean
     */
    boolean isEmpty();

    /**
     * Inserts an element into the BinarySearchTree
     * @param element
     */
    void insert(E element);

    /**
     * Removes an element from the BinarySearchTree
     * @param element
     */
    void remove(E element);

    /**
     * Returns the size of the BinarySearchTree
     * @return int
     */
    int size();

    /**
     * Returns the height of the BinarySearchTree
     * @return int
     */
    int height();

    /**
     * Fetches the smallest element within the BinarySearchTree
     * @return Element
     */
    E smallestElement();

    /**
     * Fetches the highest element within the BinarySearchTree
     * @return Element
     */
    E highestElement();

    /**
     * Traverses the tree in order
     * @return Iterable list of elements
     */
    Iterable<E> inOrder();

    /**
     * Traverses the tree in pre order
     * @return Iterable list of elements
     */
    Iterable<E> preOrder();

    /**
     * Traverses the tree in pos order
     * @return Iterable list of elements
     */
    Iterable<E> posOrder();

    /**
     * Finds an element within the BinarySearchTree
     * @return Iterable list of elements
     */
    E find(E element);
}
