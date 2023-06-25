package lapr.project.utils.fileoperations;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface FileReader {
    /**
     * Reads the content of the file
     * @param filePath Path for the file to be read
     * @return Content of the file as a List of strings
     * @throws FileNotFoundException
     * @throws IOException
     * @throws IllegalArgumentException
     */
    List<String> readFile(String filePath) throws IOException;
}
