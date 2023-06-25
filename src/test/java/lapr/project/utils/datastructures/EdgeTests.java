package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class EdgeTests {

    @Test
    public void testEquals(){
        // Arrange
        Edge<String, Integer> edge = new Edge<>("Porto", "Lisboa", 3);
        Edge<String, Integer> edge2 = new Edge<>("Porto", "Funchal", 3);

        // Act
        boolean result = edge.equals(edge2);
        boolean result2 = edge.equals(null);
        boolean result3 = edge.equals(new Integer(3));
        boolean result4 = edge.equals(edge);

        // Assert
        assertFalse(result);
        assertFalse(result2);
        assertFalse(result3);
        assertTrue(result4);
    }
}
