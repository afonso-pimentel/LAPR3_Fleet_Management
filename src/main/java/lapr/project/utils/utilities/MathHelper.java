package lapr.project.utils.utilities;

import java.sql.Timestamp;

/**
 * @author Group 169 LAPRIII
 */
public class MathHelper {

    private MathHelper(){}

    /**
     * Calculates the distance between 2 coordinates points and returns distance in kms
     * @param latitude1 Point 1 latitude
     * @param longitude1 Point 1 longitude
     * @param latitude2 Point 2 latitude
     * @param longitude2 Point 2 longitude
     * @return returns a float with the distance in kms
     */
    public static float calculateDistanceBetweenCoordinates(float latitude1, float longitude1, float latitude2, float longitude2){
        if ((latitude1== 91) || (latitude2==91) || (longitude1==181) || (longitude2==181))
            throw new IllegalArgumentException("Coordinates are not valid for calculation, ship position should probably be not available");

        final int R = 6371; // Radius of the earth
        double latDistance = Math.toRadians( latitude2 -  latitude1);
        double lonDistance = Math.toRadians(longitude2 - longitude1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(latitude1)) * Math.cos(Math.toRadians(latitude2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = R * c; // convert to kms
        distance = Math.pow(distance, 2);

        return (float) Math.sqrt(distance);
    }

    public static long calculateDifferenceInMinutes(Timestamp dateOne, Timestamp dateTwo){
        long differenceInTime = dateOne.getTime() - dateTwo.getTime();
        return Math.abs((differenceInTime / (1000 * 60)) % 60);
    }
}
