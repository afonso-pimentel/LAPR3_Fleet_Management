package lapr.project.mappers;


import lapr.project.mappers.dtos.PortDTO;
import lapr.project.model.Port;
import lapr.project.utils.datastructures.PortNode;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface PortMapper {

    /**
     * Maps the contents of a csv file to a list of Port objects
     * @param csvParsedContent CSV parsed content has a matrix of strings
     * @return List of Ports
     * @throws ParseException
     */
    List<Port> mapPortFromCsvContent(List<List<String>> csvParsedContent) throws ParseException;


    /**
     * Maps a CSV line with its columns to a Port object
     * @param columns Columns of the CSV line
     * @return Port
     * @throws ParseException
     */
    Port mapPort(List<String> columns);


    /**
     * Maps the content to a PortDTO object
     * @param code
     * @param name
     * @param continent
     * @param country
     * @param latitude
     * @param longitude
     * @return
     */
    PortDTO mapToPortDTO(int code, String name, String continent, String country, Float latitude, Float longitude);

    /**
     * Maps a file line from a CSV structure to a PortNode object
     * @param csvParsedContent file line as a CSV structure
     * @return PortNode
     */
    PortNode mapPortNodeFromCsvContent(List<String> csvParsedContent);

    /**
     * Maps a database ResultSet to a PortNode object
     * @param resultSet database ResultSet
     * @return PortNode
     * @throws SQLException
     */
    PortNode mapPortNodeFromDatabaseResultSet(ResultSet resultSet) throws SQLException;
}
