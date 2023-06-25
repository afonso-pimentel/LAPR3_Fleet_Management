package lapr.project.utils.fileoperations;

import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface CsvFileParser {
    /**
     * Parses the content of a file to a csv file
     * @param fileContent The content of the file as a list of strings
     * @return Matrix of strings with lines and columns of a CSV file
     */
    List<List<String>> parseToCsv(List<String> fileContent);
}
