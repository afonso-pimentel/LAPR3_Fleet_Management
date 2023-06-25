/****************************************************************************************************
script Usage:       To have feedback from the script you should activate "Enable DBMS_OUTPUT"
                    This script do not create the database, it should be created first and THEN
                    this script should run in it.
                    The instructions executed are rolled back at the end of every test.
***************************************************************************************************
SUMMARY OF CHANGES
Date(dd-MM-yyyy)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
***************************************************************************************************/

/****************
  CargoManifest
*****************/

-- [Identity] CargoManifest.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    cmId                 CargoManifest.id%TYPE;
    cmIdTransport        CargoManifest.IDTRANSPORT%TYPE;
    cmIdCargoSite        CargoManifest.IDCARGOSITE%TYPE;
    cmIdCargoManifest    CargoManifest.IDCARGOMANIFESTTYPE%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] CargoManifest.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType);
--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE
        INTO cmId, cmIdTransport, cmIdCargoSite, cmIdCargoManifest
        FROM CargoManifest;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifest : id= ' || cmId || ' idTransport= ' || cmIdTransport
            || ' idCargoSite= ' || cmIdCargoSite || ' idCargoManifest= ' || cmIdCargoManifest);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] CargoManifest.idTransport - not null
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifest.idTransport - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifest.idTransport can not be null.');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (NULL, tIdCargosite, tIdCargoManifestType);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] CargoManifest.idTransport - NUMBER(19)
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idTransport - ( NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(19).');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (99999999999999999999, tIdCargosite, tIdCargoManifestType);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] CargoManifest.idTransport - foreign key constraint
--prepare
DECLARE
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] CargoManifest.idTransport - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (99, tIdCargosite, tIdCargoManifestType);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifest.idCargoSite - not null
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifest.idTransport - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifest.idTransport can not be null.');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (tIdTransport, NULL, tIdCargoManifestType);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] CargoManifest.idCargoSite - NUMBER(19)
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idCargoSite - ( NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(19).');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (tIdTransport, 99999999999999999999, tIdCargoManifestType);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] CargoManifest.idCargoSite - foreign key constraint
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdCargoManifestType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] CargoManifest.idCargoSite - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');
    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (tIdTransport, 99, tIdCargoManifestType);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] CargoManifest.idCargoManifestType - not null
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifest.idCargoManifestType - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifest.idCargoManifestType can not be null.');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (tIdTransport, tIdCargosite, NULL);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] CargoManifest.idCargoSite - NUMBER(19)
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idCargoManifestType - ( NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(19).');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (tIdTransport, tIdCargosite, 99999999999999999999);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] CargoManifest.idCargoManifestType - foreign key constraint
--prepare
DECLARE
    tIdTransType     NUMBER;
    tIdTransport     NUMBER;
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
    tIdCargosite     NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] CargoManifest.idCargoManifestType - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');
    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;

--act
    INSERT
    INTO CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    VALUES (tIdTransport, tIdCargosite, 99);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/*******************
  CargoManifestLine
********************/


-- [Identity] CargoManifestLine.id - Primary Key: unique and not null
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;
    cmIdContainer        CargoManifestLine.idContainer%TYPE;
    cmIdCargoManifest    CargoManifestLine.idCargoManifest%TYPE;
    cmGrossWeight        CargoManifestLine.grossWeight%TYPE;
    cmXpos               CargoManifestLine.xPosition%TYPE;
    cmYpos               CargoManifestLine.yPosition%TYPE;
    cmZpos               CargoManifestLine.zPosition%TYPE;


BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] CargoManifestLine.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, 20000, 10, 10, 10);

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition
        INTO cmIdContainer, cmIdCargoManifest, cmGrossWeight, cmXpos, cmYpos, cmZpos
        FROM CARGOMANIFESTLINE
        WHERE idContainer = tIdContainer
          and idCargoManifest = tIdCargoManifest;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifest : idContainer= ' || cmIdContainer || ' idCargoManifest= ' ||
                             cmIdCargoManifest
            || ' grossWeight= ' || cmGrossWeight || ' xPosition= ' || cmXpos || ' yPosition= ' || cmYpos ||
                             ' zPosition= ' || cmZpos);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/



-- [Identity] CargoManifestLine.idContainer - not null
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] CargoManifestLine.idContainer - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (null, tIdCargoManifest, 20000, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] CargoManifestLine.idContainer - NUMBER(19)
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.idContainer  - (NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(19).');

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (99999999999999999999, tIdCargoManifest, 20000, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Identity] CargoManifestLine.idCargoManifest - not null
--prepare
DECLARE
    tDate        Date;
    tIdContainer NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] CargoManifestLine.idCargoManifest - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, null, 20000, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.idCargoManifest - NUMBER(19)
--prepare
DECLARE
    tDate        Date;
    tIdContainer NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.idCargoManifest  - (NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(19).');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, 99999999999999999999, 20000, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/

-- [Referential] CargoManifestLine.idContainer - foreign key constraint
--prepare
DECLARE
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] CargoManifestLine.idContainer - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');


    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (99, tIdCargoManifest, 20000, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Referential] CargoManifestLine.idCargoManifest - foreign key constraint
--prepare
DECLARE
    tDate        Date;
    tIdContainer NUMBER;


BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] CargoManifestLine.idCargoManifest - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, 99, 20000, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.grossWeight - not null
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.grossWeight - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifestLine.grossWeight can not be null.');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, NULL, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.grossWeight - NUMBER(5)
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.grossWeight - (NUMBER(5)) INSERT 999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(5).');
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, 999999, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.xPosition - not null
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.xPosition - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifestLine.xPosition can not be null.');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, 50000, NULL, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.xPosition - NUMBER(3)
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.xPosition - (NUMBER(3)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(3).');
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, 50000, 9999, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.xPositon - check constraint ck_cargomanifestline_xposition
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.xPositon ck_CargoManifestLine_xPosition ( xPosition >= 0 ) - INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): CargoManifestLine.xPositon  check constraint violation');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, 20000, -1, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.yPosition - not null
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.yPosition - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifestLine.yPosition can not be null.');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, 50000, 10, NULL, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.yPosition - NUMBER(3)
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.yPosition - (NUMBER(3)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(3).');
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, 50000, 10, 9999, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestLine.yPositon - check constraint ck_cargomanifestline_yposition
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.yPositon ck_CargoManifestLine_yPosition ( yPosition >= 0 ) - INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): CargoManifestLine.yPositon  check constraint violation');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, 20000, 10, -10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] CargoManifestLine.grossWeight - check constraint ck_cargoManifestLine_grossWeight
--prepare
DECLARE
    tDate                Date;
    tIdContainer         NUMBER;
    tIdTransType         NUMBER;
    tIdTransport         NUMBER;
    tIdContinent         NUMBER;
    tIdCountry           NUMBER;
    tIdCargositetype     NUMBER;
    tIdCargosite         NUMBER;
    tIdCargoManifestType NUMBER;
    tIdCargoManifest     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.grossWeight constraint ck_cargoManifestLine_grossWeight - ( grossWeight > 0 ) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): CargoManifestLine.grossWeight  check constraint violation');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (active, idTransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, idContinent) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
    INSERT INTO Cargosite (name, latitude, longitude, idCountry, idCargoSiteType)
    VALUES ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    RETURNING id INTO tIdCargosite;
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING id INTO tIdCargoManifestType;
    INSERT INTO CargoManifest (idTransport, idCargoSite, idCargoManifestTYPE)
    VALUES (tIdTransport, tIdCargosite, tIdCargoManifestType)
    RETURNING id INTO tIdCargoManifest;
