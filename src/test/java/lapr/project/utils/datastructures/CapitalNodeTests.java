package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class CapitalNodeTests {

    @Test
    public void valid_CapitalNodeObject_ShouldReturnExpected_toString(){
        // Arrange
        CapitalNode capitalNode = new CapitalNode(30.0f, 35.0f, "Lisbon", new Country("Portugal", "Europe"));

        String expected = "Capital Node => Capital Name = Lisbon | Country = Portugal | Latitude = 30.0 | Longitude = 35.0";

        // Act
        String result = capitalNode.toString();

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void invalid_PortNodeObject_ShouldReturnFalse_EqualsMethodCall(){
        // Arrange
        PortNode portNode = new PortNode(30.0f, 35.0f, "Lisbon", new Country("Portugal", "Europe"));
        CapitalNode capitalNode = new CapitalNode(30.0f, 35.0f, "Lisbon", new Country("Portugal", "Europe"));

        // Act
        boolean result = capitalNode.equals(portNode);

        // Assert
        assertFalse(result);
    }

    @Test
    public void valid_HashCodeCall_ShouldReturn_CapitalNameStringHashCode(){
        // Arrange
        String capitalNameAsString = "Lisbon";
        CapitalNode capitalNode = new CapitalNode(30.0f, 35.0f, capitalNameAsString, new Country("Portugal", "Europe"));
        int expected = capitalNameAsString.hashCode();

        // Act
        int result = capitalNode.hashCode();

        // Assert
        assertEquals(expected, result);
    }
}
