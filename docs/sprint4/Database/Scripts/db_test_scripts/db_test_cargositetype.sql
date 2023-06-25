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

-- [Identity] CargoSiteType.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdCargoSiteType NUMBER;
    tId                  CargoSiteType.id%TYPE;
    tDesc                CargoSiteType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] CargoSiteType.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO CargoSiteType (description) VALUES ('Port') returning ID into tIdCargoSiteType;

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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description - (not null) insert null');
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
declare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description - (unique) insert duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: CargoSiteType.description can not have duplicate values.');
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description - (varchar2(30)) insert "ten-Chars|" x4');
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description ck_CargoSiteType_description( description IN ("Port", "Warehouse") ) insert "string"');
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
    tId                  CargoSiteType.id%TYPE;
    tDesc                CargoSiteType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description ck_CargoSiteType_description( description IN ("Port", "Warehouse")) insert "Port"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');

--act
    INSERT INTO CargoSiteType(description) VALUES ('Port') returning ID into tIdCargoSiteType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM CargoSiteType WHERE id = tIdCargoSiteType;
        dbms_output.put_line('SUCCESS ==> CargoSiteType : id= ' || tId || ' desc= ' || tDesc);
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
    tId                  CargoSiteType.id%TYPE;
    tDesc                CargoSiteType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoSiteType.description ck_CargoSiteType_description( description IN ("Port", "Warehouse") ) insert "Warehouse"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');

--act
    INSERT INTO CargoSiteType(description) VALUES ('Warehouse') returning ID into tIdCargoSiteType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM CargoSiteType WHERE id = tIdCargoSiteType;
        dbms_output.put_line('SUCCESS ==> CargoSiteType : id= ' || tId || ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/
