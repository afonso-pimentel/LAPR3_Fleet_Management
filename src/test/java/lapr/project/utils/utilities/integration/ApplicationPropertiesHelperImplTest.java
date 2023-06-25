package lapr.project.utils.utilities.integration;

import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.utilmodels.ApplicationProperties;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.BDDMockito.willAnswer;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.Properties;

public class ApplicationPropertiesHelperImplTest {

    @Test
    public void valid_MethodCall_ShouldReturn_ExpectedObject() throws IOException {
        // Arrange
        Properties properties = new Properties(System.getProperties());
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream
                ("application.properties");
        properties.load(inputStream);
        inputStream.close();

        String databaseURL = properties.getProperty("database.url");
        String databaseUsername = properties.getProperty("database.username");
        String databasePassword = properties.getProperty("database.password");

        ApplicationProperties expected = new ApplicationProperties(databaseURL, databaseUsername, databasePassword);

        // Act
        ApplicationPropertiesHelperImpl applicationPropertiesHelperImpl = new ApplicationPropertiesHelperImpl();
        inputStream.close();
        ApplicationProperties result = applicationPropertiesHelperImpl.getApplicationProperties();

        // Assert
        assertNotNull(result);
        assertEquals(expected.getDatabasePassword(), result.getDatabasePassword());
        assertEquals(expected.getDatabaseUsername(), result.getDatabaseUsername());
        assertEquals(expected.getDatabaseURL(), result.getDatabaseURL());
    }
}
