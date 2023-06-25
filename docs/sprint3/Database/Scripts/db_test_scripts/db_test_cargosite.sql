/****************************************************************************************************
script Usage:       To have feedback from the script you should activate "Enable DBMS_OUTPUT"
                    This script do not create the database, it should be created first and then
                    this script should run in it.
                    On every test, the instructions executed are rolled back
***************************************************************************************************
SUMMARY OF CHANGES
Date(dd-MM-yyyy)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
***************************************************************************************************/


-- [Identity] Cargosite.id - Primary Key: unique and not null
--prepare
declare
    tIdContinent     number;
    tIdCountr        number;
    tIdCargositety   number;
    tIdCargosite     number;
    tId              CARGOSITE.id%TYPE;
    tName            CARGOSITE.name%TYPE;
    tLatitude        CARGOSITE.latitude%TYPE;
    tLongitude       CARGOSITE.longitude%TYPE;
    tIdCountry       CARGOSITE.idCountry%TYPE;
    tIdCargositeType CARGOSITE.idCargoSiteType%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Cargosite.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');


    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountr;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositety;
--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdCountr, tIdCargositety)
    RETURNING id INTO tIdCargosite;
--assert

    if sql%rowcount > 0 then
        SELECT ID, NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE
        INTO tId, tName, tLatitude, tLongitude, tIdCountry, tIdCargositeType
        FROM Cargosite
        WHERE id = tIdCargosite;
        dbms_output.put_line('SUCCESS ==> Cargosite : id= ' || tId || ' name= ' || tName || ' latitude= ' || tLatitude
            || ' longitude= ' || tLongitude || ' idCountry= ' || tIdCountry || ' idCargoSiteType= ' ||
                             tIdCargoSiteType);
    else
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Cargosite.name - not null
--prepare
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.name - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.name can not be null.');
    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values (NULL, 35, 35, tIdCountry, tIdCargositetype);
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
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.name - (varchar2(50)) insert "ten-Chars|" x6');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(50).');
    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|', 35, 35, tIdCountry, tIdCargositetype);
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
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.latitude - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.latitude can not be null.');
    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', NULL, 35, tIdCountry, tIdCargositetype);
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


-- [Domain] Cargosite.latitude - number(8,5)
--prepare
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.latitude - (number(8,5)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(8,5).');
    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 9999, 35, tIdCountry, tIdCargositetype);
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
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.latitude ck_CargoSite_latitude - (latitude >= -90 AND latitude <= 90) insert -91');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Cargosite.latitude check constraint violation');

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
--act
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', -91, 34, tIdCountry, tIdCargositetype);
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
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.latitude ck_CargoSite_latitude - (latitude >= -90 AND latitude <= 90) insert 91');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Cargosite.latitude check constraint violation');

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
--act
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 91, 34, tIdCountry, tIdCargositetype);
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
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.longitude - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.longitude can not be null.');
    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 35, NULL, tIdCountry, tIdCargositetype);
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


-- [Domain] Cargosite.longitude - number(8,5)
--prepare
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.longitude - (number(8,5)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(8,5).');
    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 35, 9999, tIdCountry, tIdCargositetype);
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
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.longitude ck_CargoSite_longitude - (longitude >= -180 AND longitude <= 180) insert 181');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Cargosite.longitude check constraint violation');

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
--act
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 181, tIdCountry, tIdCargositetype);
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
declare
    tIdContinent     number;
    tIdCountry       number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.longitude ck_CargoSite_longitude - (longitude >= -180 AND longitude <= 180) insert -181');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Cargosite.longitude check constraint violation');

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
--act
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, -181, tIdCountry, tIdCargositetype);
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
declare
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idcountry - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.idcountry can not be null.');
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 35, 35, NULL, tIdCargositetype);
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


-- [Domain] Cargosite.idcountry - number(19)
--prepare
declare
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idcountry - ( number(19)) insert 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(19).');
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 9999, 35, 99999999999999999999, tIdCargositetype);
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
declare
    tIdContinent     number;
    tIdCargositetype number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.idcountry - (foreign key constraint) insert non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent);
    insert into CARGOSITETYPE (Description) values ('Port') returning id into tIdCargositetype;
--act
    insert into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, 99, tIdCargositetype);
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
declare
    tIdContinent number;
    tIdCountry   number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idCargositeType - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Cargosite.idCargositeType can not be null.');
    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 35, 35, tIdCountry, NULL);
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


-- [Domain] Cargosite.idCargositeType - number(19)
--prepare
declare
    tIdContinent number;
    tIdCountry   number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Cargosite.idCargositeType - ( number(19)) insert 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(19).');
    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent);

--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 9999, 35, tIdCountry, 99999999999999999999);
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
declare
    tIdContinent number;
    tIdCountry   number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Cargosite.idcargositetype - (foreign key constraint) insert non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    insert into CONTINENT (Description) values ('Europe') returning id into tIdContinent;
    insert into COUNTRY (Description, IDCONTINENT) values ('Portugal', tIdContinent) returning id into tIdCountry;
    insert into CARGOSITETYPE (Description) values ('Port');
--act
    insert
    into Cargosite (NAME, LATITUDE, LONGITUDE, IDCOUNTRY, IDCARGOSITETYPE)
    values ('Porto de Leixões', 34, 34, tIdContinent, 99);
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

