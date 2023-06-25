-- insert 50 containers

-- insert transports and trucks and ships
declare
    vContainerID01            NUMBER;
    vContainerID02            NUMBER;
    vContainerID03            NUMBER;
    vContainerID04            NUMBER;
    vContainerID05            NUMBER;
    vContainerID06            NUMBER;
    vContainerID07            NUMBER;
    vContainerID08            NUMBER;
    vContainerID09            NUMBER;
    vContainerID10            NUMBER;
    vContainerID11            NUMBER;
    vContainerID12            NUMBER;
    vContainerID13            NUMBER;
    vContainerID14            NUMBER;
    vContainerID15            NUMBER;
    vContainerID16            NUMBER;
    vContainerID17            NUMBER;
    vContainerID18            NUMBER;
    vContainerID19            NUMBER;
    vContainerID20            NUMBER;
    vContainerID21            NUMBER;
    vContainerID22            NUMBER;
    vContainerID23            NUMBER;
    vContainerID24            NUMBER;
    vContainerID25            NUMBER;
    vContainerID26            NUMBER;
    vContainerID27            NUMBER;
    vContainerID28            NUMBER;
    vContainerID29            NUMBER;
    vContainerID30            NUMBER;
    vContainerID31            NUMBER;
    vContainerID32            NUMBER;
    vContainerID33            NUMBER;
    vContainerID34            NUMBER;
    vContainerID35            NUMBER;
    vContainerID36            NUMBER;
    vContainerID37            NUMBER;
    vContainerID38            NUMBER;
    vContainerID39            NUMBER;
    vContainerID40            NUMBER;
    vContainerID41            NUMBER;
    vContainerID42            NUMBER;
    vContainerID43            NUMBER;
    vContainerID44            NUMBER;
    vContainerID45            NUMBER;
    vContainerID46            NUMBER;
    vContainerID47            NUMBER;
    vContainerID48            NUMBER;
    vContainerID49            NUMBER;
    vContainerID50            NUMBER;
    vTruckTransportID01       NUMBER;
    vTruckTransportID02       NUMBER;
    vTruckTransportID03       NUMBER;
    vTruckTransportID04       NUMBER;
    vTruckTransportID05       NUMBER;
    vTruckTransportID06       NUMBER;
    vTruckTransportID07       NUMBER;
    vTruckTransportID08       NUMBER;
    vTruckTransportID09       NUMBER;
    vTruckTransportID10       NUMBER;
    vTruckTransportID11       NUMBER;
    vTruckTransportID12       NUMBER;
    vTruckTransportID13       NUMBER;
    vTruckTransportID14       NUMBER;
    vTruckTransportID15       NUMBER;
    vTruckTransportID16       NUMBER;
    vTruckTransportID17       NUMBER;
    vTruckTransportID18       NUMBER;
    vTruckTransportID19       NUMBER;
    vTruckTransportID20       NUMBER;
    vTruckCargoManifestIDTemp NUMBER;
    vShipTransportID01        NUMBER;
    vShipTransportID02        NUMBER;
    vShipTransportID03        NUMBER;
    vShipTransportID04        NUMBER;
    vShipTransportID05        NUMBER;
    vShipTransportID06        NUMBER;
    vShipTransportID07        NUMBER;
    vShipTransportID08        NUMBER;
    vShipTransportID09        NUMBER;
    vShipTransportID10        NUMBER;
    vShipCargoManifestIDTemp  NUMBER;
    vTransportTypeID          TRANSPORTTYPE.ID%TYPE;
    vCargositeTypeID          CARGOSITETYPE.ID%TYPE;
    vCargosite01              CARGOSITE.ID%TYPE;
    vCargosite02              CARGOSITE.ID%TYPE;
    vCargosite03              CARGOSITE.ID%TYPE;
    vCargoManifestTypeLoad    CARGOMANIFESTTYPE.ID%TYPE;
    vCargoManifestTypeUnload  CARGOMANIFESTTYPE.ID%TYPE;

