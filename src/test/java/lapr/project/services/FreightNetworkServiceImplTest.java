package lapr.project.services;

import lapr.project.mappers.*;
import lapr.project.mappers.dtos.FreightNodeClosenessDTO;
import lapr.project.model.Country;
import lapr.project.model.Port;
import lapr.project.model.enums.Continents;
import lapr.project.model.enums.PathType;
import lapr.project.utils.datastructures.*;
import lapr.project.utils.fileoperations.CsvFileParser;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.*;
import org.junit.jupiter.api.Test;

import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

class FreightNetworkServiceImplTest {
    private FreightNetworkImpl freightNetworkImpl;
    private final FreightNetworkServiceImpl freightNetworkServiceImpl;
    private Graph<FreightNetworkNode, Float> testFreightNetworkGraph;

    public FreightNetworkServiceImplTest() throws IOException {
        SeadistsMapper seadistsMapper = new SeadistsMapperImpl();
        PortMapper portMapper = new PortMapperImpl();
        CapitalMapper capitalMapper = new CapitalMapperImpl();
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection databaseConnection = new DatabaseConnectionImpl(applicationPropertiesHelper);
        FileReader fileReader = new FileReaderImpl();
        CsvFileParser csvFileParser = new CsvFileParserImpl();

        FreightNetworkDataHandler freightNetworkDataAccess = new FreightNetworkDataHandlerImpl(capitalMapper, portMapper, seadistsMapper, fileReader, csvFileParser, databaseConnection);
        FreightNetworkLogic freightNetworkLogic = new FreightNetworkLogicImpl();

        String capitalNodesFilePath = System.getProperty("user.dir") + "/src/test/resources/countries.csv";
        String portNodesFilePath = System.getProperty("user.dir") + "/src/test/resources/bports.csv";
        String bordersFilePath = System.getProperty("user.dir") + "/src/test/resources/borders.csv";
        String seadistsFilePath = System.getProperty("user.dir") + "/src/test/resources/seadists.csv";

        freightNetworkImpl = new FreightNetworkImpl(freightNetworkDataAccess, freightNetworkLogic);

        //Test from files
        freightNetworkImpl.initializeNetworkFromFiles(5, capitalNodesFilePath, portNodesFilePath, bordersFilePath, seadistsFilePath);

        //Test from database
        // freightNetworkImpl.initializeNetworkFromDatabase(5);

        testFreightNetworkGraph = freightNetworkImpl.getFreightNetwork();

        this.freightNetworkServiceImpl = new FreightNetworkServiceImpl(testFreightNetworkGraph);
    }

    /**
     * Test to check if an exception is thrown when the user inserts an inferior N value.
     */
    @Test
    public void invalidInputShouldThrowException() {
        //Arrange
        int n = -1;

        //Act & Assert
        assertThrows(IllegalArgumentException.class, () -> freightNetworkServiceImpl.getTopNClosenessPlaces(n));

    }

    /**
     * Static test for when N = 5. It checks if the shortest path distance average for every 5 nodes inside
     * America and Europe (We only have data regarding locations on these two) are the correct ones.
     * The expected values were based on calculations made previously.
     *
     * @throws IOException
     */
    @Test
    public void validInputShouldReturnValidInputNEqualsFiveStatic() throws IOException {
        //Arrange
        int n = 5;
        String outputFilePath = System.getProperty("user.dir") + "/src/test/resources/output/outputUS303static.csv";
        String[] expectedNamesEurope = {"Vienna","Bratislava","Berlin","Rostock","Prague"};
        String[] expectedNamesAmerica = {"Esmeraldas","Buenaventura","Balboa","Panama City","Cristobal"};
        float[] expectedDistancesEurope = { 1229.7917f,1240.9507f,1241.8798f,1241.9047f,1269.2816f};
        float[] expectedDistancesAmerica =  {2231.875f,2270.0024f, 2284.4492f,2287.9556f,2303.5342f};

        //Act
        Map<Continents, ArrayList<FreightNodeClosenessDTO>> result = freightNetworkServiceImpl.getTopNClosenessPlaces(n);
        writeShortestPathsOutputFile(getResultsStringArrayList(result),outputFilePath);

        //Assert
        for (Map.Entry<Continents, ArrayList<FreightNodeClosenessDTO>> entry : result.entrySet()) {
            int i = 0;
            for (FreightNodeClosenessDTO resultClosenessDTO : entry.getValue()) {
                if(entry.getKey().equals(Continents.EUROPE)) {
                    FreightNodeClosenessDTO expectedClosenessDTO = new FreightNodeClosenessDTO(expectedNamesEurope[i],expectedDistancesEurope[i]);
                    assertEquals(resultClosenessDTO, expectedClosenessDTO);
                }
                else  {
                    FreightNodeClosenessDTO expectedClosenessDTO = new FreightNodeClosenessDTO(expectedNamesAmerica[i],expectedDistancesAmerica[i]);
                    assertEquals(resultClosenessDTO, expectedClosenessDTO);
                }
                i++;
            }
        }
    }

    /**
     * This test does not have asserts but it allows a dynamic input and will output a file and console results.
     *
     * @throws IOException
     */
    @Test
    public void validInputShouldReturnValidInputDynamic() throws IOException {
        //Arrange
        int n = 10;
        String outputFilePath = System.getProperty("user.dir") + "/src/test/resources/output/outputUS303.csv";
        //Act
        Map<Continents, ArrayList<FreightNodeClosenessDTO>> result = freightNetworkServiceImpl.getTopNClosenessPlaces(n);
        writeShortestPathsOutputFile(getResultsStringArrayList(result),outputFilePath);
    }

