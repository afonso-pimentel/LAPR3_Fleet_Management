package lapr.project.services;

import lapr.project.model.Port;

import java.sql.Timestamp;

public interface PortService {

	/**
	 * @param callsign
	 * @param datetime
	 */
	Port getClosestPortToShipInGivenDate(String callsign, Timestamp datetime);

}
