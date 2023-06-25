package lapr.project.mappers;

import lapr.project.utils.datastructures.CapitalNode;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface CapitalMapper {
    /**
     * Maps a file line from a CSV structure to a CapitalNode object
     * @param csvParsedContent file line as a CSV structure
     * @return CapitalNode
     */
    CapitalNode mapCapitalNodeFromCsvContent(List<String> csvParsedContent);

    /**
     * Maps a database ResultSet to a CapitalNode object
     * @param resultSet database ResultSet
     * @return CapitalNode
     * @throws SQLException
     */
    CapitalNode mapCapitalNodeFromDatabaseResultSet(ResultSet resultSet) throws SQLException;
}
