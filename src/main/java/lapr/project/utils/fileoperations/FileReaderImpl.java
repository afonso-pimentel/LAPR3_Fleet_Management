package lapr.project.utils.fileoperations;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public class FileReaderImpl implements FileReader{

    /**
     * {@inheritdoc}
     */
    @Override
    public List<String> readFile(String filePath) throws IOException {
        if(filePath == null || filePath.isEmpty())
            throw new IllegalArgumentException("filePath argument can't be null or empty");

        List<String> fileContent = new ArrayList<>();

        try(BufferedReader br = new BufferedReader(new java.io.FileReader(filePath))) {
            String line = br.readLine();

            while (line != null) {
                fileContent.add(line);
                line = br.readLine();
            }
        }

        return fileContent;
    }
}