    /**
     * This one outputs the result of the shortest path average for every node in Europe.
     *
     * @throws IOException
     */
    @Test
    public void buildEuropeanGraphAndReturnShortestPaths() throws IOException {
        FileReader fileReader = new FileReaderImpl();
        CsvFileParser csvFileParser = new CsvFileParserImpl();
        String nodesFilePath = System.getProperty("user.dir") + "/src/test/resources/input/inputNodesEurope.csv";
        String edgesFilePath = System.getProperty("user.dir") + "/src/test/resources/input/inputEdgesEurope.csv";
        String outputFilePath = System.getProperty("user.dir") + "/src/test/resources/output/outputShortestPathsEurope.csv";

        //For the nodes
        List<String> fileContentNodes = fileReader.readFile(nodesFilePath);
        List<List<String>> csvParsedFileContentNodes = csvFileParser.parseToCsv(fileContentNodes);
        Graph<FreightNetworkNode,Float> europeanGraph = new MapGraph<>(false);
        for(List<String> line: csvParsedFileContentNodes){
            if (line.get(0).equals("Port Node")){
                PortNode portNode = new PortNode(0f, 0f, line.get(1), new Country("test", "Europe"));
                europeanGraph.addVertex(portNode);
            }else{
                    CapitalNode capitalNode = new CapitalNode(0f, 0f, line.get(1), new Country("test", "Europe"));
                    europeanGraph.addVertex(capitalNode);
                }
        }

        //For the edges
        List<String> fileContentEdges = fileReader.readFile(edgesFilePath);
        List<List<String>> csvParsedFileContentEdges = csvFileParser.parseToCsv(fileContentEdges);

        for(List<String> line: csvParsedFileContentEdges){
            if(line.get(0).equals("Capital Node") && line.get(2).equals("Capital Node")){
                CapitalNode vOrigin = new CapitalNode(0f,0f,line.get(1),new Country("test","Europe"));
                CapitalNode vDest = new CapitalNode(0f,0f,line.get(3),new Country("test","Europe"));
                float weight = Float.parseFloat(line.get(4));
                europeanGraph.addEdge(vOrigin,vDest,weight);
            }else if(line.get(0).equals("Port Node") && line.get(2).equals("Port Node")){
                PortNode vOrigin = new PortNode(0f,0f,line.get(1),new Country("test","Europe"));
                PortNode vDest = new PortNode(0f,0f,line.get(3),new Country("test","Europe"));
                float weight = Float.parseFloat(line.get(4));
                europeanGraph.addEdge(vOrigin,vDest,weight);
            }else if(line.get(0).equals("Port Node") && line.get(2).equals("Capital Node")){
                PortNode vOrigin = new PortNode(0f,0f,line.get(1),new Country("test","Europe"));
                CapitalNode vDest = new CapitalNode(0f,0f,line.get(3),new Country("test","Europe"));
                float weight = Float.parseFloat(line.get(4));
                europeanGraph.addEdge(vOrigin,vDest,weight);
            }else{
                CapitalNode vOrigin = new CapitalNode(0f,0f,line.get(1),new Country("test","Europe"));
                PortNode vDest = new PortNode(0f,0f,line.get(3),new Country("test","Europe"));
                float weight = Float.parseFloat(line.get(4));
                europeanGraph.addEdge(vOrigin,vDest,weight);
            }
        }
        ArrayList<String> resultStringList = new ArrayList<>();
        for (FreightNetworkNode vertex : europeanGraph.vertices()) {
            ArrayList<LinkedList<FreightNetworkNode>> paths = new ArrayList<>();
            ArrayList<Float> dists = new ArrayList<>();
            String result = "";
            Algorithms.shortestPaths(europeanGraph,vertex,Float :: compare,Float :: sum, 0f,paths,dists, null);
            float pathDistanceAvg = Utilities.sumFloatArrayList(dists)/dists.size(); //Average of pathDistances
            if(vertex instanceof PortNode) result = "Port " + ((PortNode)vertex).getPortName() + " has average path distance of: "+ pathDistanceAvg;
            if(vertex instanceof CapitalNode) result = "Capital " + ((CapitalNode)vertex).getCapitalName() + " has average path distance of: "+ pathDistanceAvg;
            resultStringList.add(result);
        }
        writeShortestPathsOutputFile(resultStringList,outputFilePath);
    }

