/****************************************************************************************************
script Usage:       To have feedback FROM the script you should activate "Enable DBMS_OUTPUT"
                    This script do not create the database, it should be created first and then
                    this script should ru in it.
                    The instructions executed are rolled back at the end of every test.
***************************************************************************************************
SUMMARY OF CHANGES
Date(dd-MM-yyyy)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
***************************************************************************************************/

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

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
    if sql%rowcount > 0 then
        SELECT idContainer, idCargoManifest, grossWeight, xPosition, yPosition, zPosition
        INTO cmIdContainer, cmIdCargoManifest, cmGrossWeight, cmXpos, cmYpos, cmZpos
        FROM CARGOMANIFESTLINE
        WHERE idContainer = tIdContainer
          and idCargoManifest = tIdCargoManifest;
        dbms_output.put_line('SUCCESS ==> CargoManifest : idContainer= ' || cmIdContainer || ' idCargoManifest= ' ||
                             cmIdCargoManifest
            || ' grossWeight= ' || cmGrossWeight || ' xPosition= ' || cmXpos || ' yPosition= ' || cmYpos ||
                             ' zPosition= ' || cmZpos);
    else
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

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.idContainer  - (NUMBER(19)) insert 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to NUMBER(19).');

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.idCargoManifest  - (NUMBER(19)) insert 99999999999999999999');
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


    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.grossWeight - (number(5)) insert 999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(5).');
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.xPosition - (number(3)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(3).');
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.xPositon ck_CargoManifestLine_xPosition ( xPosition >= 0 ) - insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): CargoManifestLine.xPositon  check constraint violation');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.yPosition - (number(3)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(3).');
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
        DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.yPositon ck_CargoManifestLine_yPosition ( yPosition >= 0 ) - insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): CargoManifestLine.yPositon  check constraint violation');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestLine.grossWeight constraint ck_cargoManifestLine_grossWeight - ( grossWeight > 0 ) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): CargoManifestLine.grossWeight  check constraint violation');

    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT INTO ZE.CONTAINER (identificationNumber, isoCod, maxWeight, tareWeight, maxVolume, repair, temperature,
                              idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc')
    RETURNING id INTO tIdContainer;

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id INTO tIdTransType;
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


