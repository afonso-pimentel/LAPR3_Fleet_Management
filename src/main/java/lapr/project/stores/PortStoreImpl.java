package lapr.project.stores;

import lapr.project.mappers.PortMapper;
import lapr.project.model.Port;
import lapr.project.utils.datastructures.KdNode;
import lapr.project.utils.datastructures.KdTree;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Group 169 LAPRIII
 */
public class PortStoreImpl implements PortStore {

    private final KdTree<Port> portKdTree;
    private final PortMapper portMapper;

    /**
     * Constructor for PortStoreImpl
     *
     * @param portMapper
     */
    public PortStoreImpl(PortMapper portMapper) {
        this.portKdTree = new KdTree<>();
        if (portMapper == null)
            throw new IllegalArgumentException("shipMapper argument cannot be null");

        this.portMapper = portMapper;
    }


    /**
     * {@inheritdoc}
     */
    @Override
    public void importPortsFromCsv(List<List<String>> csvParsedFileContent) throws ParseException {
        if (csvParsedFileContent == null)
            throw new IllegalArgumentException("csvParsedFileContent argument cannot be null");

        List<Port> ports = portMapper.mapPortFromCsvContent(csvParsedFileContent);
        List<KdNode<Port>> portNodes = PortStoreImpl.portsToNodes(ports);

        portKdTree.buildTree(portNodes);

    }

    /**
     * {@inheritdoc}
     */
    @Override
    public KdTree<Port> getPorts() {
        return portKdTree;
    }

    /**
     * Converts Ports list to a KdNode List
     *
     * @param ports
     * @return
     */
    public static List<KdNode<Port>> portsToNodes(List<Port> ports) {
        List<KdNode<Port>> nodes = new ArrayList<>();

        for (Port port : ports) {
            KdNode<Port> node = new KdNode<>(port, port.getLongitude(), port.getLatitude());
            nodes.add(node);
        }
        return nodes;
    }
}