--act

    INSERT INTO CARGOMANIFESTLINE (idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition)
    VALUES (tIdContainer, tIdCargoManifest, -1, 10, 10, 10);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/*******************
  CargoManifestType
********************/


-- [Identity] CargoManifestType.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdCargoManifestType NUMBER;
    tId                  CargoManifestType.id%TYPE;
    tDesc                CargoManifestType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] CargoManifestType.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO CargoManifestType (description) VALUES ('Load') RETURNING ID INTO tIdCargoManifestType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description
        INTO tId, tDesc
        FROM CargoManifestType
        WHERE id = tIdCargoManifestType;
        DBMS_OUTPUT.put_line('SUCCESS ==> CargoManifestType : id= ' || tId || ' description= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/

-- [Domain] CargoManifestType.description - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: CargoManifestType.description can not be null.');

--act
    INSERT INTO CargoManifestType (description) VALUES (NULL);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestType.description - varchar2(30)
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description - (varchar2(30)) INSERT "ten-Chars|" x4');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(30).');

--act
    INSERT INTO CargoManifestType (description) VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoManifestType.description - unique
--prepare
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description - (unique) INSERT duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: CargoManifestType.description can not have duplicate VALUES.');
    INSERT INTO CargoManifestType (description) VALUES ('Load');

--act
    INSERT INTO CargoManifestType (description) VALUES ('Load');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] CargoManifestType.description - check constraint ck_CargoManifestType_description
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description ck_CargoManifestType_description( description IN ("Load", "Unload") ) INSERT "lload"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): CargoManifestType.description check constraint violation');

--act
    INSERT INTO CargoManifestType(description)
    VALUES ('lload');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] CargoManifestType.description - check constraint ck_CargoManifestType_description
--prepare
DECLARE
    tIdCargoManifestType NUMBER;
    tId                  CargoManifestType.id%TYPE;
    tDesc                CargoManifestType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description ck_CargoManifestType_description( description IN ("Load", "Unload") ) INSERT "Load"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: CargoManifestType.description check constraint violation');

--act
    INSERT INTO CargoManifestType(description) VALUES ('Load') RETURNING ID INTO tIdCargoManifestType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM CargoManifestType WHERE id = tIdCargoManifestType;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifestType : id= ' || tId || ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] CargoManifestType.description - check constraint ck_CargoManifestType_description
--prepare
DECLARE
    tIdCargoManifestType NUMBER;
    tId                  CargoManifestType.id%TYPE;
    tDesc                CargoManifestType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description ck_CargoManifestType_description( description IN ("Load", "Unload") ) INSERT "Unload"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: CargoManifestType.description check constraint violation');

--act
    INSERT INTO CargoManifestType(description) VALUES ('Unload') RETURNING ID INTO tIdCargoManifestType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM CargoManifestType WHERE id = tIdCargoManifestType;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifestType : id= ' || tId || ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


/************
  Cargosite
*************/


-- [Identity] Cargosite.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdContinent     NUMBER;
    tIdCountr        NUMBER;
    tIdCargositety   NUMBER;
    tIdCargosite     NUMBER;
    tId              CARGOSITE.id%TYPE;
    tName            CARGOSITE.name%TYPE;
    tLatitude        CARGOSITE.latitude%TYPE;
    tLongitude       CARGOSITE.longitude%TYPE;
    tIdCountry       CARGOSITE.idCountry%TYPE;
    tIdCargositeType CARGOSITE.idCargoSiteType%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Cargosite.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');


    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountr;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositety;
--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdCountr, tIdCargositety)
    RETURNING id INTO tIdCargosite;
--assert

    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE
        INTO tId, tName, tLatitude, tLongitude, tIdCountry, tIdCargositeType
        FROM Cargosite
        WHERE id = tIdCargosite;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Cargosite : id= ' || tId || ' name= ' || tName || ' latitude= ' || tLatitude
            || ' longitude= ' || tLongitude || ' idCountry= ' || tIdCountry || ' idCargoSiteType= ' ||
                             tIdCargoSiteType);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Cargosite.name - not null
--prepare
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.name - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.name can not be null.');
    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES (NULL, 35, 35, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.name - varchar2(50)
--prepare
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.name - (varchar2(50)) INSERT "ten-Chars|" x6');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(50).');
    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|', 35, 35, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.latitude - not null
--prepare
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.latitude - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.latitude can not be null.');
    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', NULL, 35, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.latitude - NUMBER(8,5)
--prepare
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.latitude - (NUMBER(8,5)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(8,5).');
    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 9999, 35, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.latitude - check constraint ck_CargoSite_latitude
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.latitude ck_CargoSite_latitude - (latitude >= -90 AND latitude <= 90) INSERT -91');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Cargosite.latitude check constraint violation');

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
--act
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', -91, 34, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.latitude - check constraint ck_CargoSite_latitude
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.latitude ck_CargoSite_latitude - (latitude >= -90 AND latitude <= 90) INSERT 91');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Cargosite.latitude check constraint violation');

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
--act
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 91, 34, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.longitude - not null
--prepare
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.longitude - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.longitude can not be null.');
    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 35, NULL, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.longitude - NUMBER(8,5)
--prepare
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.longitude - (NUMBER(8,5)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(8,5).');
    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 35, 9999, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.longitude - check constraint ck_CargoSite_longitude
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.longitude ck_CargoSite_longitude - (longitude >= -180 AND longitude <= 180) INSERT 181');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Cargosite.longitude check constraint violation');

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
--act
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 181, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.longitude - check constraint ck_CargoSite_longitude
DECLARE
    tIdContinent     NUMBER;
    tIdCountry       NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.longitude ck_CargoSite_longitude - (longitude >= -180 AND longitude <= 180) INSERT -181');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Cargosite.longitude check constraint violation');

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
--act
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, -181, tIdCountry, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.idcountry - not null
--prepare
DECLARE
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idcountry - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.idcountry can not be null.');
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 35, 35, NULL, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.idcountry - NUMBER(19)
--prepare
DECLARE
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idcountry - ( NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(19).');
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 9999, 35, 99999999999999999999, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] Cargosite.idcountry - foreign key constraint
DECLARE
    tIdContinent     NUMBER;
    tIdCargositetype NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.idcountry - (foreign key constraint) INSERT non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent);
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port') RETURNING id INTO tIdCargositetype;
--act
    INSERT INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, 99, tIdCargositetype);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.idCargositeType - not null
--prepare
DECLARE
    tIdContinent NUMBER;
    tIdCountry   NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idCargositeType - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.idCargositeType can not be null.');
    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 35, 35, tIdCountry, NULL);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Cargosite.idCargositeType - NUMBER(19)
