package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

public class SeadistsTests {

    @Test
    public void valid_DifferentSeadists_ShouldReturnLessOnCompareTo(){
        // Arrange
        Country countryOne = new Country("Portugal", "Europe");

        Seadist seadistOne = new Seadist(countryOne, "Lisbon", countryOne, "Funchal", 1000);
        Seadist seadistTwo = new Seadist(countryOne, "Funchal", countryOne, "Leixoes", 2000);

        int expected = -1;

        // Act
        int result = seadistOne.compareTo(seadistTwo);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void valid_DifferentSeadists_ShouldReturnBiggerOnCompareTo(){
        // Arrange
        Country countryOne = new Country("Portugal", "Europe");

        Seadist seadistOne = new Seadist(countryOne, "Lisbon", countryOne, "Funchal", 1000);
        Seadist seadistTwo = new Seadist(countryOne, "Funchal", countryOne, "Leixoes", 2000);

        int expected = 1;

        // Act
        int result = seadistTwo.compareTo(seadistOne);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void valid_EqualSeadists_ShouldReturnEqualOnCompareTo(){
        // Arrange
        Country countryOne = new Country("Portugal", "Europe");

        Seadist seadist = new Seadist(countryOne, "Lisbon", countryOne, "Funchal", 1000);

        int expected = 0;

        // Act
        int result = seadist.compareTo(seadist);

        // Assert
        assertEquals(expected, result);
    }

    @Test
    public void testHashCode(){
        // Arrange
        Seadist seadist = new Seadist(new Country("Portugal", "Europe"), "Lisbon", new Country("Portugal", "Europe"), "Funchal", 1000);

        int expectedHashCode = seadist.getFromCountry().hashCode() + seadist.getToCountry().hashCode() + seadist.getFromPort().hashCode() + seadist.getToPort().hashCode();

        // Act
        int result = seadist.hashCode();

        // Assert
        assertEquals(expectedHashCode, result);
    }

    @Test
    public void testEquals(){
        // Arrange
        Country countryOne = new Country("Portugal", "Europe");

        Seadist seadist = new Seadist(countryOne, "Lisbon", countryOne, "Funchal", 1000);
        Seadist seadist2 = new Seadist(countryOne, "Lisbon", new Country("Spain", "Europe"), "Barcelona", 1000);


        // Act
        boolean result = seadist.equals(seadist2);
        boolean result2 = seadist.equals(null);
        boolean result3 = seadist.equals(new Integer(3));

        // Assert
        assertFalse(result);
        assertFalse(result2);
        assertFalse(result3);
    }
}
