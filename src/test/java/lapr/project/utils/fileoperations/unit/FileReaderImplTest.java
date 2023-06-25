package lapr.project.utils.fileoperations.unit;

import lapr.project.utils.fileoperations.FileReaderImpl;
import org.junit.jupiter.api.Test;
import java.io.FileNotFoundException;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class FileReaderImplTest {
    private FileReaderImpl fileReaderImplementation;

    public FileReaderImplTest(){
        fileReaderImplementation = new FileReaderImpl();
    }

    @Test
    public void Invalid_NullFilePath_ShouldThrow_IllegalArgumentException(){
        // Arrange
        String nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  fileReaderImplementation.readFile(nullArgument));
    }

    @Test
    public void Invalid_EmptyFilePath_ShouldThrow_IllegalArgumentException(){
        // Arrange
        String emptyArgument = "";

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  fileReaderImplementation.readFile(emptyArgument));
    }

    @Test
    public void Invalid_FilePath_ShouldThrow_FileNotFoundException(){
        // Arrange
        String invalidArgument = "C:\\";

        // Act & Assert
        assertThrows(FileNotFoundException.class, () ->  fileReaderImplementation.readFile(invalidArgument));
    }
}