    /**
     * This one outputs the result of the shortest path average for every node in America.
     *
     * @throws IOException
     */
    @Test
    public void buildAmericanGraphAndReturnShortestPaths() throws IOException {
        FileReader fileReader = new FileReaderImpl();
        CsvFileParser csvFileParser = new CsvFileParserImpl();
        String nodesFilePath = System.getProperty("user.dir") + "/src/test/resources/input/inputNodesAmerica.csv";
        String edgesFilePath = System.getProperty("user.dir") + "/src/test/resources/input/inputEdgesAmerica.csv";
        String outputFilePath = System.getProperty("user.dir") + "/src/test/resources/output/outputShortestPathsAmerica.csv";

        //For the nodes
        List<String> fileContentNodes = fileReader.readFile(nodesFilePath);
        List<List<String>> csvParsedFileContentNodes = csvFileParser.parseToCsv(fileContentNodes);
        Graph<FreightNetworkNode,Float> americanGraph = new MapGraph<>(false);


        for(List<String> line: csvParsedFileContentNodes){
            if (line.get(0).equals("Port Node")){
                PortNode portNode = new PortNode(0f, 0f, line.get(1), new Country("test", "America"));
                americanGraph.addVertex(portNode);
            }else{
                CapitalNode capitalNode = new CapitalNode(0f, 0f, line.get(1), new Country("test", "America"));
                americanGraph.addVertex(capitalNode);
            }
        }

        //For the edges
        List<String> fileContentEdges = fileReader.readFile(edgesFilePath);
        List<List<String>> csvParsedFileContentEdges = csvFileParser.parseToCsv(fileContentEdges);

        for(List<String> line: csvParsedFileContentEdges){
            if(line.get(0).equals("Capital Node") && line.get(2).equals("Capital Node")){
                CapitalNode vOrigin = new CapitalNode(0f,0f,line.get(1),new Country("test","America"));
                CapitalNode vDest = new CapitalNode(0f,0f,line.get(3),new Country("test","America"));
                float weight = Float.parseFloat(line.get(4));
                americanGraph.addEdge(vOrigin,vDest,weight);
            }else if(line.get(0).equals("Port Node") && line.get(2).equals("Port Node")){
                PortNode vOrigin = new PortNode(0f,0f,line.get(1),new Country("test","America"));
                PortNode vDest = new PortNode(0f,0f,line.get(3),new Country("test","America"));
                float weight = Float.parseFloat(line.get(4));
                americanGraph.addEdge(vOrigin,vDest,weight);
            }else if(line.get(0).equals("Port Node") && line.get(2).equals("Capital Node")){
                PortNode vOrigin = new PortNode(0f,0f,line.get(1),new Country("test","America"));
                CapitalNode vDest = new CapitalNode(0f,0f,line.get(3),new Country("test","America"));
                float weight = Float.parseFloat(line.get(4));
                americanGraph.addEdge(vOrigin,vDest,weight);
            }else if(line.get(0).equals("Capital Node") && line.get(2).equals("Port Node")){
                CapitalNode vOrigin = new CapitalNode(0f,0f,line.get(1),new Country("test","America"));
                PortNode vDest = new PortNode(0f,0f,line.get(3),new Country("test","America"));
                float weight = Float.parseFloat(line.get(4));
                americanGraph.addEdge(vOrigin,vDest,weight);
            }
        }
        ArrayList<String> resultStringList = new ArrayList<>();
        for (FreightNetworkNode vertex : americanGraph.vertices()) {
            ArrayList<LinkedList<FreightNetworkNode>> paths = new ArrayList<>();
            ArrayList<Float> dists = new ArrayList<>();
            String result = "";
            Algorithms.shortestPaths(americanGraph,vertex,Float :: compare,Float :: sum, 0f,paths,dists, null);
            float pathDistanceAvg = Utilities.sumFloatArrayList(dists)/dists.size(); //Average of pathDistances
            if(vertex instanceof PortNode) result = "Port " + ((PortNode)vertex).getPortName() + " has average path distance of: "+ pathDistanceAvg;
            else  result = "Capital " + ((CapitalNode)vertex).getCapitalName() + " has average path distance of: "+ pathDistanceAvg;
            resultStringList.add(result);
        }
        writeShortestPathsOutputFile(resultStringList,outputFilePath);
    }

