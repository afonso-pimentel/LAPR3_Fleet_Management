DECLARE
    IN_SHIP_MMSI  NUMBER;
    IN_START_DATE DATE;
    IN_END_DATE  DATE;
    OUT_AVERAGE_OCCUPANCY_RATE DECIMAL;

BEGIN
    IN_SHIP_MMSI := 210950000;
    IN_START_DATE := TO_DATE('01/01/2020', 'DD/MM/YYYY');
    IN_END_DATE := TO_DATE('12/12/2021', 'DD/MM/YYYY');

    OUT_AVERAGE_OCCUPANCY_RATE := US405(IN_SHIP_MMSI, IN_START_DATE, IN_END_DATE);
     DBMS_OUTPUT.PUT_LINE('AVERAGE OCCUPANCY RATE FOR SHIP WITH MMSI ' || IN_SHIP_MMSI || ' IN THE TIME PERIOD OF ' || TO_CHAR (IN_START_DATE,
'YYYY-MM-DD')  ||  '/' ||  TO_CHAR (IN_END_DATE, 'YYYY-MM-DD') || ' is ' || OUT_AVERAGE_OCCUPANCY_RATE || '%');
END;