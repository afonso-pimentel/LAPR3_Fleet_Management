package lapr.project.utils.utilities;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Group 169 LAPRIII
 */
public interface DatabaseConnection {
    /**
     * Gets a new connection to the database
     * @return Connection
     * @throws SQLException
     * @throws IOException
     */
    Connection getConnection() throws SQLException, IOException;

    /**
     * Closes a specific connection to the database
     * @param connection Connection to be closed
     * @throws SQLException
     */
    void closeConnection(Connection connection) throws SQLException ;

    /**
     * Closes the specified ResultSet
     * @param resultSet
     */
    void closeResultSet(ResultSet resultSet) throws SQLException;

    /**
     * Closes the specified PreparedStatement
     * @param preparedStatement
     */
    void closePreparedStatement(PreparedStatement preparedStatement) throws SQLException;

    /**
     * Closes the specified Database Resources
     * @param connection
     * @param resultSet
     * @param preparedStatement
     * @throws SQLException
     */
    void closeDatabaseResources(Connection connection, ResultSet resultSet, PreparedStatement preparedStatement) throws SQLException;
}