    /**
     * This is a private method to write the results in a file and output them also in the console.
     *
     * @param result
     * @param outputFilePath
     * @throws IOException
     */
    private void writeShortestPathsOutputFile(ArrayList<String> result, String outputFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();
        try (FileWriter myWriter = new FileWriter(outputFilePath)){
            for (String string:result) {
                fileOutputLine.append(string+"\n");
            }
            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }

    /**
     * This builds an arraylist of strings that will later be used to output the result.
     *
     * @param result
     * @return
     */
    private ArrayList<String> getResultsStringArrayList(Map<Continents, ArrayList<FreightNodeClosenessDTO>> result){
        ArrayList<String> resultArrayList = new ArrayList<>();
        for (Map.Entry<Continents, ArrayList<FreightNodeClosenessDTO>> entry : result.entrySet()) {
            String resultString = entry.getKey().toString() + ": \n";
            for (FreightNodeClosenessDTO resultClosenessDTO: entry.getValue()) {
                resultString = resultString + resultClosenessDTO.toString()+"\n";
            }
            resultArrayList.add(resultString);
        }
        return resultArrayList;
    }

    /**
     * Test if the function throws execption when needed arguments are null
     */
    @Test
    public void shortestPathSelectedShouldThrowException(){
        //Variable Preparation
        LinkedList<FreightNetworkNode>  empty = new LinkedList<>();

        //Should throw exception as expected
        assertThrowsExactly(IllegalArgumentException.class, () -> freightNetworkServiceImpl.shortestPathSelected(null,turnStringIntoFreightNetworkNode("Setubal"),empty, PathType.BOTH));
        assertThrowsExactly(IllegalArgumentException.class, () -> freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Rome"),null,empty, PathType.BOTH));
        assertThrowsExactly(IllegalArgumentException.class, () -> freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Rome"),turnStringIntoFreightNetworkNode("Setubal"),empty, null));
    }

    /**
     * Tests if the part of travelling only through Land is Correct - ExtremeTest
     */
    @Test
    public void shortesPathSelectedLandExtremeTest(){
        //Variable Preparation
        LinkedList<FreightNetworkNode>  empty = new LinkedList<>();

        //LandExtreme
        ArrayList<String> expectedLandExtremeString = new ArrayList<>();
        LinkedList<FreightNetworkNode> expectedLandExtremeLL = new LinkedList<>();

        expectedLandExtremeString.add("Ottawa");
        expectedLandExtremeString.add("Washington");
        expectedLandExtremeString.add("Mexico City");
        expectedLandExtremeString.add("Guatemala City");
        expectedLandExtremeString.add("San Salvador");
        expectedLandExtremeString.add("Tegucigalpa");
        expectedLandExtremeString.add("Managua");
        expectedLandExtremeString.add("San Jose");
        expectedLandExtremeString.add("Panama City");
        expectedLandExtremeString.add("Bogota");
        expectedLandExtremeString.add("Brasilia");

        expectedLandExtremeLL= turnStringIntoFreightNetworkNode(expectedLandExtremeString);

        LinkedList<FreightNetworkNode> resultLandExtreme = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Ottawa"), turnStringIntoFreightNetworkNode("Brasilia"), empty, PathType.LAND);
        for (FreightNetworkNode node: resultLandExtreme) {
            assertTrue(expectedLandExtremeLL.contains(node));
        }
    }

    /**
     * Tests if the part of travelling only through Land is Correct - normalTest
     */
    @Test
    public void shortestPathSelectedLandNormalTest(){
        //Variable Preparation
       LinkedList<FreightNetworkNode>  empty = new LinkedList<>();

        //LandNormal
        ArrayList<String> expectedLandNormalString = new ArrayList<>();
        LinkedList<FreightNetworkNode> expectedLandNormalLL = new LinkedList<>();

        expectedLandNormalString.add("Athens");
        expectedLandNormalString.add("Sofia");
        expectedLandNormalString.add("Bucharest");

        expectedLandNormalLL = turnStringIntoFreightNetworkNode(expectedLandNormalString);

        LinkedList<FreightNetworkNode> resultLandNormal = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Athens"), turnStringIntoFreightNetworkNode("Bucharest"), empty, PathType.LAND);
        for (FreightNetworkNode node: resultLandNormal) {
            assertTrue(expectedLandNormalLL.contains(node));
        }
    }

    /**
     * Tests if the part of travelling only through Land Starting or/and ending on Port is correct
     */
    @Test
    public void shortestPathSelectedLandStartingEndingPortTest(){

        //Variable Preparation
        LinkedList<FreightNetworkNode>  empty = new LinkedList<>();

        //SeaStartExtreme
        ArrayList<String> expectedSeaStartLandExtreme = new ArrayList<>();
        LinkedList<FreightNetworkNode> expectedSeaStartLandExtremeLL;

        expectedSeaStartLandExtreme.add("New Jersey");
        expectedSeaStartLandExtreme.add("Washington");
        expectedSeaStartLandExtreme.add("Mexico City");
        expectedSeaStartLandExtreme.add("Guatemala City");
        expectedSeaStartLandExtreme.add("San Salvador");
        expectedSeaStartLandExtreme.add("Tegucigalpa");
        expectedSeaStartLandExtreme.add("Managua");
        expectedSeaStartLandExtreme.add("San Jose");
        expectedSeaStartLandExtreme.add("Panama City");
        expectedSeaStartLandExtreme.add("Bogota");
        expectedSeaStartLandExtreme.add("Brasilia");

        expectedSeaStartLandExtremeLL = turnStringIntoFreightNetworkNode(expectedSeaStartLandExtreme);

        //SeaEndExtreme
        ArrayList<String> expectedSeaEndLandExtreme = new ArrayList<>();
        LinkedList<FreightNetworkNode> expectedSeaEndLandExtremeLL;

        expectedSeaEndLandExtreme.add("New Jersey");
        expectedSeaEndLandExtreme.add("Washington");
        expectedSeaEndLandExtreme.add("Mexico City");
        expectedSeaEndLandExtreme.add("Guatemala City");
        expectedSeaEndLandExtreme.add("San Salvador");
        expectedSeaEndLandExtreme.add("Tegucigalpa");
        expectedSeaEndLandExtreme.add("Managua");
        expectedSeaEndLandExtreme.add("San Jose");
        expectedSeaEndLandExtreme.add("Panama City");
        expectedSeaEndLandExtreme.add("Bogota");
        expectedSeaEndLandExtreme.add("Buenaventura");

        expectedSeaEndLandExtremeLL = turnStringIntoFreightNetworkNode(expectedSeaEndLandExtreme);

        //SeaBothExtreme
        ArrayList<String> expectedSeaBothLandExtreme = new ArrayList<>();
        LinkedList<FreightNetworkNode> expectedSeaBothLandExtremeLL;

        expectedSeaBothLandExtreme.add("Santos");
        expectedSeaBothLandExtreme.add("Brasilia");
        expectedSeaBothLandExtreme.add("Bogota");
        expectedSeaBothLandExtreme.add("Panama City");
        expectedSeaBothLandExtreme.add("San Jose");
        expectedSeaBothLandExtreme.add("Managua");
        expectedSeaBothLandExtreme.add("Tegucigalpa");
        expectedSeaBothLandExtreme.add("San Salvador");
        expectedSeaBothLandExtreme.add("Guatemala City");
        expectedSeaBothLandExtreme.add("Mexico City");
        expectedSeaBothLandExtreme.add("Washington");
        expectedSeaBothLandExtreme.add("New Jersey");



        expectedSeaBothLandExtremeLL = turnStringIntoFreightNetworkNode(expectedSeaBothLandExtreme);


        //Test Land only with port beginning extreme
        LinkedList<FreightNetworkNode> resultSeaStartLandExtreme = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("New Jersey"), turnStringIntoFreightNetworkNode("Brasilia"), empty, PathType.LAND);
        for (FreightNetworkNode node: resultSeaStartLandExtreme) {
            assertTrue(expectedSeaStartLandExtremeLL.contains(node));
        }
        //Test Land only with port end extreme
        LinkedList<FreightNetworkNode> resultSeaEndLandExtreme = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("New Jersey"), turnStringIntoFreightNetworkNode("Buenaventura"), empty, PathType.LAND);
        for (FreightNetworkNode node: resultSeaEndLandExtreme) {
            assertTrue(expectedSeaEndLandExtremeLL.contains(node));
        }
        //Test Land only with port both extreme
        LinkedList<FreightNetworkNode> resultSeaBothLandExtreme = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Santos"), turnStringIntoFreightNetworkNode("New Jersey"), empty, PathType.LAND);
        for (FreightNetworkNode node: resultSeaBothLandExtreme) {
            assertTrue(expectedSeaBothLandExtremeLL.contains(node));
        }
    }

    /**
     * Tests if the part of travelling only through Sea is Correct - extremeTest
     */
    @Test
    public void shortestPathSelectedSeaExtremeTest(){
        //Variable Preparation
        LinkedList<FreightNetworkNode>  empty = new LinkedList<>();

        //SeaExtreme
        ArrayList<String> expectedSeaExtremeString = new ArrayList<>();
        LinkedList<FreightNetworkNode> expectedSeaExtremeLL;

        //Data
        expectedSeaExtremeString.add("Larnaca");
        expectedSeaExtremeString.add("Piraeus");
        expectedSeaExtremeString.add("Venice");
        expectedSeaExtremeString.add("Genoa");
        expectedSeaExtremeString.add("Valencia");
        expectedSeaExtremeString.add("Setubal");
        expectedSeaExtremeString.add("Horta");
        expectedSeaExtremeString.add("Halifax");
        expectedSeaExtremeString.add("New Jersey");
        expectedSeaExtremeString.add("Cartagena");
        expectedSeaExtremeString.add("Cristobal");
        expectedSeaExtremeString.add("Esmeraldas");
        expectedSeaExtremeString.add("Callao");
        expectedSeaExtremeString.add("San Vicente");
        expectedSeaExtremeString.add("Bahia Blanca");
        expectedSeaExtremeString.add("Santos");

        expectedSeaExtremeLL = turnStringIntoFreightNetworkNode(expectedSeaExtremeString);

        //Test Sea only extreme
        LinkedList<FreightNetworkNode> resultSeaExtreme = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Larnaca"), turnStringIntoFreightNetworkNode("Santos"), empty, PathType.SEA);
        for (FreightNetworkNode node: resultSeaExtreme) {
            assertTrue(expectedSeaExtremeLL.contains(node));
        }

    }

    /**
     * Tests if the part of travelling only through Sea is Correct - normalTest
     */
    @Test
    public void shortestPathSelectedSeaNormalTest(){
        //Variable Preparation
        LinkedList<FreightNetworkNode> empty = new LinkedList<>();

        //SeaNormal
        ArrayList<String> expectedSeaNormalString = new ArrayList<>();
        LinkedList<FreightNetworkNode> expectedSeaNormalLL;

        //Data
        expectedSeaNormalString.add("Larnaca");
        expectedSeaNormalString.add("Piraeus");
        expectedSeaNormalString.add("Venice");
        expectedSeaNormalString.add("Genoa");
        expectedSeaNormalString.add("Valencia");
        expectedSeaNormalString.add("Setubal");
        expectedSeaNormalString.add("Ponta Delgada");



        expectedSeaNormalLL=turnStringIntoFreightNetworkNode(expectedSeaNormalString);

        LinkedList<FreightNetworkNode> resultSeaNormal = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Larnaca"), turnStringIntoFreightNetworkNode("Ponta Delgada"), empty, PathType.SEA);
        for (FreightNetworkNode node: resultSeaNormal) {
            assertTrue(expectedSeaNormalLL.contains(node));
        }
    }

    /**
     * Tests if the part of travelling through N places is Correct
     */
    @Test
    public void shortestPathSelectedPassThroughNPlacesTest(){
        //VariablePreparation
        ArrayList<String> passThroughSimple = new ArrayList<>();
        ArrayList<String> passThroughExtreme = new ArrayList<>();

        //passThroughSimple
        passThroughSimple.add("Lisbon");
        passThroughSimple.add("Athens");

        //passThroughExtreme
        passThroughExtreme.add("Larnaca");
        passThroughExtreme.add("Santos");
        passThroughExtreme.add("Ottawa");
        passThroughExtreme.add("New Jersey");
        passThroughExtreme.add("Ankara");
        passThroughExtreme.add("Lisbon");
        passThroughExtreme.add("Bahia Blanca");
        passThroughExtreme.add("San Jose");

        //PassThroughSimple
        ArrayList<String> expectedPassThroughSimple = new ArrayList<>();
        LinkedList<FreightNetworkNode> expectedPassThroughSimpleLL;


        expectedPassThroughSimple.add("Bern");
        expectedPassThroughSimple.add("Paris");
        expectedPassThroughSimple.add("Dunkirk");
        expectedPassThroughSimple.add("Brest");
        expectedPassThroughSimple.add("Setubal");
        expectedPassThroughSimple.add("Lisbon");
        expectedPassThroughSimple.add("Setubal");
        expectedPassThroughSimple.add("Valencia");
        expectedPassThroughSimple.add("Genoa");
        expectedPassThroughSimple.add("Venice");
        expectedPassThroughSimple.add("Piraeus");
        expectedPassThroughSimple.add("Athens");
        expectedPassThroughSimple.add("Piraeus");
        expectedPassThroughSimple.add("Venice");
        expectedPassThroughSimple.add("Rome");

        expectedPassThroughSimpleLL=turnStringIntoFreightNetworkNode(expectedPassThroughSimple);


        //Test PassThrough 2 places small route
        LinkedList<FreightNetworkNode> resultPassThroughSimple = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Bern"), turnStringIntoFreightNetworkNode("Rome"), turnStringIntoFreightNetworkNode(passThroughSimple), PathType.BOTH);
        for (FreightNetworkNode node: resultPassThroughSimple) {
            assertTrue(expectedPassThroughSimpleLL.contains(node));
        }

        //Test PassThrough 8 places big route
        LinkedList<FreightNetworkNode> resultPassThroughExtreme = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode("Washington"), turnStringIntoFreightNetworkNode("Guatemala City"), turnStringIntoFreightNetworkNode(passThroughExtreme), PathType.BOTH);
        for (FreightNetworkNode node: resultPassThroughExtreme) {
            System.out.println(node+"\n");
        }
    }

