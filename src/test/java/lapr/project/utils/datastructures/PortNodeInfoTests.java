package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class PortNodeInfoTests {

    @Test
    public void valid_SamePortNodeInfoObject_ShouldReturnEquals(){
        // Arrange
        PortNodeInfo portNodeInfo = new PortNodeInfo("Lisbon");

        // Act
        boolean result = portNodeInfo.equals(portNodeInfo);

        // Assert
        assertTrue(result);
    }

    @Test
    public void invalid_PortNodeObject_ShouldReturnFalseForEquals(){
        // Arrange
        PortNodeInfo portNodeInfo = new PortNodeInfo("Lisbon");
        PortNode portNode = new PortNode(30.0f, 35.0f, "Lisbon", new Country("Portugal", "Europe"));

        // Act
        boolean result = portNodeInfo.equals(portNode);

        // Assert
        assertFalse(result);
    }

    @Test
    public void valid_SameNamePortNodeInfo_ShouldReturnTrueForEquals(){
        // Arrange
        PortNodeInfo portNodeInfoOne = new PortNodeInfo("Lisbon");
        PortNodeInfo portNodeInfoTwo = new PortNodeInfo("Lisbon");

        // Act
        boolean result = portNodeInfoOne.equals(portNodeInfoTwo);

        // Assert

        assertTrue(result);
    }

    @Test
    public void invalid_DifferentNamePortNodeInfo_ShouldReturnFalseForEquals(){
        // Arrange
        PortNodeInfo portNodeInfoOne = new PortNodeInfo("Lisbon");
        PortNodeInfo portNodeInfoTwo = new PortNodeInfo("Lisbon2");

        // Act
        boolean result = portNodeInfoOne.equals(portNodeInfoTwo);

        // Assert
        assertFalse(result);
    }
}
