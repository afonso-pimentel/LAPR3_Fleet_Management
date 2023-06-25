package lapr.project.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class SolidTest {

    @Test
    void invalidDimensionsShouldThrowException(){
        float[] originZero = {-1f,0f,0f};
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,0f,0f,originZero));
        float[] originOne = {0f,-1f,0f};
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,0f,0f,originOne));
        float[] originTwo = {0f,0f,-1f};
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,0f,0f,originTwo));
        float[] validOrigin = {0f,0f,0f};
        assertThrows(IllegalArgumentException.class, () -> new Solid(-1f,0f,0f,0f,validOrigin));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,-1f,0f,0f,validOrigin));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,-1f,0f,validOrigin));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,0f,-1f,validOrigin));
    }

    @Test
    void invalidDimensionsTwoShouldThrowException(){
        assertThrows(IllegalArgumentException.class, () -> new Solid(-1f,0f,0f,0f,0f,0f,0f));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,-1f,0f,0f,0f,0f,0f));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,-1f,0f,0f,0f,0f));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,0f,-1f,0f,0f,0f));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,0f,0f,-1f,0f,0f));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,0f,0f,0f,-1f,0f));
        assertThrows(IllegalArgumentException.class, () -> new Solid(0f,0f,0f,0f,0f,0f,-1f));
    }


    @Test
    void testIsEqual() {
        //Arrange
        float[] originOne = {0f,0f,0f};
        Solid solidOne = new Solid(1f,1f,1f,1f,originOne[0],originOne[1],originOne[2]);
        float[] originTwo = {0f,0f,0f};
        Solid solidTwo = new Solid(1f,1f,1f,1f,originTwo[0],originTwo[1],originTwo[2]);

        //Assert
        assertTrue(solidOne.equals(solidTwo));

    }

    @Test
    void testIsDifferent() {
        //Arrange
        float[] originOne = {0f,0f,0f};
        Solid solidOne = new Solid(1f,1f,1f,1f,originOne[0],originOne[1],originOne[2]);
        float[] originTwo = {0f,0f,0f};
        Solid solidTwo = new Solid(0f,1f,1f,1f,originTwo[0],originTwo[1],originTwo[2]);
        float[] originThree = {0f,0f,0f};
        Solid solidThree = new Solid(1f,0f,1f,1f,originThree[0],originThree[1],originThree[2]);
        float[] originFour = {0f,0f,0f};
        Solid solidFour = new Solid(1f,1f,0f,1f,originFour[0],originFour[1],originFour[2]);
        float[] originFive = {0f,0f,0f};
        Solid solidFive = new Solid(1f,1f,1f,0f,originFive[0],originFive[1],originFive[2]);


        //Assert
        assertFalse( solidOne.equals(solidTwo));
        assertFalse( solidOne.equals(solidThree));
        assertFalse( solidOne.equals(solidFour));
        assertFalse( solidOne.equals(solidFive));
    }

    @Test
    void testHash(){
        float[] originOne = {0f,0f,0f};
        Solid solidOne = new Solid(1f,1f,1f,1f,originOne[0],originOne[1],originOne[2]);
        float[] originTwo = {0f,0f,0f};
        Solid solidTwo = new Solid(0f,0f,0f,1f,originTwo[0],originTwo[1],originTwo[2]);
        Solid solidThree = new Solid(1f,1f,1f,1f,originOne[0],originOne[1],originOne[2]);

        //Different Hash Code
        assertFalse(solidOne.hashCode() == solidTwo.hashCode());

        //Equal Hash Code
        assertTrue(solidOne.hashCode() == solidThree.hashCode());

        //Different Class Hashcode
        assertFalse(solidOne.equals(new Integer(5)));
    }

}