    /**
     * This test doesn't have asserts and its sole purpose is to be able to dynamically, with a inputFile
     * located in test/resources/input/input_shortestPathSelected.csv, execute the function
     * and verify it's result in the output file located in test/resources/output/output_shortestPathSelected.csv
     *
     * The file Input data should be presented with this format:
     * 1st line[origin],[destination],[true/false](if you want the path to go through a specific place),
     * [SEA/LAND/BOTH] (type of terrain you choose, if in the previous field chosen true then you must write BOTH).
     *
     * If you selected true then in the rest of the lines you should define which places you choose to go through.
     * One place per Line!
     */
    @Test
    public void shortestPathSelectedTestIntegration() throws IOException {
        FileReader fileReaderImpl = new FileReaderImpl();
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputShortestPathSelected.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_shortestPathSelected.csv";
        String origin= "";
        String destination= "";
        boolean direct = false;
        ArrayList<String> passHere = new ArrayList<>();
        LinkedList<FreightNetworkNode> result;
        PathType pt = null;

        for (String line: fileReaderImpl.readFile(filePathInput)){
            if (line.contains(",")){
                String[] separator = line.split(",");
                origin = separator[0];
                destination = separator[1];
                direct =Boolean.parseBoolean(separator[2]);
                pt = PathType.valueOf(separator[3]);
            }else if(direct){
                passHere.add(line);
            }
        }
        result = freightNetworkServiceImpl.shortestPathSelected(turnStringIntoFreightNetworkNode(origin),turnStringIntoFreightNetworkNode(destination),turnStringIntoFreightNetworkNode(passHere),pt);

        // Assert
        writeShortestPathSelectedOutputToFile(result, filePathOutput);
    }

