package lapr.project.model;

import java.sql.Timestamp;

/**
 * @author Group 169 LAPRIII
 */
public class PositionData implements Comparable<PositionData> {
    private final long idShip;
    private final Timestamp dateTimeReceived;
    private final float latitude;
    private final float longitude;
    private final int heading;
    private final int position;
    private final char transceiverClass;
    private final PositionDataVelocity positionDataVelocity;

    /**
     * Constructor for PositionData object
     * @param shipIdTransport
     * @param dateTimeReceived
     * @param latitude
     * @param longitude
     * @param heading
     * @param position
     * @param transceiverClass
     */
    public PositionData(long shipIdTransport, Timestamp dateTimeReceived, float latitude, float longitude, PositionDataVelocity positionDataVelocity, int heading, int position, char transceiverClass) {
        if(dateTimeReceived == null)
            throw new IllegalArgumentException("DateTimeReceived argument cannot be null");

        this.idShip = shipIdTransport;
        this.dateTimeReceived = (Timestamp)dateTimeReceived.clone();
        this.latitude = latitude;
        this.longitude = longitude;
        this.heading = heading;
        this.position = position;
        this.positionDataVelocity = positionDataVelocity;
        this.transceiverClass = transceiverClass;
    }

    /**
     * Gets the velocity metrics for the position data
     * @return
     */
    public PositionDataVelocity getPositionDataVelocity() {
        return positionDataVelocity;
    }

    /**
     * Gets the ship Transport ID
     * @return long
     */
    public long getIdShip() {
        return idShip;
    }

    /**
     * Gets the DateTime this message was received at
     * @return TimeStamp
     */
    public Timestamp getDateTimeReceived() {
        return (Timestamp) dateTimeReceived.clone();
    }

    /**
     * Gets the ships latitude
     * @return float
     */
    public float getLatitude() {
        return latitude;
    }

    /**
     * Gets the ships longitude
     * @return float
     */
    public float getLongitude() {
        return longitude;
    }

    /**
     * Gets the ships Heading
     * @return float
     */
    public int getHeading() {
        return heading;
    }

    /**
     * Gets the ships Position
     * @return float
     */
    public int getPosition() {
        return position;
    }

    /**
     * Gets the ships TransceiverClass
     * @return float
     */
    public char getTransceiverClass() {
        return transceiverClass;
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public int compareTo(PositionData o) {
        return this.dateTimeReceived.compareTo(o.getDateTimeReceived());
    }

    /**
     * {@inheritdoc}
     */
    @Override
    public boolean equals(Object o) {
        if (o instanceof PositionData)
            return ((PositionData) o).getDateTimeReceived().getTime() == this.getDateTimeReceived().getTime();
        return false;
    }

    @Override
    public int hashCode(){
        return (int) Math.abs(Math.sqrt(this.getDateTimeReceived().getTime()));
    }
}
