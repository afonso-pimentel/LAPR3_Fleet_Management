/****************************************************************************************************
script Usage:       To have feedback from the script you should activate "Enable DBMS_OUTPUT"
                    This script do not create the database, it should be created first and then
                    this script should run in it.
                    The instructions executed are rolled back at the end of every test.
***************************************************************************************************
SUMMARY OF CHANGES
Date(dd-MM-yyyy)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
***************************************************************************************************/

-- [Identity] CargoManifest.id - Primary Key: unique and not null
--prepare
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
    tIdCargoManifestType number;
    cmId                 CargoManifest.id%TYPE;
    cmIdTransport        CargoManifest.IDTRANSPORT%TYPE;
    cmIdCargoSite        CargoManifest.IDCARGOSITE%TYPE;
    cmIdCargoManifest    CargoManifest.IDCARGOMANIFESTTYPE%TYPE;
BEGIN
        DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] CargoManifest.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (tIdTransport, tIdCargosite, tIdCargoManifestType);
--assert
    if sql%rowcount > 0 then
        SELECT ID, IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE
        INTO cmId, cmIdTransport, cmIdCargoSite, cmIdCargoManifest
        FROM CargoManifest;
        dbms_output.put_line('SUCCESS ==> CargoManifest : id= ' || cmId || ' idTransport= ' || cmIdTransport
            || ' idCargoSite= ' || cmIdCargoSite || ' idCargoManifest= ' || cmIdCargoManifest);
    else
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] CargoManifest.idTransport - not null
--prepare
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
    tIdCargoManifestType number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifest.idTransport - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifest.idTransport can not be null.');

    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (NULL, tIdCargosite, tIdCargoManifestType);
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



-- [Domain] CargoManifest.idTransport - number(19)
--prepare
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
    tIdCargoManifestType number;
BEGIN
        DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idTransport - ( number(19)) insert 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(19).');

    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (99999999999999999999, tIdCargosite, tIdCargoManifestType);
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
declare
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
    tIdCargoManifestType number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] CargoManifest.idTransport - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (99, tIdCargosite, tIdCargoManifestType);
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
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
    tIdCargoManifestType number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifest.idTransport - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifest.idTransport can not be null.');

    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (tIdTransport, NULL, tIdCargoManifestType);
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



-- [Domain] CargoManifest.idCargoSite - number(19)
--prepare
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
    tIdCargoManifestType number;
BEGIN
        DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idCargoSite - ( number(19)) insert 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(19).');

    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (tIdTransport, 99999999999999999999, tIdCargoManifestType);
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
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdCargoManifestType number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] CargoManifest.idCargoSite - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');
    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (tIdTransport, 99, tIdCargoManifestType);
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
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
    tIdCargoManifestType number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifest.idCargoManifestType - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): CargoManifest.idCargoManifestType can not be null.');

    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (tIdTransport, tIdCargosite, NULL);
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



-- [Domain] CargoManifest.idCargoSite - number(19)
--prepare
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
    tIdCargoManifestType number;
BEGIN
        DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idCargoManifestType - ( number(19)) insert 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(19).');

    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

    insert into CargoManifestType (description) values ('Load') returning id into tIdCargoManifestType;
--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (tIdTransport, tIdCargosite, 99999999999999999999);
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
declare
    tIdTransType         number;
    tIdTransport         number;
    tIdContinent         number;
    tIdCountry           number;
    tIdCargositetype     number;
    tIdCargosite         number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] CargoManifest.idCargoManifestType - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');
    insert into TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountry, tIdCargositetype)
    returning id into tIdCargosite;

--act
    insert
    into CargoManifest (IDTRANSPORT, IDCARGOSITE, IDCARGOMANIFESTTYPE)
    values (tIdTransport, tIdCargosite, 99);
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
