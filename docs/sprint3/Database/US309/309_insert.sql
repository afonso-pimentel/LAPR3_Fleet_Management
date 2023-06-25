declare

    vDateStart DATE  := TO_DATE('04/01/2021', 'dd/MM/yyyy');
    vDateEnd DATE  := TO_DATE('25/01/2022', 'dd/MM/yyyy');

    vShipTransportID         TRANSPORT.ID%TYPE;
    vCargoSiteIDA            CARGOSITE.ID%TYPE;
    vCargoSiteIDB            CARGOSITE.ID%TYPE;
    vLoadCargoManifestTypeID CARGOMANIFESTTYPE.ID%TYPE;


BEGIN

    SELECT SHIP.IDTRANSPORT INTO vShipTransportID FROM SHIP WHERE SHIP.NAME = 'US309_Ship';

-- get cargosites

    SELECT CARGOSITE.ID INTO vCargoSiteIDA FROM CARGOSITE WHERE CARGOSITE.NAME = 'Barcelona';
    SELECT CARGOSITE.ID INTO vCargoSiteIDB FROM CARGOSITE WHERE CARGOSITE.NAME = 'London';

    SELECT CARGOMANIFESTTYPE.ID
    INTO vLoadCargoManifestTypeID
    FROM CARGOMANIFESTTYPE
    WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Load';


-- insert cargo manifest of type load

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vCargoSiteIDA, vCargoSiteIDB, vLoadCargoManifestTypeID, NULL, NULL,
            vDateStart, vDateEnd);

END;




declare

    vDateStart DATE  := TO_DATE('04/01/2021', 'dd/MM/yyyy');
    vDateEnd DATE  := TO_DATE('25/01/2022', 'dd/MM/yyyy');

    vShipTransportID         TRANSPORT.ID%TYPE;
    vCargoSiteIDA            CARGOSITE.ID%TYPE;
    vCargoSiteIDB            CARGOSITE.ID%TYPE;
    vLoadCargoManifestTypeID CARGOMANIFESTTYPE.ID%TYPE;


BEGIN

    SELECT SHIP.IDTRANSPORT INTO vShipTransportID FROM SHIP WHERE SHIP.NAME = 'US309_Ship';

-- get cargosites

    SELECT CARGOSITE.ID INTO vCargoSiteIDA FROM CARGOSITE WHERE CARGOSITE.NAME = 'Barcelona';
    SELECT CARGOSITE.ID INTO vCargoSiteIDB FROM CARGOSITE WHERE CARGOSITE.NAME = 'London';

    SELECT CARGOMANIFESTTYPE.ID
    INTO vLoadCargoManifestTypeID
    FROM CARGOMANIFESTTYPE
    WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Unload';


-- insert cargo manifest of type unload

    insert into CARGOMANIFEST (IDTRANSPORT, IDCARGOSITEORIGIN, IDCARGOSITEDESTINATION, IDCARGOMANIFESTTYPE, DATESTART,
                               DATEFINISH, DATESTARTESTIMATED, DATEFINISHESTIMATED)
    values (vShipTransportID, vCargoSiteIDA, vCargoSiteIDB, vLoadCargoManifestTypeID, NULL, NULL,
            vDateStart, vDateEnd);

END;

