package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

public class FreightNetworkLogicImplTests {
    private final FreightNetworkLogicImpl freightNetworkLogicImpl;
    private HashMap<Country, List<Country>> borders;
    private HashMap<Country, CapitalNode> importedCapitalNodes;
    private HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes;
    private HashMap<PortNodeInfo, TreeSet<Seadist>> seadists;
    private Graph<FreightNetworkNode, Float> inputGraph;

    public FreightNetworkLogicImplTests(){
        freightNetworkLogicImpl = new FreightNetworkLogicImpl();
    }

    @BeforeEach
    public void setUp() {
        this.importedPortNodes = new HashMap<>();
        this.importedCapitalNodes = new HashMap<>();
        this.borders = new HashMap<>();
        this.seadists = new HashMap<>();
        this.inputGraph = new MatrixGraph<>(false);

        Country portugalCountry = new Country("Portugal", "Europe");

        HashMap<PortNodeInfo, PortNode> portugalPortNodes = new HashMap<>();

        PortNode lisbonPortNode = new PortNode(30.0f, 35.0f, "Lisbon", portugalCountry);
        PortNode funchalPortNode = new PortNode(44.0f, 35.0f, "Funchal", portugalCountry);
        PortNode leixoesPortNode = new PortNode(50.0f, 35.0f, "Leixoes", portugalCountry);
        PortNodeInfo lisbonPortNodeInfo = new PortNodeInfo("Lisbon");
        PortNodeInfo funchalPortNodeInfo = new PortNodeInfo("Funchal");
        PortNodeInfo leixoesPortNodeInfo = new PortNodeInfo("Leixoes");

        portugalPortNodes.put(lisbonPortNodeInfo, lisbonPortNode);
        portugalPortNodes.put(leixoesPortNodeInfo, leixoesPortNode);
        portugalPortNodes.put(funchalPortNodeInfo, funchalPortNode);

        this.importedPortNodes.put(portugalCountry, portugalPortNodes);

        Seadist seadistsLisbonToFunchal = new Seadist(portugalCountry, "Lisbon", portugalCountry, "Funchal", 100);
        Seadist seadistsLisbonToLeixoes= new Seadist(portugalCountry, "Lisbon", portugalCountry, "Leixoes", 200);
        Seadist seadistsFunchalToLeixoes= new Seadist(portugalCountry, "Funchal", portugalCountry, "Leixoes", 300);

        TreeSet<Seadist> lisbonSeaDists = new TreeSet<>();
        lisbonSeaDists.add(seadistsLisbonToLeixoes);
        lisbonSeaDists.add(seadistsLisbonToFunchal);

        this.seadists.put(lisbonPortNodeInfo, lisbonSeaDists);

        TreeSet<Seadist> funchalSeaDists = new TreeSet<>();
        funchalSeaDists.add(seadistsFunchalToLeixoes);
        funchalSeaDists.add(seadistsLisbonToFunchal);

        this.seadists.put(funchalPortNodeInfo, funchalSeaDists);

        CapitalNode lisbonCapitalNode = new CapitalNode(30.0f, 35.0f, "Lisbon", portugalCountry);
        this.importedCapitalNodes.put(portugalCountry, lisbonCapitalNode);

        this.inputGraph.addVertex(lisbonPortNode);
        this.inputGraph.addVertex(funchalPortNode);
        this.inputGraph.addVertex(leixoesPortNode);
        this.inputGraph.addVertex(lisbonCapitalNode);

        this.borders.put(portugalCountry, new ArrayList<>());
        this.borders.get(portugalCountry).add(new Country("Spain", "Europe"));
    }

    @Test
    public void valid_inputImportedNodes_ShouldContainExpectedPortToPortsFromSameCountryConnection(){
        // Arrange
        Country portugalCountry = new Country("Portugal", "Europe");

        PortNode lisbonPortNode = new PortNode(30.0f, 35.0f, "Lisbon", portugalCountry);
        PortNode funchalPortNode = new PortNode(44.0f, 35.0f, "Funchal", portugalCountry);
        PortNode leixoesPortNode = new PortNode(50.0f, 35.0f, "Leixoes", portugalCountry);

        // Act
        freightNetworkLogicImpl.addPortConnectionToPortsFromSameCountry(importedPortNodes, seadists, inputGraph);

        // Assert
        Edge<FreightNetworkNode, Float> resultLisbonToFunchalConnection = inputGraph.edge(lisbonPortNode, funchalPortNode);
        Edge<FreightNetworkNode, Float> resultLisbonToLeixoesConnection = inputGraph.edge(lisbonPortNode, leixoesPortNode);

        assertNotNull(resultLisbonToFunchalConnection);
        assertNotNull(resultLisbonToLeixoesConnection);
    }

    @Test
    public void valid_inputGraph_ShouldContainExpectedConnectionBetweenClosestPortToCapital(){
        // Arrange
        Country portugalCountry = new Country("Portugal", "Europe");
        CapitalNode lisbonCapitalNode = new CapitalNode(30.0f, 35.0f, "Lisbon", portugalCountry);
        PortNode lisbonPortNode = new PortNode(30.0f, 35.0f, "Lisbon", portugalCountry);
        PortNode funchalPortNode = new PortNode(44.0f, 35.0f, "Funchal", portugalCountry);
        PortNode leixoesPortNode = new PortNode(50.0f, 35.0f, "Leixoes", portugalCountry);

        // Act
        this.freightNetworkLogicImpl.addClosestPortToCapitalConnection(this.importedCapitalNodes, this.importedPortNodes, this.borders, this.inputGraph);

        // Assert
        Edge<FreightNetworkNode, Float> resultLisbonPortToLisbonCapitalConnection = inputGraph.edge(lisbonCapitalNode, lisbonPortNode);
        Edge<FreightNetworkNode, Float> resultFunchalPortToLisbonCapitalConnection = inputGraph.edge(funchalPortNode, lisbonPortNode);
        Edge<FreightNetworkNode, Float> resultLeixoesPortToLisbonCapitalConnection = inputGraph.edge(leixoesPortNode, lisbonPortNode);

        assertNotNull(resultLisbonPortToLisbonCapitalConnection);
        assertNull(resultFunchalPortToLisbonCapitalConnection);
        assertNull(resultLeixoesPortToLisbonCapitalConnection);
    }

    @Test
    public void invalid_PortNode_ShouldHaveNullConnectionToCapital(){
        // Arrange
        Country portugalCountry = new Country("Portugal", "Europe");
        CapitalNode lisbonCapitalNode = new CapitalNode(30.0f, 35.0f, "Lisbon", portugalCountry);
        PortNode sameLocationAsLisbonPortNode = new PortNode(30.0f, 35.0f, "TEST", portugalCountry);

        this.inputGraph.addVertex(sameLocationAsLisbonPortNode);
        this.importedPortNodes.get(portugalCountry).put(new PortNodeInfo("TEST"), sameLocationAsLisbonPortNode);

        // Act
        this.freightNetworkLogicImpl.addClosestPortToCapitalConnection(this.importedCapitalNodes, this.importedPortNodes, this.borders, this.inputGraph);

        // Assert
        Edge<FreightNetworkNode, Float> resultLisbonPortToLisbonCapitalConnection = inputGraph.edge(lisbonCapitalNode, sameLocationAsLisbonPortNode);

        assertNull(resultLisbonPortToLisbonCapitalConnection);
    }
}
