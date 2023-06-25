package lapr.project.stores;

import lapr.project.mappers.CargoManifestMapper;
import lapr.project.mappers.dtos.CargoManifestAvgDTO;
import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.DatabaseConnection;
import lapr.project.utils.utilities.Utilities;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

/**
 * @author Group 169 LAPRIII
 */
public class CargoManifestStoreImpl implements CargoManifestStore {
    private final DatabaseConnection databaseConnection;
    private final CargoManifestMapper cargoManifestMapper;

    public CargoManifestStoreImpl(DatabaseConnection databaseConnection, ApplicationPropertiesHelper applicationPropertiesHelper, CargoManifestMapper cargoManifestMapper) {
        if(databaseConnection == null)

            throw new IllegalArgumentException("databaseConnection argument cannot be null");

        if(applicationPropertiesHelper == null)

            throw new IllegalArgumentException("applicationPropertiesHelper argument cannot be null");

        if(cargoManifestMapper == null)

            throw new IllegalArgumentException("containerMapper argument cannot be null");

        this.databaseConnection = databaseConnection;
        this.cargoManifestMapper = cargoManifestMapper;
    }

    @Override
    public CargoManifestAvgDTO getCargoManifestsAveragesYear(LocalDate year) throws SQLException, IOException {
        Connection conn = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String query= Utilities.convertInputStreamToString(getClass().getClassLoader().getResourceAsStream
                ("database/select_cargo_manifest_average_year.sql"));
        CargoManifestAvgDTO cargoManifestAvgDTO = null;

        try{
            conn = databaseConnection.getConnection();
            preparedStatement = conn.prepareStatement(query);

            preparedStatement.setDate(1, java.sql.Date.valueOf(year));

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next())
                cargoManifestAvgDTO = cargoManifestMapper.cargoManifestAverageDTO(resultSet.getInt("CARGOMANIFESTNUMBER"), resultSet.getFloat("CONTAINERAVERAGE"));
        } finally{
            databaseConnection.closeDatabaseResources(conn, resultSet, preparedStatement);
        }

        return cargoManifestAvgDTO;
    }
}
