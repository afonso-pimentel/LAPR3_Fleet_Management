package lapr.project.utils.fileoperations;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Group 169 LAPRIII
 */
public class CsvFileParserImpl implements CsvFileParser{
    /**
     * {@inheritdoc}
     */
    @Override
    public List<List<String>> parseToCsv(List<String> fileContent) {
        if(fileContent == null)
            throw new IllegalArgumentException("fileContent argument can't be null");

        List<List<String>> csvParsedFileContent = new ArrayList<>();

        for(String line : fileContent)
            csvParsedFileContent.add(
                    Arrays.stream(line.replace(',',';')
                    .split(";")).collect(Collectors.toList()));

        return csvParsedFileContent;
    }
}
