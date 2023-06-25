package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * @author Group 169 LAPRIII
 */
public class FreightNetworkImpl implements FreightNetwork{
    private final FreightNetworkDataHandler freightNetworkDataHandler;
    private final FreightNetworkLogic freightNetworkLogic;

    private MatrixGraph<FreightNetworkNode, Float> freightNetwork;

    public FreightNetworkImpl(FreightNetworkDataHandler freightNetworkDataAccess, FreightNetworkLogic freightNetworkLogic) {
        this.freightNetworkDataHandler = freightNetworkDataAccess;
        this.freightNetworkLogic = freightNetworkLogic;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void initializeNetworkFromFiles(int numberOfClosesPortsToConnectTo, String capitalNodesFilePath, String portNodesFilePath,  String bordersFilePath, String seadistsFilePath) throws IOException {
        freightNetwork = new MatrixGraph<>(false);

        HashMap<Country, CapitalNode> importedCapitalNodes = freightNetworkDataHandler.importCapitalNodesFromFileIntoGraph(capitalNodesFilePath, this.freightNetwork);
        HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes = freightNetworkDataHandler.importPortNodesFromFileIntoGraph(portNodesFilePath, this.freightNetwork);
        HashMap<Country, List<Country>> borders = freightNetworkDataHandler.importBordersFromFile(bordersFilePath);
        HashMap<PortNodeInfo, TreeSet<Seadist>> seadists = freightNetworkDataHandler.importSeadistsFromFile(seadistsFilePath);

        applyFreightNetworkLogic(importedCapitalNodes, importedPortNodes, borders, seadists, numberOfClosesPortsToConnectTo);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void initializeNetworkFromDatabase(int numberOfClosestPortsToConnectTo) throws IOException, SQLException {
        freightNetwork = new MatrixGraph<>(false);

        HashMap<Country, CapitalNode> importedCapitalNodes = freightNetworkDataHandler.importCapitalNodesFromDatabaseIntoGraph(this.freightNetwork);
        HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes = freightNetworkDataHandler.importPortNodesFromDatabaseIntoGraph(this.freightNetwork);
        HashMap<Country, List<Country>> borders = freightNetworkDataHandler.importBordersFromDatabase();
        HashMap<PortNodeInfo, TreeSet<Seadist>> seadists = freightNetworkDataHandler.importSeadistsFromDatabase();

        applyFreightNetworkLogic(importedCapitalNodes, importedPortNodes, borders, seadists, numberOfClosestPortsToConnectTo);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public MatrixGraph<FreightNetworkNode, Float> getFreightNetwork() {
        return this.freightNetwork;
    }

    private void applyFreightNetworkLogic(HashMap<Country, CapitalNode> importedCapitalNodes, HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes, HashMap<Country, List<Country>> borders, HashMap<PortNodeInfo, TreeSet<Seadist>> seadists, int numberOfClosesPortsToConnectTo){
        freightNetworkLogic.addCapitalConnectionToCapitalsFromBorderCountries(importedCapitalNodes, borders, this.freightNetwork); // Acceptance Criteria 1
        freightNetworkLogic.addPortConnectionToPortsFromSameCountry(importedPortNodes, seadists, this.freightNetwork); // Acceptance Criteria 2
        freightNetworkLogic.addClosestPortToCapitalConnection(importedCapitalNodes, importedPortNodes, borders, this.freightNetwork); // Acceptance Criteria 3
        freightNetworkLogic.addPortConnectionToNClosestPorts(numberOfClosesPortsToConnectTo, importedPortNodes, seadists, this.freightNetwork); // Acceptance Criteria 4
    }
}
