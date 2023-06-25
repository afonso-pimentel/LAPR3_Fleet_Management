package lapr.project.utils.utilities;

import lapr.project.utils.utilities.utilmodels.ApplicationProperties;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ApplicationPropertiesTest {

    @Test
    public void valid_ApplicationPropertiesHelper_ShouldReturnExpectedObject(){
        // Arrange
        String expectedURL = "URL";
        String expectedUsername = "USERNAME";
        String expectedPassword = "PASSWORD";

        // Act
        ApplicationProperties applicationProperties = new ApplicationProperties("URL", "USERNAME", "PASSWORD");

        // Assert
        assertEquals(expectedURL, applicationProperties.getDatabaseURL());
        assertEquals(expectedUsername, applicationProperties.getDatabaseUsername());
        assertEquals(expectedPassword, applicationProperties.getDatabasePassword());
    }
}
