package lapr.project.mappers;

import lapr.project.model.Country;
import lapr.project.utils.datastructures.CapitalNode;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public class CapitalMapperImpl implements CapitalMapper{

    /**
     * {@inheritdoc}
     */
    @Override
    public CapitalNode mapCapitalNodeFromCsvContent(List<String> csvParsedContent) {
        Country currentCountry = new Country(csvParsedContent.get(3), csvParsedContent.get(0));
        float latitude = Float.parseFloat(csvParsedContent.get(6));
        float longitude = Float.parseFloat(csvParsedContent.get(7));
        String capitalName = csvParsedContent.get(5);

        return new CapitalNode(latitude, longitude, capitalName, currentCountry);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public CapitalNode mapCapitalNodeFromDatabaseResultSet(ResultSet resultSet) throws SQLException {
        Country currentCountry = new Country(resultSet.getString("COUNTRY"), resultSet.getString("CONTINENT"));
        float latitude = resultSet.getFloat("LATITUDE");
        float longitude =  resultSet.getFloat("LONGITUDE");
        String capitalName = resultSet.getString("CAPITAL_NAME");

        return new CapitalNode(latitude, longitude, capitalName, currentCountry);
    }
}
