-- MAIN FUNCTION FOR US405. THIS FUNCTION EXECUTES EVERYTHING TO OBTAIN THE RESULT FOR THE US
CREATE OR REPLACE FUNCTION US405(IN_SHIP_MMSI NUMBER, IN_START_DATE DATE, IN_END_DATE DATE) RETURN DECIMAL
AS BEGIN
DECLARE
    IN_OUT_CARGOMANIFESTS_CURSOR  SYS_REFCURSOR;
    SUM_OCCUPANCYRATE NUMBER := 0;
    OUT_OCCUPANCYRATE NUMBER := 0;
    CURSOR_CARGOMANIFEST_ID NUMBER := 0;
    CURSOR_SIZE NUMBER := 0;
BEGIN

    GET_CARGOMANIFESTS_FORSPECIFICSHIP_ONSPECIFICDATE_INTERVAL(IN_SHIP_MMSI, IN_START_DATE, IN_END_DATE, IN_OUT_CARGOMANIFESTS_CURSOR);

    LOOP
        FETCH IN_OUT_CARGOMANIFESTS_CURSOR INTO CURSOR_CARGOMANIFEST_ID;
        EXIT WHEN IN_OUT_CARGOMANIFESTS_CURSOR%NOTFOUND;
        -- GET OCCUPANCY RATE FOR CURRENT CARGOMANIFEST ON CURSOR
        GET_OCCUPANCYRATE(IN_SHIP_MMSI, CURSOR_CARGOMANIFEST_ID, OUT_OCCUPANCYRATE);

        -- KEEP UPDATING CURSOR TOTAL SIZE TO GET TOTAL NUMBER OF CARGOMANFESTS
        CURSOR_SIZE := IN_OUT_CARGOMANIFESTS_CURSOR%rowcount;

         -- KEEP UPDATING TOTAL OCCUPANCY RATE WITH OCCUPANCY RATE OF CURRENT CARGOMANIFEST ON THE CURSOR
        SUM_OCCUPANCYRATE := SUM_OCCUPANCYRATE + OUT_OCCUPANCYRATE;

    END LOOP;
    CLOSE IN_OUT_CARGOMANIFESTS_CURSOR;

    IF SUM_OCCUPANCYRATE != 0 AND CURSOR_SIZE != 0 THEN
        RETURN SUM_OCCUPANCYRATE / CURSOR_SIZE;
    ELSE
        RETURN 0;
    END IF;

END;
END;
