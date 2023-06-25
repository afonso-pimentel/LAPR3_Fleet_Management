package lapr.project.stores.integration;

import lapr.project.mappers.CargoManifestMapper;
import lapr.project.mappers.CargoManifestMapperImpl;
import lapr.project.mappers.dtos.CargoManifestAvgDTO;
import lapr.project.stores.CargoManifestStore;
import lapr.project.stores.CargoManifestStoreImpl;
import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnection;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import org.junit.jupiter.api.Test;
import java.io.FileWriter;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;

public class CargoManifestStoreImplTest {
    private final CargoManifestStore cargoManifestStore;

    public CargoManifestStoreImplTest() throws IOException {
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection databaseConnection = new DatabaseConnectionImpl(applicationPropertiesHelper);
        CargoManifestMapper cargoManifestMapper = new CargoManifestMapperImpl();

        cargoManifestStore = new CargoManifestStoreImpl(databaseConnection,applicationPropertiesHelper,cargoManifestMapper);
    }


   /* @Test
    public void valid_CargoManifestAvgYear_ShouldExecute() throws IOException, SQLException {
        // Arrange
        FileReader fileReaderImpl = new FileReaderImpl();
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputQueryCargoManifestAvgYear.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_query_Cargo_Manifest_Average_Year.csv";
        String[] year = fileReaderImpl.readFile(filePathInput).get(0).split("/");

        //Act
        CargoManifestAvgDTO result = cargoManifestStore.getCargoManifestsAveragesYear(LocalDate.of(Integer.parseInt(year[2]),Integer.parseInt(year[1]),Integer.parseInt(year[0])));

        // Assert
        writeCargoManifestAvgYearOutputToFile(result, filePathOutput);
    }*/

    /*
    private void writeCargoManifestAvgYearOutputToFile(CargoManifestAvgDTO result, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();
        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("CargoManifestQty,ContainerAVG\n");
            fileOutputLine.append(result.getCargoManifestQty() + ",");
            fileOutputLine.append(result.getAvgContainerQty());

            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println((fileOutputLine.toString() + "\n").replace(","," | "));
        }
    }*/
}
