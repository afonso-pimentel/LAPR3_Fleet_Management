package lapr.project.utils.datastructures;

import lapr.project.mappers.PortMapperImpl;
import lapr.project.model.Port;
import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.stores.PortStoreImpl;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReaderImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class KdTreeTest {

    KdTree<Port> instance;
    KdTree<Port> instance2;
    KdTree<Port> instancen;

    KdNode<Port> noden;
    KdNode<Port> node1;
    KdNode<Port> node2;
    KdNode<Port> node3;
    KdNode<Port> node4;
    KdNode<Port> node5;
    KdNode<Port> node6;
    KdNode<Port> node7;
    KdNode<Port> node8;
    KdNode<Port> node9;
    KdNode<Port> node10;

    Port portn;
    Port port1;
    Port port2;
    Port port3;
    Port port4;
    Port port5;
    Port port6;
    Port port7;
    Port port8;
    Port port9;
    Port port10;
    Port port11;
    Port port12;
    Port port13;
    Port port14;


    @BeforeEach
    public void setUp(){
        instance = new KdTree<>();
        instance2 = new KdTree<>();
        instancen = new KdTree<>();

        port1 = new Port("Name1", "Continent1",  "country1", 00001,  10,  10);
        port2 = new Port("Name2", "Continent2",  "country2", 00001,  15,  10);
        port3 = new Port("Name3", "Continent3",  "country3", 00001,  15,  15);
        port4 = new Port("Name4", "Continent4",  "country4", 00001,  20,  20);
        port5 = new Port("Name5", "Continent5",  "country5", 00001,  10,  15);
        port6 = new Port("Name6", "Continent6",  "country6", 00006,  16,  16);
        port7 = new Port("Name7", "Continent7",  "country7", 00007,  17,  17);
        port8 = new Port("Name8", "Continent8",  "country8",    18,  18,  18);
        port9 = new Port("Name9", "Continent9",  "country9",     9,  19,  95);
        port10 = new Port("Name10", "Continent10",  "country10", 00005,  10,  110);
        port11 = new Port("Name11", "Continent11",  "country11", 00002,  1,  1);
        port12 = new Port("Name12", "Continent12",  "country12", 00003,  2,  2);
        port13 = new Port("Name13", "Continent13",  "country13", 00004,  3,  3);
        port14 = new Port("Name14", "Continent14",  "country14", 00004,  -10,  -20);
        portn = null;

        node1 = new KdNode<>(port1, 10, 10);
        node2 = new KdNode<>(port2, 15, 10);
        node3 = new KdNode<>(port3, 15, 15);
        node4 = new KdNode<>(port4, 20, 20);
        node5 = new KdNode<>(port5, 10, 15);
        node6 = new KdNode<>(port6, 16, 16);
        node7 = new KdNode<>(port7, 17, 17);
        node8 = new KdNode<>(port8, 18, 18);
        node9 = new KdNode<>(port9, 19, 19);
        node10 = new KdNode<>(port10, 10, 110);
        noden = null;
    }

    @Test
    public void testBuildTreeNull_NodeArgument_ShouldReturn_NullFind() {
        // Arrange
        int expectedListSize = 0;
        //---
        // Act
        instance.buildTree(null);
        int actualListSize = instance.getAll().size();

        // Assert
        assertEquals(expectedListSize, actualListSize);
    }

    /**
     * Checks if for an equal value to a port, it returns the same port.
     * @throws IOException
     * @throws ParseException
     */
    @Test
    public void equal_Value_Should_Return_Expected_Object_GetNearest() throws IOException, ParseException {
        // Arrange
        PortMapperImpl portMapperImpl = new PortMapperImpl();
        FileReaderImpl fileReaderImpl = new FileReaderImpl();
        CsvFileParserImpl csvFileParserImpl = new CsvFileParserImpl();
        PortStoreImpl portStoreImpl = new PortStoreImpl(portMapperImpl);

        String filePath = System.getProperty("user.dir") + "/src/test/resources/sports.csv"; //mine does not identify only by /resources/file.csv

        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);

        // Act
        portStoreImpl.importPortsFromCsv(csvParsedFileContent);
        KdTree<Port> portKdTree = portStoreImpl.getPorts();

        Port actual = portKdTree.findNearestNeighbour(-32.066666f,-52.066666f);
        Port expected = new Port("Rio Grande", "America","Brazil",20301,-32.066666f,-52.066666f);

        // Assert
        assertEquals(expected.getLongitude(), actual.getLongitude());
    }

    /**
     * Checks if for 5 values of longitude and latitude it returns the expected result.
     *
     * @throws IOException
     * @throws ParseException
     */
    @Test
    public void valid_Values_Should_Return_Expected_Objects_GetNearest() throws IOException, ParseException {
        // Arrange
        PortMapperImpl portMapperImpl = new PortMapperImpl();
        FileReaderImpl fileReaderImpl = new FileReaderImpl();
        CsvFileParserImpl csvFileParserImpl = new CsvFileParserImpl();
        PortStoreImpl portStoreImpl = new PortStoreImpl(portMapperImpl);

        String filePath = System.getProperty("user.dir") + "/src/test/resources/sports.csv"; //mine does not identify only by /resources/file.csv

        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);

        // Act
        portStoreImpl.importPortsFromCsv(csvParsedFileContent);
        KdTree<Port> portKdTree = portStoreImpl.getPorts();

        Port actual0 = portKdTree.findNearestNeighbour(-88.82491f,28.33263f);
        Port expected0 = new Port("New Jersey","America","United States",25007,40.66666667f,-74.16666667f);
        Port actual1 = portKdTree.findNearestNeighbour(-10.0f,37.0f);
        Port expected1 = new Port("Setubal","Europe","Portugal",13390,38.5f,-8.916666667f);
        Port actual2 = portKdTree.findNearestNeighbour(-80.0f,-10.0f);
        Port expected2 = new Port("Callao","America","Peru",30045,-12.05f,-77.16666667f);
        Port actual3 = portKdTree.findNearestNeighbour(-77.0f,-34.0f);
        Port expected3 = new Port("San Vicente","America","Chile",27792,-36.73333333f,-73.15f);
        Port actual4 = portKdTree.findNearestNeighbour(-100.0f,35.0f);
        Port expected4 = new Port("Los Angeles","America","United States",13390,33.71666667f,-118.2666667f);
        Port actual5 = portKdTree.findNearestNeighbour(0.0f,41f);
        Port expected5 = new Port("Valencia","Europe","Spain",18937,39.45f,-0.3f);

        // Assert
        assertEquals(expected0.getLongitude(), actual0.getLongitude());
        assertEquals(expected1.getLongitude(), actual1.getLongitude());
        assertEquals(expected2.getLongitude(), actual2.getLongitude());
        assertEquals(expected3.getLongitude(), actual3.getLongitude());
        assertEquals(expected4.getLongitude(), actual4.getLongitude());
        assertEquals(expected5.getLongitude(), actual5.getLongitude());
    }

    @Test
    public void testBuildTreeEmpty_NodeArgument_ShouldReturn_NullFind() {
        // Arrange
        int expectedListSize = 0;

        List<KdNode<Port>> emptyList = new ArrayList<KdNode<Port>>();

        // Act
        instance.buildTree(emptyList);
        int actualListSize = instance.getAll().size();

        // Assert
        assertEquals(expectedListSize, actualListSize);
    }

    @Test
    public void testBuildTree_NodeArgument_ShouldReturn_expected_size(){
        // Arrange
        int expectedListSize = 5;

        List<KdNode<Port>> nodes = new ArrayList<>();

        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);
        nodes.add(node5);

        // Act

        instance.buildTree(nodes);
        int actualListSize = instance.getAll().size();

        // Assert
        assertEquals(expectedListSize, actualListSize);
    }

    @Test
    public void testKdTreeConstructor_NodeArgument_ShouldReturn_expected_size(){
        // Arrange
        int expectedListSize = 5;

        List<KdNode<Port>> nodes = new ArrayList<>();

        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);
        nodes.add(node5);

        // Act
        KdTree<Port> portKdTree = new KdTree<>(nodes);
        int actualListSize = portKdTree.getAll().size();

        // Assert
        assertEquals(expectedListSize, actualListSize);
    }

    @Test
    public void testInsert() {
        // Arrange
        List<Port> expectednodes = new ArrayList<>();
        expectednodes.add(port6);
        expectednodes.add(port5);
        expectednodes.add(port13);
        expectednodes.add(port11);
        expectednodes.add(port12);
        expectednodes.add(port2);
        expectednodes.add(port1);
        expectednodes.add(port3);
        expectednodes.add(port8);
        expectednodes.add(port7);
        expectednodes.add(port10);
        expectednodes.add(port9);
        expectednodes.add(port4);

        // Act
        instance.insert(port6, port6.getLongitude(), port6.getLatitude());
        instance.insert(port8, port8.getLongitude(), port8.getLatitude());
        instance.insert(port9, port9.getLongitude(), port9.getLatitude());
        instance.insert(port5, port5.getLongitude(), port5.getLatitude());
        instance.insert(port4, port4.getLongitude(), port4.getLatitude());
        instance.insert(port7, port7.getLongitude(), port7.getLatitude());
        instance.insert(port2, port2.getLongitude(), port2.getLatitude());
        instance.insert(port1, port1.getLongitude(), port1.getLatitude());
        instance.insert(port10, port10.getLongitude(), port10.getLatitude());
        instance.insert(port3, port3.getLongitude(), port3.getLatitude());
        instance.insert(port13, port13.getLongitude(), port13.getLatitude());
        instance.insert(port11, port11.getLongitude(), port11.getLatitude());
        instance.insert(port12, port12.getLongitude(), port12.getLatitude());

        List<Port> actualPorts = instance.getAll();

        Port actualPort = instance.findNearestNeighbour(port5.getLongitude(), port5.getLatitude());
        Port expectedPort = port5;

        instancen.buildTree(new ArrayList<>());
        instancen.insert(portn,0,0);
        Port portnuli = instancen.findNearestNeighbour(0, 0);

        //Assert - TestOnePort
        assertEquals(expectedPort, actualPort);
        //Assert2 - TestListPortsOrder
        assertEquals(expectednodes,actualPorts);
        //Assert3 - TestNullPort
        assertNull(portnuli);
    }

    @Test
    public void testInsertInto_Empty_Tree() {
        // Arrange
        // Act
        instance.insert(port5, port5.getLongitude(), port5.getLatitude());
        Port actualPort = instance.findNearestNeighbour(port5.getLongitude(), port5.getLatitude());
        Port expectedPort = port5;

        // Assert
        assertEquals(expectedPort, actualPort);
    }

    @Test
    public void testbuild_Expected_tree() {
        // Arrange
        List<KdNode<Port>> nodes = new ArrayList<>();

        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);
        nodes.add(node5);
        nodes.add(node6);
        nodes.add(node7);
        nodes.add(node8);
        nodes.add(node9);
        nodes.add(node10);

        List<Port> expectedPortList = new ArrayList<>();
        
        expectedPortList.add(port6);
        expectedPortList.add(port5);
        expectedPortList.add(port2);
        expectedPortList.add(port1);
        expectedPortList.add(port3);
        expectedPortList.add(port10);
        expectedPortList.add(port9);
        expectedPortList.add(port8);
        expectedPortList.add(port7);
        expectedPortList.add(port4);

        // Act
        instance.buildTree(nodes);
        List<Port> actualPortList = instance.getAll();

        // Assert
        for (int i = 0; i < actualPortList.size(); i++) {

            assertEquals(expectedPortList.get(i), actualPortList.get(i));
        }
    }

    @Test
    public void testInsert_Expected_tree() {
        // Arrange
        List<KdNode<Port>> nodes = new ArrayList<>();

        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);

        instance.buildTree(nodes);

        List<Port> expectedPortList = new ArrayList<>();
        expectedPortList.add(port3);
        expectedPortList.add(port2);
        expectedPortList.add(port1);
        expectedPortList.add(port4);
        expectedPortList.add(port5);

        // Act
        instance.insert(port5, port5.getLongitude(), port5.getLatitude());
        List<Port> actualPortList = instance.getAll();


        // Assert
        for (int i = 0; i < actualPortList.size(); i++) {
            assertEquals(expectedPortList.get(i), actualPortList.get(i));
        }
    }

    @Test
    public void testVerifySetObject(){
        //Arrange
        Ship ship = new Ship(0,0,null,null,0,new ShipCharacteristics(0,0,null,0,0,0,0f),null);
        Port porto = new Port("Leixoes", "Europa",  "Portugal", 00021,  30,  15.7f);
        node1.setObject(porto);

        //Act & Assert
        assertEquals(node1.object,porto);
        assertNotEquals(node1.object,ship);
    }

    @Test
    public void testNearestNeighbor(){
        //Arrange
        instance.insert(port6, port6.getLongitude(), port6.getLatitude());
        instance.insert(port8, port8.getLongitude(), port8.getLatitude());
        instance.insert(port9, port9.getLongitude(), port9.getLatitude());
        instance.insert(port5, port5.getLongitude(), port5.getLatitude());
        instance.insert(port4, port4.getLongitude(), port4.getLatitude());
        instance.insert(port7, port7.getLongitude(), port7.getLatitude());
        instance.insert(port2, port2.getLongitude(), port2.getLatitude());
        instance.insert(port1, port1.getLongitude(), port1.getLatitude());
        instance.insert(port10, port10.getLongitude(), port10.getLatitude());
        instance.insert(port3, port3.getLongitude(), port3.getLatitude());
        instance.insert(port11, port11.getLongitude(), port11.getLatitude());
        instance.insert(port12, port12.getLongitude(), port12.getLatitude());
        instance.insert(port13, port13.getLongitude(), port13.getLatitude());
        instance.insert(port14, port14.getLongitude(), port14.getLatitude());


        List<KdNode<Port>> nodes = new ArrayList<>();
        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);
        instance2.buildTree(nodes);

        //Act

        Port actualNeighbor = instance.findNearestNeighbour(port13.getLongitude(),port13.getLatitude());
        Port actualNeighbor1 = instance.findNearestNeighbour(0.1f,-4.5f);
        Port actualNeighbor2 = instance.findNearestNeighbour(0.6f,200.6f);
        Port actualNeighbor3 = instance.findNearestNeighbour(25,-15);

        Port actualNeighbor5 = instance.findNearestNeighbour(9.5f,15.2f);
        Port actualNeighbor6 = instance.findNearestNeighbour(Float.POSITIVE_INFINITY,1);
        Port actualNeighbor7 = instance.findNearestNeighbour(Float.NEGATIVE_INFINITY,0);


        Port actualNeighbor4 = instance.findNearestNeighbour(12.5f,11.2f);

        instance2.insert(port5, port5.getLongitude(), port5.getLatitude());

        Port actualPort = instance2.findNearestNeighbour(port5.getLongitude(), port5.getLatitude());
        Port actualPort2 = instance2.findNearestNeighbour(port1.getLongitude(), port1.getLatitude());
        Port actualPort3 = instance2.findNearestNeighbour(port3.getLongitude(), port3.getLatitude());
        Port actualPort4 = instance2.findNearestNeighbour(port2.getLongitude(), port2.getLatitude());
        Port actualPort5 = instance2.findNearestNeighbour(port4.getLongitude(), port4.getLatitude());


        Port actualPort6 = instance.findNearestNeighbour(port6.getLongitude(), port6.getLatitude());
        Port actualPort7 = instance.findNearestNeighbour(port7.getLongitude(), port7.getLatitude());
        Port actualPort8 = instance.findNearestNeighbour(port8.getLongitude(), port8.getLatitude());
        Port actualPort9 = instance.findNearestNeighbour(port9.getLongitude(), port9.getLatitude());
        Port actualPort10 = instance.findNearestNeighbour(port10.getLongitude(), port10.getLatitude());
        Port actualPort11 = instance.findNearestNeighbour(port11.getLongitude(), port11.getLatitude());
        Port actualPort12 = instance.findNearestNeighbour(port12.getLongitude(), port12.getLatitude());
        Port actualPort13 = instance.findNearestNeighbour(port13.getLongitude(), port13.getLatitude());
        Port actualPort14 = instance.findNearestNeighbour(port14.getLongitude(), port14.getLatitude());



        Port expectedPort = port5;
        Port expectedPort2 = port1;
        Port expectedPort3 = port3;
        Port expectedPort4 = port3;
        Port expectedPort5 = port4;

        Port expectedPort6 = port6;
        Port expectedPort7 = port7;
        Port expectedPort8 = port8;
        Port expectedPort9 = port9;
        Port expectedPort10 = port10;
        Port expectedPort11 = port11;
        Port expectedPort12 = port12;
        Port expectedPort13 = port13;
        Port expectedPort14 = port14;

        //Assert
        assertEquals(port13,actualNeighbor);
        assertEquals(port11,actualNeighbor1);
        assertEquals(port5,actualNeighbor3);
        assertEquals(port4,actualNeighbor2);
        assertEquals(port5,actualNeighbor4);
        assertEquals(port2,actualNeighbor5);

        assertEquals(expectedPort, actualPort);
        assertEquals(expectedPort2, actualPort2);
        assertEquals(expectedPort3, actualPort3);
        assertEquals(expectedPort4, actualPort4);
        assertEquals(expectedPort5, actualPort5);

        assertEquals(expectedPort6, actualPort6);
        assertEquals(expectedPort7, actualPort7);
        assertEquals(expectedPort8, actualPort8);
        assertEquals(expectedPort9, actualPort9);

        assertNull(actualNeighbor7);

    }

    @Test
    public void testCompareToNum(){
        float a= 100.2f;
        float b= 20.4f;

        assertTrue(instance.compareToNum(a,b));
        assertFalse(instance.compareToNum(b,a));
        assertFalse(instance.compareToNum(a,a));
    }
}
