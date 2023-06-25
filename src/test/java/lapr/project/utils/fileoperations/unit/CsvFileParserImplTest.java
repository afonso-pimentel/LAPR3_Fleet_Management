package lapr.project.utils.fileoperations.unit;

import lapr.project.utils.fileoperations.CsvFileParserImpl;
import org.junit.jupiter.api.Test;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * @author Group 169 LAPRIII
 */
public class CsvFileParserImplTest {
    private CsvFileParserImpl csvFileParserImplementation;

    /**
     * Constructor for the CsvFileParserImplTest object
     */
    public CsvFileParserImplTest(){
        csvFileParserImplementation = new CsvFileParserImpl();
    }

    /**
     * Tests if an IllegalArgumentException is thrown due to a null list argument
     */
    @Test
    public void Invalid_NullArgument_ShouldThrow_IllegalArgumentException(){
        // Arrange
        List<String> nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  csvFileParserImplementation.parseToCsv(nullArgument));
    }

    /**
     * Tests if the expected value is received based on a valid file content input has a List of strings
     */
    @Test
    public void Valid_ListOfStrings_ShouldReturn_ExpectedValue(){
        // Arrange
        List<String> fileContent = new ArrayList<>();
        fileContent.add("test,test2,test3,test4");
        fileContent.add("test5,test6,test7,test8");
        fileContent.add("test9,test10,test11,test12");

        ArrayList<ArrayList<String>> expected = new ArrayList<>();
        expected.add(new ArrayList<String>(Arrays.asList("test", "test2", "test3", "test4")));
        expected.add(new ArrayList<String>(Arrays.asList("test5", "test6", "test7", "test8")));
        expected.add(new ArrayList<String>(Arrays.asList("test9", "test10", "test11", "test12")));

        // Act
        List<List<String>> result = csvFileParserImplementation.parseToCsv(fileContent);

        // Assert
        assertEquals(expected.size(), result.size());
        assertEquals(expected.get(0), result.get(0));
        assertEquals(expected.get(1), result.get(1));
        assertEquals(expected.get(2), result.get(2));
    }
}
