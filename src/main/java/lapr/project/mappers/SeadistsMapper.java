package lapr.project.mappers;

import lapr.project.utils.datastructures.Seadist;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface SeadistsMapper {
   /**
    * Maps a file line from a CSV structure to a Seadist object
    * @param csvParsedContent file line as a CSV structure
    * @return
    */
   Seadist mapSeadistFromCsvContent(List<String>  csvParsedContent);

   /**
    * Maps a database ResultSet to a Seadist object
    * @param resultSet database ResultSet
    * @return Seadist
    * @throws SQLException
    */
   Seadist mapSeadistFromDatabaseResultSet(ResultSet resultSet) throws SQLException;
}