--prepare
DECLARE
    tIdContinent NUMBER;
    tIdCountry   NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idCargositeType - ( NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(19).');
    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent);

--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 9999, 35, tIdCountry, 99999999999999999999);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] Cargosite.idcargositetype - foreign key constraint
DECLARE
    tIdContinent NUMBER;
    tIdCountry   NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.idcargositetype - (foreign key constraint) INSERT non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    INSERT INTO CONTINENT (Description) VALUES ('Europe') RETURNING id INTO tIdContinent;
    INSERT INTO COUNTRY (Description, IDCONTINENT) VALUES ('Portugal', tIdContinent) RETURNING id INTO tIdCountry;
    INSERT INTO CARGOSITETYPE (Description) VALUES ('Port');
--act
    INSERT
    INTO Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    VALUES ('Porto de Leixões', 34, 34, tIdContinent, 99);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/***************
  CargoSiteType
****************/


-- [Identity] CargoSiteType.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdCargoSiteType NUMBER;
    tId              CargoSiteType.id%TYPE;
    tDesc            CargoSiteType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] CargoSiteType.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO CargoSiteType (description) VALUES ('Port') RETURNING ID INTO tIdCargoSiteType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description
        INTO tId, tDesc
        FROM CargoSiteType
        WHERE id = tIdCargoSiteType;
        DBMS_OUTPUT.put_line('SUCCESS ==> CargoSiteType : id= ' || tId || ' description= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] CargoSiteType.description - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: CargoSiteType.description can not be null.');

--act
    INSERT INTO CargoSiteType (description) VALUES (NULL);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoSiteType.description - unique
--prepare
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description - (unique) INSERT duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: CargoSiteType.description can not have duplicate VALUES.');
    INSERT INTO CargoSiteType (description) VALUES ('Port');

--act
    INSERT INTO CargoSiteType (description) VALUES ('Port');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] CargoSiteType.description - varchar2(30)
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description - (varchar2(30)) INSERT "ten-Chars|" x4');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(30).');

--act
    INSERT INTO CargoSiteType (description) VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] CargoSiteType.description - check constraint ck_CargoSiteType_description
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description ck_CargoSiteType_description( description IN ("Port", "Warehouse") ) INSERT "string"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): CargoSiteType.description check constraint violation');

--act
    INSERT INTO CargoSiteType(description)
    VALUES ('string');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] CargoSiteType.description - check constraint ck_CargoSiteType_description
--prepare
DECLARE
    tIdCargoSiteType NUMBER;
    tId              CargoSiteType.id%TYPE;
    tDesc            CargoSiteType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description ck_CargoSiteType_description( description IN ("Port", "Warehouse")) INSERT "Port"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');

--act
    INSERT INTO CargoSiteType(description) VALUES ('Port') RETURNING ID INTO tIdCargoSiteType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM CargoSiteType WHERE id = tIdCargoSiteType;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoSiteType : id= ' || tId || ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] CargoSiteType.description - check constraint ck_CargoSiteType_description
--prepare
DECLARE
    tIdCargoSiteType NUMBER;
    tId              CargoSiteType.id%TYPE;
    tDesc            CargoSiteType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description ck_CargoSiteType_description( description IN ("Port", "Warehouse") ) INSERT "Warehouse"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');

--act
    INSERT INTO CargoSiteType(description) VALUES ('Warehouse') RETURNING ID INTO tIdCargoSiteType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM CargoSiteType WHERE id = tIdCargoSiteType;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoSiteType : id= ' || tId || ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


/************
  Container
*************/


-- [Identity] Container.id - Primary Key: unique and not null
--prepare
DECLARE
    tDate   Date;
    tIdCont NUMBER;
    tId     CONTAINER.id%TYPE;
    tIdent  CONTAINER.identificationNumber%TYPE;
    tIsocod CONTAINER.isoCod%TYPE;
    tMaxW   CONTAINER.maxWeight%TYPE;
    tTareW  CONTAINER.tareWeight%TYPE;
    tMaxV   CONTAINER.maxVolume%TYPE;
    tRep    CONTAINER.repair%TYPE;
    tTemp   CONTAINER.temperature%TYPE;
    tIdCsc  CONTAINER.idCsc%TYPE;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Container.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), 10, 'temporary isCsc')
    RETURNING id INTO tIdCont;
--assert

    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID,
               identificationNumber,
               isoCod,
               maxWeight,
               tareWeight,
               maxVolume,
               repair,
               temperature,
               idCsc
        INTO tId, tIdent, tIsocod, tMaxW, tTareW, tMaxV, trep, tTemp, tIdCsc
        FROM CONTAINER
        WHERE id = tIDCont;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Container : id= ' || tId || ' IdentificationNumber= ' || tIdent
            || ' isoCod= ' || tIsocod || ' maxWeight= ' || tMaxW || ' tareWeight= ' || tTareW
            || ' maxVolume= ' || tMaxV || ' repair= ' || trep || ' temperature= ' || tTemp
            || ' idCsc= ' || tIdCsc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Container.identificationNumber - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.identificationNumber - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.identificationNumber can not be null.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES (NULL, '22G1', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.identificationNumber - unique
--prepare
DECLARE
    tDate Date;

BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');

    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.identificationNumber - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-00001): Container.identificationNumber can not have duplicate VALUES.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.identificationNumber - varchar2(11)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.identificationNumber - (varchar2(11)) INSERT "ten-Chars|" x2');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(11).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('ten-Chars|ten-Chars|', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.isoCod - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.isoCod - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.isoCod can not be null.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', NULL, 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.isoCod - varchar2(4)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.isoCod - (varchar2(4)) INSERT "ten-Chars|" x1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(4).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', 'ten-Chars|', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.maxWeight - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.maxWeight - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.maxWeight can not be null.');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.maxWeight - NUMBER(5)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.maxWeight - (NUMBER(5)) INSERT 999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(5).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23E4', 999999, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] Container.maxWeight - check constraint ck_container_maxweight
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.maxWeight constraint ck_container_maxweight - ( maxWeight > 0 AND maxWeight > tareWeight ) INSERT maxWeight = 1999, tareWeight = 2000');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.maxWeight check constraint violation');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 1999, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] Container.maxWeight - check constraint ck_container_maxweight
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.maxWeight constraint ck_container_maxweight - ( maxWeight > 0 AND maxWeight > tareWeight ) INSERT maxWeight = -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.maxWeight check constraint violation');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', -1, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.tareWeight - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.tareWeight - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Container.tareWeight can not be null.');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.tareWeight - NUMBER(5)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.tareWeight - (NUMBER(5)) INSERT 999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(5).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23E4', 20000, 999999, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] Container.tareWeight - check constraint ck_container_tareWeight
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.tareWeight constraint ck_container_tareWeight - ( tareWeight > 0 AND tareWeight < maxWeight ) INSERT tareWeight = 1999, maxWeight = 2000');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.tareWeight check constraint violation');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 1999, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] Container.tareWeight - check constraint ck_container_tareWeight
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.tareWeight constraint ck_container_tareWeight - ( tareWeight > 0 AND tareWeight < maxWeight ) INSERT tareWeight = -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.tareWeight check constraint violation');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 10000, -1, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.maxVolume - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.maxVolume - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.maxVolume can not be null.');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, NULL, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.maxVolume - NUMBER(3,1)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.maxVolume - (NUMBER(3,1)) INSERT 999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(3,1).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23E4', 20000, 2000, 999, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] Container.maxVolume - check constraint ck_container_maxVolume
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.maxVolume constraint ck_container_maxVolume - ( maxVolume > 0 ) INSERT maxVolume = -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.maxVolume check constraint violation');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 1999, 2000, -1, add_months(tDate, 12), -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.repair - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.repair - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.repair can not be null.');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 12, NULL, -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.repair - Date
--prepare
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.repair - (Date) INSERT "string');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01858) because data type length is Date.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23E4', 20000, 2000, 19.2, 'string', -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01858 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.temperature - allow not null
--prepare
DECLARE
    tDate   Date;
    tIdCont NUMBER;
    tId     CONTAINER.id%TYPE;
    tIdent  CONTAINER.identificationNumber%TYPE;
    tIsocod CONTAINER.isoCod%TYPE;
    tMaxW   CONTAINER.maxWeight%TYPE;
    tTareW  CONTAINER.tareWeight%TYPE;
    tMaxV   CONTAINER.maxVolume%TYPE;
    tRep    CONTAINER.repair%TYPE;
    tTemp   CONTAINER.temperature%TYPE;
    tIdCsc  CONTAINER.idCsc%TYPE;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.temperature allow null - INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), null, 'temporary isCsc')
    RETURNING id INTO tIdCont;
