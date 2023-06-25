package lapr.project.stores;

import lapr.project.mappers.dtos.CargoManifestAvgDTO;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

/**
 * @author Group 169 LAPRIII
 */
public interface CargoManifestStore {
    /**
     *
     * Communicates with Database in order to return cargoManifest's quantity and container average of a given year
     * @param year chosen year
     * @return cargoManifestAvgDTO object with the averages of a given Year
     */
    CargoManifestAvgDTO getCargoManifestsAveragesYear(LocalDate year) throws SQLException, IOException;
}