    /**
     * Turns Arraylist of Strings into FreightNetworkNodes
     */
    private LinkedList<FreightNetworkNode> turnStringIntoFreightNetworkNode(ArrayList<String> str){
        LinkedList<FreightNetworkNode> list = new LinkedList<>();
        for (FreightNetworkNode node: this.testFreightNetworkGraph.vertices()) {
            if (node instanceof CapitalNode) {
                CapitalNode cN = (CapitalNode) node;

                if (str.contains(cN.getCapitalName()))
                    list.add(node);
            } else if (node instanceof PortNode) {
                PortNode pN = (PortNode) node;

                if (str.contains(pN.getPortName()))
                    list.add(node);
            }
        }

        return list;
    }

    /**
     * Turns Strings into FreightNetworkNodes
     */
    private FreightNetworkNode turnStringIntoFreightNetworkNode(String str){
        FreightNetworkNode list = null;
        for (FreightNetworkNode node: this.testFreightNetworkGraph.vertices()) {
            if (node instanceof CapitalNode) {
                CapitalNode cN = (CapitalNode) node;

                if (str.contains(cN.getCapitalName()))
                    list =node;
            } else if (node instanceof PortNode) {
                PortNode pN = (PortNode) node;

                if (str.contains(pN.getPortName()))
                    list =node;
            }
        }

        return list;
    }