--assert

    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID,
               identificationNumber,
               isoCod,
               maxWeight,
               tareWeight,
               maxVolume,
               repair,
               temperature,
               idCsc
        INTO tId, tIdent, tIsocod, tMaxW, tTareW, tMaxV, trep, tTemp, tIdCsc
        FROM CONTAINER
        WHERE id = tIdCont;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Container : id= ' || tId || ' IdentificationNumber= ' || tIdent
            || ' isoCod= ' || tIsocod || ' maxWeight= ' || tMaxW || ' tareWeight= ' || tTareW
            || ' maxVolume= ' || tMaxV || ' repair= ' || trep || ' temperature= ' || tTemp
            || ' idCsc= ' || tIdCsc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/

-- [Domain] Container.idCsc - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.idCsc - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.idCsc can not be null.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23R3', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, NULL);
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.idCsc - varchar2(15)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.idCsc - (varchar2(15)) INSERT "ten-Chars|" x2');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(15');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '34R5', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'ten-Chars|ten-Chars|');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/************
  Continent
*************/


-- [Identity] Continent.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdContinent NUMBER;
    tId          Continent.id%TYPE;
    tDesc        Continent.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Continent.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO Continent (description)
    VALUES ('Europe')
    RETURNING ID INTO tIdContinent;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description
        INTO tId, tDesc
        FROM Continent
        WHERE id = tIdContinent;
        DBMS_OUTPUT.put_line('SUCCESS ==> Continent : id= ' || tId || ' description= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Continent.desc - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Continent.description - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400) because a Primary Key with auto-increment can not allow manual INSERT, and that includes null and duplicates.');

--act
    INSERT INTO Continent (description)
    VALUES (NULL);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Continent.description - unique
--prepare
DECLARE
    tIdContinent NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Continent.description - (unique) INSERT duplicate "Europe"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-00001) because a unique column can not allow duplicates.');

    INSERT INTO Continent (description) VALUES ('Europe');

--act
    INSERT INTO Continent (description) VALUES ('Europe') RETURNING ID INTO tIdContinent;

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -00001 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Continent.desc - varchar2(50)
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Continent.description - (varchar2(50)) INSERT "ten-Chars|" x6');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because a Primary Key with auto-increment can not allow manual INSERT, and that includes null and duplicates.');

--act
    INSERT INTO Continent (description)
    VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/************
  Country
*************/


-- [Identity] Country.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdConti     NUMBER;
    tIdCountry   NUMBER;
    tId          Country.id%TYPE;
    tDesc        Country.description%TYPE;
    tIdContinent Country.idContinent%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Country.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');
    INSERT INTO Continent (description) VALUES ('Europe') RETURNING id INTO tIdConti;
--act
    INSERT INTO Country (description, idcontinent) VALUES ('Portugal', tIdConti) RETURNING ID INTO tIdCountry;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description, tIdContinent
        INTO tId, tDesc, tIdContinent
        FROM Country
        WHERE id = tIdCountry;
        DBMS_OUTPUT.put_line('SUCCESS ==> Country : id= ' || tId || ' description= ' || tDesc || ' idContinent= ' ||
                             tIdContinent);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Country.description - not null
--prepare
DECLARE
    tIdConti NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Country.description - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Country.description can not be null.');
    INSERT INTO Continent (description) VALUES ('Europe') RETURNING id INTO tIdConti;

--act
    INSERT INTO Country (description, idContinent) VALUES (NULL, tIdConti);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Country.description - varchar2(50)
--prepare
DECLARE
    tIdConti NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Country.description - (varchar2(50)) INSERT "ten-Chars|" x6');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(50).');
    INSERT INTO Continent (description) VALUES ('Europe') RETURNING id INTO tIdConti;

--act
    INSERT INTO Country (description, idContinent)
    VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|', tIdConti);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] Country.idContinent - foreign key constraint
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Country.idContinent - (foreign key constraint) INSERT non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

--act
    INSERT INTO Country (description, idcontinent) VALUES ('Portugal', 99);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/**************
  PlatformUser
***************/


-- [Identity] PlatformUser.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdRo     NUMBER;
    tId       PlatformUser.id%TYPE;
    tUserName PlatformUser.userName%TYPE;
    tPass     PlatformUser.password%TYPE;
    tDesc     PlatformUser.description%TYPE;
    tIdRole   PlatformUser.idRole%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] PlatformUser.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;
--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco da Game', 'password1', 'description', tIdRo);
--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, userName, password, description, idRole
        INTO tId, tUserName, tPass, tDesc, tIdRole
        FROM PlatformUser;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> PlatformUser : id= ' || tId || ' userName= ' || tUserName
            || ' password= ' || tPass || ' description= ' || tdesc || ' idRole= ' || tIdRole);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] PlatformUser.userName - unique
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.userName - (unique) INSERT duplicate "Vasco da Game"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-00001) because a unique column can not allow duplicates.');
    INSERT INTO Role (DESCRIPTION) VALUES ('Client') RETURNING id INTO tIdRo;
    INSERT INTO PlatformUser (USERNAME, PASSWORD, DESCRIPTION, IDROLE)
    VALUES ('Vasco da Game', 'password1', 'description', tIdRo);
--act
    INSERT INTO PlatformUser (USERNAME, PASSWORD, DESCRIPTION, IDROLE)
    VALUES ('Vasco da Game', 'password1', 'description', tIdRo);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/

