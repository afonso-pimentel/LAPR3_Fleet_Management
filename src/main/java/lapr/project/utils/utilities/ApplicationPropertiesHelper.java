package lapr.project.utils.utilities;

import lapr.project.utils.utilities.utilmodels.ApplicationProperties;
import java.io.IOException;

/**
 * @author Group 169 LAPRIII
 */
public interface ApplicationPropertiesHelper {

    /**
     * Gets the defined properties for the application
     * @return ApplicationProperties
     * @throws IOException
     */
    ApplicationProperties getApplicationProperties() throws IOException;
}
