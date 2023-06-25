package lapr.project.mappers;

import lapr.project.model.Country;
import lapr.project.utils.datastructures.CapitalNode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;


/**
 * @author Group 169 LAPRIII
 */
public class CapitalMapperImplTest {
    @Mock
    private ResultSet mockResultSet;
    private CapitalMapperImpl capitalMapperImpl;

    public CapitalMapperImplTest(){
        capitalMapperImpl = new CapitalMapperImpl();
    }

    @BeforeEach
    public void createMocks() {
        MockitoAnnotations.openMocks(this);
        capitalMapperImpl = new CapitalMapperImpl();
    }

    @Test
    public void valid_CsvContent_ShouldReturn_ExpectedCapitalNode(){
        // Arrange
        CapitalNode expected = new CapitalNode(35.16666667f, 33.366667f, "Nicosia", new Country("Cyprus", "Europe"));

        String capital1 = "Europe,CY,CYP,Cyprus,0.85,Nicosia,35.16666667,33.366667";

        // Act
        CapitalNode result = capitalMapperImpl.mapCapitalNodeFromCsvContent(Arrays.asList(capital1.split(",")));

        // Assert
        assertNotNull(result);
        assertEquals(expected.getLatitude(), result.getLatitude());
        assertEquals(expected.getLongitude(), result.getLongitude());
        assertEquals(expected.getCapitalName(), result.getCapitalName());
        assertEquals(expected.getCountry().getName(), result.getCountry().getName());
        assertEquals(expected.getCountry().getContinent(), result.getCountry().getContinent());
    }

    @Test
    public void valid_InputResultSet_ShouldReturn_ExpectedCapitalNode() throws SQLException {
        // Arrange
        CapitalNode expected = new CapitalNode(35.16666667f, 33.366667f, "Barcelona", new Country("Spain", "Europe"));

        when(mockResultSet.getFloat("LATITUDE")).thenReturn(35.16666667f);
        when(mockResultSet.getFloat("LONGITUDE")).thenReturn(33.366667f);
        when(mockResultSet.getString("CAPITAL_NAME")).thenReturn("Barcelona");
        when(mockResultSet.getString("COUNTRY")).thenReturn("Spain");
        when(mockResultSet.getString("CONTINENT")).thenReturn("Europe");

        // Act
        CapitalNode result = capitalMapperImpl.mapCapitalNodeFromDatabaseResultSet(mockResultSet);

        // Assert
        assertNotNull(result);
        assertEquals(expected.getLatitude(), result.getLatitude());
        assertEquals(expected.getLongitude(), result.getLongitude());
        assertEquals(expected.getCapitalName(), result.getCapitalName());
        assertEquals(expected.getCountry().getName(), result.getCountry().getName());
        assertEquals(expected.getCountry().getContinent(), result.getCountry().getContinent());
    }
}
