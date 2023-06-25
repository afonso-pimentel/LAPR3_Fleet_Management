package lapr.project.utils.datastructures.integration;

import lapr.project.mappers.*;
import lapr.project.model.Country;
import lapr.project.utils.datastructures.*;
import lapr.project.utils.fileoperations.CsvFileParser;
import lapr.project.utils.fileoperations.CsvFileParserImpl;
import lapr.project.utils.fileoperations.FileReader;
import lapr.project.utils.fileoperations.FileReaderImpl;
import lapr.project.utils.utilities.ApplicationPropertiesHelper;
import lapr.project.utils.utilities.ApplicationPropertiesHelperImpl;
import lapr.project.utils.utilities.DatabaseConnection;
import lapr.project.utils.utilities.DatabaseConnectionImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeAll;
import java.io.IOException;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;


/**
 * @author Group 169 LAPRIII
 */
public class FreightNetworkDatabaseImplTests {
    private static FreightNetworkImpl freightNetworkImpl;
    private static Graph<FreightNetworkNode, Float> testFreightNetworkFromDatabase;

    /*
    //WARNING: THESE TESTS SHOULD ONLY BE UNCOMMENTED/EXECUTED FOR DEMONSTRATION PURPOSES OF
    //THE US 301 WHEN THERE IS AN AVAILABLE AND RELIABLE ORACLE SERVER. DUE TO NOT HAVING A STABLE ORACLE DATABASE SERVER, THIS TEST
    //WILL FAIL WHEN IT IS RUN ON THE PIPELINE OF JENKINS, THUS RESULTING IN A FAILED BUILD
    @BeforeAll
    public static void oneTimeSetUp() throws IOException, SQLException {
        SeadistsMapper seadistsMapper = new SeadistsMapperImpl();
        PortMapper portMapper = new PortMapperImpl();
        CapitalMapper capitalMapper = new CapitalMapperImpl();
        ApplicationPropertiesHelper applicationPropertiesHelper = new ApplicationPropertiesHelperImpl();
        DatabaseConnection databaseConnection = new DatabaseConnectionImpl(applicationPropertiesHelper);
        FileReader fileReader = new FileReaderImpl();
        CsvFileParser csvFileParser = new CsvFileParserImpl();

        FreightNetworkDataHandler freightNetworkDataAccess = new FreightNetworkDataHandlerImpl(capitalMapper, portMapper, seadistsMapper, fileReader, csvFileParser, databaseConnection, applicationPropertiesHelper);
        FreightNetworkLogic freightNetworkLogic = new FreightNetworkLogicImpl();

        freightNetworkImpl = new FreightNetworkImpl(freightNetworkDataAccess, freightNetworkLogic);
        freightNetworkImpl.initializeNetworkFromDatabase(5);
        testFreightNetworkFromDatabase = freightNetworkImpl.getFreightNetwork();
    }

    // Test Acceptance Criteria: The capital of a country has a direct connection with the capitals of the
    // countries with which it borders.
    @Test
    public void testAcceptanceCriteriaCapitalToBorderCapitalsConnection() throws IOException {
        // Arrange
        // Test data for case where country has multiple borders(e.g Argentina)
        CapitalNode argentinaStartingCapitalNode = new CapitalNode(0.0f, 0.0f, "Buenos Aires", new Country("Argentina", ""));
        CapitalNode expectedBoliviaCapitalNode = new CapitalNode(0.0f, 0.0f, "La Paz", new Country("Bolivia", ""));
        CapitalNode expectedBrazilCapitalNode = new CapitalNode(0.0f, 0.0f, "Brasilia", new Country("Brazil", ""));
        CapitalNode expectedChileCapitalNode = new CapitalNode(0.0f, 0.0f, "Santiago", new Country("Chile", ""));
        CapitalNode expectedParaguayCapitalNode = new CapitalNode(0.0f, 0.0f, "Asuncion", new Country("Paraguay", ""));
        CapitalNode expectedUruguayCapitalNode = new CapitalNode(0.0f, 0.0f, "Montevideo", new Country("Uruguay", ""));

        // Test data for case where country has only one border(e.g Portugal)
        CapitalNode portugalStartingCapitalNode = new CapitalNode(0.0f, 0.0f, "Lisbon", new Country("Portugal", ""));
        CapitalNode expectedSpainCapitalNode = new CapitalNode(0.0f, 0.0f, "Madrid", new Country("Spain", ""));

        // Assert
        Edge<FreightNetworkNode, Float> resultArgentinaBoliviaConnection = this.testFreightNetworkFromDatabase.edge(argentinaStartingCapitalNode, expectedBoliviaCapitalNode);
        Edge<FreightNetworkNode, Float> resultArgentinaBrazilConnection = this.testFreightNetworkFromDatabase.edge(argentinaStartingCapitalNode, expectedBrazilCapitalNode);
        Edge<FreightNetworkNode, Float> resultArgentinaChileConnection = this.testFreightNetworkFromDatabase.edge(argentinaStartingCapitalNode, expectedChileCapitalNode);
        Edge<FreightNetworkNode, Float> resultArgentinaParaguayConnection = this.testFreightNetworkFromDatabase.edge(argentinaStartingCapitalNode, expectedParaguayCapitalNode);
        Edge<FreightNetworkNode, Float> resultArgentinaUruguayConnection = this.testFreightNetworkFromDatabase.edge(argentinaStartingCapitalNode, expectedUruguayCapitalNode);

        Edge<FreightNetworkNode, Float> resultPortugalSpainConnection = this.testFreightNetworkFromDatabase.edge(portugalStartingCapitalNode, expectedSpainCapitalNode);

        assertNotNull(resultArgentinaBoliviaConnection);
        assertNotNull(resultArgentinaBrazilConnection);
        assertNotNull(resultArgentinaChileConnection);
        assertNotNull(resultArgentinaParaguayConnection);
        assertNotNull(resultArgentinaUruguayConnection);

        assertNotNull(resultPortugalSpainConnection);

        // Connection between Buenos Aires(Argentina) --> La Paz(Bolivia)
        assertEquals(((CapitalNode)resultArgentinaBoliviaConnection.getVOrig()).getCapitalName(), argentinaStartingCapitalNode.getCapitalName(), "Origin capital node should be Buenos Aires");
        assertEquals( ((CapitalNode)resultArgentinaBoliviaConnection.getVDest()).getCapitalName(), expectedBoliviaCapitalNode.getCapitalName(), "Destination capital node should be La Paz");
        assertEquals(2221.5652f, resultArgentinaBoliviaConnection.getWeight(), 1.0f, "Distance between Buenos Aires --> La Paz should be +/- 2221.5652 km's");

        // Connection between Buenos Aires(Argentina) --> Brasilia(Brazil)
        assertEquals(((CapitalNode)resultArgentinaBrazilConnection.getVOrig()).getCapitalName(), argentinaStartingCapitalNode.getCapitalName(), "Origin capital node should be Buenos Aires");
        assertEquals(((CapitalNode)resultArgentinaBrazilConnection.getVDest()).getCapitalName(), expectedBrazilCapitalNode.getCapitalName(), "Destination capital node should be Brasilia");
        assertEquals(2349.8936f, resultArgentinaBrazilConnection.getWeight(), 1.0f, "Distance between Buenos Aires --> Brasilia should be +/- 2349.8936 km's");

        // Connection between Buenos Aires(Argentina) --> Santiago(Chile)
        assertEquals( ((CapitalNode)resultArgentinaChileConnection.getVOrig()).getCapitalName(), argentinaStartingCapitalNode.getCapitalName(), "Origin capital node should be Buenos Aires");
        assertEquals( ((CapitalNode)resultArgentinaChileConnection.getVDest()).getCapitalName(), expectedChileCapitalNode.getCapitalName(), "Destination capital node should be Santiago");
        assertEquals(1112.4834f, resultArgentinaChileConnection.getWeight(), 1.0f, "Distance between Buenos Aires --> Santiago should be +/- 1112.4834 km's");

        // Connection between Buenos Aires(Argentina) --> Asuncion(Paraguay)
        assertEquals(((CapitalNode)resultArgentinaParaguayConnection.getVOrig()).getCapitalName(), argentinaStartingCapitalNode.getCapitalName(), "Origin capital node should be Buenos Aires");
        assertEquals( ((CapitalNode)resultArgentinaParaguayConnection.getVDest()).getCapitalName(), expectedParaguayCapitalNode.getCapitalName(), "Destination capital node should be Asuncion");
        assertEquals(1040.4191f, resultArgentinaParaguayConnection.getWeight(), 1.0f, "Distance between Buenos Aires --> Asuncion should be +/- 1040.4191 km's");

        // Connection between Buenos Aires(Argentina) --> Montevideo(Uruguay)
        assertEquals(((CapitalNode)resultArgentinaUruguayConnection.getVOrig()).getCapitalName(), argentinaStartingCapitalNode.getCapitalName(), "Origin capital node should be Buenos Aires");
        assertEquals( ((CapitalNode)resultArgentinaUruguayConnection.getVDest()).getCapitalName(), expectedUruguayCapitalNode.getCapitalName(),"Destination capital node should be Montevideo");
        assertEquals(230.40915f, resultArgentinaUruguayConnection.getWeight(), 1.0f, "Distance between Buenos Aires --> Montevideo should be +/- 230.40915 km's");

        // Connection between Lisbon(Portugal) --> Madrid(Spain)
        assertEquals(((CapitalNode)resultPortugalSpainConnection.getVOrig()).getCapitalName(), portugalStartingCapitalNode.getCapitalName(), "Origin capital node should be Lisbon");
        assertEquals( ((CapitalNode)resultPortugalSpainConnection.getVDest()).getCapitalName(), expectedSpainCapitalNode.getCapitalName(),"Destination capital node should be Madrid");
        assertEquals(503.20657f, resultPortugalSpainConnection.getWeight(), 1.0f, "Distance between Lisbon --> Madrid should be +/- 503.20657 km's");

        System.out.println("___________________________TEST CAPITAL CONNECTIONS WITH CAPITAL FROM BORDER COUNTRIES____________");
        System.out.println(resultArgentinaBoliviaConnection);
        System.out.println(resultArgentinaBrazilConnection);
        System.out.println(resultArgentinaChileConnection);
        System.out.println(resultArgentinaParaguayConnection);
        System.out.println(resultArgentinaUruguayConnection);
        System.out.println("___________________________________________________________________________________________________\n");

    }

    //Test Acceptance Criteria: The ports of a country should be connected with all the ports of the same country
    @Test
    public void testAcceptanceCriteriaPortConnectionToPortsWithinSameCountry() throws IOException {
        // Arrange
        // Test data for case where there is only 2 ports within the same country(e.g Argentina)
        PortNode originPortNodeArgentina = new PortNode(0.0f, 0.0f, "Bahia Blanca", new Country("Argentina", ""));
        PortNode destinationPortNodeArgentina = new PortNode(0.0f, 0.0f, "Buenos Aires", new Country("Argentina", ""));

        // Test data for case where there is more than 2 ports within the same country(e.g Portugal)
        PortNode originPortNodePortugal = new PortNode(0.0f, 0.0f, "Funchal", new Country("Portugal", ""));
        PortNode destinationPortNodePortugal1 = new PortNode(0.0f, 0.0f, "Leixoes", new Country("Portugal", ""));
        PortNode destinationPortNodePortugal2 = new PortNode(0.0f, 0.0f, "Setubal", new Country("Portugal", ""));
        PortNode destinationPortNodePortugal3 = new PortNode(0.0f, 0.0f, "Horta", new Country("Portugal", ""));

        // Assert
        Edge<FreightNetworkNode, Float> resultArgentinaBahiaAndBuenosAiresConnection = this.testFreightNetworkFromDatabase.edge(originPortNodeArgentina, destinationPortNodeArgentina);
        Edge<FreightNetworkNode, Float> resultPortugalFunchalAndLeixoesConnection = this.testFreightNetworkFromDatabase.edge(originPortNodePortugal, destinationPortNodePortugal1);
        Edge<FreightNetworkNode, Float> resultPortugalFunchalAndSetubalConnection = this.testFreightNetworkFromDatabase.edge(originPortNodePortugal, destinationPortNodePortugal2);
        Edge<FreightNetworkNode, Float> resultPortugalFunchalAndHortaConnection = this.testFreightNetworkFromDatabase.edge(originPortNodePortugal, destinationPortNodePortugal3);

        assertNotNull(resultArgentinaBahiaAndBuenosAiresConnection);
        assertNotNull(resultPortugalFunchalAndLeixoesConnection);
        assertNotNull(resultPortugalFunchalAndSetubalConnection);
        assertNotNull(resultPortugalFunchalAndHortaConnection);

        // Connection between Bahia Blanca --> Buenos Aires
        assertEquals(((PortNode)resultArgentinaBahiaAndBuenosAiresConnection.getVOrig()).getPortName(), originPortNodeArgentina.getPortName(), "Origin node should be Bahia Blanca");
        assertEquals(((PortNode)resultArgentinaBahiaAndBuenosAiresConnection.getVDest()).getPortName(), destinationPortNodeArgentina.getPortName(), "Destination node should be Buenos Aires");
        assertEquals(557f, resultArgentinaBahiaAndBuenosAiresConnection.getWeight(), 1.0f,"Distance between Bahia Blanca --> Buenos Aires should be +/- 557");

        // Connection between Funchal --> Leixoes
        assertEquals(((PortNode)resultPortugalFunchalAndLeixoesConnection.getVOrig()).getPortName(), originPortNodePortugal.getPortName(), "Origin node should be Funchal");
        assertEquals(((PortNode)resultPortugalFunchalAndLeixoesConnection.getVDest()).getPortName(), destinationPortNodePortugal1.getPortName(), "Destination node should be Leixoes");
        assertEquals(655f, resultPortugalFunchalAndLeixoesConnection.getWeight(), 1.0f,"Distance between Funchal --> Leixoes should be +/- 655");

        // Connection between Funchal --> Setubal
        assertEquals(((PortNode)resultPortugalFunchalAndSetubalConnection.getVOrig()).getPortName(), originPortNodePortugal.getPortName(), "Origin node should be Funchal");
        assertEquals(((PortNode)resultPortugalFunchalAndSetubalConnection.getVDest()).getPortName(), destinationPortNodePortugal2.getPortName(), "Destination node should be Setubal");
        assertEquals(536f, resultPortugalFunchalAndSetubalConnection.getWeight(), 1.0f,"Distance between Funchal --> Setubal should be +/- 536");

        // Connection between Funchal --> Horta
        assertEquals(((PortNode)resultPortugalFunchalAndHortaConnection.getVOrig()).getPortName(), originPortNodePortugal.getPortName(), "Origin node should be Funchal");
        assertEquals(((PortNode)resultPortugalFunchalAndHortaConnection.getVDest()).getPortName(), destinationPortNodePortugal3.getPortName(), "Destination node should be Horta");
        assertEquals(678f, resultPortugalFunchalAndHortaConnection.getWeight(), 1.0f,"Distance between Funchal --> Horta should be +/- 678");

        System.out.println("___________________________TEST PORTS OF COUNTRY CONNECT WITH PORTS FROM SAME COUNTRY____________");
        System.out.println(resultArgentinaBahiaAndBuenosAiresConnection);
        System.out.println(resultPortugalFunchalAndLeixoesConnection);
        System.out.println(resultPortugalFunchalAndSetubalConnection);
        System.out.println(resultPortugalFunchalAndHortaConnection);
        System.out.println("___________________________________________________________________________________________________\n");
    }


    //Test Acceptance Criteria: The port closest to the capital of the country connects with it.
    @Test
    public void testAcceptanceCriteriaConnectionClosestPortToCapital(){
        // Arrange
        // Test data for country where there is a port on the capital(e.g Denmark)
        CapitalNode denmarkCapitalNode = new CapitalNode(0.0f,0.0f, "Copenhagen", new Country("Denmark", ""));
        PortNode expectedPortNodeClosestToDenmarkCapital = new PortNode(0.0f, 0.0f, "Copenhagen", new Country("Denmark", ""));

        // Test data for country where there is no port on the capital(e.g Romania)
        CapitalNode romaniaCapitalNode = new CapitalNode(0.0f,0.0f, "Bucharest", new Country("Romania", ""));
        PortNode expectedPortNodeClosestToRomaniaCapital = new PortNode(0.0f, 0.0f, "Galatz", new Country("Romania", ""));

        // Test data for country where the nearest port is located on a border country(e.g Canada)
        CapitalNode canadaCapitalNode = new CapitalNode(0.0f,0.0f, "Ottawa", new Country("Canada", ""));
        PortNode expectedPortNodeClosestToCanadaCapital = new PortNode(0.0f, 0.0f, "New Jersey", new Country("United States Of America", ""));

        // Assert
        Edge<FreightNetworkNode, Float> resultDenmarkConnection = this.testFreightNetworkFromDatabase.edge(expectedPortNodeClosestToDenmarkCapital, denmarkCapitalNode);
        Edge<FreightNetworkNode, Float> resultRomaniaConnection = this.testFreightNetworkFromDatabase.edge(expectedPortNodeClosestToRomaniaCapital, romaniaCapitalNode);
        Edge<FreightNetworkNode, Float> resultCanadaConnection = this.testFreightNetworkFromDatabase.edge(expectedPortNodeClosestToCanadaCapital, canadaCapitalNode);

        assertNotNull(resultDenmarkConnection);
        assertNotNull(resultRomaniaConnection);
        assertNotNull(resultCanadaConnection);

        // Connection between Port of Copenhagen --> Capital Copenhagen
        assertEquals(((PortNode)resultDenmarkConnection.getVOrig()).getPortName(), expectedPortNodeClosestToDenmarkCapital.getPortName(), "Origin node should be Port of Copenhagen");
        assertEquals(((CapitalNode)resultDenmarkConnection.getVDest()).getCapitalName(), denmarkCapitalNode.getCapitalName(), "Destination node should be Capital of Denmark: Copenhagen");
        assertEquals(4.254908, resultDenmarkConnection.getWeight(), 1.0f,"Distance between Port of Copenhagen --> Capital Copenhagen should be +/- 4.254908");

        // Connection between Port of Galatz --> Capital Bucharest
        assertEquals(((PortNode)resultRomaniaConnection.getVOrig()).getPortName(), expectedPortNodeClosestToRomaniaCapital.getPortName(), "Origin node should be Port of Galatz");
        assertEquals(((CapitalNode)resultRomaniaConnection.getVDest()).getCapitalName(), romaniaCapitalNode.getCapitalName(), "Destination node should be Capital of Romania: Bucharest");
        assertEquals(190.61447f, resultRomaniaConnection.getWeight(), 1.0f,"Distance between Port of Galatz --> Capital Bucharest should be +/- 190.61447");

        // Connection between Port of New Jersey --> Capital Ottawa
        assertEquals(((PortNode)resultCanadaConnection.getVOrig()).getPortName(), expectedPortNodeClosestToCanadaCapital.getPortName(), "Origin node should be Port of New Jersey");
        assertEquals(((CapitalNode)resultCanadaConnection.getVDest()).getCapitalName(), canadaCapitalNode.getCapitalName(), "Destination node should be Capital of Canada: Ottawa");
        assertEquals(542.64624f, resultCanadaConnection.getWeight(), 1.0f,"Distance between Port of New Jersey --> Capital Ottawa should be +/- 542.64624");

        System.out.println("___________________________TEST CLOSEST PORT TO CAPITAL CONNECTION____________");
        System.out.println(resultDenmarkConnection);
        System.out.println(resultRomaniaConnection);
        System.out.println(resultCanadaConnection);
        System.out.println("_______________________________________________________________________________\n");
    }


    //Test Acceptance Criteria: Each port of a country connects with the n closest ports of any other country.
    @Test
    public void testAcceptanceCriteriaConnectionPortToNClosestPorts(){
        // Arrange
        // Test data for case where there is one close port from another country(e.g Spain)
        PortNode originPortNodeSpain = new PortNode(0.0f, 0.0f, "Valencia", new Country("Spain", ""));
        PortNode destinationPortNodeSpainBarcelona = new PortNode(0.0f, 0.0f, "Barcelona", new Country("Spain", ""));
        PortNode destinationPortNodeMonacoMonaco = new PortNode(0.0f, 0.0f, "Monaco", new Country("Monaco", ""));

        // Test data for case where there is more than one close port from another country and from multiple countries(e.g Canada)
        PortNode originPortNodeCanada = new PortNode(0.0f, 0.0f, "Halifax", new Country("Canada", ""));
        PortNode destinationPortNodeUSANewJersey = new PortNode(0.0f, 0.0f, "New Jersey", new Country("United States of America", ""));
        PortNode destinationPortNodePortugalHorta = new PortNode(0.0f, 0.0f, "Horta", new Country("Portugal", ""));
        PortNode destinationPortNodePortugalPontaDelgada = new PortNode(0.0f, 0.0f, "Ponta Delgada", new Country("Portugal", ""));

        // Assert
        Edge<FreightNetworkNode, Float> resultValenciaAndBarcelonaConnection = this.testFreightNetworkFromDatabase.edge(originPortNodeSpain, destinationPortNodeSpainBarcelona);
        Edge<FreightNetworkNode, Float> resultValenciaAndMonacoConnection = this.testFreightNetworkFromDatabase.edge(originPortNodeSpain, destinationPortNodeMonacoMonaco);

        Edge<FreightNetworkNode, Float> resultHalifaxAndNewJerseyConnection = this.testFreightNetworkFromDatabase.edge(originPortNodeCanada, destinationPortNodeUSANewJersey);
        Edge<FreightNetworkNode, Float> resultHalifaxAndHortaConnection = this.testFreightNetworkFromDatabase.edge(originPortNodeCanada, destinationPortNodePortugalHorta);
        Edge<FreightNetworkNode, Float> resultHalifaxAndPontaDelgadaConnection = this.testFreightNetworkFromDatabase.edge(originPortNodeCanada, destinationPortNodePortugalPontaDelgada);

        assertNotNull(resultValenciaAndBarcelonaConnection);
        assertNotNull(resultValenciaAndMonacoConnection);

        assertNotNull(resultHalifaxAndNewJerseyConnection);
        assertNotNull(resultHalifaxAndHortaConnection);
        assertNotNull(resultHalifaxAndPontaDelgadaConnection);

        // Connection between Port of Valencia --> Port of Barcelona
        assertEquals(((PortNode)resultValenciaAndBarcelonaConnection.getVOrig()).getPortName(), originPortNodeSpain.getPortName(), "Origin node should be Valencia");
        assertEquals(((PortNode)resultValenciaAndBarcelonaConnection.getVDest()).getPortName(), destinationPortNodeSpainBarcelona.getPortName(), "Destination node should be Barcelona");
        assertEquals(164.0f, resultValenciaAndBarcelonaConnection.getWeight(), 1.0f,"Distance between Valencia --> Barcelona should be +/- 164.0");

        // Connection between Port of Valencia --> Port of Monaco
        assertEquals(((PortNode)resultValenciaAndMonacoConnection.getVOrig()).getPortName(), originPortNodeSpain.getPortName(), "Origin node should be Valencia");
        assertEquals(((PortNode)resultValenciaAndMonacoConnection.getVDest()).getPortName(), destinationPortNodeMonacoMonaco.getPortName(), "Destination node should be Monaco");
        assertEquals( 431.0f, resultValenciaAndMonacoConnection.getWeight(), 1.0f,"Distance between Valencia --> Monaco should be +/-  431.0");

        // Connection between Port of Halifax --> Port of New Jersey
        assertEquals(((PortNode)resultHalifaxAndNewJerseyConnection.getVOrig()).getPortName(), originPortNodeCanada.getPortName(), "Origin node should be Halifax");
        assertEquals(((PortNode)resultHalifaxAndNewJerseyConnection.getVDest()).getPortName(), destinationPortNodeUSANewJersey.getPortName(), "Destination node should be New Jersey");
        assertEquals( 600.0f, resultHalifaxAndNewJerseyConnection.getWeight(), 1.0f,"Distance between Halifax --> New Jersey should be +/-  600.0");

        // Connection between Port of Halifax --> Port of Horta
        assertEquals(((PortNode)resultHalifaxAndHortaConnection.getVOrig()).getPortName(), originPortNodeCanada.getPortName(), "Origin node should be Halifax");
        assertEquals(((PortNode)resultHalifaxAndHortaConnection.getVDest()).getPortName(), destinationPortNodePortugalHorta.getPortName(), "Destination node should be Horta");
        assertEquals( 1609.0f, resultHalifaxAndHortaConnection.getWeight(), 1.0f,"Distance between Halifax --> Horta should be +/-  1609.0");

        // Connection between Port of Halifax --> Port of Ponta Delgada
        assertEquals(((PortNode)resultHalifaxAndPontaDelgadaConnection.getVOrig()).getPortName(), originPortNodeCanada.getPortName(), "Origin node should be Halifax");
        assertEquals(((PortNode)resultHalifaxAndPontaDelgadaConnection.getVDest()).getPortName(), destinationPortNodePortugalPontaDelgada.getPortName(), "Destination node should be Ponta Delgada");
        assertEquals( 1754.0f, resultHalifaxAndPontaDelgadaConnection.getWeight(), 1.0f,"Distance between Halifax --> Ponta Delgada should be +/-  1754.0");
    }

    @Test
    public void printGraph(){
        System.out.println("___________________________DATABASE GRAPH VERTICES____________");
        for(FreightNetworkNode vertice : this.testFreightNetworkFromDatabase.vertices()){
            System.out.println(vertice);
        }
        System.out.println("______________________________________________________\n\n");

        System.out.println("___________________________DATABASE GRAPH EDGES______________");
        for(Edge<FreightNetworkNode, Float> edge : this.testFreightNetworkFromDatabase.edges()){
            System.out.println(edge);
        }
        System.out.println("______________________________________________________");
    }*/
}
