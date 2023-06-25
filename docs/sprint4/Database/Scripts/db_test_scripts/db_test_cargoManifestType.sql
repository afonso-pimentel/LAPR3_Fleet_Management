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
    INSERT INTO CargoManifestType (description) VALUES ('Load') returning ID into tIdCargoManifestType;

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
END ;


-- [Domain] CargoManifestType.description - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description - (not null) insert null');
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description - (varchar2(30)) insert "ten-Chars|" x4');
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
declare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description - (unique) insert duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: CargoManifestType.description can not have duplicate values.');
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description ck_CargoManifestType_description( description IN ("Load", "Unload") ) insert "lload"');
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description ck_CargoManifestType_description( description IN ("Load", "Unload") ) insert "Load"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: CargoManifestType.description check constraint violation');

--act
    INSERT INTO CargoManifestType(description) VALUES ('Load') returning ID into tIdCargoManifestType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM CargoManifestType WHERE id = tIdCargoManifestType;
        dbms_output.put_line('SUCCESS ==> CargoManifestType : id= ' || tId || ' desc= ' || tDesc);
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] CargoManifestType.description ck_CargoManifestType_description( description IN ("Load", "Unload") ) insert "Unload"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: CargoManifestType.description check constraint violation');

--act
    INSERT INTO CargoManifestType(description) VALUES ('Unload') returning ID into tIdCargoManifestType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM CargoManifestType WHERE id = tIdCargoManifestType;
        dbms_output.put_line('SUCCESS ==> CargoManifestType : id= ' || tId || ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


