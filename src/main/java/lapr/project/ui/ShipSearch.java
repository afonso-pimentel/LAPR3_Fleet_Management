package lapr.project.ui;

import lapr.project.model.Ship;
import lapr.project.model.ShipCharacteristics;
import lapr.project.stores.ShipStoreImpl;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ShipSearch {

    ShipStoreImpl shipstore;

    public ShipSearch(ShipStoreImpl shipstore) {
        this.shipstore = shipstore;
    }

    public ShipSearch() {
        this.shipstore = null;
    }


    /**
     *
     * @param mmsi
     *
     * Calls the getShips method in ShipStoreImpl
     * which returns an AVL of ships created by the MMSI.
     * Then it uses the find method from the AVL to
     * find a Node when given an object of the type Ship.
     * Even though the ship_mmsi is an empty ship with only
     * the MMSI code, it will match with a given ship because its
     * compareTo method only compares the MMSI code.
     *
     * @return Returns the found ship.
     */
    public Ship shipSearchByMMSI(int mmsi){
        if(mmsi<100000000)
            throw new IllegalArgumentException("Invalid MMSI. Under the standard of 9 digits.");

        if(mmsi>999999999)
            throw new IllegalArgumentException("Invalid MMSI. Over the standard of 9 digits.");

        return shipstore.getShips().find(new Ship(-1,mmsi,null,null,-1, new ShipCharacteristics( -1,-1,
                                                 null,-1,-1,-1,-1),null));
    }

    /**
     *
     * @param imo
     *
     * Calls the getShipsIMO method in ShipStoreImpl
     * which returns an AVL of ships created by the IMO.
     * Then it uses the find method from the AVL to
     * find a Node when given an object of the type Ship.
     * Even though the ship_imo is an empty ship with only
     * the IMO code, it will match with a given ship because its
     * compareTo method only compares the IMO code.
     *
     * @return Returns the found ship.
     */
    public Ship shipSearchByIMO(int imo){
        if(imo<1000000)
            throw new IllegalArgumentException("Invalid IMO. Under the standard of 7 digits.");

        if(imo>9999999)
            throw new IllegalArgumentException("Invalid IMO. Over the standard of 7 digits.");

        return shipstore.getShipsIMO().find(new Ship(-1,-1,null,null,imo,new ShipCharacteristics(-1,-1,
                                                    null,-1,-1,-1,-1),null));
    }

    /**
     *
     * @param callsign
     *
     * Calls the getShipsCallSign method in ShipStoreImpl
     * which returns an AVL of ships created by the CallSign.
     * Then it uses the find method from the AVL to
     * find a Node when given an object of the type Ship.
     * Even though the ship_callsign is an empty ship with only
     * the CallSign, it will match with a given ship because its
     * compareTo method only compares the CallSign.
     *
     * @return Returns the found ship.
     */
    public Ship shipSearchByCallSign(String callsign){
        if(callsign==null)
            throw new IllegalArgumentException("Invalid Call Sign. It can not be null.");

        Pattern p = Pattern.compile("[^a-z0-9 ]", Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(callsign);

        if(m.find())
            throw new IllegalArgumentException("Invalid Call Sign. Code isn't alphanumeric.");

        return shipstore.getShipsCallSign().find(new Ship(-1,-1,callsign,null,-1,new ShipCharacteristics(-1,-1,
                                        null,-1,-1,-1,-1),null));
    }
}
