package lapr.project.mappers;

import lapr.project.mappers.dtos.PortDTO;
import lapr.project.model.Country;
import lapr.project.model.Port;
import lapr.project.utils.datastructures.PortNode;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Group 169 LAPRIII
 */
public class PortMapperImpl implements PortMapper {


    /**
     * {@inheritdoc}
     */
    @Override
    public List<Port> mapPortFromCsvContent(List<List<String>> csvParsedContent) throws ParseException {
        if(csvParsedContent == null)
            throw new IllegalArgumentException("csvParsedLine argumment cannot be null");

        if(isFirstLineHeaderLine(csvParsedContent.get(0)))
            csvParsedContent.remove(0);

        Integer lastknownIdCode = Integer.parseInt(csvParsedContent.get(0).get(2));
        Port firstPort = mapPort(csvParsedContent.get(0));

        Map<Integer, Port> portMappings = new HashMap<>();

        portMappings.put(firstPort.getIdCode(), firstPort);

        for(List<String> line: csvParsedContent){
            Integer currentidCode = Integer.parseInt(line.get(2));

            if(currentidCode.compareTo(lastknownIdCode) != 0){
                portMappings.put(currentidCode, mapPort(line));

                lastknownIdCode = currentidCode;
            }
        }
        return portMappings.values().stream().collect(Collectors.toList());
    }

    /**
     * Determines if the line is the header line from the Ports files csv
     * @param line composed of it's columns distributed through of type List<String></String>
     * @return Boolean
     */
    private boolean isFirstLineHeaderLine(List<String> line){
        return line.contains("code");
    }



    /**
     * {@inheritdoc}
     */
    public Port mapPort(List<String> columns) {

        String name = columns.get(3);
        String continent = columns.get(0);
        String country = columns.get(1);
        int code = Integer.parseInt(columns.get(2));
        float latitude = Float.parseFloat(columns.get(4));
        float longitude = Float.parseFloat(columns.get(5));

        return new Port(name, continent, country, code, latitude, longitude);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public PortDTO mapToPortDTO(int code, String name, String continent, String country, Float latitude, Float longitude) {
        return new PortDTO(code, name, continent, country, latitude, longitude);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public PortNode mapPortNodeFromCsvContent(List<String> csvParsedContent) {
        Country currentCountry = new Country(csvParsedContent.get(1), csvParsedContent.get(0));
        float latitude = Float.parseFloat(csvParsedContent.get(4));
        float longitude = Float.parseFloat(csvParsedContent.get(5));
        String portName = csvParsedContent.get(3);

        return new PortNode(latitude, longitude, portName, currentCountry);
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public PortNode mapPortNodeFromDatabaseResultSet(ResultSet resultSet) throws SQLException {
        Country currentCountry = new Country(resultSet.getString("PORT_COUNTRY"), "PORT_CONTINENT");
        float latitude = resultSet.getFloat("LATITUDE");
        float longitude = resultSet.getFloat("LONGITUDE");
        String portName = resultSet.getString("PORT_NAME");

        return new PortNode(latitude, longitude, portName, currentCountry);
    }

}
