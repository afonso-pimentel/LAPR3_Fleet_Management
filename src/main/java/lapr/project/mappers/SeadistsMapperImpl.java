package lapr.project.mappers;

import lapr.project.model.Country;
import lapr.project.utils.datastructures.Seadist;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public class SeadistsMapperImpl implements SeadistsMapper{

    /**
     * {@inheritdoc}
     */
    @Override
    public Seadist mapSeadistFromCsvContent(List<String> csvParsedContent) {
        String fromPort = csvParsedContent.get(2);
        Country fromCountry = new Country(csvParsedContent.get(0), "");
        Country toCountry = new Country(csvParsedContent.get(3), "");
        String toPort = csvParsedContent.get(5);
        float distance = Float.parseFloat(csvParsedContent.get(6));

        return new Seadist(fromCountry, fromPort, toCountry, toPort, distance);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public Seadist mapSeadistFromDatabaseResultSet(ResultSet resultSet) throws SQLException {
        String fromPort = resultSet.getString("FROM_PORT");
        Country fromCountry = new Country(resultSet.getString("FROM_COUNTRY"), "");
        Country toCountry = new Country(resultSet.getString("TO_COUNTRY"), "");
        String toPort = resultSet.getString("TO_PORT");
        float distance = resultSet.getFloat("DISTANCE");

        return new Seadist(fromCountry, fromPort, toCountry, toPort, distance);
    }
}
