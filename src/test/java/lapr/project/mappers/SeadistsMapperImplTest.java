package lapr.project.mappers;

import lapr.project.model.Country;
import lapr.project.utils.datastructures.Seadist;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;


/**
 * @author Group 169 LAPRIII
 */
public class SeadistsMapperImplTest {
    @Mock
    private ResultSet mockResultSet;
    private SeadistsMapperImpl seadistsMapperImpl;

    public SeadistsMapperImplTest(){
        seadistsMapperImpl = new SeadistsMapperImpl();
    }

    @BeforeEach
    public void createMocks() {
        MockitoAnnotations.openMocks(this);
        seadistsMapperImpl = new SeadistsMapperImpl();
    }

    @Test
    public void valid_CsvContent_ShouldReturn_ExpectedSeaDists(){
        // Arrange
        String seaDistance1 = "Denmark,10358,Aarhus,Turkey,246265,Ambarli,3673";
        Seadist expectedSeadist = new Seadist(new Country("Denmark", "Europe"), "Aarhus", new Country("Turkey", "Europe"), "Ambarli", 3673);

        // Act
        Seadist result = seadistsMapperImpl.mapSeadistFromCsvContent(Arrays.asList(seaDistance1.split(",")));

        // Assert
        assertNotNull(result);
        assertEquals(expectedSeadist.getDistance(), result.getDistance());
        assertEquals(expectedSeadist.getFromCountry(), result.getFromCountry());
        assertEquals(expectedSeadist.getToCountry(), result.getToCountry());
        assertEquals(expectedSeadist.getFromPort(), result.getFromPort());
        assertEquals(expectedSeadist.getToPort(), result.getToPort());
    }


    @Test
    public void valid_InputResultSet_ShouldReturn_ExpectedSeaDist() throws SQLException {
        // Arrange
        Seadist expected = new Seadist(new Country("Portugal", ""), "Leixoes", new Country("Spain", ""), "Barcelona", 333.0f);

        when(mockResultSet.getString("FROM_COUNTRY")).thenReturn("Portugal");
        when(mockResultSet.getString("FROM_PORT")).thenReturn("Leixoes");
        when(mockResultSet.getString("TO_COUNTRY")).thenReturn("Spain");
        when(mockResultSet.getString("TO_PORT")).thenReturn("Barcelona");
        when(mockResultSet.getFloat("DISTANCE")).thenReturn(333.0f);

        // Act
        Seadist result = seadistsMapperImpl.mapSeadistFromDatabaseResultSet(mockResultSet);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getFromCountry().getName(), result.getFromCountry().getName());
        assertEquals(expected.getToCountry().getName(), result.getToCountry().getName());
        assertEquals(expected.getFromPort(), result.getFromPort());
        assertEquals(expected.getToPort(), result.getToPort());
        assertEquals(expected.getDistance(), result.getDistance());
    }
}
