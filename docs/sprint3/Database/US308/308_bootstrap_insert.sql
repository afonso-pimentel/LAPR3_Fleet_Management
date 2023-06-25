declare
    vShipTransTypeID           number;
    vPortCargoSiteTypeID       number;
    vShipTransportID           number;
    vRoleID                    NUMBER;
    vPlatformUserID            NUMBER;
    vACargositeID              number;
    vBCargositeID              number;
    vCCargositeID              number;
    vLoadCargoManifestTypeID   number;
    vUnloadCargoManifestTypeID number;
    vACargoManifestID          number; -- full capacity
    vBCargoManifestID          number; -- 2 out of 5 capacity
    vCCargoManifestID          number; -- cargo manifest B plus 3 = full capacity
    vXCargoManifestID          number;
    vYCargoManifestID          number;
    vZCargoManifestID          number;
    vAContainerID              number;
    vBContainerID              number;
    vCContainerID              number;
    vDContainerID              number;
    vEContainerID              number;
    vFContainerID              number;
    vGContainerID              number;
    vHContainerID              number;
    vIContainerID              number;
    vJContainerID              number;

BEGIN

    --     get ship transport type id
    SELECT TRANSPORTTYPE.ID INTO vShipTransTypeID FROM TRANSPORTTYPE WHERE TRANSPORTTYPE.DESCRIPTION = 'Ship';
        --     get cargosite type id
    SELECT CARGOSITETYPE.ID INTO vPortCargoSiteTypeID FROM CARGOSITETYPE WHERE CARGOSITETYPE.DESCRIPTION = 'Port';

--     create a new ship
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', vShipTransTypeID) returning id into vShipTransportID;
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (vShipTransportID, 999999999, 'Fishy', 'US308_Ship', 9999999, 5, 100, 15, 100, 10, 5, 6);



--     insert three ports
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE, CONTAINERCAPACITY, SHIPCAPACITY, TRUCKCAPACITY)
    values ('US308_Port_A', 50, 50, 'Portugal', vPortCargoSiteTypeID, 10, 10, 10)
    returning id into vACargositeID;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE, CONTAINERCAPACITY, SHIPCAPACITY, TRUCKCAPACITY)
    values ('US308_Port_B', 50, 50, 'Portugal', vPortCargoSiteTypeID, 10, 10, 10)
    returning id into vBCargositeID;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE, CONTAINERCAPACITY, SHIPCAPACITY, TRUCKCAPACITY)
    values ('US308_Port_C', 50, 50, 'Portugal', vPortCargoSiteTypeID, 10, 10, 10)
    returning id into vCCargositeID;

    SELECT CARGOMANIFESTTYPE.ID
    INTO vLoadCargoManifestTypeID
    FROM CARGOMANIFESTTYPE
    WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Load';

    SELECT CARGOMANIFESTTYPE.ID
    INTO vUnloadCargoManifestTypeID
    FROM CARGOMANIFESTTYPE
    WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Unload';

--     insert three cargo manifest of type load
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vACargositeID, vBCargositeID, vLoadCargoManifestTypeID, NULL, NULL,
            TO_DATE('15/01/2022', 'dd/MM/yyyy'), TO_DATE('20/01/2022', 'dd/MM/yyyy'))
    returning id into vACargoManifestID;

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vACargositeID, vBCargositeID, vLoadCargoManifestTypeID, NULL, NULL,
            TO_DATE('20/01/2022', 'dd/MM/yyyy'), TO_DATE('29/01/2022', 'dd/MM/yyyy'))
    returning id into vBCargoManifestID;

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vACargositeID, vBCargositeID, vLoadCargoManifestTypeID, NULL, NULL,
            TO_DATE('22/01/2022', 'dd/MM/yyyy'), TO_DATE('29/01/2022', 'dd/MM/yyyy'))
    returning id into vCCargoManifestID;

    --     insert three cargo manifest of type unload
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vACargositeID, vBCargositeID, vUnloadCargoManifestTypeID, NULL, NULL,
            TO_DATE('15/01/2022', 'dd/MM/yyyy'), TO_DATE('20/01/2022', 'dd/MM/yyyy'))
    returning id into vXCargoManifestID;

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vACargositeID, vBCargositeID, vUnloadCargoManifestTypeID, NULL, NULL,
            TO_DATE('20/01/2022', 'dd/MM/yyyy'), TO_DATE('29/01/2022', 'dd/MM/yyyy'))
    returning id into vYCargoManifestID;

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vACargositeID, vBCargositeID, vUnloadCargoManifestTypeID, NULL, NULL,
            TO_DATE('22/01/2022', 'dd/MM/yyyy'), TO_DATE('29/01/2022', 'dd/MM/yyyy'))
    returning id into vZCargoManifestID;

--     insert Containers 10 containers
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTA', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vAContainerID;

    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTB', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vBContainerID;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTC', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vCContainerID;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTD', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vDContainerID;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTE', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vEContainerID;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTF', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vFContainerID;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTG', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vGContainerID;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTH', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vHContainerID;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTI', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vIContainerID;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE,
                           IDCSC)
    VALUES ('US308_CONTJ', '22G1', 20000, 2000, 16.1, TO_DATE('22/01/2024', 'dd/MM/yyyy'), 4.00, 'temporary isCsc')
    RETURNING id INTO vJContainerID;



--     get client role
    SELECT ROLE.ID INTO vRoleID FROM ROLE WHERE ROLE.DESCRIPTION = 'Client';

--     create a new platformUser
    insert into PLATFORMUSER (USERNAME, PASSWORD, DESCRIPTION, IDROLE)
    values('sprint3_user', 'password', 'description', vRoleID) returning ID into vPlatformUserID;


    --     insert cargoManifest lines (loading)

--     first 5 out of 5, full capacity from A to B (15-20)
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vAContainerID, vACargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vBContainerID, vACargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vCContainerID, vACargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vDContainerID, vACargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vEContainerID, vACargoManifestID, 20000, 10, 10, 10, vPlatformUserID);

    --     second 3 out of 5, from B to C (20-29)
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vFContainerID, vBCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vGContainerID, vBCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vHContainerID, vBCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);

    --     third 5 out of 5, full capacity from C to A (22-29)
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vIContainerID, vCCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vJContainerID, vCCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);


    --     insert cargoManifest lines (unloading)

--     first 5 out of 5, full capacity from A to B (15-20)
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vAContainerID, vXCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vBContainerID, vXCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vCContainerID, vXCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vDContainerID, vXCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vEContainerID, vXCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);

    --     second 3 out of 5, from B to C (20-29)
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vFContainerID, vYCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vGContainerID, vYCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vHContainerID, vYCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);

    --     third 5 out of 5, full capacity from C to A (22-29)
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vIContainerID, vZCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);
    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition, IDLEASINGCLIENT)
    VALUES (vJContainerID, vZCargoManifestID, 20000, 10, 10, 10, vPlatformUserID);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || vAContainerID);
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        ROLLBACK;
END;
