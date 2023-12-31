CREATE OR REPLACE PROCEDURE GET_CARGOMANIFESTS_FORSPECIFICSHIP_ONSPECIFICDATE_INTERVAL(IN_SHIP_MMSI NUMBER, IN_START_DATE DATE, IN_END_DATE DATE, IN_OUT_CARGOMANIFESTS_CURSOR IN OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN IN_OUT_CARGOMANIFESTS_CURSOR FOR
        SELECT CARGOMANIFEST.ID FROM CARGOMANIFEST
        INNER JOIN TRANSPORT ON TRANSPORT.ID = CARGOMANIFEST.IDTRANSPORT
        INNER JOIN SHIP on SHIP.IDTRANSPORT = TRANSPORT.ID
        INNER JOIN CARGOMANIFESTTYPE ON CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID
        WHERE SHIP.MMSI = IN_SHIP_MMSI
        AND DATESTART BETWEEN IN_START_DATE AND IN_END_DATE -- FILTER BY CARGOMANIFEST'S THAT STARTED WITHIN THE DATE RANGE PROVIDED
        AND DATEFINISH BETWEEN IN_START_DATE AND IN_END_DATE -- FILTER BY CARGOMANIFEST'S THAT FINISHED WITHIN THE DATE RANGE PROVIDED
        AND CARGOMANIFESTTYPE.DESCRIPTION = 'Load'; -- FILTER BY CARGOMANIFEST'S OF TYPE LOAD, THEREFORE ONLY ACCOUNT FOR CARGOMANIFEST'S THAT REQUIRE A SHARE OF THE SHIP'S CAPACITY;
END;
