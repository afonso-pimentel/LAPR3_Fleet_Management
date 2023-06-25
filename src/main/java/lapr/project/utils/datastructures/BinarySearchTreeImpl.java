package lapr.project.utils.datastructures;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public class BinarySearchTreeImpl <E extends Comparable<E>> implements BinarySearchTree<E> {

    protected static class Node<E> {
        private E element;
        private Node<E> left;
        private Node<E> right;

        public Node(E e, Node<E> leftChild, Node<E> rightChild) {
            element = e;
            left = leftChild;
            right = rightChild;
        }

        public E getElement() { return element; }
        public Node<E> getLeft() { return left; }
        public Node<E> getRight() { return right; }

        public void setElement(E e) { element = e; }
        public void setLeft(Node<E> leftChild) { left = leftChild; }
        public void setRight(Node<E> rightChild) { right = rightChild; }
    }

    protected Node<E> root = null;

    /**
     * Constructor for the BinarySearchTreeImpl object
     */
    public BinarySearchTreeImpl() {
        root = null;
    }

    /*
     * @return root Node of the tree (or null if tree is empty)
     */
    protected Node<E> root() {
        return root;
    }

    /**
     * {@inheritdoc}
     */
    public boolean isEmpty(){
        return root==null;
    }

    /**
     * {@inheritdoc}
     */
    public void insert(E element){
        root = insert(element, root());
    }

    /**
     * {@inheritdoc}
     */
    public int size(){
        return size(root());
    }

    /**
     * {@inheritdoc}
     */
    public void remove(E element){
        root = remove(element, root());
    }

    /**
     * {@inheritdoc}
     */
    public int height(){
        return height(root());
    }

    /**
     * {@inheritdoc}
     */
    public E smallestElement(){
        return smallestElement(root);
    }


    /**
     * Fetches the highest element within the BinarySearchTree
     *
     * @return Element
     */
    @Override
    public E highestElement() {
        return highestElement(root);
    }

    /**
     * {@inheritdoc}
     */
    public Iterable<E> inOrder(){
        List<E> snapshot = new ArrayList<>();
        if (root!=null)
            inOrderSubtree(root, snapshot);   // fill the snapshot recursively
        return snapshot;
    }

    /**
     * {@inheritdoc}
     */
    public Iterable<E> preOrder(){
        List<E> snapshot = new ArrayList();
        snapshot.add(root().element);

        preOrderSubtree(root().left, snapshot);
        preOrderSubtree(root().right, snapshot);
        return snapshot;
    }

    /**
     * {@inheritdoc}
     */
    public Iterable<E> posOrder(){
        List<E> snapshot = new ArrayList();

        posOrderSubtree(root(), snapshot);

        return snapshot;
    }

    /**
     * {@inheritdoc}
     */
    public E find(E element){
        return find(element, root());
    }

    /**
     * Returns a string representation of the tree.
     * Draw the tree horizontally
     */
    public String toString(){
        StringBuilder sb = new StringBuilder();
        toStringRec(root, 0, sb);
        return sb.toString();
    }

    private Node<E> insert(E element, Node<E> node){
        Node<E> newNode = new Node(element, null, null);

        if(node == null){
            node = newNode;
        }else if(element.compareTo(node.element) > 0){
            if(node.getRight() == null){
                node.setRight(newNode);
            }else{
                insert(element, node.getRight());
            }
        }else if(element.compareTo(node.element) < 0){
            if(node.getLeft() == null){
                node.setLeft(newNode);
            }else{
                insert(element, node.getLeft());
            }
        }

        return node;
    }

    private Node<E> remove(E element, Node<E> node) {

        if (node == null) {
            return null;
        }
        if (element.compareTo(node.getElement())==0) {
            // node is the Node to be removed
            if (node.getLeft() == null && node.getRight() == null) { //node is a leaf (has no childs)
                return null;
            }
            if (node.getLeft() == null) {   //has only right child
                return node.getRight();
            }
            if (node.getRight() == null) {  //has only left child
                return node.getLeft();
            }
            E min = smallestElement(node.getRight());
            node.setElement(min);
            node.setRight(remove(min, node.getRight()));
        }
        else if (element.compareTo(node.getElement()) <= -1)
            node.setLeft( remove(element, node.getLeft()) );
        else
            node.setRight( remove(element, node.getRight()) );

        return node;
    }

    private int size(Node<E> node){
        if (node == null)
            return 0;
        else
            return(size(node.left) + 1 + size(node.right));
    }

    /**
     * Adds elements of the subtree rooted at Node node to the given
     * snapshot using an in-order traversal
     * @param node       Node serving as the root of a subtree
     * @param snapshot  a list to which results are appended
     */
    private void inOrderSubtree(Node<E> node, List<E> snapshot) {
        if (node == null)
            return;
        inOrderSubtree(node.getLeft(), snapshot);
        snapshot.add(node.getElement());
        inOrderSubtree(node.getRight(), snapshot);
    }

    /**
     * Adds elements of the subtree rooted at Node node to the given
     * snapshot using an pre-order traversal
     * @param node       Node serving as the root of a subtree
     * @param snapshot  a list to which results are appended
     */
    private void preOrderSubtree(Node<E> node, List<E> snapshot) {
        if(node != null){
            snapshot.add(node.element);
            preOrderSubtree(node.left, snapshot);
            preOrderSubtree(node.right, snapshot);
        }
    }

    /**
     * Adds positions of the subtree rooted at Node node to the given
     * snapshot using an post-order traversal
     * @param node       Node serving as the root of a subtree
     * @param snapshot  a list to which results are appended
     */
    private void posOrderSubtree(Node<E> node, List<E> snapshot) {
        if(node != null){

            posOrderSubtree(node.left, snapshot);
            posOrderSubtree(node.right, snapshot);
            snapshot.add(node.element);
        }
    }

    private E find(E element, Node<E> node){
        if (node == null) {
            return null;
        } else if (node.element.compareTo(element) == 0) {
            return node.element;
        } else if (node.element.compareTo(element) >= 1) {
            return find(element, node.left);
        }

        return find(element, node.getRight());
    }

    /*
     * Returns the height of the subtree rooted at Node node.
     * @param node A valid Node within the tree
     * @return height
     */
    protected int height(Node<E> node){
        if (node == null) return -1;
        return 1 + Math.max(height(node.left), height(node.right));
    }

    protected E smallestElement(Node<E> node){
        if(node.getLeft() == null){
            return node.element;
        }
        return smallestElement(node.getLeft());
    }

    protected E highestElement(Node<E> node){
        if(node.getRight() == null){
            return node.element;
        }
        return highestElement(node.getRight());
    }

    private void toStringRec(Node<E> root, int level, StringBuilder sb){
        if(root==null)
            return;
        toStringRec(root.getRight(), level+1, sb);
        if (level!=0){
            for(int i=0;i<level-1;i++)
                sb.append("|\t");
            sb.append("|-------"+root.getElement()+"\n");
        }
        else
            sb.append(root.getElement()+"\n");
        toStringRec(root.getLeft(), level+1, sb);
    }
}