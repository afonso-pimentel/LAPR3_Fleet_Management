package lapr.project.stores.unit;

import lapr.project.mappers.PortMapperImpl;
import lapr.project.stores.PortStoreImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import org.junit.jupiter.api.Test;
import java.io.IOException;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class PortStoreImplTest {
    
    private final PortStoreImpl portStoreImpl;

    /**
     * Constructor for the PortStoreImplTest object
     */
    public PortStoreImplTest() throws IOException {
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();

        portStoreImpl = new PortStoreImpl(new PortMapperImpl());
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null mapper argument
     */
    @Test
    public void invalid_NullMapperOnConstructor_ShouldThrow_IllegalArgumentException() throws IOException {
        // Arrange
        PortMapperImpl nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  new PortStoreImpl(nullArgument));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for a null file content argument
     */
    @Test
    public void invalid_NullArgumentOnImportPorts_ShouldThrow_IllegalArgumentException(){
        // Arrange
        List<List<String>> nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> portStoreImpl.importPortsFromCsv(nullArgument));
    }

}
