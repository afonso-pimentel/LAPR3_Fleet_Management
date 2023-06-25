package lapr.project.utils.utilities;

import lapr.project.utils.utilities.utilmodels.ApplicationProperties;
import oracle.jdbc.pool.OracleDataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Group 169 LAPRIII
 */
public class DatabaseConnectionImpl implements DatabaseConnection{
    private final ApplicationPropertiesHelper applicationPropertiesHelper;

    public DatabaseConnectionImpl(ApplicationPropertiesHelper applicationPropertiesHelper) {
        if(applicationPropertiesHelper == null)
            throw new IllegalArgumentException("ApplicationPropertiesHelper argument cannot be null");

        this.applicationPropertiesHelper = applicationPropertiesHelper;
    }

    public Connection getConnection() throws SQLException, IOException {
        ApplicationProperties applicationProperties = applicationPropertiesHelper.getApplicationProperties();

        OracleDataSource oracleDataSource = new OracleDataSource();

        oracleDataSource.setURL(applicationProperties.getDatabaseURL());

        return oracleDataSource.getConnection(applicationProperties.getDatabaseUsername(), applicationProperties.getDatabasePassword());
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void closeConnection(Connection connection) throws SQLException {
        if(connection != null)
            connection.close();
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void closeResultSet(ResultSet resultSet) throws SQLException {
        if(resultSet != null)
            resultSet.close();
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void closePreparedStatement(PreparedStatement preparedStatement) throws SQLException {
        if(preparedStatement != null)
            preparedStatement.close();
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void closeDatabaseResources(Connection connection, ResultSet resultSet, PreparedStatement preparedStatement) throws SQLException {
        closeConnection(connection);
        closePreparedStatement(preparedStatement);
        closeResultSet(resultSet);
    }
}
