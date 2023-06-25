package lapr.project.utils.utilities;

import lapr.project.utils.utilities.utilmodels.ApplicationProperties;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * @author Group 169 LAPRIII
 */
public class ApplicationPropertiesHelperImpl implements ApplicationPropertiesHelper {
    private ApplicationProperties applicationProperties;

    public ApplicationPropertiesHelperImpl() throws IOException {
        initializeApplicationPropertiesHelper();
    }

    /**
     * {@inheritdoc}
     */
    public ApplicationProperties getApplicationProperties() throws IOException {
        return applicationProperties;
    }

    private void initializeApplicationPropertiesHelper() throws IOException {
        Properties properties = new Properties(System.getProperties());

        InputStream inputStream = getClass().getClassLoader().getResourceAsStream
                ("application.properties");
        properties.load(inputStream);

        String databaseURL = properties.getProperty("database.url");
        String databaseUsername = properties.getProperty("database.username");
        String databasePassword = properties.getProperty("database.password");

        applicationProperties = new ApplicationProperties(databaseURL, databaseUsername, databasePassword);
    }
}
