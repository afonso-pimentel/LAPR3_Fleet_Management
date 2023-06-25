package lapr.project.utils.datastructures;

import java.io.IOException;
import java.sql.SQLException;

/**
 * @author Group 169 LAPRIII
 */
public interface FreightNetwork {

    /**
     * Initializes the Freight Network from a set of files that contain data for the Freight Network
     * @param numberOfClosesPortsToConnectTo number of closest ports that any port should connect to
     * @param capitalNodesFilePath file path for the file that contains data for the capital nodes
     * @param portNodesFilePath file path for the file that contains data for the port nodes
     * @param bordersFilePath file path for the file that contains data for the borders
     * @param seadistsFilePath file path for the file that contains data for the seadists
     * @throws IOException
     */
    void initializeNetworkFromFiles(int numberOfClosesPortsToConnectTo, String capitalNodesFilePath, String portNodesFilePath,  String bordersFilePath, String seadistsFilePath) throws IOException;

    /**
     * Initializes the Freight Network from the data that is stored on the database
     * @param numberOfClosestPortsToConnectTo number of closest ports that any port should connect to
     * @throws IOException
     */
    void initializeNetworkFromDatabase(int numberOfClosestPortsToConnectTo) throws IOException, SQLException;

    /**
     * Gets the freight network as a MatrixGraph
     * @return MatrixGraph<FreightNetworkNode, Float>
     */
    MatrixGraph<FreightNetworkNode, Float> getFreightNetwork();
}