-- [Domain] PlatformUser.userName - not null
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.userName - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PlatformUser.userName can not be null.');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;
--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES (NULL, 'password1', 'description', tIdRo);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PlatformUser.userName - varchar2(20)
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.userName - (varchar2(20)) INSERT "ten-Chars|" x3');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(20).');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;

--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('ten-Chars|ten-Chars|ten-Chars|', 'password1', 'description', tIdRo);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PlatformUser.password - not null
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.password - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PlatformUser.password can not be null.');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;
--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco de Game', NULL, 'description', tIdRo);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PlatformUser.password - varchar2(20)
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.password - (varchar2(20)) INSERT "ten-Chars|" x3');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(20).');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;

--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco de Game', 'ten-Chars|ten-Chars|ten-Chars|', 'description', tIdRo);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PlatformUser.description - not null
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.description - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PlatformUser.description can not be null.');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;
--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco de Game', 'password', NULL, tIdRo);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PlatformUser.description - varchar2(255)
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.description - (varchar2(255)) INSERT "ten-Chars|" x26');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(255).');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;

--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco de Game', 'password',
            'ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|',
            tIdRo);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] PlatformUser.idRole - foreign key constraint
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] PlatformUser.idRole - (foreign key constraint) INSERT non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');
--act
    INSERT INTO PlatformUser (USERNAME, PASSWORD, DESCRIPTION, IDROLE)
    VALUES ('Vasco da Game', 'password1', 'description', 99);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/**************
  PositionData
***************/


-- [Identity] PositionData - Primary Key: unique and not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
    pdIdShip     POSITIONDATA.IDSHIP%TYPE;
    pdDateRec    POSITIONDATA.DATETIMERECEIVED%TYPE;
    pdLatitude   POSITIONDATA.LATITUDE%TYPE;
    pdLongitude  POSITIONDATA.LONGITUDE%TYPE;
    pdSog        POSITIONDATA.SOG%TYPE;
    pdCog        POSITIONDATA.COG%TYPE;
    pdHeading    POSITIONDATA.HEADING%TYPE;
    pdPosition   POSITIONDATA.POSITION%TYPE;
    pdTransClass POSITIONDATA.TRANSCEIVERCLASS%TYPE;


BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] PositionData Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 120, 15, 10, 233, 999999999, 'A');

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT IDSHIP,
               DATETIMERECEIVED,
               LATITUDE,
               LONGITUDE,
               SOG,
               COG,
               HEADING,
               POSITION,
               TRANSCEIVERCLASS
        INTO pdIdShip, pdDateRec , pdLatitude , pdLongitude , pdSog, pdCog, pdHeading, pdPosition, pdTransClass
        FROM PositionData
        where idShip = tidShip
          and DATETIMERECEIVED = tdate;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/



