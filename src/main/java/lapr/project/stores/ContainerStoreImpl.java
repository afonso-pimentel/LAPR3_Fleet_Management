package lapr.project.stores;

import lapr.project.mappers.ContainerMapper;
import lapr.project.mappers.dtos.ContainerSituationDTO;
import lapr.project.mappers.dtos.ContainerToLoadOnPortDTO;
import lapr.project.mappers.dtos.ContainerWithNextPortDTO;
import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.DatabaseConnection;
import lapr.project.utils.utilities.Utilities;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public class ContainerStoreImpl implements ContainerStore {
    private final DatabaseConnection databaseConnection;
    private final ContainerMapper containerMapper;

    /**
     * Constructor for the ContainerStore implementation
     * @param databaseConnection
     * @param applicationPropertiesHelper
     * @param containerMapper
     */
    public ContainerStoreImpl(DatabaseConnection databaseConnection, ApplicationPropertiesHelper applicationPropertiesHelper, ContainerMapper containerMapper) {
        if(databaseConnection == null)
            throw new IllegalArgumentException("databaseConnection argument cannot be null");

        if(applicationPropertiesHelper == null)
            throw new IllegalArgumentException("applicationPropertiesHelper argument cannot be null");

        if(containerMapper == null)
            throw new IllegalArgumentException("containerMapper argument cannot be null");

        this.databaseConnection = databaseConnection;
        this.containerMapper = containerMapper;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public ContainerSituationDTO getContainerCurrentSituation(String containerIdentifier) throws SQLException, IOException {
        if(containerIdentifier == null)
            throw new IllegalArgumentException("containerIdentifier argument cannot be null");

        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream
                ("database/client_container_situation.sql"));

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        ContainerSituationDTO containerSituationDTO = null;

        try{
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);

            preparedStatement.setString(1, containerIdentifier);

            resultSet = preparedStatement.executeQuery();

            if(resultSet.next())
                containerSituationDTO = containerMapper.mapToContainerSituationDTO(resultSet.getString("LOCATION_NAME"), resultSet.getString("LOCATION_TYPE"));

        } finally{
            databaseConnection.closeDatabaseResources(connection, resultSet, preparedStatement);
        }

        return containerSituationDTO;
    }

    @Override
    public List<ContainerWithNextPortDTO> getContainersToBeOffloadedNextPort(int mmsi) throws SQLException, IOException {
        if(mmsi < 100000000 || mmsi > 999999999)
            throw new IllegalArgumentException("MMSI number must be a 9 digit number between 100000000 and 999999999");

        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream
                ("database/containers_to_unload_next_port.sql"));

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        ContainerWithNextPortDTO containerWithNextPortDTO = null;
        List<ContainerWithNextPortDTO> containerWithNextPortDTOList = new ArrayList<>();
        try{
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);

            preparedStatement.setString(1, String.valueOf(mmsi));

            resultSet = preparedStatement.executeQuery();
            while(resultSet.next()) {
                    containerWithNextPortDTO = containerMapper.mapToContainerWithNextPortDTO(
                              resultSet.getString("CONTAINER_ID")
                            , Integer.parseInt(resultSet.getString("CONTAINER_LOAD"))
                            , Integer.parseInt(resultSet.getString("CONTAINER_TYPE"))
                            , resultSet.getString("CONTAINER_POSITION")
                            , resultSet.getString("CARGO_SITE_TYPE")
                            , resultSet.getString("CARGO_SITE_NAME"));
                    containerWithNextPortDTOList.add(containerWithNextPortDTO);
            }
        } finally{
            databaseConnection.closeDatabaseResources(connection, resultSet, preparedStatement);
        }

        return containerWithNextPortDTOList;
    }

    @Override
    public List<ContainerToLoadOnPortDTO> getContainersToBeLoadedNextPort(int mmsi) throws SQLException, IOException {
        if(mmsi < 100000000 || mmsi > 999999999)
            throw new IllegalArgumentException("MMSI number must be a 9 digit number between 100000000 and 999999999");

        String query = Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream
                ("database/containers_to_load_next_port.sql"));

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        ContainerToLoadOnPortDTO containerToLoadOnPortDTO = null;
        List<ContainerToLoadOnPortDTO> containerToLoadOnPortDTOList = new ArrayList<>();
        try{
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);

            preparedStatement.setString(1, String.valueOf(mmsi));

            resultSet = preparedStatement.executeQuery();
            while(resultSet.next()) {
                containerToLoadOnPortDTO = containerMapper.mapToContainerToLoadOnPortDTO(
                          resultSet.getString("CONTAINER_ID")
                        , resultSet.getInt("CONTAINER_LOAD")
                        , resultSet.getInt("CONTAINER_TYPE")
                        , resultSet.getString("CARGO_SITE_TYPE")
                        , resultSet.getString("CARGO_SITE_NAME")
                        , resultSet.getString("CARGO_SITE_COUNTRY"));
                containerToLoadOnPortDTOList.add(containerToLoadOnPortDTO);
            }
        } finally{
            databaseConnection.closeDatabaseResources(connection, resultSet, preparedStatement);
        }

        return containerToLoadOnPortDTOList;
    }
}

