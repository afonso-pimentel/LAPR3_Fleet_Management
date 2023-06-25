package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

/**
 * @author Group 169 LAPRIII
 */
public interface FreightNetworkDataHandler {

    /**
     * Imports the capital nodes stored on the file into the graph and returns an HashMap of the imported capital nodes ordered by Country
     * @param filePath file path for the file that contains data for the capital nodes
     * @param graph input graph for the capital nodes to be added
     * @return HashMap of the imported capital nodes where the country of each capital is the key
     * @throws IOException
     */
    HashMap<Country, CapitalNode> importCapitalNodesFromFileIntoGraph(String filePath, Graph<FreightNetworkNode,Float> graph) throws IOException;

    /**
     * Imports the port nodes stored on the file into the graph and returns an HashMap of the imported port nodes ordered by Country
     * @param filePath  file path for the file that contains data for the port nodes
     * @param graph input graph for the ports nodes to be added
     * @return HashMap of the imported port nodes where the countries are the key and the value is another HashMap where the key is the Port Name
     * @throws IOException
     */
    HashMap<Country, HashMap<PortNodeInfo, PortNode>> importPortNodesFromFileIntoGraph(String filePath, Graph<FreightNetworkNode,Float> graph) throws IOException;

    /**
     * Imports the borders stored on the file
     * @param filePath file path for the file that contains data for the borders
     * @return HashMap where the countries are the key and the value is the list of countries with which it borders
     * @throws IOException
     */
    HashMap<Country, List<Country>> importBordersFromFile(String filePath) throws IOException;

    /**
     * Imports the seadists stored on the file
     * @param filePath file path for the file that contains data for the seadists
     * @return HashMap where the port name is the key and the value is an ordered TreeSet of Seadists
     * @throws IOException
     */
    HashMap<PortNodeInfo, TreeSet<Seadist>> importSeadistsFromFile(String filePath) throws IOException;

    /**
     * Imports the capital nodes stored on the database into the graph and returns an HashMap of the imported capital nodes ordered by Country
     * @param graph input graph for the ports nodes to be added
     * @return HashMap of the imported capital nodes where the country of each capital is the key
     * @throws IOException
     * @throws SQLException
     */
    HashMap<Country, CapitalNode> importCapitalNodesFromDatabaseIntoGraph(Graph<FreightNetworkNode,Float> graph) throws IOException, SQLException;

    /**
     * Imports the port nodes stored on the database into the graph and returns an HashMap of the imported port nodes ordered by Country
     * @param graph input graph for the ports nodes to be added
     * @return HashMap of the imported port nodes where the countries are the key and the value is another HashMap where the key is the Port Name
     * @throws IOException
     * @throws SQLException
     */
    HashMap<Country, HashMap<PortNodeInfo, PortNode>> importPortNodesFromDatabaseIntoGraph(Graph<FreightNetworkNode,Float> graph) throws IOException, SQLException;

    /**
     * Imports the borders stored on the database
     * @return HashMap where the countries are the key and the value is the list of countries with which it borders
     * @throws IOException
     * @throws SQLException
     */
    HashMap<Country, List<Country>> importBordersFromDatabase() throws IOException, SQLException;

    /**
     * Imports the seadists stored on the database
     * @return HashMap where the port name is the key and the value is an ordered TreeSet of Seadists
     * @throws IOException
     * @throws SQLException
     */
    HashMap<PortNodeInfo, TreeSet<Seadist>> importSeadistsFromDatabase() throws IOException, SQLException;
}
