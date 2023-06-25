package lapr.project.utils.datastructures;


public class AVL<E extends Comparable<E>> extends BinarySearchTreeImpl<E>  {

    @Override
    public void insert(E element){
        root = insertIntoNode(element, root);
    }

    @Override
    public void remove(E element){
        root = removeFromNode(element, root());
    }

    public boolean equals(Object otherObj) {

        if (this == otherObj)
            return true;

        if (otherObj == null || this.getClass() != otherObj.getClass())
            return false;

        AVL<E> second = (AVL<E>) otherObj;
        return equals(root, second.root);
    }

    public boolean equals(Node<E> root1, Node<E> root2) {
        if (root1 == null && root2 == null)
            return true;
        else if (root1 != null && root2 != null) {
            if (root1.getElement().compareTo(root2.getElement()) == 0) {
                return equals(root1.getLeft(), root2.getLeft())
                        && equals(root1.getRight(), root2.getRight());
            } else
                return false;
        }
        else return false;
    }

    private int balanceFactor(Node<E> node){
        return height(node.getRight()) - height(node.getLeft());
    }

    private Node<E> rightRotation(Node<E> node){
        Node<E> leftNode = node.getLeft();

        node.setLeft(leftNode.getRight());
        leftNode.setRight(node);

        return leftNode;
    }

    private Node<E> leftRotation(Node<E> node){

        Node<E> rightNode = node.getRight();

        node.setRight(rightNode.getLeft());
        rightNode.setLeft(node);

        return rightNode;
    }

    private Node<E> balanceNode(Node<E> node)
    {
        int balanceFactor = balanceFactor(node);

        if(balanceFactor > 0){
            return leftRotation(node);
        }else if(balanceFactor < 0){
            return rightRotation(node);
        }

        return node;
    }

    private Node<E> insertIntoNode(E element, Node<E> node){
        if(node == null){
            return new Node(element, null, null);
        }

        if(node.getElement() != element){
            if(node.getElement().compareTo(element) >= 1){
                node.setLeft(insertIntoNode(element, node.getLeft()));
                node = balanceNode(node);
            }else{
                node.setRight(insertIntoNode(element, node.getRight()));
                node = balanceNode(node);
            }
        }

        return node;
    }

    private Node<E> removeFromNode(E element, BinarySearchTreeImpl.Node<E> node) {
        if (node == null)
            return null;

        if (node.getElement() == element) {
            if (node.getLeft() == null && node.getRight()== null)
                return null;

            if (node.getLeft() == null)
                return node.getRight();

            if (node.getRight() == null)
                return node.getLeft();

            E smallElem = smallestElement(node.getRight());

            node.setElement(smallElem);
            node.setRight(removeFromNode(smallElem, node.getRight()));
            node = balanceNode(node);
        }
        else if (node.getElement().compareTo(element) >= 1) {
            node.setLeft(removeFromNode(element,node.getLeft()));
            node = balanceNode(node);
        }
        else {
            node.setRight(removeFromNode(element,node.getRight()));
            node = balanceNode(node);
        }

        return node;
    }

    /**
     * Gets the closest element of a given element.
     * @param element - element to find the closest
     * @return - closest element found
     */
    public E closestElement(E element){
        return closestElement(element, root());
    }

    /**
     * Returns the closest element in the node comepared to a element
     * @param element - element to find the closest
     * @param node - node to be looked into
     * @return returns closest element
     */
    private E closestElement(E element, Node<E> node){
        if(node == null)
            return null;

        if(node.getRight() == null || node.getLeft() == null)
            return node.getElement();

        if((element.compareTo(node.getElement())) > 0)
            return closestElement(element,node.getRight());

        if(element.compareTo(node.getElement()) < 0)
            return closestElement(element,node.getLeft());

        return node.getElement();
    }

    @Override
    public int hashCode(){
        return this.size()*169;
    }
}