BEGIN

    --     types of cargoManifests
    select ID into vCargoManifestTypeLoad from CARGOMANIFESTTYPE where DESCRIPTION = 'Load';
    select ID into vCargoManifestTypeUnload from CARGOMANIFESTTYPE where DESCRIPTION = 'Unload';


-- insert containers

    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT001', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID01;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT002', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID02;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT003', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID03;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT004', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID04;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT005', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID05;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT006', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID06;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT007', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID07;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT008', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID08;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT009', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID09;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT010', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID10;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT011', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID11;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT012', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID12;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT013', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID13;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT014', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID14;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT015', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID15;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT016', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID16;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT017', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID17;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT018', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID18;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT019', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID19;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT020', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID20;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT021', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID21;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT022', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID22;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT023', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID23;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT024', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID24;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT025', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID25;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT026', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID26;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT027', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID27;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT028', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID28;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT029', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID29;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT030', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID30;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT031', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID31;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT032', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID32;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT033', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID33;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT034', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID34;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT035', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID35;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT036', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID36;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT037', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID37;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT038', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID38;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT039', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID39;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT040', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID40;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT041', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID41;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT042', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID42;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT043', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID43;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT044', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID44;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT045', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID45;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT046', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID46;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT047', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID47;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT048', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID48;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT049', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID49;
    INSERT INTO CONTAINER (IDENTIFICATIONNUMBER, ISOCOD, MAXWEIGHT, TAREWEIGHT, MAXVOLUME, REPAIR, TEMPERATURE, IDCSC)
    VALUES ('SPRT3_CT050', '45G1', 32500, 3830, 20.3, TO_DATE('2023-12-04', 'YYYY-MM-DD HH24:MI:SS'), 4.00, '"n/a"')
    returning ID into vContainerID50;


--     insert transports
    select ID INTO vTransportTypeID from TRANSPORTTYPE where DESCRIPTION = 'Truck';
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID01;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID02;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID03;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID04;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID05;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID06;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID07;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID08;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID09;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID10;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID11;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID12;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID13;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID14;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID15;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID16;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID17;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID18;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID19;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vTruckTransportID20;


    select ID INTO vTransportTypeID from TRANSPORTTYPE where DESCRIPTION = 'Ship';
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID01;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID02;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID03;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID04;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID05;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID06;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID07;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID08;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID09;
    insert into TRANSPORT (ACTIVE, IDTRANSPORTTYPE) values (1, vTransportTypeID) returning ID INTO vShipTransportID10;

--     insert trucks
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID01, 'TK-00-01');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID02, 'TK-00-02');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID03, 'TK-00-03');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID04, 'TK-00-04');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID05, 'TK-00-05');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID06, 'TK-00-06');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID07, 'TK-00-07');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID08, 'TK-00-08');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID09, 'TK-00-09');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID10, 'TK-00-10');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID11, 'TK-00-11');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID12, 'TK-00-12');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID13, 'TK-00-13');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID14, 'TK-00-14');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID15, 'TK-00-15');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID16, 'TK-00-16');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID17, 'TK-00-17');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID18, 'TK-00-18');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID19, 'TK-00-19');
    insert into TRUCK (IDTRANSPORT, LICENSEPLATE) values (vTruckTransportID20, 'TK-00-20');

