package lapr.project.mappers.dtos;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class FreightNodeClosenessDTOTest {

    @Test
    void testEquals() {
        //Arrange
        FreightNodeClosenessDTO obj1 = new FreightNodeClosenessDTO("AAA",1f);
        FreightNodeClosenessDTO obj2 = new FreightNodeClosenessDTO("AAA",1f);

        //Act & Assert
        boolean result = obj1.equals(obj2);
        assertTrue(result);
    }
    @Test
    void testNotEquals(){
        //Arrange
        FreightNodeClosenessDTO obj1 = new FreightNodeClosenessDTO("AAA",1f);
        FreightNodeClosenessDTO obj2 = new FreightNodeClosenessDTO("BBB",1f);

        //Act & Assert
        boolean result = obj1.equals(obj2);
        assertFalse(result);
    }

    @Test
    void compareToSmaller() {
        //Arrange
        FreightNodeClosenessDTO obj1 = new FreightNodeClosenessDTO("AAA",1f);
        FreightNodeClosenessDTO obj2 = new FreightNodeClosenessDTO("AAA",2f);
        int expected = -1;
        int result = obj1.compareTo(obj2);

        //Act & Assert
        assertEquals(result,expected);
    }

    @Test
    void compareToBigger() {
        //Arrange
        FreightNodeClosenessDTO obj1 = new FreightNodeClosenessDTO("AAA",2f);
        FreightNodeClosenessDTO obj2 = new FreightNodeClosenessDTO("AAA",1f);
        int expected = 1;
        int result = obj1.compareTo(obj2);

        //Act & Assert
        assertEquals(result,expected);
    }

    @Test
    void compareToEqual() {
        //Arrange
        FreightNodeClosenessDTO obj1 = new FreightNodeClosenessDTO("AAA",1f);
        FreightNodeClosenessDTO obj2 = new FreightNodeClosenessDTO("AAA",1f);
        int expected = 0;
        int result = obj1.compareTo(obj2);

        //Act & Assert
        assertEquals(result,expected);
    }
}