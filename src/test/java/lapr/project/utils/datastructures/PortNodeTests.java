package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

public class PortNodeTests {

    @Test
    public void valid_PortNodeObject_ShouldReturnExpected_toString(){
        // Arrange
        PortNode portNode = new PortNode(30.0f, 35.0f, "Lisbon", new Country("Portugal", "Europe"));

        String expected = "Port Node => Port Name = Lisbon | Country = Portugal | Latitude = 30.0 | Longitude = 35.0";

        // Act
        String result = portNode.toString();

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void invalid_CapitalNodeObject_ShouldReturnFalse_EqualsMethodCall(){
        // Arrange
        PortNode portNode = new PortNode(30.0f, 35.0f, "Lisbon", new Country("Portugal", "Europe"));
        CapitalNode capitalNode = new CapitalNode(30.0f, 35.0f, "Lisbon", new Country("Portugal", "Europe"));

        // Act
        boolean result = portNode.equals(capitalNode);

        // Assert
        assertFalse(result);
    }

    @Test
    public void valid_HashCodeCall_ShouldReturn_CapitalNameStringHashCode(){
        // Arrange
        String portNameAsString = "Lisbon";
        PortNode portNode = new PortNode(30.0f, 35.0f, portNameAsString, new Country("Portugal", "Europe"));
        int expected = portNameAsString.hashCode();

        // Act
        int result = portNode.hashCode();

        // Assert
        assertEquals(expected, result);
    }
}
