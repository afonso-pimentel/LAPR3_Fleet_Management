package lapr.project.stores.integration;

import lapr.project.mappers.ContainerMapper;
import lapr.project.mappers.ContainerMapperImpl;
import lapr.project.mappers.dtos.ContainerSituationDTO;
import lapr.project.mappers.dtos.ContainerToLoadOnPortDTO;
import lapr.project.mappers.dtos.ContainerWithNextPortDTO;
import lapr.project.stores.ContainerStoreImpl;
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
import java.util.List;

public class ContainerStoreImplTest {
    private final ContainerStoreImpl containerStoreImpl;

    public ContainerStoreImplTest() throws IOException {
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection databaseConnection = new DatabaseConnectionImpl(applicationPropertiesHelper);
        ContainerMapper containerMapper = new ContainerMapperImpl();

        containerStoreImpl = new ContainerStoreImpl(databaseConnection, applicationPropertiesHelper, containerMapper);
    }
    /*
    @Test
    public void valid_containerIdentifier_ShouldExecute() throws SQLException, IOException, SQLException {
        // Arrange
        FileReader fileReaderImpl = new FileReaderImpl();
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputQueryContainerSituation.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_query_container_situation.csv";
        String expectedContainerIdentifier = fileReaderImpl.readFile(filePathInput).get(0);

        //Act
        ContainerSituationDTO result = containerStoreImpl.getContainerCurrentSituation(expectedContainerIdentifier);

        // Assert
        writeContainerSituationOutputToFile(result, filePathOutput);
    }

    private void writeContainerSituationOutputToFile(ContainerSituationDTO containerSituationDTO, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();

        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("LocationName, LocationType\n");

            fileOutputLine.append(containerSituationDTO.getLocationName()+ ",");
            fileOutputLine.append(containerSituationDTO.getLocationType());

            myWriter.write(fileOutputLine.toString() + "\n");
            System.out.println(fileOutputLine.toString() + "\n");
        }
    }*/

//
//    @Test
//    public void valid_MMSI_ShouldExecute() throws SQLException, IOException, SQLException {
//        // Arrange
//        FileReader fileReaderImpl = new FileReaderImpl();
//        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputQueryContainersToUnloadNextPort.csv";
//        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_query_containers_to_unload_next_port.csv";
//        int expectedShipIdentifier = Integer.parseInt((fileReaderImpl.readFile(filePathInput).get(0)));
//
//
//        //Act
//        List<ContainerWithNextPortDTO> result = containerStoreImpl.getContainersToBeOffloadedNextPort(expectedShipIdentifier);
//
//        // Assert
//        writeContainersToUnloadNextPortOutputToFile(result, filePathOutput);
//    }
//
//    private void writeContainersToUnloadNextPortOutputToFile(List<ContainerWithNextPortDTO> result, String newFilePath) {
//        StringBuilder fileOutputLine = new StringBuilder();
//
//        try (FileWriter myWriter = new FileWriter(newFilePath)){
//            myWriter.write("CONTAINER_ID, PAYLOAD, CARGOSITE_NAME, CARGOSITE_TYPE, CONTAINER_TYPE, CONTAINER_POSITION\n");
//
//            for (ContainerWithNextPortDTO containerUnload:result) {
//
//                fileOutputLine.append(containerUnload.getIdContainer()+ ",");
//                fileOutputLine.append(containerUnload.getPayload()+ ",");
//                fileOutputLine.append(containerUnload.getCargoSiteName()+ ",");
//                fileOutputLine.append(containerUnload.getCargoSiteType()+ ",");
//                fileOutputLine.append(containerUnload.getType()+ ",");
//                fileOutputLine.append(containerUnload.getXyzPosition());
//                myWriter.write(fileOutputLine.toString() + "\n");
//                System.out.println(fileOutputLine.toString() + "\n");
//                fileOutputLine = new StringBuilder();
//            }
//
//            } catch (IOException e) {
//        }
//    }
//
//
//    @Test
//    public void valid_MMSI_ShouldExecuteUnload() throws SQLException, IOException, SQLException {
//        // Arrange
//        FileReader fileReaderImpl = new FileReaderImpl();
//        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputQueryContainersToLoadNextPort.csv";
//        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/output_query_containers_to_unload_next_port.csv";
//        int expectedShipIdentifier = Integer.parseInt((fileReaderImpl.readFile(filePathInput).get(0)));
//
//        //Act
//        List<ContainerToLoadOnPortDTO> result = containerStoreImpl.getContainersToBeLoadedNextPort(expectedShipIdentifier);
//
//        // Assert
//        writeContainersToLoadNextPortOutputToFile(result, filePathOutput);
//    }
//
//    private void writeContainersToLoadNextPortOutputToFile(List<ContainerToLoadOnPortDTO> result, String newFilePath) {
//        StringBuilder fileOutputLine = new StringBuilder();
//
//        try (FileWriter myWriter = new FileWriter(newFilePath)){
//            myWriter.write("CONTAINER_ID, PAYLOAD, CARGOSITE_NAME, CARGOSITE_TYPE, CONTAINER_TYPE, COUNTRY\n");
//
//            for (ContainerToLoadOnPortDTO containerload:result) {
//
//                fileOutputLine.append(containerload.getIdContainer()+ ",");
//                fileOutputLine.append(containerload.getPayload()+ ",");
//                fileOutputLine.append(containerload.getCargoSiteName()+ ",");
//                fileOutputLine.append(containerload.getCargoSiteType()+ ",");
//                fileOutputLine.append(containerload.getType()+ ",");
//                fileOutputLine.append(containerload.getCountry());
//                myWriter.write(fileOutputLine.toString() + "\n");
//                System.out.println(fileOutputLine.toString() + "\n");
//                fileOutputLine = new StringBuilder();
//            }
//
//        } catch (IOException e) {
//        }
//    }

}
