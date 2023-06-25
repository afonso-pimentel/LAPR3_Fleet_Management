package lapr.project.utils.datastructures;

import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.fileoperations.FileReaderImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

class MapAlgorithmsTest {

    final Graph<String, Integer> completeMap = new MapGraph<>(false);
    Graph<String, Integer> incompleteMap = new MapGraph<>(false);

    public MapAlgorithmsTest() {
    }

    @BeforeEach
    public void setUp() {

        completeMap.addVertex("Porto");
        completeMap.addVertex("Braga");
        completeMap.addVertex("Vila Real");
        completeMap.addVertex("Aveiro");
        completeMap.addVertex("Coimbra");
        completeMap.addVertex("Leiria");

        completeMap.addVertex("Viseu");
        completeMap.addVertex("Guarda");
        completeMap.addVertex("Castelo Branco");
        completeMap.addVertex("Lisboa");
        completeMap.addVertex("Faro");

        completeMap.addEdge("Porto", "Aveiro", 75);
        completeMap.addEdge("Porto", "Braga", 60);
        completeMap.addEdge("Porto", "Vila Real", 100);
        completeMap.addEdge("Viseu", "Guarda", 75);
        completeMap.addEdge("Guarda", "Castelo Branco", 100);
        completeMap.addEdge("Aveiro", "Coimbra", 60);
        completeMap.addEdge("Coimbra", "Lisboa", 200);
        completeMap.addEdge("Coimbra", "Leiria", 80);
        completeMap.addEdge("Aveiro", "Leiria", 120);
        completeMap.addEdge("Leiria", "Lisboa", 150);

        incompleteMap = completeMap.clone();

        completeMap.addEdge("Aveiro", "Viseu", 85);
        completeMap.addEdge("Leiria", "Castelo Branco", 170);
        completeMap.addEdge("Lisboa", "Faro", 280);
    }

    private void checkContentEquals(List<String> l1, List<String> l2, String msg) {
        Collections.sort(l1);
        Collections.sort(l2);
        assertEquals(l1, l2, msg);
    }

    /**
     * Test of BreadthFirstSearch method, of class Algorithms.
     */
    @Test
    public void testBreadthFirstSearch() {
        System.out.println("Test BreadthFirstSearch");

        assertEquals(Collections.<Integer>emptyList(), Algorithms.breadthFirstSearch(completeMap, "LX"), "Should be empty collection if vertex does not exist");

        LinkedList<String> path = (LinkedList)Algorithms.breadthFirstSearch(incompleteMap, "Faro");

        assertEquals(1, path.size(), "Should be just one");

        assertEquals("Faro", path.peekFirst());

        path = (LinkedList)Algorithms.breadthFirstSearch(incompleteMap, "Porto");
        assertEquals(7, path.size(), "Should give seven vertices");

        assertEquals("Porto", path.removeFirst(), "BreathFirst Porto");

        LinkedList<String> expected = new LinkedList<>(Arrays.asList("Aveiro", "Braga", "Vila Real"));
        checkContentEquals(expected, path.subList(0, 3), "BreathFirst Porto");

        expected = new LinkedList<>(Arrays.asList("Coimbra", "Leiria"));
        checkContentEquals(expected, path.subList(3, 5), "BreathFirst Porto");

        expected = new LinkedList<>(Arrays.asList("Lisboa"));
        checkContentEquals(expected, path.subList(5, 6), "BreathFirst Porto");

        path = (LinkedList)Algorithms.breadthFirstSearch(incompleteMap, "Viseu");
        expected = new LinkedList<>(Arrays.asList("Viseu", "Guarda", "Castelo Branco"));
        assertEquals(expected, path, "BreathFirst Viseu");
    }

    /**
     * Test of DepthFirstSearch method, of class Algorithms.
     */
    @Test
    public void testDepthFirstSearch() {
        System.out.println("Test of DepthFirstSearch");

        assertEquals(Collections.<Integer>emptyList(), Algorithms.depthFirstSearch(completeMap, "LX"), "Should be null if vertex does not exist");

        LinkedList<String> path = (LinkedList<String>)Algorithms.depthFirstSearch(incompleteMap, "Faro");
        assertEquals(1, path.size(), "Should be just one");

        assertEquals("Faro", path.peekFirst());

        path = (LinkedList<String>)Algorithms.depthFirstSearch(incompleteMap, "Porto");
        assertEquals(7, path.size(), "Should give seven vertices");

        assertEquals("Porto", path.removeFirst(), "DepthFirst Porto");
        assertTrue(new LinkedList<>(Arrays.asList("Aveiro", "Braga", "Vila Real")).contains(path.removeFirst()), "DepthFirst Porto");

        path = (LinkedList<String>)Algorithms.depthFirstSearch(incompleteMap, "Viseu");
        List<String> expected = new LinkedList<>(Arrays.asList("Viseu", "Guarda", "Castelo Branco"));
        assertEquals(expected, path, "DepthFirst Viseu");
    }

