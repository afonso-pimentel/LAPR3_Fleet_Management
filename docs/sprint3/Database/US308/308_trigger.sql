CREATE OR REPLACE TRIGGER CHECK_SHIP_CAPACITY_BEFORE_INSERT_MANIFESTLINE
    BEFORE INSERT
    ON CARGOMANIFESTLINE
    FOR EACH ROW
DECLARE

    vShipMMSI               SHIP.MMSI%TYPE;
    vShipName               SHIP.NAME%TYPE;
    vShipCapacity           SHIP.CAPACITY%TYPE;
    vShipTransportID        SHIP.IDTRANSPORT%TYPE;
    vCargoManifestDateStart CARGOMANIFEST.DATESTARTESTIMATED%TYPE;
    vCargoManifestType      CARGOMANIFESTTYPE.DESCRIPTION%TYPE;
    vShipContainerQty       NUMBER;

BEGIN

    select SHIP.MMSI,
           SHIP.NAME,
           SHIP.CAPACITY,
           SHIP.IDTRANSPORT,
           CARGOMANIFESTTYPE.DESCRIPTION,
           CARGOMANIFEST.DATESTARTESTIMATED
    into vShipMMSI, vShipName, vShipCapacity, vShipTransportID, vCargoManifestType, vCargoManifestDateStart
    from CARGOMANIFEST
             inner join SHIP on SHIP.IDTRANSPORT = CARGOMANIFEST.IDTRANSPORT
             inner join CARGOMANIFESTTYPE on CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID
    where CARGOMANIFEST.ID = :NEW.IDCARGOMANIFEST;


    SELECT (containerLoad.count - containerUnload.count)
    INTO vShipContainerQty
    FROM (select COUNT(*) as count
          from CARGOMANIFEST
                   inner join CARGOMANIFESTLINE on CARGOMANIFEST.ID = CARGOMANIFESTLINE.IDCARGOMANIFEST
                   INNER JOIN CARGOMANIFESTTYPE ON CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID

          where CARGOMANIFESTTYPE.DESCRIPTION = 'Load'
            and CARGOMANIFEST.IDTRANSPORT = vShipTransportID
            and CARGOMANIFEST.DATEFINISH IS NULL
            and vCargoManifestDateStart between CARGOMANIFEST.DATESTARTESTIMATED and CARGOMANIFEST.DATEFINISHESTIMATED) containerLoad,

         (select COUNT(*) as count
          from CARGOMANIFEST
                   inner join CARGOMANIFESTLINE on CARGOMANIFEST.ID = CARGOMANIFESTLINE.IDCARGOMANIFEST
                   INNER JOIN CARGOMANIFESTTYPE ON CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID

          where CARGOMANIFESTTYPE.DESCRIPTION = 'Unload'
            and CARGOMANIFEST.IDTRANSPORT = vShipTransportID
            and vCargoManifestDateStart between CARGOMANIFEST.DATESTARTESTIMATED and CARGOMANIFEST.DATEFINISHESTIMATED
            and CARGOMANIFEST.DATEFINISHESTIMATED <= vCargoManifestDateStart) containerUnload;


    IF (vShipCapacity - vShipContainerQty = 0 AND vCargoManifestType = 'Load')
    THEN
        RAISE_APPLICATION_ERROR(-20308,
                                'Ship capacity full. - The Ship with MMSI ' || vShipMMSI || ' and Name ' || vShipName ||
                                ' has a rate of occupancy of ' || vShipContainerQty || '/' || vShipCapacity ||
                                ' in the date of ' || vCargoManifestDateStart);
    END IF;

    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);

END;

