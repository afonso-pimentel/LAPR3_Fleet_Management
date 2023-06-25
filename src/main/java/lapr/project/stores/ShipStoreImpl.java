package lapr.project.stores;

import lapr.project.mappers.ShipMapper;
import lapr.project.mappers.dtos.ShipAvailableDTO;
import lapr.project.model.Ship;
import lapr.project.model.ShipCallSign;
import lapr.project.model.ShipCharacteristics;
import lapr.project.model.ShipIMO;
import lapr.project.utils.datastructures.AVL;
import lapr.project.utils.utilities.DatabaseConnection;
import lapr.project.utils.utilities.Utilities;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public class ShipStoreImpl implements ShipStore {
    static final String PARAMS_NULL_MESSAGE = "Parameters cannot be null.";
    private final AVL<Ship> shipBinarySearchTreeMMSI;
    private final AVL<Ship> shipBinarySearchTreeCallSign;
    private final AVL<Ship> shipBinarySearchTreeIMO;
    private final ShipMapper shipMapper;
    private final DatabaseConnection databaseConnection;


    /**
     * Constructor for the ShipStore implementation
     * @param shipMapper Explicit depedency of the required mapper for this class
     */
    public ShipStoreImpl(ShipMapper shipMapper, DatabaseConnection databaseConnection){
        this.shipBinarySearchTreeIMO = new AVL<>();
        this.shipBinarySearchTreeCallSign = new AVL<>();
        this.shipBinarySearchTreeMMSI = new AVL<>();

        if(shipMapper == null)
            throw new IllegalArgumentException("shipMapper argument cannot be null");

        if(databaseConnection == null)
            throw new IllegalArgumentException("databaseConnection argument cannot be null");

        this.shipMapper = shipMapper;
        this.databaseConnection = databaseConnection;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void importShipsFromCsv(List<List<String>> csvParsedFileContent) throws ParseException {
        if(csvParsedFileContent == null)
            throw new IllegalArgumentException("csvParsedFileContent argument cannot be null");

        List<Ship> ships = shipMapper.mapShipFromCsvContent(csvParsedFileContent);

        for(Ship ship : ships){
            shipBinarySearchTreeMMSI.insert(ship);
            shipBinarySearchTreeIMO.insert(new ShipIMO(ship));
            shipBinarySearchTreeCallSign.insert(new ShipCallSign(ship));
        }
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public AVL<Ship> getShips() {
        return shipBinarySearchTreeMMSI;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public Ship getShipByMMSI(int shipMMSI) {
        Ship shipToFind = new Ship(-1,shipMMSI,null,null,-1,new ShipCharacteristics(-1,-1,null,-1,-1,-1,-1),null);
        return shipBinarySearchTreeMMSI.find(shipToFind);
    }

    public AVL<Ship> getShipsIMO() {
        return shipBinarySearchTreeIMO;
    }

    public AVL<Ship> getShipsCallSign() {
        return shipBinarySearchTreeCallSign;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public List<ShipAvailableDTO> getAvailableShipsNextWeek() throws SQLException, IOException {
        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream("database/traffic_manager_available_ships.sql"));

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<ShipAvailableDTO> listOfAvailableShips = new ArrayList<>();
        try{
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();

            while(resultSet.next())
                listOfAvailableShips.add(shipMapper.mapToShipAvailableDTO(
                                        resultSet.getInt("SHIPMMSI"),
                                        resultSet.getString("SHIPNAME"),
                                        resultSet.getString("LOCATIONDESCRIPTION"),
                                        resultSet.getFloat("LOCATIONLATITUDE"),
                                        resultSet.getFloat("LOCATIONLONGITUDE")));

        } finally{
            databaseConnection.closeDatabaseResources(connection, resultSet, preparedStatement);
        }

        return listOfAvailableShips;
    }


    @Override
    public float occupancyRate(int shipID, int cargoManifestID) throws IOException, SQLException {
        return getOccupancyRate(false, shipID, cargoManifestID, null);
    }

    @Override
    public float getOccupancyRateAtGivenMoment(int shipID, LocalDate moment) throws IOException, SQLException {
        return getOccupancyRate(true, shipID, 0, moment);
    }

    private float getOccupancyRate(boolean byDate, int shipID, int cargoManifestID, LocalDate moment) throws SQLException, IOException {

        if (byDate && (shipID <= 0 || moment == null))
            throw new IllegalArgumentException(PARAMS_NULL_MESSAGE);

        if(!byDate && (shipID <= 0 || cargoManifestID <= 0))
            throw new IllegalArgumentException(PARAMS_NULL_MESSAGE);

        String queryFile = byDate ? "select_ship_cargo_manifest_occupancy_rate_at_given_moment.sql" : "select_ship_cargo_manifest_occupancy_rate.sql";

        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream
                ("database/" + queryFile));

        Connection conn = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        float occupancyRate = 0;
        try{
            conn = databaseConnection.getConnection();
            preparedStatement = conn.prepareStatement(query);

            preparedStatement.setInt(1, shipID);

            if(byDate){
                preparedStatement.setDate(2, java.sql.Date.valueOf(moment) );
                preparedStatement.setInt(3, shipID);
                preparedStatement.setDate(4, java.sql.Date.valueOf(moment) );
            }else{
                preparedStatement.setInt(2,cargoManifestID);
            }

            resultSet = preparedStatement.executeQuery();

            if(resultSet.next())
                occupancyRate = byDate ? resultSet.getFloat("OccupancyPercentage") : resultSet.getFloat("OCCUPANCY_PERC");
        }
        finally {
            closeDatabaseResources(conn, resultSet, preparedStatement);
        }

        return occupancyRate;
    }

    private void closeDatabaseResources(Connection connection, ResultSet resultSet, PreparedStatement preparedStatement) throws SQLException {
        databaseConnection.closeConnection(connection);
        databaseConnection.closePreparedStatement(preparedStatement);
        databaseConnection.closeResultSet(resultSet);
    }
}
