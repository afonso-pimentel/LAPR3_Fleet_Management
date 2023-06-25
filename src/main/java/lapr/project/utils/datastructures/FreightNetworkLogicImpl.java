package lapr.project.utils.datastructures;

import lapr.project.model.Country;
import lapr.project.utils.utilities.MathHelper;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author Group 169 LAPRIII
 */
public class FreightNetworkLogicImpl implements FreightNetworkLogic{

    /**
     * {@inheritdoc}
     */
    @Override
    public void addCapitalConnectionToCapitalsFromBorderCountries(HashMap<Country, CapitalNode> importedCapitalNodes, HashMap<Country, List<Country>> borders, Graph<FreightNetworkNode, Float> freightNetworkGraph){
        for (Map.Entry<Country, List<Country>> pair: borders.entrySet()) {
            CapitalNode originCapitalNode = importedCapitalNodes.get(pair.getKey());

            List<Country> originCapitalCountryBorders = pair.getValue();

            for(Country country : originCapitalCountryBorders){
                CapitalNode destinationCapitalNode = importedCapitalNodes.get(country);

                float distanceBetweenCapitals = MathHelper.calculateDistanceBetweenCoordinates(originCapitalNode.getLatitude(), originCapitalNode.getLongitude(),
                        destinationCapitalNode.getLatitude(), destinationCapitalNode.getLongitude());

                freightNetworkGraph.addEdge(originCapitalNode, destinationCapitalNode,distanceBetweenCapitals);
            }
        }
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void addPortConnectionToPortsFromSameCountry(HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes,  HashMap<PortNodeInfo, TreeSet<Seadist>> seadists, Graph<FreightNetworkNode,Float> freightNetworkGraph){
        for (Map.Entry<Country, HashMap<PortNodeInfo, PortNode>> importedNodesByCountry: importedPortNodes.entrySet()) {

            for(Map.Entry<PortNodeInfo, PortNode> importedPort : importedNodesByCountry.getValue().entrySet()){
                TreeSet<Seadist> seaDistsToCurrentPort = seadists.get(importedPort.getKey());

                if(seaDistsToCurrentPort != null){
                    Iterator<Seadist> iterator = seaDistsToCurrentPort.iterator();

                    while (iterator.hasNext()){
                        Seadist currentSeadist = iterator.next();
                        Country importedPortCountry = importedPort.getValue().getCountry();
                        PortNode connectionNode = null;

                        // Check to see if the current seadist is a seadist between the same country
                        if(currentSeadist.getFromCountry().equals(importedPortCountry) && currentSeadist.getToCountry().equals(importedPortCountry)){

                            if(currentSeadist.getToPort().equals(importedPort.getValue().getPortName())){
                                connectionNode = importedPortNodes.get(importedPortCountry).get(new PortNodeInfo(currentSeadist.getFromPort()));
                            }else{
                                connectionNode = importedPortNodes.get(importedPortCountry).get(new PortNodeInfo(currentSeadist.getToPort()));
                            }

                            freightNetworkGraph.addEdge(importedPort.getValue(), connectionNode, currentSeadist.getDistance());
                        }
                    }
                }
            }
        }
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void addClosestPortToCapitalConnection(HashMap<Country, CapitalNode> importedCapitalNodes, HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes, HashMap<Country, List<Country>> borders, Graph<FreightNetworkNode,Float> freightNetworkGraph){
        for (Map.Entry<Country, CapitalNode> capitalNodePair: importedCapitalNodes.entrySet()) { // for each capital imported
            CapitalNode currentCapital = capitalNodePair.getValue();

            List<Country> listOfCountriesToSearchForClosestPort = new ArrayList<>();
            listOfCountriesToSearchForClosestPort.add(capitalNodePair.getKey());

            // Get list of border countries to use for search the closest port on border countries
            List<Country> listOfBorderCountries = borders.get(capitalNodePair.getKey());

            if(listOfBorderCountries != null)
                listOfCountriesToSearchForClosestPort.addAll(borders.get(capitalNodePair.getKey()));

            calculateAndAddClosestPortToCapital(importedPortNodes, listOfCountriesToSearchForClosestPort, currentCapital, freightNetworkGraph);
        }
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public void addPortConnectionToNClosestPorts(int numberOfClosestPortsToConnectTo, HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes, HashMap<PortNodeInfo, TreeSet<Seadist>> seadists, Graph<FreightNetworkNode,Float>freightNetworkGraph){
        for(Map.Entry<Country, HashMap<PortNodeInfo,PortNode>> importedPorts : importedPortNodes.entrySet()){

            for(Map.Entry<PortNodeInfo,PortNode> importedPortByCountry : importedPorts.getValue().entrySet()){
                List<Seadist> topNSeadDistsToImportedPort = seadists.get(new PortNodeInfo(importedPortByCountry.getValue().getPortName())).stream().limit(numberOfClosestPortsToConnectTo).collect(Collectors.toList());

                for(Seadist seadist : topNSeadDistsToImportedPort){
                    PortNode connectionNode = null;

                    if(seadist.getToPort().equals(importedPortByCountry.getValue().getPortName())){
                        connectionNode = importedPortNodes.get(seadist.getFromCountry()) == null ? null : importedPortNodes.get(seadist.getFromCountry()).get(new PortNodeInfo(seadist.getFromPort()));
                    }else{
                        connectionNode = importedPortNodes.get(seadist.getToCountry()) == null ? null : importedPortNodes.get(seadist.getToCountry()).get(new PortNodeInfo(seadist.getToPort()));
                    }

                    if(connectionNode != null)
                        freightNetworkGraph.addEdge(importedPortByCountry.getValue(), connectionNode, seadist.getDistance());

                }
            }
        }
    }

    private void calculateAndAddClosestPortToCapital(HashMap<Country, HashMap<PortNodeInfo, PortNode>> importedPortNodes, List<Country> listOfCountriesToSearchForClosestPort, CapitalNode currentCapital, Graph<FreightNetworkNode,Float> freightNetworkGraph){
        PortNode closestPortNodeToCapital = null;
        float closestDistanceBetweenPortNodeAndCapital = Float.MAX_VALUE;

        for(Country countryWithNearbyPorts : listOfCountriesToSearchForClosestPort){ // for each country that contains nearby ports
            HashMap<PortNodeInfo, PortNode> portsFromCountry = importedPortNodes.get(countryWithNearbyPorts);

            if(portsFromCountry != null){ //Validate if input data is coherent
                for(Map.Entry<PortNodeInfo, PortNode> portNodeFromCountry : portsFromCountry.entrySet()){ // for each port for the current country

                    Float distanceBetweenCapitalAndBorderPortNode = MathHelper
                            .calculateDistanceBetweenCoordinates
                                    (currentCapital.getLatitude(), currentCapital.getLongitude(),
                                            portNodeFromCountry.getValue().getLatitude(), portNodeFromCountry.getValue().getLongitude());

                    if(distanceBetweenCapitalAndBorderPortNode <= closestDistanceBetweenPortNodeAndCapital){
                        closestDistanceBetweenPortNodeAndCapital = distanceBetweenCapitalAndBorderPortNode;
                        closestPortNodeToCapital = portNodeFromCountry.getValue();
                    }
                }
            }
        }

        if(closestPortNodeToCapital != null) //Validate if input data is coherent
            freightNetworkGraph.addEdge(closestPortNodeToCapital, currentCapital, closestDistanceBetweenPortNodeAndCapital);
    }
}