-- insert ships
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID01, 200000001, 'SPRT3_SP01', 'SPRT3_SHIP_01', 2000001, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID02, 200000002, 'SPRT3_SP02', 'SPRT3_SHIP_02', 2000002, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID03, 200000003, 'SPRT3_SP03', 'SPRT3_SHIP_03', 2000003, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID04, 200000004, 'SPRT3_SP04', 'SPRT3_SHIP_04', 2000004, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID05, 200000005, 'SPRT3_SP05', 'SPRT3_SHIP_05', 2000005, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID06, 200000006, 'SPRT3_SP06', 'SPRT3_SHIP_06', 2000006, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID07, 200000007, 'SPRT3_SP07', 'SPRT3_SHIP_07', 2000007, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID08, 200000008, 'SPRT3_SP08', 'SPRT3_SHIP_08', 2000008, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID09, 200000009, 'SPRT3_SP09', 'SPRT3_SHIP_09', 2000009, 5, 1000, 15, 100, 16, 10, 6);
    insert into SHIP (IDTRANSPORT, MMSI, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (vShipTransportID10, 200000010, 'SPRT3_SP10', 'SPRT3_SHIP_10', 2000010, 5, 1000, 15, 100, 16, 10, 6);


-- get cargosites
    select id INTO vCargositeTypeID from CARGOSITETYPE where DESCRIPTION = 'Port';

    insert into CARGOSITE (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE, CONTAINERCAPACITY, SHIPCAPACITY,
                           TRUCKCAPACITY)
    values ('Port_Portugal_A_310', 20, 20, 'Portugal', vCargositeTypeID, 100000, 10, 200)
    returning ID into vCargosite01;

    insert into CARGOSITE (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE, CONTAINERCAPACITY, SHIPCAPACITY,
                           TRUCKCAPACITY)
    values ('Port_Brazil_310', 20, 20, 'Brazil', vCargositeTypeID, 100000, 10, 200)
    returning ID into vCargosite02;

    insert into CARGOSITE (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE, CONTAINERCAPACITY, SHIPCAPACITY,
                           TRUCKCAPACITY)
    values ('Port_Portugal_B_310', 20, 20, 'Brazil', vCargositeTypeID, 100000, 10, 200)
    returning ID into vCargosite03;


    -- inserts cargo manifests for trucks comming to port


-- in range of month 02/2022 day 03
-- truck 01
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID01, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('02/02/2022', 'dd/MM/yyyy'),
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('02/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID31, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID01, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('02/02/2022', 'dd/MM/yyyy'),
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('02/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID31, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 02
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID02, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('02/02/2022', 'dd/MM/yyyy'),
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('02/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID32, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID02, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('02/02/2022', 'dd/MM/yyyy'),
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('02/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID32, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

    -- in range of month 02/2022 day 04

-- truck 03
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID03, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'),
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID33, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID03, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'),
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID33, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


-- truck 04
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID04, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'),
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID34, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID04, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'),
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID34, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


-- truck 05
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID05, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'),
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID35, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID05, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'),
            TO_DATE('03/02/2022', 'dd/MM/yyyy'), TO_DATE('04/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID35, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

    -- in range of month 02/2022 day 07

-- truck 06
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID06, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('06/02/2022', 'dd/MM/yyyy'), TO_DATE('07/02/2022', 'dd/MM/yyyy'),
            TO_DATE('06/02/2022', 'dd/MM/yyyy'), TO_DATE('07/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID36, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID06, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('06/02/2022', 'dd/MM/yyyy'), TO_DATE('07/02/2022', 'dd/MM/yyyy'),
            TO_DATE('06/02/2022', 'dd/MM/yyyy'), TO_DATE('07/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID36, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 07
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID07, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('06/02/2022', 'dd/MM/yyyy'), TO_DATE('07/02/2022', 'dd/MM/yyyy'),
            TO_DATE('06/02/2022', 'dd/MM/yyyy'), TO_DATE('07/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID37, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID07, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('06/02/2022', 'dd/MM/yyyy'), TO_DATE('07/02/2022', 'dd/MM/yyyy'),
            TO_DATE('06/02/2022', 'dd/MM/yyyy'), TO_DATE('07/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID37, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    -- in range of month 02/2022 day 13

-- truck 08
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID08, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID38, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID08, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID38, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


-- truck 09
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID09, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID39, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID09, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID39, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


-- truck 10
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID10, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID40, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID10, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID40, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 11
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID11, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID41, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID11, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID41, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 12
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID12, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID42, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID12, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'),
            TO_DATE('12/02/2022', 'dd/MM/yyyy'), TO_DATE('13/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID42, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

    -- in range of month 02/2022 day 17

-- truck 13
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID13, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('16/02/2022', 'dd/MM/yyyy'), TO_DATE('17/02/2022', 'dd/MM/yyyy'),
            TO_DATE('16/02/2022', 'dd/MM/yyyy'), TO_DATE('17/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID43, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID13, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('16/02/2022', 'dd/MM/yyyy'), TO_DATE('17/02/2022', 'dd/MM/yyyy'),
            TO_DATE('16/02/2022', 'dd/MM/yyyy'), TO_DATE('17/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID43, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

    -- in range of month 02/2022 day 18

-- truck 14
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID14, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('17/02/2022', 'dd/MM/yyyy'), TO_DATE('18/02/2022', 'dd/MM/yyyy'),
            TO_DATE('17/02/2022', 'dd/MM/yyyy'), TO_DATE('18/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID44, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID14, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('17/02/2022', 'dd/MM/yyyy'), TO_DATE('18/02/2022', 'dd/MM/yyyy'),
            TO_DATE('17/02/2022', 'dd/MM/yyyy'), TO_DATE('18/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID44, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    -- in range of month 02/2022 day 20

-- truck 15
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID15, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('19/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'),
            TO_DATE('19/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID45, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID15, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('19/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'),
            TO_DATE('19/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID45, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 16
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID16, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('19/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'),
            TO_DATE('19/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID46, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID16, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('19/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'),
            TO_DATE('19/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID46, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    -- in range of month 02/2022 day 22

-- truck 17
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID17, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('21/02/2022', 'dd/MM/yyyy'), TO_DATE('22/02/2022', 'dd/MM/yyyy'),
            TO_DATE('21/02/2022', 'dd/MM/yyyy'), TO_DATE('22/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID47, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID17, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('21/02/2022', 'dd/MM/yyyy'), TO_DATE('22/02/2022', 'dd/MM/yyyy'),
            TO_DATE('21/02/2022', 'dd/MM/yyyy'), TO_DATE('22/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID47, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

    -- in range of month 02/2022 day 24

-- truck 18
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID18, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('23/02/2022', 'dd/MM/yyyy'), TO_DATE('24/02/2022', 'dd/MM/yyyy'),
            TO_DATE('23/02/2022', 'dd/MM/yyyy'), TO_DATE('24/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID48, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID18, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('23/02/2022', 'dd/MM/yyyy'), TO_DATE('24/02/2022', 'dd/MM/yyyy'),
            TO_DATE('23/02/2022', 'dd/MM/yyyy'), TO_DATE('24/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID48, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    -- in range of month 02/2022 day 26

-- truck 19
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID19, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID49, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID19, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID49, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    -- in range of month 02/2022 day 28

-- truck 20
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID20, vCargosite03, vCargosite01, vCargoManifestTypeLoad,
            TO_DATE('27/02/2022', 'dd/MM/yyyy'), TO_DATE('28/02/2022', 'dd/MM/yyyy'),
            TO_DATE('27/02/2022', 'dd/MM/yyyy'), TO_DATE('28/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID50, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID20, vCargosite03, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('27/02/2022', 'dd/MM/yyyy'), TO_DATE('28/02/2022', 'dd/MM/yyyy'),
            TO_DATE('27/02/2022', 'dd/MM/yyyy'), TO_DATE('28/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID50, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    -- trucks leaving port
-- in range of month 02/2022 day 9

-- truck 1
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID01, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID31, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID01, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID31, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 2
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID02, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID32, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID02, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID32, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 3
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID03, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID33, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID03, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID33, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 4
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID04, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID34, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID04, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID34, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 5
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID05, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID35, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID05, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID35, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

    -- in range of month 02/2022 day 15
-- truck 6
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID06, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID36, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID06, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID36, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 7
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID07, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID37, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID07, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID37, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 8
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID08, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID38, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID08, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID38, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 9
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID09, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID39, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID09, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID39, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);

-- truck 10
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID10, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID40, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID10, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('16/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID40, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    -- in range of month 02/2022 day 25

-- truck 11
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID11, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID41, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID11, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID41, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


-- truck 12
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID12, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID42, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID12, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID42, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


-- truck 13
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID13, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID43, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID13, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID43, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


-- truck 14
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID14, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID44, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID14, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID44, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


-- truck 15
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID15, vCargosite01, vCargosite03, vCargoManifestTypeLoad,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID45, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vTruckTransportID15, vCargosite01, vCargosite03, vCargoManifestTypeUnload,
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'))
    returning ID into vTruckCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID45, vTruckCargoManifestIDTemp, 20000, 0, 0, 0);


    -- inserts cargo manifests for ships comming to port


-- out of range of month 02/2022 (less, ship 01)
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID01, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('01/01/2022', 'dd/MM/yyyy'),
            TO_DATE('10/01/2022', 'dd/MM/yyyy'), TO_DATE('01/01/2022', 'dd/MM/yyyy'),
            TO_DATE('10/01/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID01, vShipCargoManifestIDTemp, 20000, 0, 0, 1);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID01, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('01/01/2022', 'dd/MM/yyyy'), TO_DATE('10/01/2022', 'dd/MM/yyyy'),
            TO_DATE('01/01/2022', 'dd/MM/yyyy'), TO_DATE('10/01/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID01, vShipCargoManifestIDTemp, 20000, 0, 0, 1);

-- out of range of month 02/2022 (more, ship 10)
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID10, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('01/03/2022', 'dd/MM/yyyy'),
            TO_DATE('10/03/2022', 'dd/MM/yyyy'), TO_DATE('01/03/2022', 'dd/MM/yyyy'),
            TO_DATE('10/03/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID50, vShipCargoManifestIDTemp, 20000, 0, 0, 1);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID10, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('01/03/2022', 'dd/MM/yyyy'), TO_DATE('10/03/2022', 'dd/MM/yyyy'),
            TO_DATE('01/03/2022', 'dd/MM/yyyy'), TO_DATE('10/03/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID50, vShipCargoManifestIDTemp, 20000, 0, 0, 1);

    -- in range of month 02/2022 day 01
-- ship 02
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID02, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('20/01/2022', 'dd/MM/yyyy'),
            TO_DATE('01/02/2022', 'dd/MM/yyyy'), TO_DATE('20/01/2022', 'dd/MM/yyyy'),
            TO_DATE('01/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID02, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID03, vShipCargoManifestIDTemp, 20000, 0, 0, 2);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID02, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('20/01/2022', 'dd/MM/yyyy'), TO_DATE('01/02/2022', 'dd/MM/yyyy'),
            TO_DATE('20/01/2022', 'dd/MM/yyyy'), TO_DATE('01/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID02, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID03, vShipCargoManifestIDTemp, 20000, 0, 0, 2);

-- ship 03
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID03, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('20/01/2022', 'dd/MM/yyyy'),
            TO_DATE('01/02/2022', 'dd/MM/yyyy'), TO_DATE('20/01/2022', 'dd/MM/yyyy'),
            TO_DATE('01/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID04, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID05, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID06, vShipCargoManifestIDTemp, 20000, 0, 0, 3);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID03, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('20/01/2022', 'dd/MM/yyyy'), TO_DATE('01/02/2022', 'dd/MM/yyyy'),
            TO_DATE('20/01/2022', 'dd/MM/yyyy'), TO_DATE('01/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID04, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID05, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID06, vShipCargoManifestIDTemp, 20000, 0, 0, 3);

    -- in range of month 02/2022 day 05
-- ship 04
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID04, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('25/01/2022', 'dd/MM/yyyy'),
            TO_DATE('05/02/2022', 'dd/MM/yyyy'), TO_DATE('25/01/2022', 'dd/MM/yyyy'),
            TO_DATE('05/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID07, vShipCargoManifestIDTemp, 20000, 0, 0, 1);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID04, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('25/01/2022', 'dd/MM/yyyy'), TO_DATE('05/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/01/2022', 'dd/MM/yyyy'), TO_DATE('05/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID07, vShipCargoManifestIDTemp, 20000, 0, 0, 1);

    -- in range of month 02/2022 day 10
-- ship 05
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID05, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('30/01/2022', 'dd/MM/yyyy'),
            TO_DATE('10/02/2022', 'dd/MM/yyyy'), TO_DATE('30/01/2022', 'dd/MM/yyyy'),
            TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID08, vShipCargoManifestIDTemp, 20000, 0, 0, 1);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID05, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('30/01/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID08, vShipCargoManifestIDTemp, 20000, 0, 0, 1);


    -- in range of month 02/2022 day 15
-- ship 06
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID06, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('05/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('05/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID09, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID10, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID11, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID12, vShipCargoManifestIDTemp, 20000, 0, 0, 4);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID06, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('05/02/2022', 'dd/MM/yyyy'), TO_DATE('15/02/2022', 'dd/MM/yyyy'),
            TO_DATE('05/02/2022', 'dd/MM/yyyy'), TO_DATE('15/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID09, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID10, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID11, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID12, vShipCargoManifestIDTemp, 20000, 0, 0, 4);

    -- in range of month 02/2022 day 20
-- ship 07
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID07, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('20/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('20/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID13, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID14, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID15, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID16, vShipCargoManifestIDTemp, 20000, 0, 0, 4);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID17, vShipCargoManifestIDTemp, 20000, 0, 0, 5);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID07, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('10/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'),
            TO_DATE('10/02/2022', 'dd/MM/yyyy'), TO_DATE('20/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID13, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID14, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID15, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID16, vShipCargoManifestIDTemp, 20000, 0, 0, 4);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID17, vShipCargoManifestIDTemp, 20000, 0, 0, 5);


    -- in range of month 02/2022 day 25
-- ship 08
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID08, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('15/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('15/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID18, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID19, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID20, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID21, vShipCargoManifestIDTemp, 20000, 0, 0, 4);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID22, vShipCargoManifestIDTemp, 20000, 0, 0, 5);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID08, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('25/02/2022', 'dd/MM/yyyy'),
            TO_DATE('15/02/2022', 'dd/MM/yyyy'), TO_DATE('25/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID18, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID19, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID20, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID21, vShipCargoManifestIDTemp, 20000, 0, 0, 4);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID22, vShipCargoManifestIDTemp, 20000, 0, 0, 5);


    -- in range of month 02/2022 day 28
-- ship 09
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID09, vCargosite02, vCargosite01, vCargoManifestTypeLoad, TO_DATE('23/02/2022', 'dd/MM/yyyy'),
            TO_DATE('28/02/2022', 'dd/MM/yyyy'), TO_DATE('23/02/2022', 'dd/MM/yyyy'),
            TO_DATE('28/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID23, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID24, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID25, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID26, vShipCargoManifestIDTemp, 20000, 0, 0, 4);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID27, vShipCargoManifestIDTemp, 20000, 0, 0, 5);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID28, vShipCargoManifestIDTemp, 20000, 0, 1, 5);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID29, vShipCargoManifestIDTemp, 20000, 0, 2, 5);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID30, vShipCargoManifestIDTemp, 20000, 0, 3, 5);

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID09, vCargosite02, vCargosite01, vCargoManifestTypeUnload,
            TO_DATE('23/02/2022', 'dd/MM/yyyy'), TO_DATE('28/02/2022', 'dd/MM/yyyy'),
            TO_DATE('23/02/2022', 'dd/MM/yyyy'), TO_DATE('28/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID23, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID24, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID25, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID26, vShipCargoManifestIDTemp, 20000, 0, 0, 4);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID27, vShipCargoManifestIDTemp, 20000, 0, 0, 5);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID28, vShipCargoManifestIDTemp, 20000, 0, 1, 5);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID29, vShipCargoManifestIDTemp, 20000, 0, 2, 5);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID30, vShipCargoManifestIDTemp, 20000, 0, 3, 5);

    -- inserts cargo manifests for ships leaving port
-- in range of month 02/2022 day 10
-- ship 01
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID01, vCargosite01, vCargosite02, vCargoManifestTypeLoad, TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('20/02/2022', 'dd/MM/yyyy'), TO_DATE('10/02/2022', 'dd/MM/yyyy'),
            TO_DATE('20/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID01, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID02, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID03, vShipCargoManifestIDTemp, 20000, 0, 0, 3);


    -- in range of month 02/2022 day 15
-- ship 02
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID02, vCargosite01, vCargosite02, vCargoManifestTypeLoad, TO_DATE('15/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'), TO_DATE('15/02/2022', 'dd/MM/yyyy'),
            TO_DATE('25/02/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID04, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID05, vShipCargoManifestIDTemp, 20000, 0, 0, 2);

    -- in range of month 02/2022 day 18
-- ship 03
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID03, vCargosite01, vCargosite02, vCargoManifestTypeLoad, TO_DATE('18/02/2022', 'dd/MM/yyyy'),
            TO_DATE('01/03/2022', 'dd/MM/yyyy'), TO_DATE('18/02/2022', 'dd/MM/yyyy'),
            TO_DATE('1/03/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID06, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID07, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID08, vShipCargoManifestIDTemp, 20000, 0, 0, 3);

    -- in range of month 02/2022 day 25
-- ship 04
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID04, vCargosite01, vCargosite02, vCargoManifestTypeLoad, TO_DATE('25/02/2022', 'dd/MM/yyyy'),
            TO_DATE('08/03/2022', 'dd/MM/yyyy'), TO_DATE('25/02/2022', 'dd/MM/yyyy'),
            TO_DATE('08/03/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID09, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID10, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID11, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID12, vShipCargoManifestIDTemp, 20000, 0, 0, 4);
    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID13, vShipCargoManifestIDTemp, 20000, 0, 0, 5);

     -- in range of month 02/2022 day 26
-- ship 05
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID05, vCargosite01, vCargosite02, vCargoManifestTypeLoad, TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/03/2022', 'dd/MM/yyyy'), TO_DATE('26/02/2022', 'dd/MM/yyyy'),
            TO_DATE('09/03/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID14, vShipCargoManifestIDTemp, 20000, 0, 0, 1);

         -- in range of month 02/2022 day 27
-- ship 06
    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID06, vCargosite01, vCargosite02, vCargoManifestTypeLoad, TO_DATE('27/02/2022', 'dd/MM/yyyy'),
            TO_DATE('10/03/2022', 'dd/MM/yyyy'), TO_DATE('27/02/2022', 'dd/MM/yyyy'),
            TO_DATE('10/03/2022', 'dd/MM/yyyy'))
    returning ID into vShipCargoManifestIDTemp;

    insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID15, vShipCargoManifestIDTemp, 20000, 0, 0, 1);
        insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID16, vShipCargoManifestIDTemp, 20000, 0, 0, 2);
        insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID17, vShipCargoManifestIDTemp, 20000, 0, 0, 3);
        insert into CARGOMANIFESTLINE (IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION)
    values (vContainerID18, vShipCargoManifestIDTemp, 20000, 0, 0, 4);


    commit;

END;
