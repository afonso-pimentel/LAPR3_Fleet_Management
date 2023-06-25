package lapr.project.utils.datastructures;

import lapr.project.mappers.dtos.ShipDTO;
import lapr.project.model.PositionData;
import lapr.project.model.PositionDataVelocity;
import lapr.project.utils.utilities.Utilities;
import org.junit.jupiter.api.Test;

import java.text.ParseException;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class AVLTest {

    public AVLTest() {
    }

    /**
     * Test of insert method, of class AVL.
     */
    @Test
    public void testInsert() {
        System.out.println("insert");

        //test Simple right rotation
        AVL<Integer> instance = new AVL();
        int arr[] = {8,8,10,2,6,3};
        Integer[] inorder1={2,3,6,8,10};
        for (int i=0; i<arr.length; i++)            //new elements
            instance.insert(arr[i]);

        List<Integer> lExpected = Arrays.asList(inorder1);
        assertEquals(lExpected, instance.inOrder());
        System.out.println("<instance 1>");
        System.out.println(instance);
        System.out.println("height1="+instance.height());
        System.out.println("------------------------------------");

        //test Simple left rotation
        AVL<Integer> instance2 = new AVL();
        int arr2[] = {8,4,10,9,15,12};
        Integer[] inorder2={4,8,9,10,12,15};
        for (int i=0; i<arr2.length; i++)
            instance2.insert(arr2[i]);
        System.out.println("<instance 2>");
        System.out.println(instance2);
        System.out.println("height2="+instance2.height());
        lExpected = Arrays.asList(inorder2);
        assertEquals(lExpected, instance2.inOrder());
        assertEquals(instance2.height(), 2);
        System.out.println("------------------------------------");

        //test double rotation
        AVL<Integer> instance3 = new AVL();
        int arr3[] = {8,4,10,2,6,5};
        Integer[] inorder3={2,4,5,6,8,10};
        for (int i=0; i<arr3.length; i++)
            instance3.insert(arr3[i]);
        System.out.println("<instance 3>");
        System.out.println(instance3);
        System.out.println("height3="+instance3.height());
        lExpected = Arrays.asList(inorder3);
        assertEquals(lExpected, instance3.inOrder());
        assertEquals(instance3.height(), 2);
        System.out.println("------------------------------------");
    }
    /**
     * Test of remove method, of class AVL.
     */
    @Test
    public void testRemove() {
        System.out.println("remove");
        List<Integer> lExpected;
        AVL<Integer> instance;

        instance = new AVL();
        int arr[] = {1,8,4,10,2,6,3};
        for (int i=0; i<arr.length; i++)
            instance.insert(arr[i]);


        //no rotations needed
        instance.remove(3);
        lExpected = Arrays.asList(1,2,4,6,8,10);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(instance.height(), 3);

        //test Simple left rotation
        instance.remove(2);
        lExpected = Arrays.asList(1,4,6,8,10);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(instance.height(), 2);

        instance.remove(10);
        lExpected = Arrays.asList(1,4,6,8);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(instance.height(), 2);

        instance.remove(6);
        lExpected = Arrays.asList(1,4,8);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(1, instance.height());

        instance.remove(4);
        lExpected = Arrays.asList(1,8);
        assertEquals(lExpected, instance.inOrder());
        assertEquals( 1, instance.height());

        instance.remove(8);
        lExpected = Arrays.asList(1);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(0, instance.height());

        instance.remove(1);
        lExpected = Arrays.asList();
        assertEquals(lExpected, instance.inOrder());
        assertEquals(-1, instance.height());

        instance = new AVL();
        int arrr[] = {8,4,10,12,6,13};
        for (int i=0; i<arrr.length; i++)
            instance.insert(arrr[i]);


        //test Simple right rotation
        instance.remove(8);
        lExpected = Arrays.asList(4,6,10,12,13);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(instance.height(), 2);

        instance.remove(12);
        lExpected = Arrays.asList(4,6,10,13);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(instance.height(), 2);

        instance.remove(4);
        lExpected = Arrays.asList(6,10,13);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(instance.height(), 2);

        instance.remove(6);
        lExpected = Arrays.asList(10,13);
        assertEquals(lExpected, instance.inOrder());
        assertEquals(1, instance.height());

        instance.remove(10);
        lExpected = Arrays.asList(13);
        assertEquals(lExpected, instance.inOrder());
        assertEquals( 0, instance.height());

        instance.remove(13);
        lExpected = Arrays.asList();
        assertEquals(lExpected, instance.inOrder());
        assertEquals(-1, instance.height());

        AVL<Integer> test = new AVL<>();
        test.remove(new Integer(0));

        System.out.println("------------------------------------");
    }

    @Test
    public void testEquals() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        int arr[] = {1, 8};
        for (int i = 0; i < arr.length; i++)
        {
            instance.insert(arr[i]);
        }
        AVL<Integer> instance2 = new AVL();
        int arr2[] = {1, 8};
        for (int i = 0; i < arr2.length; i++)
        {
            instance2.insert(arr2[i]);
        }
        assertTrue(instance.equals(instance2));
        instance2.remove(8);
        assertFalse(instance.equals(instance2));
    }

    @Test
    public void invalid_DifferentHasCode_ShouldReturn_False(){
        // Arrange
        AVL<Integer> instance = new AVL();
        int arr[] = {1, 8,4,5,6};
        for (int i = 0; i < arr.length; i++)
        {
            instance.insert(arr[i]);
        }
        AVL<Integer> instance2 = new AVL();
        int arr2[] = {1};
        for (int i = 0; i < arr2.length; i++)
        {
            instance2.insert(arr2[i]);
        }
        // Act & Assert
        assertEquals(false, instance.hashCode()==instance2.hashCode());
    }

    @Test
    public void valid_SameHasCode_ShouldReturn_True(){
        // Arrange
        AVL<Integer> instance = new AVL();
        int arr[] = {1, 8};
        for (int i = 0; i < arr.length; i++)
        {
            instance.insert(arr[i]);
        }
        AVL<Integer> instance2 = new AVL();
        int arr2[] = {1, 8};
        for (int i = 0; i < arr2.length; i++)
        {
            instance2.insert(arr2[i]);
        }
        // Act & Assert
        assertEquals(true, instance.hashCode()==instance2.hashCode());
    }

    @Test
    public void invalid_DifferentClass_ShouldReturn_False(){
        // Arrange
        AVL<Integer> instance = new AVL();
        int arr[] = {1, 8};
        for (int i = 0; i < arr.length; i++)
        {
            instance.insert(arr[i]);
        }
        // Act & Assert
        assertEquals(false, instance.equals(new Integer(5)));
    }

    @Test
    public void valid_equalsNode_ShouldReturn_True(){
        //Arrange
        ShipDTO ship1 = new ShipDTO(123456789,2,10f,20f);
        ShipDTO ship2 = new ShipDTO(123456789,2,10f,20f);
        BinarySearchTreeImpl.Node root1 = new BinarySearchTreeImpl.Node(ship1,null,null);
        BinarySearchTreeImpl.Node root2 = new BinarySearchTreeImpl.Node(ship2,null,null);

        AVL<ShipDTO> nodeTester = new AVL<>();
        nodeTester.insert(ship1);
        nodeTester.insert(ship2);
        nodeTester.equals(root1,root2);

        // Act & Assert
        assertEquals(true, nodeTester.equals(root1,root2));
    }

    @Test
    public void valid_equalsNode_ShouldReturn_False(){
        //Arrange
        ShipDTO ship1 = new ShipDTO(122456799,2,10123f,203123.1231f);
        ShipDTO ship2 = new ShipDTO(123456789,2,10f,20f);
        BinarySearchTreeImpl.Node root1 = new BinarySearchTreeImpl.Node(ship1,null,null);
        BinarySearchTreeImpl.Node root2 = new BinarySearchTreeImpl.Node(ship2,null,null);

        AVL<ShipDTO> nodeTester = new AVL<>();
        nodeTester.insert(ship1);
        nodeTester.insert(ship2);
        nodeTester.equals(root1,root2);

        // Act & Assert
        assertEquals(false, nodeTester.equals(root1,root2));
    }

    @Test
    public void testEqualsWithSameInstance() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        assertTrue(instance.equals(instance));
    }

    @Test
    public void testEqualsWithNullArgument() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        assertFalse(instance.equals(null));
    }

    @Test
    public void testEqualsWithDifferentClass() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        assertFalse(instance.equals(new Integer(2)));
    }

    @Test
    public void testEqualsWithNullNodes() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        assertTrue(instance.equals(null, null));
    }

    @Test
    public void testEqualsWithEqualNodes() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        BinarySearchTreeImpl.Node<Integer> node1 = new BinarySearchTreeImpl.Node<Integer>(3, null, null);
        BinarySearchTreeImpl.Node<Integer> node2 = new BinarySearchTreeImpl.Node<Integer>(3, null, null);

        assertTrue(instance.equals(node1, node2));
    }

    @Test
    public void testEqualsWithNullNode() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        BinarySearchTreeImpl.Node<Integer> node = new BinarySearchTreeImpl.Node<Integer>(3, null, null);

        assertFalse(instance.equals(node, null));
    }

    @Test
    public void testEqualsWithNullNode2() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        BinarySearchTreeImpl.Node<Integer> node = new BinarySearchTreeImpl.Node<Integer>(3, null, null);

        assertFalse(instance.equals(null, node));
    }

    @Test
    public void testEqualsWithEqualNodesAndDifferentChildNodesOnFirstNode() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        BinarySearchTreeImpl.Node<Integer> leftChild = new BinarySearchTreeImpl.Node<Integer>(5, null, null);
        BinarySearchTreeImpl.Node<Integer> rightChild = new BinarySearchTreeImpl.Node<Integer>(5, null, null);

        BinarySearchTreeImpl.Node<Integer> node1 = new BinarySearchTreeImpl.Node<Integer>(3, null, null);
        BinarySearchTreeImpl.Node<Integer> node2 = new BinarySearchTreeImpl.Node<Integer>(3, leftChild, rightChild);

        assertFalse(instance.equals(node1, node2));
    }

    @Test
    public void testEqualsWithEqualNodesAndDifferentChildNodesOnSecondNode() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        BinarySearchTreeImpl.Node<Integer> leftChild = new BinarySearchTreeImpl.Node<Integer>(5, null, null);
        BinarySearchTreeImpl.Node<Integer> rightChild = new BinarySearchTreeImpl.Node<Integer>(5, null, null);

        BinarySearchTreeImpl.Node<Integer> node1 = new BinarySearchTreeImpl.Node<Integer>(3, leftChild, rightChild);
        BinarySearchTreeImpl.Node<Integer> node2 = new BinarySearchTreeImpl.Node<Integer>(3, null, null);

        assertFalse(instance.equals(node1, node2));
    }

    @Test
    public void testEqualsWithEqualNodesAndEqualChildNodes() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        BinarySearchTreeImpl.Node<Integer> leftChild = new BinarySearchTreeImpl.Node<Integer>(5, null, null);
        BinarySearchTreeImpl.Node<Integer> rightChild = new BinarySearchTreeImpl.Node<Integer>(5, null, null);

        BinarySearchTreeImpl.Node<Integer> node1 = new BinarySearchTreeImpl.Node<Integer>(3, leftChild, rightChild);
        BinarySearchTreeImpl.Node<Integer> node2 = new BinarySearchTreeImpl.Node<Integer>(3, leftChild, rightChild);

        assertTrue(instance.equals(node1, node2));
    }

    @Test
    public void testEqualsWithEqualNodesAndDifferentChildNodesOnRightChildNode() {
        System.out.println("equals");
        AVL<Integer> instance = new AVL();
        instance.insert(1);
        instance.insert(2);

        BinarySearchTreeImpl.Node<Integer> leftChild = new BinarySearchTreeImpl.Node<Integer>(5, null, null);
        BinarySearchTreeImpl.Node<Integer> rightChild = new BinarySearchTreeImpl.Node<Integer>(5, null, null);

        BinarySearchTreeImpl.Node<Integer> node1 = new BinarySearchTreeImpl.Node<Integer>(3, leftChild, rightChild);
        BinarySearchTreeImpl.Node<Integer> node2 = new BinarySearchTreeImpl.Node<Integer>(3, leftChild, null);

        assertFalse(instance.equals(node1, node2));
    }

    @Test
    public void testClosestElement() throws ParseException {
        //Arrange
        PositionData positionData = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("31/12/2020 07:25"),
                36.39094f, -122.71335f, new PositionDataVelocity(19.7f, 145.5f), 147, 0, 'B');

        PositionData positionData1 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("19/12/2020 01:25"),
               36.39094f, -122.71334f, new PositionDataVelocity(19.4f, 145.5f), 147, 0, 'B');

        PositionData positionData2 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:24"),
                36.39094f, -100f, new PositionDataVelocity(23f, 145.5f), 147, 0, 'B');

        PositionData positionData3 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:28"),
                36.39994f, -99f, new PositionDataVelocity(23f, 145.5f), 147, 0, 'A');

        PositionData positionData4 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:29"),
                36.39994f, -99f, new PositionDataVelocity(23f, 145.5f), 147, 0, 'A');

        PositionData positionData5 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:30"),
                36.39994f, -99f, new PositionDataVelocity(23f, 145.5f), 147, 0, 'A');

        PositionData positionData6 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:32"),
                36.39994f, -99f, new PositionDataVelocity(23f, 145.5f), 147, 0, 'A');

        PositionData positionData7 = new PositionData(1, Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:33"),
                36.39994f, -99f, new PositionDataVelocity(23f, 145.5f), 147, 0, 'A');

        PositionData findMe = new PositionData(0,Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:31") ,0,0,new PositionDataVelocity(0,0),0,0,'A');
        PositionData findMe1 = new PositionData(0,Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:27") ,0,0,new PositionDataVelocity(0,0),0,0,'A');
        PositionData findMe2 = new PositionData(0,Utilities.convertFromDateStringToTimeStamp("20/12/2020 01:32") ,0,0,new PositionDataVelocity(0,0),0,0,'A');


        AVL<PositionData> pd = new AVL<>();
        pd.insert(positionData);
        pd.insert(positionData1);
        pd.insert(positionData2);
        pd.insert(positionData3);
        pd.insert(positionData4);
        pd.insert(positionData5);
        pd.insert(positionData6);
        pd.insert(positionData7);

        AVL<PositionData> pd2 = new AVL<>();
        pd2.insert(positionData5);
        pd2.insert(positionData6);
        pd2.insert(positionData7);


        AVL<PositionData> nuliAvl = new AVL<>();

        //Act
        PositionData result  = pd.closestElement(findMe);
        PositionData expected = positionData5;

        //Act2
        PositionData result1  = pd.closestElement(findMe1);
        PositionData expected1 = positionData3;

        //Act3
        PositionData result2  = pd2.closestElement(findMe2);
        PositionData expected2 = positionData6;

        //Assert
        assertEquals(expected, result);
        //Assert2
        assertNotEquals(expected1, result1);
        //Assert3
        assertEquals(expected2, result2);
        //Assert4
        assertNull(nuliAvl.closestElement(null));
    }
}