-- [Identity] PositionData.idShip - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.idShip - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.idShip can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (NULL, tDate, 90, 120, 15, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Identity] PositionData.dateTimeRecieved - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.dateTimeRecieved - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.dateTimeRecieved can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, NULL, 90, 120, 15, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] PositionData.idShip - foreign key constraint
--prepare
DECLARE
    tDate Date;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] PositionData.idShip - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    select CURRENT_DATE INTO tDate from dual;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (99, tDate, 90, 120, 15, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.latitude - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.latitude can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, NULL, 120, 15, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.latitude - NUMBER(8,6)
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude - (NUMBER(8,6)) INSERT 999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(8,6).');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 999, 120, 15, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.latitude - check constraint ck_PositionData_latitude
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude ck_PositionData_latitude(latitude >= -90 AND latitude <= 90) OR latitude = 91 ) INSERT -91');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.latitude  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, -91, 120, 15, 120, 120, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] PositionData.latitude - check constraint ck_PositionData_latitude
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude ck_PositionData_latitude(latitude >= -90 AND latitude <= 90) OR latitude = 91 ) INSERT 92');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.latitude  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 92, 120, 15, 120, 120, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] PositionData.latitude - check constraint ck_PositionData_latitude
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
    pdIdShip     POSITIONDATA.IDSHIP%TYPE;
    pdDateRec    POSITIONDATA.DATETIMERECEIVED%TYPE;
    pdLatitude   POSITIONDATA.LATITUDE%TYPE;
    pdLongitude  POSITIONDATA.LONGITUDE%TYPE;
    pdSog        POSITIONDATA.SOG%TYPE;
    pdCog        POSITIONDATA.COG%TYPE;
    pdHeading    POSITIONDATA.HEADING%TYPE;
    pdPosition   POSITIONDATA.POSITION%TYPE;
    pdTransClass POSITIONDATA.TRANSCEIVERCLASS%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude ck_PositionData_latitude((latitude >= -90 AND latitude <= 90) OR latitude = 91 ) INSERT 91');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 91, 120, 15, 120, 123, 999999999, 'A');

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT IDSHIP,
               DATETIMERECEIVED,
               LATITUDE,
               LONGITUDE,
               SOG,
               COG,
               HEADING,
               POSITION,
               TRANSCEIVERCLASS
        INTO pdIdShip, pdDateRec , pdLatitude , pdLongitude , pdSog, pdCog, pdHeading, pdPosition, pdTransClass
        FROM PositionData
        where idShip = tidShip
          and DATETIMERECEIVED = tdate;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] PositionData.longitude - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.longitude can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 67, NULL, 15, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.longitude - NUMBER(9,6)
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude - (NUMBER(9,6)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(9,6).');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 66, 9999, 15, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] PositionData.longitude - check constraint ck_PositionData_longitude
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude ck_PositionData_longitude((longitude >= -180 AND longitude <= 180) OR longitude = 181 ) INSERT -181');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.longitude  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 67, -181, 15, 120, 120, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] PositionData.longitude - check constraint ck_PositionData_longitude
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude ck_PositionData_longitude((longitude >= -180 AND longitude <= 180) OR longitude = 181 ) INSERT 182');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.longitude  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 182, 15, 120, 120, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] PositionData.longitude - check constraint ck_PositionData_longitude
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
    pdIdShip     POSITIONDATA.IDSHIP%TYPE;
    pdDateRec    POSITIONDATA.DATETIMERECEIVED%TYPE;
    pdLatitude   POSITIONDATA.LATITUDE%TYPE;
    pdLongitude  POSITIONDATA.LONGITUDE%TYPE;
    pdSog        POSITIONDATA.SOG%TYPE;
    pdCog        POSITIONDATA.COG%TYPE;
    pdHeading    POSITIONDATA.HEADING%TYPE;
    pdPosition   POSITIONDATA.POSITION%TYPE;
    pdTransClass POSITIONDATA.TRANSCEIVERCLASS%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude ck_PositionData_longitude((longitude >= -180 AND longitude <= 180) OR longitude = 181 ) INSERT 181');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 181, 15, 120, 123, 999999999, 'A');

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT IDSHIP,
               DATETIMERECEIVED,
               LATITUDE,
               LONGITUDE,
               SOG,
               COG,
               HEADING,
               POSITION,
               TRANSCEIVERCLASS
        INTO pdIdShip, pdDateRec , pdLatitude , pdLongitude , pdSog, pdCog, pdHeading, pdPosition, pdTransClass
        FROM PositionData
        where idShip = tidShip
          and DATETIMERECEIVED = tdate;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] PositionData.sog - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.sog - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.sog can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 67, 45, NULL, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.sog - NUMBER(4,1)
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.sog - (NUMBER(4,1)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(4,1).');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 66, 34, 9999, 10, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.sog - check constraint ck_PositionData_sog
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.sog ck_PositionData_sog(cog >= 0) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.sog  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 120, -1, 122, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] PositionData.cog - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.cog - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.cog can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 67, 45, 13, NULL, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.cog - NUMBER(4,1)
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.cog - (NUMBER(4,1)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(4,1).');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 66, 34, 12, 9999, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.cog - check constraint ck_PositionData_cog
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.cog ck_PositionData_cog(cog >= 0 AND cog <= 359 ) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.cog  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 120, 15, -1, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.cog - check constraint ck_PositionData_cog
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.cog ck_PositionData_cog(cog >= 0 AND cog <= 359 ) INSERT 360');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.cog  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 120, 15, 360, 233, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.heading - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.heading can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 67, 45, 12, 10, NULL, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.heading - NUMBER(3)
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading - (NUMBER(3)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(3).');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 66, 34, 12, 10, 9999, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.heading - check constraint ck_PositionData_heading
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading ck_PositionData_heading(heading >= 0 AND heading <= 359) OR heading = 511 ) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.heading  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 120, 15, 120, -1, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.heading - check constraint ck_PositionData_heading
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading ck_PositionData_heading(heading >= 0 AND heading <= 359) OR heading = 511 ) INSERT 360');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.heading  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 120, 15, 120, 360, 999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] PositionData.heading - check constraint ck_PositionData_heading
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
    pdIdShip     POSITIONDATA.IDSHIP%TYPE;
    pdDateRec    POSITIONDATA.DATETIMERECEIVED%TYPE;
    pdLatitude   POSITIONDATA.LATITUDE%TYPE;
    pdLongitude  POSITIONDATA.LONGITUDE%TYPE;
    pdSog        POSITIONDATA.SOG%TYPE;
    pdCog        POSITIONDATA.COG%TYPE;
    pdHeading    POSITIONDATA.HEADING%TYPE;
    pdPosition   POSITIONDATA.POSITION%TYPE;
    pdTransClass POSITIONDATA.TRANSCEIVERCLASS%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading ck_PositionData_heading(heading >= 0 AND heading <= 359) OR heading = 511 ) INSERT 511');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 120, 15, 120, 511, 999999999, 'A');

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT IDSHIP,
               DATETIMERECEIVED,
               LATITUDE,
               LONGITUDE,
               SOG,
               COG,
               HEADING,
               POSITION,
               TRANSCEIVERCLASS
        INTO pdIdShip, pdDateRec , pdLatitude , pdLongitude , pdSog, pdCog, pdHeading, pdPosition, pdTransClass
        FROM PositionData
        where idShip = tidShip
          and DATETIMERECEIVED = tdate;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] PositionData.position - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.position - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.position can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 67, 45, 12, 10, 231, NULL, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.position - NUMBER(9)
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.position - (NUMBER(9)) INSERT 9999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(9).');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 66, 34, 12, 10, 23, 9999999999, 'A');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] PositionData.transcieverClass - not null
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.transcieverClass can not be null.');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 67, 45, 12, 10, 231, 999999999, NULL);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.transcieverClass - char(1)
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass - ( char(1)) INSERT "AA"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to  char(1).');

    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 66, 34, 12, 10, 23, 999999999, 'AA');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.transcieverClass - check constraint ck_PositionData_transceiverClass
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass ck_PositionData_transceiverClass(transceiverClass IN ("A", "B")) INSERT "C"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.transcieverClass  check constraint violation');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 120, 12, 122, 233, 999999999, 'C');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] PositionData.transcieverClass - check constraint ck_PositionData_transceiverClass
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
    pdIdShip     POSITIONDATA.IDSHIP%TYPE;
    pdDateRec    POSITIONDATA.DATETIMERECEIVED%TYPE;
    pdLatitude   POSITIONDATA.LATITUDE%TYPE;
    pdLongitude  POSITIONDATA.LONGITUDE%TYPE;
    pdSog        POSITIONDATA.SOG%TYPE;
    pdCog        POSITIONDATA.COG%TYPE;
    pdHeading    POSITIONDATA.HEADING%TYPE;
    pdPosition   POSITIONDATA.POSITION%TYPE;
    pdTransClass POSITIONDATA.TRANSCEIVERCLASS%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass ck_PositionData_transceiverClass(transceiverClass IN ("A", "B")) INSERT "A"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 181, 15, 120, 123, 999999999, 'A');

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT IDSHIP,
               DATETIMERECEIVED,
               LATITUDE,
               LONGITUDE,
               SOG,
               COG,
               HEADING,
               POSITION,
               TRANSCEIVERCLASS
        INTO pdIdShip, pdDateRec , pdLatitude , pdLongitude , pdSog, pdCog, pdHeading, pdPosition, pdTransClass
        FROM PositionData
        where idShip = tidShip
          and DATETIMERECEIVED = tdate;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/



-- [Domain] PositionData.transcieverClass - check constraint ck_PositionData_transceiverClass
--prepare
DECLARE
    tDate        Date;
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tIdShip      NUMBER;
    pdIdShip     POSITIONDATA.IDSHIP%TYPE;
    pdDateRec    POSITIONDATA.DATETIMERECEIVED%TYPE;
    pdLatitude   POSITIONDATA.LATITUDE%TYPE;
    pdLongitude  POSITIONDATA.LONGITUDE%TYPE;
    pdSog        POSITIONDATA.SOG%TYPE;
    pdCog        POSITIONDATA.COG%TYPE;
    pdHeading    POSITIONDATA.HEADING%TYPE;
    pdPosition   POSITIONDATA.POSITION%TYPE;
    pdTransClass POSITIONDATA.TRANSCEIVERCLASS%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass ck_PositionData_transceiverClass(transceiverClass IN ("A", "B")) INSERT "B"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE INTO tDate from dual;
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    RETURNING IDTRANSPORT INTO tIdShip;

--act
    INSERT INTO POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    VALUES (tIdShip, tDate, 90, 181, 15, 120, 123, 999999999, 'B');

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT IDSHIP,
               DATETIMERECEIVED,
               LATITUDE,
               LONGITUDE,
               SOG,
               COG,
               HEADING,
               POSITION,
               TRANSCEIVERCLASS
        INTO pdIdShip, pdDateRec , pdLatitude , pdLongitude , pdSog, pdCog, pdHeading, pdPosition, pdTransClass
        FROM PositionData
        where idShip = tidShip
          and DATETIMERECEIVED = tdate;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


/************
  Role
*************/


-- [Identity] Role.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Role.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO Role (description)
    VALUES ('Client')
    RETURNING ID INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description
        INTO rId, rDesc
        FROM Role
        WHERE id = tIdRole;
        DBMS_OUTPUT.put_line('SUCCESS ==> Role : id= ' || rId || ' description= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Role.desc - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Role.description - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400) because a Primary Key with auto-increment can not allow manual INSERT, and that includes null and duplicates.');

