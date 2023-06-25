package lapr.project.stores;

import lapr.project.mappers.dtos.ContainerSituationDTO;
import lapr.project.mappers.dtos.ContainerToLoadOnPortDTO;
import lapr.project.mappers.dtos.ContainerWithNextPortDTO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface ContainerStore {
    /**
     * Gets the current cargo site name and type where the specified container is
     * @param containerIdentifier Identifier of the container
     * @return ContainerSituationDTO
     * @throws SQLException
     * @throws IOException
     */
    ContainerSituationDTO getContainerCurrentSituation(String containerIdentifier) throws SQLException, IOException;

    List<ContainerWithNextPortDTO> getContainersToBeOffloadedNextPort(int mmsi) throws SQLException, IOException;

    /**
     * Gets the list of container to be loaded in the next port given a ship MMSI
     * @param mmsi
     * @return ContainerWithNextPortDTO
     * @throws SQLException
     * @throws IOException
     */
    List<ContainerToLoadOnPortDTO> getContainersToBeLoadedNextPort(int mmsi) throws SQLException, IOException;


}
