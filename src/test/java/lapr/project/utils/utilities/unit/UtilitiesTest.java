package lapr.project.utils.utilities.unit;

import lapr.project.model.Country;
import lapr.project.model.Port;
import lapr.project.utils.datastructures.PortNode;
import lapr.project.utils.utilities.Utilities;
import lapr.project.utils.utilities.ValidateGraphNodes;
import org.junit.jupiter.api.Test;
import java.io.InputStream;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * @author Group 169 LAPRIII
 */
public class UtilitiesTest {

    /**
     * Tests if an IllegalArgumentException is thrown for a null date string argument
     */
    @Test
    public void invalid_NullArgument_ShouldThrow_IllegalArgumentException(){
        // Arrange
        String nullArgument = null;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  Utilities.convertFromDateStringToTimeStamp(nullArgument));
    }

    /**
     * Tests if an IllegalArgumentException is thrown for an empty date string argument
     */
    @Test
    public void invalid_EmptyArgument_ShouldThrow_IllegalArgumentException(){
        // Arrange
        String nullArgument = "";

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->  Utilities.convertFromDateStringToTimeStamp(nullArgument));
    }

    /**
     * Tests if the expected timestamp is returned from a valid input date as a string
     */
    @Test
    public void valid_Argument_ShouldReturn_ExpectedTimestamp() throws ParseException {
        // Arrange
        String validArgument = "31/12/2020 05:25";
        Timestamp expected = new Timestamp(1609392300000l);

        // Act
        Timestamp result = Utilities.convertFromDateStringToTimeStamp(validArgument);

        // Assert
        assertEquals(expected,result);
    }

    /**
     * Tests if an IllegalArgumentException is thrown when a null input stream is specified
     */
    @Test
    public void invalid_NullInputStream_ShouldThrow_IllegalArgumentException() {
        // Arrange
        InputStream nullArgument = null;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () -> Utilities.convertInputStreamToString(nullArgument));
    }

    /**
     * Tests if a non null result object is returned when a valid input stream is specified
     */
    @Test
    public void valid_InputStream_ShouldReturn_NotNullResult() {
        // Arrange
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream
                ("sports.csv");

        String emptyString = "";

        // Act
        String result = Utilities.convertInputStreamToString(inputStream);

        // Arrange
        assertNotNull(result);
        assertNotEquals(emptyString, result);
    }

    @Test
    public void testSumFloatArrayList(){
        // Arrange
        List<Float> input = new ArrayList<>();
        input.add(3.0f);
        input.add(5.0f);
        float expected = 8.0f;

        // Act
        float result = Utilities.sumFloatArrayList(input);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testValidateNode(){
        // Arrange
        ValidateGraphNodes validation = new ValidateGraphNodes() {
            @Override
            public <V> boolean valid(V a) {
                return a instanceof PortNode;
            }
        };

        PortNode port =  new PortNode(0f,0f,"",null);
        Country country =  new Country("","");

        // Act & Assert
        assertTrue(Utilities.validateNode(null, port));
        assertTrue(Utilities.validateNode(validation, port));
        assertFalse(Utilities.validateNode(validation, country));
    }
    @Test
    public void testAddItemToMapAndIncrementOneOnValue(){
        // Arrange
        HashMap<String,Long> hashMap = new HashMap();

        // Act
        Utilities.addItemToMapAndIncrementOneOnValue(hashMap, "Empty");

        //Assert
        assertEquals(hashMap.get("Empty"), 1L);

        // Act
        Utilities.addItemToMapAndIncrementOneOnValue(hashMap, "Empty");

        //Assert
        assertEquals(hashMap.get("Empty"), 2L);
    }

    @Test
    public void testSortMapByValueComparator(){
        // Arrange
        HashMap<String,Long> hashMap = new HashMap<String,Long> (){{
            put("Last",3L);
            put("First",1L);
            put("Second",2L);
        }};

        String[] correctAsc = {"First","Second","Last"};
        String[] correctDesc = {"Last","Second","First"};

        int i = 0;

        // Act
        LinkedHashMap<String,Long> resultAsc = Utilities.sortMapByValueComparator(hashMap, true);
        LinkedHashMap<String,Long> resultDesc = Utilities.sortMapByValueComparator(hashMap, false);

        //Assert
        for (Map.Entry<String,Long> entry : resultAsc.entrySet()) {
           assertEquals(correctAsc[i], entry.getKey());
            i++;
        }

        i = 0;

        for (Map.Entry<String,Long> entry : resultDesc.entrySet()) {
            assertEquals(correctDesc[i], entry.getKey());
            i++;
        }
    }
}