--act
    INSERT INTO Role (description)
    VALUES (NULL);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Role.description - unique
--prepare
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Role.description - (unique) INSERT duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-00001): Role.description can not have duplicate VALUES.');
    INSERT INTO Role (description) VALUES ('Client');

--act
    INSERT INTO Role (description) VALUES ('Client');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -00001 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Role.desc - varchar2(255)
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Role.description - (varchar2(255)) INSERT "ten-Chars|" x26');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(255).');

--act
    INSERT INTO Role (description)
    VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Client", "Fleet manager", "Traffic manager", "Warehouse staff", "Warehouse manage", "Port staff", "Port manager", "Ship captain", "Ship chief electrical engineer", "Truck driver") INSERT "string"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('string');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Client" ...) ) INSERT "Client"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Client')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Fleet manager" ...) ) INSERT "Fleet manager"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Fleet manager')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Traffic manager" ...) ) INSERT "Traffic manager"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Traffic manager')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Wharehouse staff" ...) ) INSERT "Warehouse staff"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Warehouse staff')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Warehouse manager" ...) ) INSERT "Warehouse manager"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Warehouse manager')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Port staff" ...) ) INSERT "Port staff"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Port staff')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Port manager" ...) ) INSERT "Port manager"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Port manager')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Ship captain" ...) ) INSERT "Ship captain"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Ship captain')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Ship chief electrical engineer" ...) ) INSERT "Ship chief electrical engineer"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Ship chief electrical engineer')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId     Role.id%TYPE;
    rDesc   Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Truck driver" ...) ) INSERT "Truck driver"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Truck driver')
    RETURNING id INTO tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


/************
  Ship
*************/


-- [Identity] Ship.idTransport - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.idTransport - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');
--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (null, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Identity] Ship.idTransport - unique
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.idTransport - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Ship.idTransport can not have duplicate VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);
--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.idTransport - NUMBER(19)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.idTransport - ( NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(19).');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;
--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (99999999999999999999, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] Ship.idTransport - foreign key constraint
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Ship.idTransport - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (99, 222222222, 'HWBM99999', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.mmsi - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.mmsi - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Ship.mmsi  can not be null.');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, null, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.mmsi - unique
--prepare
DECLARE
    tIdTransType  NUMBER;
    tIdTransport1 NUMBER;
    tIdTransport2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.mmsi - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Ship.mmsi can not have duplicate VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport1;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport2;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport1, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);
--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport2, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.mmsi - NUMBER(9)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.mmsi - ( NUMBER(9)) INSERT 9999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(9).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 9999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



-- [Domain] Ship.callSign - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.callSign - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Ship.callSign can not be null.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, null, 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.callSign - unique
--prepare
DECLARE
    tIdTransType  NUMBER;
    tIdTransport1 NUMBER;
    tIdTransport2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.callSign - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Ship.callSign can not have duplicate VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport1;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport2;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport1, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);
--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport2, 222222222, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.callSign - varchar2(10)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.callSign - ( varchar2(10)) INSERT "ten_chars|" x3');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(10).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'ten_chars|ten_chars|ten_chars|', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30,
            10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.name - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.name - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', null, 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.name - varchar2(50)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.name - ( varchar2(50)) INSERT "ten_chars|" x6');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(50).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'ten_chars|ten_chars|ten_chars|ten_chars|ten_chars|ten_chars|',
            9999999, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.imoNumber - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.imoNumber - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', null, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.imoNumber - unique
--prepare
DECLARE
    tIdTransType  NUMBER;
    tIdTransport1 NUMBER;
    tIdTransport2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.imoNumber - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Ship.imoNumber can not have duplicate VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport1;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport2;
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport1, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);
--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport2, 222222222, 'HWBM99999', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.imoNumber - NUMBER(7)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.imoNumber - ( NUMBER(7)) INSERT 99999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(7).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 99999999, 99, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.generators - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.generators - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, null, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.generators - NUMBER(3)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.generators - ( NUMBER(3)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(3).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 9999, 10000, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.generators - check constraint ck_Ship_generators
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.generators ck_Ship_generators( capacity >= 0) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.generators  check constraint violation');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, -99, 1000, 20, 100, 60, 40, 12.2);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.outputGenerator - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.outputGenerator - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, null, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.outputGenerator - NUMBER(6)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.generators - ( NUMBER(6)) INSERT 9999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(6).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 9999999, 10, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.outputGenerator - check constraint ck_Ship_outputGenerator
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.outputGenerator ck_Ship_outputGenerator( capacity >= 0) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.outputGenerator  check constraint violation');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, -1, 20, 100, 60, 40, 12.2);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.vesseType - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.vesseType - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, null, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.vesseType - NUMBER(4)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.vesseType - ( NUMBER(4)) INSERT 99999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(4).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 99999, 200, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.vesselType - check constraint ck_Ship_vesselType
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.vesselType ck_Ship_vesselType( capacity >= 0) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.vesselType  check constraint violation');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, -1, 100, 60, 40, 12.2);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.length - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.length - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, null, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.length - NUMBER(4)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.length - ( NUMBER(4)) INSERT 99999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(4).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 9999, 99999, 60, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.length - check constraint ck_Ship_length
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.length ck_Ship_length( capacity >= 0) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.length  check constraint violation');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, -1, 60, 40, 12.2);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.width - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.width - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, null, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.width - NUMBER(3)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.width - ( NUMBER(3)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(3).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 9999, 999, 9999, 30, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


--[Domain] Ship.width - check constraint ck_Ship_width
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.width ck_Ship_width( capacity >= 0) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.width  check constraint violation');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 30, 100, -1, 40, 12.2);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.capacity - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.capacity - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, null, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.capacity - NUMBER(7)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.capacity - ( NUMBER(7)) INSERT 99999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(7).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 9999, 999, 99, 99999999, 10.3);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.capacity - check constraint ck_Ship_capacity
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.capacity ck_Ship_capacity( capacity >= 0) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.capacity  check constraint violation');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, -40, 12.2);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.draft - not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.draft - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null VALUES.');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, null);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.draft - NUMBER(3,1)
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.draft - ( NUMBER(3,1)) INSERT 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  NUMBER(3,1).');
    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 9999, 999, 99, 9999999, 9999);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Ship.draft - check constraint ck_Ship_draft
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.draft ck_Ship_draft( capacity >= 0) INSERT -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.draft  check constraint violation');

    INSERT INTO transportType (DESCRIPTION) VALUES ('Ship') RETURNING id INTO tIdTransType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    VALUES (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, -12.2);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/************
  Transport
*************/


-- [Identity] Transport.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
    tId          Transport.id%TYPE;
    tActive      Transport.active%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Transport.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
--act
    INSERT
    INTO Transport (active, idTransportType)
    VALUES ('1', tIdTransType)
    RETURNING id iNTO tidTransport;
--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, active, idTransportType
        INTO tId, tActive, tIdTransType
        FROM Transport
        WHERE id = tIdTransport;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Transport : id= ' || tId || ' active= ' || tActive || ' idTransportType= ' ||
                             tIdTransType);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Transport.active - not null
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Transport.active - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Transport.active can not be null.');
    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
