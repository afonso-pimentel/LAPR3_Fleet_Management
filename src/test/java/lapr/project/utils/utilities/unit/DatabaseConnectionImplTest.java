package lapr.project.utils.utilities.unit;

import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import lapr.project.utils.utilities.utilmodels.ApplicationProperties;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.BDDMockito.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class DatabaseConnectionImplTest {
    @Mock
    private ResultSet mockResultSet;
    @Mock
    private PreparedStatement mockPreparedStatement;
    @Mock
    private Connection mockConnection;
    @Mock
    private ApplicationPropertiesHelper mockApplicationPropertiesHelper;
    @Mock
    private ApplicationProperties mockApplicationProperties;

    private final DatabaseConnectionImpl databaseConnectionImpl;

    public DatabaseConnectionImplTest() throws IOException {
        databaseConnectionImpl = new DatabaseConnectionImpl(new ApplicationPropertiesHelperImpl());
    }

    @Test
    public void invalid_NullArgument_ShouldThrow_IllegalArgumentException(){
        // Arrange
        ApplicationPropertiesHelper nullArgument = null;

        // Act & Assert
        assertThrowsExactly(IllegalArgumentException.class, () -> new DatabaseConnectionImpl(nullArgument));
    }

    @Test
    public void valid_Arguments_ShouldNotThrow_Exceptions() throws IOException {
        // Arrange
        ApplicationPropertiesHelper validArgument = new ApplicationPropertiesHelperImpl();

        // Act & Assert
        assertDoesNotThrow(() -> new DatabaseConnectionImpl(validArgument));
    }

    @Test
    public void valid_NullConnection_ShouldNotThrow_Exceptions(){
        // Arrange
        Connection nullConnection = null;

        // Act & Assert
        assertDoesNotThrow(() -> databaseConnectionImpl.closeConnection(nullConnection));
    }

    @Test
    public void valid_NullResultSet_ShouldNotThrow_Exceptions() {
        // Arrange
        ResultSet nullResultSet = null;

        // Act & Assert
        assertDoesNotThrow(() -> databaseConnectionImpl.closeResultSet(nullResultSet));
    }

    @Test
    public void valid_NullPreparedStatement_ShouldNotThrow_Exceptions() {
        // Arrange
        PreparedStatement nullPreparedStatement = null;

        // Act & Assert
        assertDoesNotThrow(() -> databaseConnectionImpl.closePreparedStatement(nullPreparedStatement));
    }

    @Test
    public void valid_MockResultSet_ShouldThrow_Exception_WhenMockedResult_IsClosed() throws SQLException {
        // Arrange
        willAnswer( invocation -> { throw new UnsupportedOperationException("Tried to close ResultSet of mocked object"); }).given(mockResultSet).close();

        // Act & Assert
        assertThrowsExactly(UnsupportedOperationException.class, () -> databaseConnectionImpl.closeResultSet(mockResultSet));
    }

    @Test
    public void valid_MockPreparedStatement_ShouldThrow_Exception_WhenMockedPreparedStatement_IsClosed() throws SQLException {
        // Arrange
        willAnswer( invocation -> { throw new UnsupportedOperationException("Tried to close PreparedStatement of mocked object"); }).given(mockPreparedStatement).close();

        // Act & Assert
        assertThrowsExactly(UnsupportedOperationException.class, () -> databaseConnectionImpl.closePreparedStatement(mockPreparedStatement));
    }

    @Test
    public void valid_MockConnection_ShouldThrow_Exception_WhenMockedConnection_IsClosed() throws SQLException {
        // Arrange
        willAnswer( invocation -> { throw new UnsupportedOperationException("Tried to close Connection of mocked object"); }).given(mockConnection).close();

        // Act & Assert
        assertThrowsExactly(UnsupportedOperationException.class, () -> databaseConnectionImpl.closeConnection(mockConnection));
    }

    @Test
    public void valid_CloseDatabaseResources_ShouldExecuteAndCloseResources() throws SQLException {
        // Act
        databaseConnectionImpl.closeDatabaseResources(mockConnection, mockResultSet, mockPreparedStatement);

        // Act & Assert
        verify(mockConnection, times(1)).close();
        verify(mockResultSet, times(1)).close();
        verify(mockPreparedStatement, times(1)).close();
    }

    @Test
    public void valid_DatabaseConnectionArguments_ShouldExecuteAndCallOracleSetUrl() throws IOException {
        // Arrange
        DatabaseConnectionImpl databaseConnection = new DatabaseConnectionImpl(mockApplicationPropertiesHelper);
        when(mockApplicationPropertiesHelper.getApplicationProperties()).thenReturn(mockApplicationProperties);
        willAnswer( invocation -> { throw new UnsupportedOperationException("Tried to get application properties of URL of mocked object"); }).given(mockApplicationProperties).getDatabaseURL();

        // Act & Assert
        assertThrowsExactly(UnsupportedOperationException.class, () -> databaseConnection.getConnection());
    }
}