    /**
     * Test of shortestPath method, of class Algorithms.
     */
    @Test
    public void testShortestPath() {
        System.out.println("Test of shortest path");

        LinkedList<String> shortPath = new LinkedList<>();

        Integer lenPath = Algorithms.shortestPath(completeMap, "Porto", "LX", Integer::compare, Integer::sum, 0, shortPath);
        assertNull(lenPath, "Length path should be null if vertex does not exist");
        assertEquals(0, shortPath.size(), "Shortest Path does not exist");

        lenPath = Algorithms.shortestPath(incompleteMap, "Porto", "Faro", Integer::compare, Integer::sum, 0, shortPath);
        assertEquals(0, shortPath.size(), "Shortest Path does not exist");

        lenPath = Algorithms.shortestPath(completeMap, "Porto", "Porto", Integer::compare, Integer::sum, 0, shortPath);
        assertEquals(0, lenPath, "Length path should be 0 if vertices are the same");
        assertEquals(Arrays.asList("Porto"), shortPath, "Shortest Path only contains Porto");

        lenPath = Algorithms.shortestPath(incompleteMap, "Porto", "Lisboa", Integer::compare, Integer::sum, 0, shortPath);
        assertEquals(335, lenPath, "Length path should be 0 if vertices are the same");
        assertEquals(Arrays.asList("Porto", "Aveiro", "Coimbra", "Lisboa"), shortPath, "Shortest Path Porto - Lisboa");

        lenPath = Algorithms.shortestPath(incompleteMap, "Braga", "Leiria", Integer::compare, Integer::sum, 0, shortPath);
        assertEquals(255, lenPath, "Length path should be 0 if vertices are the same");
        assertEquals(Arrays.asList("Braga", "Porto", "Aveiro", "Leiria"), shortPath, "Shortest Path Braga - Leiria");

        lenPath = Algorithms.shortestPath(completeMap, "Porto", "Castelo Branco", Integer::compare, Integer::sum, 0, shortPath);
        assertEquals(335, lenPath, "Length path should be 0 if vertices are the same");
        assertEquals(Arrays.asList("Porto", "Aveiro", "Viseu", "Guarda", "Castelo Branco"), shortPath, "Shortest Path Porto - Castelo Branco");

        //Changing Edge: Aveiro-Viseu with Edge: Leiria-C.Branco
        //should change shortest path between Porto and Castelo Branco

        completeMap.removeEdge("Aveiro", "Viseu");
        completeMap.addEdge("Leiria", "Castelo Branco", 170);

        lenPath = Algorithms.shortestPath(completeMap, "Porto", "Castelo Branco", Integer::compare, Integer::sum, 0, shortPath);
        assertEquals(365, lenPath, "Length path should be 0 if vertices are the same");
        assertEquals(Arrays.asList("Porto", "Aveiro", "Leiria", "Castelo Branco"), shortPath, "Shortest Path Porto - Castelo Branco");
    }