--act
    INSERT
    INTO Transport (idTransportType)
    VALUES (tIdTransType);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Transport.active - char(1)
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Transport.active - (char(1)) INSERT "11" ');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to char(1).');

    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
--act
    INSERT
    INTO Transport (active, idTransportType)
    VALUES ('11', tIdTransType);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Transport.idTransportType - not null
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Transport.idTransportType - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Transport.idTransportType can not be null.');
    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
--act
    INSERT
    INTO Transport (active, idTransportType)
    VALUES ('1', null);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Transport.idTransportType - NUMBER(19)
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Transport.idTransportType - (NUMBER(19)) INSERT 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(19).');
    INSERT INTO transportType (transportType.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
--act
    INSERT
    INTO Transport (active, idTransportType)
    VALUES ('1', 99999999999999999999);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01438 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] Transport.idTransportType - foreign key constraint
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Transport.idTransportType - (foreign key constraint) INSERT non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    --act
    INSERT
    INTO Transport (active, idTransportType)
    VALUES ('1', 1);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


/************
  Cargosite
*************/


-- [Identity] TransportType.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdTransportType NUMBER;
    tId              TransportType.id%TYPE;
    tDesc            TransportType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] TransportType.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO TransportType (description)
    VALUES ('Truck')
    RETURNING ID INTO tIdTransportType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description
        INTO tId, tDesc
        FROM TransportType
        WHERE id = tIdTransportType;
        DBMS_OUTPUT.put_line('SUCCESS ==> TransportType : id= ' || tId || ' description= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] TransportType.description - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description - (not null) INSERT null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): TransportType.description can not be null.');

--act
    INSERT INTO TransportType (description)
    VALUES (NULL);

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] TransportType.description - unique
--prepare
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description - (unique) INSERT duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: TransportType.description can not have duplicate VALUES.');
    INSERT INTO TransportType (description) VALUES ('Ship');

--act
    INSERT INTO TransportType (description) VALUES ('Ship');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] TransportType.description - varchar2(255)
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description - (varchar2(255)) INSERT "ten-Chars|" x26');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(255).');

--act
    INSERT INTO TransportType (description)
    VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] TransportType.description - check constraint ck_TransportType_description
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description ck_TransportType_description( description IN ("Client", "Fleet manager", "Traffic manager", "Warehouse staff", "Warehouse manage", "Port staff", "Port manager", "Ship captain", "Ship chief electrical engineer", "Truck driver") INSERT "string"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): TransportType.description check constraint violation');

--act
    INSERT INTO TransportType(description)
    VALUES ('string');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02290 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Aplicational] TransportType.description - check constraint ck_TransportType_description
--prepare
DECLARE
    tIdTransportType NUMBER;
    tId              TransportType.id%TYPE;
    tDesc            TransportType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description ck_TransportType_description( description IN ("Truck" ...) ) INSERT "Truck"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: TransportType.description check constraint violation');

--act
    INSERT INTO TransportType(description)
    VALUES ('Truck')
    RETURNING id INTO tIdTransportType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM TransportType WHERE id = tIdTransportType;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> TransportType : id= ' || tId || ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] TransportType.description - check constraint ck_TransportType_description
--prepare
DECLARE
    tIdTransportType NUMBER;
    tId              TransportType.id%TYPE;
    tDesc            TransportType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description ck_TransportType_description( description IN ("Ship" ...) ) INSERT "Ship"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: TransportType.description check constraint violation');

--act
    INSERT INTO TransportType(description)
    VALUES ('Ship')
    RETURNING id INTO tIdTransportType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM TransportType WHERE id = tIdTransportType;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> TransportType : id= ' || tId || ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


/************
  Truck
*************/


-- [Identity] Truck.idTransport - Primary Key not null
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Truck.idTransport - (Primary Key not null) INSERT null ');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Truck.idTransport can not be null.');

--act
    INSERT INTO Truck (IDTRANSPORT, LICENSEPLATE) VALUES (null, '99-77-jj');
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/

-- [Identity] Truck.idTransport - Primary Key unique
--prepare
DECLARE
    tIdTransType NUMBER;
    tIdTransport NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Truck.idTransport - (Primary Key unique) INSERT duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Truck.idTransport can not have duplicate VALUES.');
    INSERT INTO transportType(DESCRIPTION) VALUES ('Ship') RETURNING ID INTO tIdTransType;
    INSERT INTO TRANSPORT(ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING ID INTO tIdTransport;
    INSERT INTO Truck (IDTRANSPORT, LICENSEPLATE) VALUES (tIdTransport, '22-11-kk');
--act
    INSERT INTO Truck (IDTRANSPORT, LICENSEPLATE) VALUES (tIdTransport, '99-77-jj');
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Truck.licensePlate - unique
--prepare
DECLARE
    tIdTransType  NUMBER;
    tIdTransport1 NUMBER;
    tIdTransport2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Truck.licensePlate - (unique) INSERT duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Truck.licensePlate can not have duplicate VALUES.');
    INSERT INTO transportType(DESCRIPTION) VALUES ('Ship') RETURNING ID INTO tIdTransType;
    INSERT INTO TRANSPORT(ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING ID INTO tIdTransport1;
    INSERT INTO TRANSPORT(ACTIVE, IDtransportType) VALUES ('1', tIdTransType) RETURNING ID INTO tIdTransport2;
    INSERT INTO Truck (IDTRANSPORT, LICENSEPLATE) VALUES (tIdTransport1, '99-77-jj');
--act
    INSERT INTO Truck (IDTRANSPORT, LICENSEPLATE) VALUES (tIdTransport2, '99-77-jj');
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Truck.licensePlate - not null
--prepare
DECLARE
    tIdTransportType NUMBER;
    tIdTransport     NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Truck.licensePlate - (not null) INSERT null ');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Truck.licensePlate can not be null.');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Truck') RETURNING id INTO tIdTransportType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransportType) RETURNING id INTO tIdTransport;
--act
    INSERT INTO Truck (IDTRANSPORT, LICENSEPLATE) VALUES (tIdTransport, null);
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1400 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Truck.licensePlate - varchar2(20)
--prepare
DECLARE
    tIdTransportType NUMBER;
    tIdTransport     NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Truck.licensePlate - (varchar2(20)) INSERT "ten-Chars|" x3');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(20).');

    INSERT INTO transportType (transportType.DESCRIPTION) VALUES ('Truck') RETURNING id INTO tIdTransportType;
    INSERT INTO Transport (ACTIVE, IDtransportType) VALUES ('1', tIdTransportType) RETURNING id INTO tIdTransport;

--act
    INSERT INTO Truck (idTransport, licensePlate)
    VALUES (tIdTransport, 'ten-Chars|ten-Chars|ten-Chars|');

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -12899 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Referential] Truck.idTransport - foreign key constraint
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Transport.idTransport - (foreign key constraint) INSERT non existent "99"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');
--act
    INSERT INTO Truck (IDTRANSPORT, LICENSEPLATE) VALUES (99, '99-77-jj');
--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -02291 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/



