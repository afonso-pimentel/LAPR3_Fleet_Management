package lapr.project.stores;

import lapr.project.model.Port;
import lapr.project.utils.datastructures.KdTree;
import java.text.ParseException;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public interface PortStore {

    /**
     * Imports Ports data from the content of a csv file
     * @param csvParsedFileContent CSV parsed content has a matrix of strings
     * @throws ParseException
     */
    void importPortsFromCsv(List<List<String>> csvParsedFileContent) throws ParseException;


    /**
     * Gets stored Ports ordered by longitude/latitude
     * @return KD-Tree containing Ports ordered by longitude/latitude
     */
    KdTree<Port> getPorts();


}
