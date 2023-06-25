package lapr.project.utils.datastructures;

import lapr.project.mappers.CapitalMapper;
import lapr.project.mappers.PortMapper;
import lapr.project.mappers.SeadistsMapper;
import lapr.project.model.Country;
import lapr.project.utils.fileoperations.CsvFileParser;
import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.utilities.DatabaseConnection;
import lapr.project.utils.utilities.Utilities;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

/**
 * @author Group 169 LAPRIII
 */
public class FreightNetworkDataHandlerImpl implements FreightNetworkDataHandler {
    private final CapitalMapper capitalMapper;
    private final PortMapper portMapper;
    private final SeadistsMapper seadistsMapper;
    private final FileReader fileReader;
    private final CsvFileParser csvFileParser;
    private final DatabaseConnection databaseConnection;

    public FreightNetworkDataHandlerImpl(CapitalMapper capitalMapper, PortMapper portMapper, SeadistsMapper seadistsMapper, FileReader fileReader, CsvFileParser csvFileParser, DatabaseConnection databaseConnection) {
        this.capitalMapper = capitalMapper;
        this.portMapper = portMapper;
        this.seadistsMapper = seadistsMapper;
        this.fileReader = fileReader;
        this.csvFileParser = csvFileParser;
        this.databaseConnection = databaseConnection;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public HashMap<Country, CapitalNode> importCapitalNodesFromFileIntoGraph(String filePath, Graph<FreightNetworkNode,Float> graph) throws IOException {
        HashMap<Country, CapitalNode> importedCapitalNodes = new HashMap<>();

        List<List<String>> csvParsedContent = readFileAndParseToCsv(filePath);

        if(isFirstLineHeaderLineFromCapitalNodesFile(csvParsedContent.get(0)))
            csvParsedContent.remove(0);

        for(List<String> line: csvParsedContent){
            CapitalNode toImportCapitalNode = capitalMapper.mapCapitalNodeFromCsvContent(line);

            graph.addVertex(toImportCapitalNode);

            importedCapitalNodes.put(toImportCapitalNode.getCountry(), toImportCapitalNode);
        }

        return importedCapitalNodes;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public HashMap<Country, HashMap<PortNodeInfo, PortNode>> importPortNodesFromFileIntoGraph(String filePath, Graph<FreightNetworkNode,Float> graph) throws IOException {
        HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes = new HashMap<>();

        List<List<String>> csvParsedContent = readFileAndParseToCsv(filePath);

        if(isFirstLineHeaderLineFromPortNodesFile(csvParsedContent.get(0)))
            csvParsedContent.remove(0);

        for(List<String> line: csvParsedContent){
            Country currentCountry = new Country(line.get(1), "");

            if(!importedPortNodes.containsKey(currentCountry))
                importedPortNodes.put(currentCountry, new HashMap<PortNodeInfo,PortNode>());

            PortNode toImportPortNode = portMapper.mapPortNodeFromCsvContent(line);

            graph.addVertex(toImportPortNode);

            importedPortNodes.get(currentCountry).put(new PortNodeInfo(toImportPortNode.getPortName()), toImportPortNode);
        }

        return importedPortNodes;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public HashMap<Country, List<Country>> importBordersFromFile(String filePath) throws IOException {
        List<List<String>> csvParsedContent = readFileAndParseToCsv(filePath);

        if(isFirstLineHeaderLineFromBordersFile(csvParsedContent.get(0)))
            csvParsedContent.remove(0);

        HashMap<Country, List<Country>> mappedBorders = new HashMap<>();

        for(List<String> line: csvParsedContent){
            Country currentCountry = new Country(line.get(0), "");

            if(!mappedBorders.containsKey(currentCountry))
                mappedBorders.put(currentCountry, new ArrayList<>());

            mappedBorders.get(currentCountry).add(new Country(line.get(1), ""));
        }

        return mappedBorders;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public HashMap<PortNodeInfo, TreeSet<Seadist>> importSeadistsFromFile(String filePath) throws IOException {
        HashMap<PortNodeInfo, TreeSet<Seadist>> mappedSeadDists = new HashMap<>();

        List<List<String>> csvParsedContent = readFileAndParseToCsv(filePath);

        if(isFirstLineHeaderLineFromSeadistsFile(csvParsedContent.get(0)))
            csvParsedContent.remove(0);

        for(List<String> line: csvParsedContent){
            PortNodeInfo fromPort = new PortNodeInfo(line.get(2));
            PortNodeInfo toPort = new PortNodeInfo(line.get(5));

            if(!mappedSeadDists.containsKey(fromPort))
                mappedSeadDists.put(fromPort, new TreeSet<Seadist>());

            if(!mappedSeadDists.containsKey(toPort))
                mappedSeadDists.put(toPort, new TreeSet<Seadist>());

            Seadist mappedSeadist = seadistsMapper.mapSeadistFromCsvContent(line);

            mappedSeadDists.get(fromPort).add(mappedSeadist);
            mappedSeadDists.get(toPort).add(mappedSeadist);
        }

        return mappedSeadDists;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public HashMap<Country, CapitalNode> importCapitalNodesFromDatabaseIntoGraph(Graph<FreightNetworkNode, Float> graph) throws IOException, SQLException {
        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream("database/select_capitals.sql"));

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        HashMap<Country, CapitalNode> importedCapitalNodes = new HashMap<>();

        try{
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();

            while(resultSet.next()){
                CapitalNode toImportCapitalNode = capitalMapper.mapCapitalNodeFromDatabaseResultSet(resultSet);

                graph.addVertex(toImportCapitalNode);

                importedCapitalNodes.put(toImportCapitalNode.getCountry(), toImportCapitalNode);
            }

        } finally{
            databaseConnection.closeDatabaseResources(connection, resultSet, preparedStatement);
        }

        return importedCapitalNodes;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public HashMap<Country, HashMap<PortNodeInfo, PortNode>> importPortNodesFromDatabaseIntoGraph(Graph<FreightNetworkNode, Float> graph) throws IOException, SQLException {
        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream("database/select_ports.sql"));

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes = new HashMap<>();

        try{
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();

            while(resultSet.next()){
                Country currentCountry = new Country(resultSet.getString("PORT_COUNTRY"), "PORT_CONTINENT");

                if(!importedPortNodes.containsKey(currentCountry))
                    importedPortNodes.put(currentCountry, new HashMap<>());

                PortNode toImportPortNode = portMapper.mapPortNodeFromDatabaseResultSet(resultSet);

                graph.addVertex(toImportPortNode);

                importedPortNodes.get(currentCountry).put(new PortNodeInfo(toImportPortNode.getPortName()), toImportPortNode);
            }

        } finally{
            databaseConnection.closeDatabaseResources(connection, resultSet, preparedStatement);
        }

        return importedPortNodes;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public HashMap<Country, List<Country>> importBordersFromDatabase() throws IOException, SQLException {
        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream("database/select_borders.sql"));

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        HashMap<Country, List<Country>> mappedBorders = new HashMap<>();

        try{
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();

            while(resultSet.next()){
                Country currentCountry = new Country(resultSet.getString("COUNTRY_ONE"), "");

                if(!mappedBorders.containsKey(currentCountry))
                    mappedBorders.put(currentCountry, new ArrayList<>());

                mappedBorders.get(currentCountry).add(new Country(resultSet.getString("COUNTRY_TWO"), ""));
            }

        } finally{
            databaseConnection.closeDatabaseResources(connection, resultSet, preparedStatement);
        }

        return mappedBorders;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public HashMap<PortNodeInfo, TreeSet<Seadist>> importSeadistsFromDatabase() throws IOException, SQLException {
        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream("database/select_seadists.sql"));

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        HashMap<PortNodeInfo, TreeSet<Seadist>> mappedSeadDists = new HashMap<>();

        try{
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();

            while(resultSet.next()){
                PortNodeInfo fromPort = new PortNodeInfo(resultSet.getString("FROM_PORT"));
                PortNodeInfo toPort = new PortNodeInfo(resultSet.getString("TO_PORT"));

                if(!mappedSeadDists.containsKey(fromPort))
                    mappedSeadDists.put(fromPort, new TreeSet<>());

                if(!mappedSeadDists.containsKey(toPort))
                    mappedSeadDists.put(toPort, new TreeSet<>());

                Seadist mappedSeadist = seadistsMapper.mapSeadistFromDatabaseResultSet(resultSet);

                mappedSeadDists.get(fromPort).add(mappedSeadist);
                mappedSeadDists.get(toPort).add(mappedSeadist);
            }

        } finally{
            databaseConnection.closeDatabaseResources(connection, resultSet, preparedStatement);
        }

        return mappedSeadDists;
    }

    private List<List<String>> readFileAndParseToCsv(String filePath) throws IOException {
        return csvFileParser.parseToCsv(fileReader.readFile(filePath));
    }

    /**
     * Determines if the line is the header line from the Capital files csv
     * @param line composed of it's columns distributed through of type List<String></String>
     * @return Boolean
     */
    private boolean isFirstLineHeaderLineFromCapitalNodesFile(List<String> line){
        return line.contains("Capital");
    }

    /**
     * Determines if the line is the header line from the Ports files csv
     * @param line composed of it's columns distributed through of type List<String></String>
     * @return Boolean
     */
    private boolean isFirstLineHeaderLineFromPortNodesFile(List<String> line){
        return line.contains("code");
    }

    /**
     * Determines if the line is the header line from the Borders files csv
     * @param line composed of it's columns distributed through of type List<String></String>
     * @return Boolean
     */
    private boolean isFirstLineHeaderLineFromBordersFile(List<String> line){
        return line.contains("Country1");
    }

    /**
     * Determines if the line is the header line from the Seadists files csv
     * @param line composed of it's columns distributed through of type List<String></String>
     * @return Boolean
     */
    private boolean isFirstLineHeaderLineFromSeadistsFile(List<String> line){
        return line.contains("from_country");
    }
}
