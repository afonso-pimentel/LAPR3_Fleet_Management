package lapr.project.utils.fileoperations.integration;

import lapr.project.utils.fileoperations.FileReaderImpl;
import org.junit.jupiter.api.Test;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertEquals;


/**
 * @author Group 169 LAPRIII
 */
public class FileReaderImplTest {
    private FileReaderImpl fileReaderImplementation;

    /**
     * Constructor for the FileReaderImplTest object
     */
    public FileReaderImplTest(){
        fileReaderImplementation = new FileReaderImpl();
    }

    /**
     * Tests if the expected result if received from a valid file has an input
     * @throws IOException
     */
    @Test
    public void valid_File_ShouldReturn_ExpectedResult() throws IOException {
        // Arrange
        String filePath = System.getProperty("user.dir") + "/src/test/resources/input/inputcsvFile1Test.csv";

        ArrayList<String> expected = new ArrayList<>();
        expected.add("test;test1;test2");
        expected.add("test3;test4;test5");
        expected.add("test6;test7;test8");

        // Act
        List<String> result = this.fileReaderImplementation.readFile(filePath);

        // Assert
        assertEquals(expected.size(), result.size());
        assertEquals(expected.get(0), result.get(0));
        assertEquals(expected.get(1), result.get(1));
        assertEquals(expected.get(2), result.get(2));
    }
}
