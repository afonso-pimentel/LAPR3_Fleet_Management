package lapr.project.utils.datastructures;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class BinarySearchTreeImplTest {
    Integer[] arr = {20,15,10,13,8,17,40,50,30,7};
    int[] height={0,1,2,3,3,3,3,3,3,4};
    Integer[] inorderT= {7,8,10,13,15,17,20,30,40,50};
    Integer[] preorderT= {20, 15, 10, 8, 7, 13, 17, 40, 30, 50};
    Integer[] posorderT = {7, 8, 13, 10, 17, 15, 30, 50, 40, 20};
    Integer[] descOrderT = {50, 40, 30};


    BinarySearchTreeImpl<Integer> instance;

    public BinarySearchTreeImplTest() {
    }

    @BeforeEach
    public void setUp(){
        instance = new BinarySearchTreeImpl();
        for(int i :arr)
            instance.insert(i);
    }

    /**
     * Test of size method, of class BST.
     */
    @Test
    public void testSize() {
        System.out.println("size");
        assertEquals(instance.size(), arr.length);

        BinarySearchTreeImpl<String> sInstance = new BinarySearchTreeImpl();
        assertEquals(sInstance.size(), 0);
        sInstance.insert("A");
        assertEquals(sInstance.size(), 1);
        sInstance.insert("B");
        assertEquals(sInstance.size(), 2);
        sInstance.insert("A");
        assertEquals(sInstance.size(), 2);
    }

    /**
     * Test of insert method, of class BST.
     */
    @Test
    public void testInsert() {
        System.out.println("insert");
        int arr[] = {20,15,10,13,8,17,40,50,30,20,15,10};
        BinarySearchTreeImpl<Integer> instance = new BinarySearchTreeImpl();
        for (int i=0; i<9; i++){            //new elements
            instance.insert(arr[i]);
            assertEquals(instance.size(), i+1);
        }
        for(int i=9; i<arr.length; i++){    //duplicated elements => same size
            instance.insert(arr[i]);
            assertEquals(instance.size(), 9);
        }
    }
    /**
     * Test of remove method, of class BST.
     */
    @Test
    public void testRemove() {
        System.out.println("remove");

        int qtd=arr.length;
        instance.remove(999);

        assertEquals(instance.size(), qtd);
        for (int i=0; i<arr.length; i++){
            instance.remove(arr[i]);
            qtd--;
            assertEquals(qtd,instance.size());
        }

        instance.remove(999);
        assertEquals(0,instance.size());
    }
    /**
     * Test of isEmpty method, of class BST.
     */
    @Test
    public void testIsEmpty() {
        System.out.println("isempty");

        assertFalse(instance.isEmpty());
        instance = new BinarySearchTreeImpl();
        assertTrue(instance.isEmpty());

        instance.insert(11);
        assertFalse(instance.isEmpty());

        instance.remove(11);
        assertTrue(instance.isEmpty());
    }
    /**
     * Test of height method, of class BST.
     */
    @Test
    public void testHeight() {
        System.out.println("height");

        instance = new BinarySearchTreeImpl();
        assertEquals(instance.height(), -1);
        for(int idx=0; idx<arr.length; idx++){
            instance.insert(arr[idx]);
            assertEquals(instance.height(), height[idx]);
        }
        instance = new BinarySearchTreeImpl();
        assertEquals(instance.height(), -1);
    }
    /**
     * Test of smallestelement method, of class TREE.
     */
    @Test
    public void testSmallestElement() {
        System.out.println("smallestElement");
        assertEquals(new Integer(7), instance.smallestElement());
        instance.remove(7);
        assertEquals(new Integer(8), instance.smallestElement());
        instance.remove(8);
        assertEquals(new Integer(10), instance.smallestElement());
    }

    /**
     * Test of highestElement method, of class TREE.
     */
    @Test
    public void testHighestElement() {
        System.out.println("highestElement");
        assertEquals(new Integer(50), instance.highestElement());
        instance.remove(50);
        assertEquals(new Integer(40), instance.highestElement());
        instance.remove(40);
        assertEquals(new Integer(30), instance.highestElement());
    }

    /**
     * Test of inOrder method, of class BST.
     */
    @Test
    public void testInOrder() {
        System.out.println("inOrder");
        List<Integer> lExpected = Arrays.asList(inorderT);
        assertEquals(lExpected, instance.inOrder());
    }
    /**
     * Test of preOrder method, of class BST.
     */
    @Test
    public void testpreOrder() {
        System.out.println("preOrder");
        List<Integer> lExpected = Arrays.asList(preorderT);
        assertEquals(lExpected, instance.preOrder());
    }
    /**
     * Test of posOrder method, of class BST.
     */
    @Test
    public void testposOrder() {
        System.out.println("posOrder");
        List<Integer> lExpected = Arrays.asList(posorderT);
        assertEquals(lExpected, instance.posOrder());
    }

    @Test
    public void Valid_NodeArgument_ShouldReturn_ExpectedValue(){
        // Arrange
        int expectedValue1 = 17;
        int expectedValue2 = 20;

        // Act
        int resultValue1 = instance.find(expectedValue1);
        int resultValue2 = instance.find(expectedValue2);

        // Assert
        assertEquals(expectedValue1, resultValue1);
        assertEquals(expectedValue2, resultValue2);
    }

    @Test
    public void Invalid_NodeArgument_ShouldReturn_NullFind(){
        // Arrange
        Integer value = Integer.MAX_VALUE;

        // Act
        Integer result = instance.find(value);

        // Assert
        assertNull(result);
    }

    @Test
    public void Valid_toStringTree_ShouldReturn_ExpectedValue(){
        int arr[] = {20,15,10,13,8,17,40,50,30,20,15,10};
        BinarySearchTreeImpl<Integer> instance = new BinarySearchTreeImpl();
        for (int i=0; i<9; i++){            //new elements
            instance.insert(arr[i]);
        }
        System.out.println(instance.toString());
        assertEquals(false,instance.toString().isEmpty());
    }

    @Test
    public void Valid_ToStringTree_ShouldReturn_ExpectedStructure(){
        int arr[] = {20,15,10,13,8,17,40,50,30,20,15,10};
        BinarySearchTreeImpl<Integer> instance = new BinarySearchTreeImpl();
        for (int i=0; i<9; i++){            //new elements
            instance.insert(arr[i]);
        }
        String expected ="|\t|-------50\n" +
                "|-------40\n" +
                "|\t|-------30\n" +
                "20\n" +
                "|\t|-------17\n" +
                "|-------15\n" +
                "|\t|\t|-------13\n" +
                "|\t|-------10\n" +
                "|\t|\t|-------8\n" +
                "";

        assertEquals(expected,instance.toString());
    }
}
