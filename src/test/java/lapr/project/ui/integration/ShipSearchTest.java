package lapr.project.ui.integration;

import lapr.project.mappers.ShipMapperImpl;
import lapr.project.model.PositionData;
import lapr.project.model.Ship;
import lapr.project.model.ShipIMO;
import lapr.project.stores.ShipStoreImpl;
import lapr.project.ui.ShipSearch;
import lapr.project.utils.datastructures.AVL;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import org.junit.jupiter.api.Test;

import java.io.FileWriter;
import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ShipSearchTest {
    private ShipStoreImpl shipStoreImpl;
    private FileReaderImpl fileReaderImpl;
    private ShipMapperImpl shipMapperImpl;
    private CsvFileParserImpl csvFileParserImpl;
    private ShipSearch shipSearch;

    /**
     * Constructor for the Test
     *
     */
    public ShipSearchTest() throws ParseException, IOException {
        shipMapperImpl = new ShipMapperImpl();
        fileReaderImpl = new FileReaderImpl();
        csvFileParserImpl = new CsvFileParserImpl();
        shipStoreImpl = new ShipStoreImpl(shipMapperImpl, new DatabaseConnectionImpl(new ApplicationPropertiesHelperImpl()));
        shipSearch = new ShipSearch(shipStoreImpl);
        String filePath = System.getProperty("user.dir") + "/src/test/resources/sships.csv";
        List<String> fileContent = fileReaderImpl.readFile(filePath);
        List<List<String>> csvParsedFileContent = csvFileParserImpl.parseToCsv(fileContent);
        shipStoreImpl.importShipsFromCsv(csvParsedFileContent);
    }

    /**
     *
     * @throws IOException
     * @throws ParseException
     *
     * Imports ships and searches for the ship by MMSI
     *
     */
    @Test
    public void valid_MMSIInputContent_ShouldReturn_Ship() throws IOException, ParseException {
        // Arrange
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputMMSISearchTest.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/outputMMSISearchTest.csv";
        String mmsi_search = fileReaderImpl.readFile(filePathInput).get(0);

        int expected_mmsi = Integer.parseInt(mmsi_search);

        //Act
        Ship result = shipSearch.shipSearchByMMSI(Integer.parseInt(mmsi_search));
        writeFoundShipDetailsInOutputFile(result, filePathOutput);
        int result_mmsi = result.getMmsi();

        //Assert
        assertEquals(expected_mmsi,result_mmsi);

    }

    /**
     *
     * @throws IOException
     * @throws ParseException
     *
     * Imports ships and searches for the ship by IMO
     *
     */
    @Test
    public void valid_IMOInputContent_ShouldReturn_Ship() throws IOException, ParseException {
         // Arrange
            String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputImoTest.csv";
            String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/outputImoTest.csv";
            String imo_search = fileReaderImpl.readFile(filePathInput).get(0);

            int expected_imo = Integer.parseInt(imo_search);

            //Act
            Ship result = shipSearch.shipSearchByIMO(Integer.parseInt(imo_search));
            writeFoundShipDetailsInOutputFile(result, filePathOutput);
            int result_imo = result.getImoNumber();

            //Assert
            assertEquals(expected_imo,result_imo);

    }

    /**
     *
     * @throws IOException
     * @throws ParseException
     *
     * Imports ships and searches for the ship by callsign
     *
     */
    @Test
    public void valid_CallSignInputContent_ShouldReturn_Ship() throws IOException, ParseException {
        // Arrange
        String filePathInput = System.getProperty("user.dir") + "/src/test/resources/input/inputCallSignTest.csv";
        String filePathOutput = System.getProperty("user.dir") + "/src/test/resources/output/outputCallSignTest.csv";
        String expected_callsign = fileReaderImpl.readFile(filePathInput).get(0);

        //Act
        Ship result = shipSearch.shipSearchByCallSign(expected_callsign);
        writeFoundShipDetailsInOutputFile(result, filePathOutput);
        String result_callsign = result.getCallSign();

        //Assert
        assertEquals(expected_callsign, result_callsign);
    }
    /**
     *
     * @param ship
     * @param newFilePath
     * @throws IOException
     *
     * Exports the found ship to a file.
     *
     */
    private void writeFoundShipDetailsInOutputFile(Ship ship, String newFilePath) throws IOException {
        StringBuilder fileOutputLine = new StringBuilder();
        try (FileWriter myWriter = new FileWriter(newFilePath)){
            myWriter.write("MMSI,BaseDateTime,LAT,LON,SOG,COG,Heading,VesselName,IMO,CallSign,VesselType,Length,Width,Draft,Cargo,TranscieverClass\n");
                for(PositionData positionData: ship.getPositionsData().inOrder()){
                    fileOutputLine.append(ship.getMmsi()+ ",");
                    fileOutputLine.append(positionData.getDateTimeReceived()+ ",");
                    fileOutputLine.append(positionData.getLatitude()+ ",");
                    fileOutputLine.append(positionData.getLatitude()+ ",");
                    fileOutputLine.append(positionData.getPositionDataVelocity().getSog()+ ",");
                    fileOutputLine.append(positionData.getPositionDataVelocity().getCog() + ",");
                    fileOutputLine.append(positionData.getHeading() + ",");
                    fileOutputLine.append(ship.getName() + ",");
                    fileOutputLine.append("IMO" + ship.getImoNumber() + ",");
                    fileOutputLine.append(ship.getCallSign() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getVessalType() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getLength() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getWidth() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getDraft() + ",");
                    fileOutputLine.append(ship.getShipCharacteristics().getCapacity() + ",");
                    fileOutputLine.append(positionData.getTransceiverClass() + ",");

                    myWriter.write(fileOutputLine.toString() + "\n");
                    System.out.println(fileOutputLine.toString() + "\n");

                    fileOutputLine = new StringBuilder();
                }
            }
        }
    }