    /**
     * Test of shortestPaths method, of class Algorithms.
     */
    @Test
    public void testShortestPaths() {
        System.out.println("Test of shortest path");

        ArrayList<LinkedList<String>> paths = new ArrayList<>();
        ArrayList<Integer> dists = new ArrayList<>();

        Algorithms.shortestPaths(completeMap, "Porto", Integer::compare, Integer::sum, 0, paths, dists, null);

        assertEquals(paths.size(), dists.size(), "There should be as many paths as sizes");
        assertEquals(completeMap.numVertices(), paths.size(), "There should be a path to every vertex");
        assertEquals(Arrays.asList("Porto"), paths.get(completeMap.key("Porto")), "Number of nodes should be 1 if source and vertex are the same");
        assertEquals(Arrays.asList("Porto", "Aveiro", "Coimbra", "Lisboa"), paths.get(completeMap.key("Lisboa")), "Path to Lisbon");
        assertEquals(Arrays.asList("Porto", "Aveiro", "Viseu", "Guarda", "Castelo Branco"), paths.get(completeMap.key("Castelo Branco")), "Path to Castelo Branco");
        assertEquals(335, dists.get(completeMap.key("Castelo Branco")), "Path between Porto and Castelo Branco should be 335 Km");

        //Changing Edge: Aveiro-Viseu with Edge: Leiria-C.Branco
        //should change shortest path between Porto and Castelo Branco
        completeMap.removeEdge("Aveiro", "Viseu");
        completeMap.addEdge("Leiria", "Castelo Branco", 170);
        Algorithms.shortestPaths(completeMap, "Porto", Integer::compare, Integer::sum, 0, paths, dists, null);
        assertEquals(365, dists.get(completeMap.key("Castelo Branco")), "Path between Porto and Castelo Branco should now be 365 Km");
        assertEquals(Arrays.asList("Porto", "Aveiro", "Leiria", "Castelo Branco"), paths.get(completeMap.key("Castelo Branco")), "Path to Castelo Branco");

        Algorithms.shortestPaths(incompleteMap, "Porto", Integer::compare, Integer::sum, 0, paths, dists, null);
        assertNull(dists.get(completeMap.key("Faro")), "Length path should be null if there is no path");
        assertEquals(335, dists.get(completeMap.key("Lisboa")), "Path between Porto and Lisboa should be 335 Km");
        assertEquals(Arrays.asList("Porto", "Aveiro", "Coimbra", "Lisboa"), paths.get(completeMap.key("Lisboa")), "Path to Lisboa");

        Algorithms.shortestPaths(incompleteMap, "Braga", Integer::compare, Integer::sum, 0, paths, dists, null);
        assertEquals(255, dists.get(completeMap.key("Leiria")), "Path between Braga and Leiria should be 255 Km");
        assertEquals(Arrays.asList("Braga", "Porto", "Aveiro", "Leiria"), paths.get(completeMap.key("Leiria")), "Path to Leiria");
    }
    
    /**
     * Test minimum distance graph using Floyd-Warshall.
     */
    @Test
    public void testminDistGraph() {
        /*Graph<Integer, Integer> map = new MapGraph<>(false);

        map.addVertex(1);
        map.addVertex(2);
        map.addVertex(3);
        map.addVertex(4);

        map.addEdge(1,2,4);
        map.addEdge(1,3,2);
        map.addEdge(2,3,3);
        map.addEdge(3,4,2);
        map.addEdge(4,2,1);

        Algorithms.minDistGraph(completeMap, Integer::compare, Integer::sum, Integer.MAX_VALUE);*/
    }

    @Test
    public void testColorMapGraph(){

        //Act & Arrange
        Map result = Algorithms.colorMapGraph(completeMap);

        Map expected = new HashMap();
        expected.put("Lisboa", 2);
        expected.put("Porto",0);
        expected.put("Castelo Branco",2);
        expected.put("Coimbra",1);
        expected.put("Faro",1);
        expected.put("Guarda",1);
        expected.put("Leiria",2);
        expected.put("Braga",1);
        expected.put("Viseu",1);
        expected.put("Vila Real",1);
        expected.put("Aveiro",1);

        //Assert
        assertEquals(expected,result);

        completeMap.addEdge("Aveiro", "Lisboa", 85);
        completeMap.addEdge("Aveiro", "Coimbra", 85);
        completeMap.addEdge("Braga", "Guarda", 85);
        completeMap.addEdge("Porto", "Lisboa", 170);
        completeMap.addEdge("Lisboa", "Viseu", 280);

        result = Algorithms.colorMapGraph(completeMap);

        Map expected1 = new HashMap();
        expected1.put("Lisboa", 5);
        expected1.put("Porto",0);
        expected1.put("Castelo Branco",2);
        expected1.put("Coimbra",1);
        expected1.put("Faro",1);
        expected1.put("Guarda",2);
        expected1.put("Leiria",2);
        expected1.put("Braga",1);
        expected1.put("Viseu",1);
        expected1.put("Vila Real",1);
        expected1.put("Aveiro",1);

        //Assert
        assertEquals(expected1,result);
    }

    @Test
    public void dynamicTestColorMapGraph() throws IOException {
        FileReader fileReaderImpl = new FileReaderImpl();
        final Graph<String, Integer> dynamicMapGraph = new MapGraph<>(false);
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputColorGraphAlgorithm.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_ColorGraph_Algorithm.csv";
        for (String line: fileReaderImpl.readFile(filePathInput)){
            if (line.contains(",")){
                String[] separator = line.split(",");
                dynamicMapGraph.addEdge(separator[0],separator[1],0);
            }else{
                dynamicMapGraph.addVertex(line);
            }
        }
        Map result = Algorithms.colorMapGraph(dynamicMapGraph);

        // Assert
        writeOccupancyRateOutputToFile(result, filePathOutput);
    }

    private void writeOccupancyRateOutputToFile(Map result, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();
        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("Key | Color Number\n");
            result.forEach((k,v) ->{
                fileOutputLine.append(k + " | "+ v +"\n");
            });
            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }
}