    /**
     * Turns Strings into FreightNetworkNodes
     */
    private FreightNetworkNode turnStringIntoFreightNetworkNode(String str, String type){
        FreightNetworkNode list = null;
        for (FreightNetworkNode node: testFreightNetworkGraph.vertices()) {
            if (node instanceof CapitalNode){
                CapitalNode cN = (CapitalNode) node;
                if (cN.getCapitalName().equals(str) && type.toLowerCase(Locale.ROOT).equals("capital"))
                    return node;
            }else if (node instanceof PortNode){
                PortNode pN = (PortNode) node;
                if (pN.getPortName().equals(str) && type.toLowerCase(Locale.ROOT).equals("port"))
                    return node;
            }
        }
        return list;
    }

    /**
     * it will print the dynamic test's output to a csv file
     * @param result test result
     * @param newFilePath output file location
     */
    private void writeShortestPathSelectedOutputToFile(LinkedList<FreightNetworkNode> result, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();
        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("Location Type -> Place | Country | Latitude | Longitude\n");
            for (FreightNetworkNode node: result) {
                fileOutputLine.append(node.toString()+" \n");
            }
            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }

    /**
     *  Returns null if it was not possible to make a circuit from a certain starting point
     */
    @Test
    public void circuitNotPossibletoMake(){
        //Since the graph is already load this test will be overly simple.
        //Assert
        assertNull(freightNetworkServiceImpl.graphCircuit(turnStringIntoFreightNetworkNode("Nicosia")));
        assertNull(freightNetworkServiceImpl.graphCircuit(turnStringIntoFreightNetworkNode("Valletta")));
    }

    /**
     * Tests if its validating a User Input that doesn't exist in the graph
     */
    @Test
    public void circuitInvalidUserInput(){
        //Prepare
        String fictionalPlace = "Hogwarts";

        //Act
        assertThrowsExactly(IllegalArgumentException.class, () -> freightNetworkServiceImpl.graphCircuit(turnStringIntoFreightNetworkNode(fictionalPlace)));
    }

