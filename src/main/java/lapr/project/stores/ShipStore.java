package lapr.project.stores;

import lapr.project.mappers.dtos.ShipAvailableDTO;
import lapr.project.model.Ship;
import lapr.project.utils.datastructures.AVL;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface ShipStore {
    /**
     * Imports ships data from the content of a csv file
     * @param csvParsedFileContent CSV parsed content has a matrix of strings
     * @throws ParseException
     */
    void importShipsFromCsv(List<List<String>> csvParsedFileContent) throws ParseException;

    /**
     * Gets stored ships ordered by MMSI
     * @return AVL Tree containing ships ordered by MMSI
     */
    AVL<Ship> getShips();

    /**
     * Gets a ship by it's MMSI code
     * @param shipMMSI Ship MMSI Code
     * @return Ship
     */
    Ship getShipByMMSI(int shipMMSI);
    /**
     * Gets stored ships ordered by IMO
     * @return AVL Tree containing ships ordered by IMO
     */
    AVL<Ship> getShipsIMO();

    /**
     * Gets stored ships ordered by CalLSign
     * @return AVL Tree containing ships ordered by CallSign
     */
    AVL<Ship> getShipsCallSign();

    /**
     * Gets a list of available ships next week
     * @return List of available ships for next week
     * @throws SQLException
     * @throws IOException
     */
    List<ShipAvailableDTO> getAvailableShipsNextWeek() throws SQLException, IOException;

    /**
     *
     * @param shipID Ship ID
     * @param cargoManifestID CargoManifestID of that ship
     * @return return float value with % of occupancyRate
     * @throws IOException
     * @throws SQLException
     */
    float occupancyRate(int shipID, int cargoManifestID) throws IOException, SQLException;

    /**
     *
     * @param shipID Ship ID
     * @param moment moment DateTime of a moment
     * @return return float value with % of occupancy rate
     * @throws IOException
     * @throws SQLException
     */
    float getOccupancyRateAtGivenMoment(int shipID, LocalDate moment) throws IOException, SQLException;
}
