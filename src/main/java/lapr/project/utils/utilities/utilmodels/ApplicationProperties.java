package lapr.project.utils.utilities.utilmodels;


/**
 * @author Group 169 LAPRIII
 */
public class ApplicationProperties {
    private final String databaseURL;
    private final String databaseUsername;
    private final String databasePassword;

    public String getDatabaseURL() {
        return databaseURL;
    }

    public String getDatabaseUsername() {
        return databaseUsername;
    }

    public String getDatabasePassword() {
        return databasePassword;
    }

    public ApplicationProperties(String databaseURL, String databaseUsername, String databasePassword) {
        this.databaseURL = databaseURL;
        this.databaseUsername = databaseUsername;
        this.databasePassword = databasePassword;
    }
}
