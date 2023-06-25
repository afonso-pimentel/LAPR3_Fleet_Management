declare
    vShipTransTypeID         TRANSPORTTYPE.ID%TYPE;
    vPortCargoSiteTypeID     CARGOSITE.ID%TYPE;
    vShipTransportID         TRANSPORT.ID%TYPE;
    vCargoSiteIDA            CARGOSITE.ID%TYPE;
    vCargoSiteIDB            CARGOSITE.ID%TYPE;
    vLoadCargoManifestTypeID CARGOMANIFESTTYPE.ID%TYPE;


BEGIN
    --     get ship transport type id
    SELECT TRANSPORTTYPE.ID INTO vShipTransTypeID FROM TRANSPORTTYPE WHERE TRANSPORTTYPE.DESCRIPTION = 'Ship';
    --     get cargosite type id
    SELECT CARGOSITETYPE.ID INTO vPortCargoSiteTypeID FROM CARGOSITETYPE WHERE CARGOSITETYPE.DESCRIPTION = 'Port';

--     create a new ship
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', vShipTransTypeID) returning id into vShipTransportID;
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (vShipTransportID, 309999999, 'Fishy_309', 'US309_Ship', 3099999, 5, 100, 15, 100, 10, 5, 6);



-- insert cargo manifest of type load
    SELECT CARGOSITE.ID INTO vCargoSiteIDA FROM CARGOSITE WHERE CARGOSITE.NAME = 'Barcelona';
    SELECT CARGOSITE.ID INTO vCargoSiteIDB FROM CARGOSITE WHERE CARGOSITE.NAME = 'London';
    SELECT CARGOMANIFESTTYPE.ID    INTO vLoadCargoManifestTypeID

-- load
    FROM CARGOMANIFESTTYPE    WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Load';


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vCargoSiteIDA, vCargoSiteIDB, vLoadCargoManifestTypeID, NULL, NULL,
            TO_DATE('05/01/2022', 'dd/MM/yyyy'), TO_DATE('20/01/2022', 'dd/MM/yyyy'));

        SELECT CARGOMANIFESTTYPE.ID    INTO vLoadCargoManifestTypeID
    FROM CARGOMANIFESTTYPE    WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Unload';

-- unload
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vCargoSiteIDA, vCargoSiteIDB, vLoadCargoManifestTypeID, NULL, NULL,
            TO_DATE('05/01/2022', 'dd/MM/yyyy'), TO_DATE('20/01/2022', 'dd/MM/yyyy'));

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        ROLLBACK;
END;
