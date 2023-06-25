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

-- [Identity] TransportType.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdTransportType NUMBER;
    tId  TransportType.id%TYPE;
    tDesc TransportType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] TransportType.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO TransportType (description)
    VALUES ('Truck')
    returning ID into tIdTransportType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description
        INTO tId, tDesc
        FROM TransportType WHERE id = tIdTransportType;
        DBMS_OUTPUT.put_line('SUCCESS ==> TransportType : id= ' || tId|| ' description= ' || tDesc);
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description - (not null) insert null');
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
declare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description - (unique) insert duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: TransportType.description can not have duplicate values.');
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description - (varchar2(255)) insert "ten-Chars|" x26');
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description ck_TransportType_description( description IN ("Client", "Fleet manager", "Traffic manager", "Warehouse staff", "Warehouse manage", "Port staff", "Port manager", "Ship captain", "Ship chief electrical engineer", "Truck driver") insert "string"');
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
    tId                 TransportType.id%TYPE;
    tDesc                TransportType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description ck_TransportType_description( description IN ("Truck" ...) ) insert "Truck"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: TransportType.description check constraint violation');

--act
    INSERT INTO TransportType(description)
    VALUES ('Truck') RETURNING id INTO tIdTransportType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM TransportType WHERE id = tIdTransportType;
        dbms_output.put_line('SUCCESS ==> TransportType : id= ' || tId|| ' desc= ' || tDesc);
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
    tId                 TransportType.id%TYPE;
    tDesc                TransportType.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] TransportType.description ck_TransportType_description( description IN ("Ship" ...) ) insert "Ship"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: TransportType.description check constraint violation');

--act
    INSERT INTO TransportType(description)
    VALUES ('Ship') returning id INTO tIdTransportType;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO tId, tDesc FROM TransportType WHERE id = tIdTransportType;
        dbms_output.put_line('SUCCESS ==> TransportType : id= ' || tId|| ' desc= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


