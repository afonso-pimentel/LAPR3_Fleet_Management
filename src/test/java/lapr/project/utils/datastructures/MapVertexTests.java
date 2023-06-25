package lapr.project.utils.datastructures;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class MapVertexTests {


    @Test
    public void testToString(){
        MapVertex<String, Integer> vertex = new MapVertex<>("Porto");

        String expected = "Porto: \n";

        String result = vertex.toString();

        assertEquals(expected, result);
    }
}