    /**
     * Tests if a circuit is being built as expected, the circuit is being verified manually with the list of edges existent
     */
    @Test
    public void circuitSmallSizeCircuit(){
        //expected
        LinkedList<FreightNetworkNode> expectedCircuit = new LinkedList<>();
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Buenos Aires","Capital"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Buenos Aires","Port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Montevideo","Port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Montevideo","capital"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Brasilia","capital"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Buenos Aires","capital"));

        //result
        LinkedList<FreightNetworkNode> result = freightNetworkServiceImpl.graphCircuit(turnStringIntoFreightNetworkNode("Buenos Aires","capital"));
        //assert
        assertEquals(expectedCircuit,result);
    }

    /**
     * Tests if a circuit is being built as expected, the circuit is being verified manually with the list of edges existent
     */
    @Test
    public void circuitNormalSizeCircuit(){
        //expected
        LinkedList<FreightNetworkNode> expectedCircuit = new LinkedList<>();
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Dublin","Capital"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Dublin","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Liverpool","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Brest","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Dunkirk","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Zeebrugge","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Vlissingen","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Antwerp","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Brussels","capital"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Amsterdam","capital"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Berlin","capital"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Rostock","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Copenhagen","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Aarhus","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Lysekil","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Bergen","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Hamburg","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"London","port"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"London","capital"));
        expectedCircuit.add(freightNetworkServiceImpl.transformStringtoFreightNetworkNode(testFreightNetworkGraph,"Dublin","capital"));

        //result
        LinkedList<FreightNetworkNode> result = freightNetworkServiceImpl.graphCircuit(turnStringIntoFreightNetworkNode("Dublin","capital"));
        //assert
        assertEquals(expectedCircuit,result);
    }

    /**
     * Prints the List of a Big Circuit, since it would be too time consuming to verify one-by-one manually a circuit of this size we simply print it out
     */
    @Test
    public void circuitExtremeSizeCircuit(){
        //expected
        LinkedList<FreightNetworkNode> expectedCircuit = new LinkedList<>();
        expectedCircuit.add(turnStringIntoFreightNetworkNode("Lisbon"));

        //result
        LinkedList<FreightNetworkNode> result = freightNetworkServiceImpl.graphCircuit(turnStringIntoFreightNetworkNode("Lisbon"));
        //assert
        for (FreightNetworkNode node: result) {
            System.out.println(node+"\n");
        }
        //Check if the starting point is correct
        assertEquals(expectedCircuit.getFirst(),result.getFirst());
        //Checks if the last point is the origin making it a circuit
        assertEquals(expectedCircuit.getFirst(),result.getLast());
        //Checks if the size of the circuit checks out with the one tested manually
        assertEquals(60,result.size());
        //Verifying it all nodes connect with each other, this way proving that a circuit does exist.
        for (int i = 0; i < result.size()-1; i++) {
            assertNotNull(testFreightNetworkGraph.edge(result.get(i),result.get(i+1)));
        }
    }

    /**
     *  This test doesn't have asserts and the it's sole purpose is to be able to execute the function dynamically using .csv files as input and output
     * @throws IOException
     */
    @Test
    public void circuitTestIntegration() throws IOException {
        FileReader fileReaderImpl = new FileReaderImpl();
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputCircuitGraph.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_circuitGraph.csv";
        String origin= "";
        LinkedList<FreightNetworkNode> result;

        for (String line: fileReaderImpl.readFile(filePathInput)){
            if (line.contains(",")){
                String[] separator = line.split(",");
                origin = separator[0];
            }
        }
        result = freightNetworkServiceImpl.graphCircuit(turnStringIntoFreightNetworkNode(origin));
        float distance= 0f;

        for (int i = 0; i < result.size()-1; i++) {
            distance += testFreightNetworkGraph.edge(result.get(i),result.get(i+1)).getWeight();
        }
        System.out.println(distance+" Meters");

        // Assert
        writeCircuitGraphOutputToFile(result, filePathOutput);
    }

    /**
     * it will print the dynamic test's output to a csv file
     * @param result test result
     * @param newFilePath output file location
     * @throws IOException
     */
    private void writeCircuitGraphOutputToFile(LinkedList<FreightNetworkNode> result, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();
        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("Location Type -> Place | Country | Latitude | Longitude\n");
            for (FreightNetworkNode node: result) {
                fileOutputLine.append(node.toString()+" \n");
            }
            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }

    /**
     * Static test for when is inserted invalid parameter
     *
     */
    @Test
    public void invalidParameterGetCriticalPortList()
    {
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> freightNetworkServiceImpl.getCriticalPortList(-1));
    }

    /**
     * Static test for when N = 5. It checks if the top 5 critical port node is the expected value
     *
     */
    @Test
    public void smallInputGetCriticalPortList()
    {
        //Arrange
        LinkedHashMap<PortNode, Long> expected = new LinkedHashMap<PortNode, Long>(){{
            put(new PortNode(0f,0f,"Halifax",null), 9399L);
            put(new PortNode(0f,0f,"Horta",null), 9315L);
            put(new PortNode(0f,0f,"New Jersey",null), 9255L);
            put(new PortNode(0f,0f,"Brest",null), 8691L);
            put(new PortNode(0f,0f,"Hamburg",null), 8667L);
        }};

        // Act
        LinkedHashMap<PortNode, Long> result  = freightNetworkServiceImpl.getCriticalPortList(5);

        // Assert
        for (Map.Entry<PortNode, Long> port : result.entrySet()) {
            assertTrue(expected.containsKey(port.getKey()));
            assertEquals(expected.get(port.getKey()),port.getValue());
            System.out.println(((PortNode)port.getKey()).getPortName() + " | " + port.getValue().toString());
        }
        
    }

    /**
     * Static test for when N = 25. It checks if the top 25 critical port node is the expected value
     *
     */
    @Test
    public void extremeInputGetCriticalPortList()
    {
        //Arrange
        LinkedHashMap<PortNode, Long> expected = new LinkedHashMap<PortNode, Long>(){{
            put(new PortNode(0f,0f,"Halifax",null), 9399L);
            put(new PortNode(0f,0f,"Horta",null), 9315L);
            put(new PortNode(0f,0f,"New Jersey",null), 9255L);
            put(new PortNode(0f,0f,"Brest",null), 8691L);
            put(new PortNode(0f,0f,"Hamburg",null), 8667L);
            put(new PortNode(0f,0f,"Cartagena",null), 8321L);
            put(new PortNode(0f,0f,"Rostock",null), 8067L);
            put(new PortNode(0f,0f,"Zeebrugge",null), 7885L);
            put(new PortNode(0f,0f,"Esmeraldas",null), 4579L);
            put(new PortNode(0f,0f,"Balboa",null), 3143L);
            put(new PortNode(0f,0f,"Cristobal",null), 2847L);
            put(new PortNode(0f,0f,"Kaliningrad",null), 2765L);
            put(new PortNode(0f,0f,"Valparaiso",null), 2649L);
            put(new PortNode(0f,0f,"Koper",null), 2643L);
            put(new PortNode(0f,0f,"Buenos Aires",null), 1933L);
            put(new PortNode(0f,0f,"Gdansk",null), 1809L);
            put(new PortNode(0f,0f,"Genoa",null), 1735L);
            put(new PortNode(0f,0f,"Setubal",null), 1721L);
            put(new PortNode(0f,0f,"Piraeus",null), 1719L);
            put(new PortNode(0f,0f,"Dunkirk",null), 1563L);
            put(new PortNode(0f,0f,"Venice",null), 1545L);
            put(new PortNode(0f,0f,"Buenaventura",null), 1515L);
            put(new PortNode(0f,0f,"Galatz",null), 1511L);
            put(new PortNode(0f,0f,"Valencia",null), 1485L);
            put(new PortNode(0f,0f,"Feodosia",null), 1141L);
        }};

        // Act
        LinkedHashMap<PortNode, Long> result  = freightNetworkServiceImpl.getCriticalPortList(25);

        // Assert
        for (Map.Entry<PortNode, Long> port : result.entrySet()) {
            assertTrue(expected.containsKey(port.getKey()));
            assertEquals(expected.get(port.getKey()),port.getValue());
            System.out.println(((PortNode)port.getKey()).getPortName() + " | " + port.getValue().toString());
        }
    }

    /**
     * Static test for when N = 80.
     * Data only contains 78 PortNode, so it should return only 78 ports
     *
     */
    @Test
    public void shouldReturnRightAmountGetCriticalPortList()
    {
        // Act
        LinkedHashMap<PortNode, Long> result  = freightNetworkServiceImpl.getCriticalPortList(80);

        // Assert
        assertEquals(result.size(), 78);
    }
}