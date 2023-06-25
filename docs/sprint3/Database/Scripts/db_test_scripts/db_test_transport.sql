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

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
--act
    INSERT
    INTO Transport (active, idTransportType)
    VALUES ('1', tIdTransType) RETURNING id iNTO tidTransport;
--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, active, idTransportType
        INTO tId, tActive, tIdTransType
        FROM Transport WHERE id = tIdTransport;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Transport : id= ' || tId || ' active= ' || tActive || ' idTransportType= ' || tIdTransType);
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
    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
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
        DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Transport.active - (char(1)) insert "11" ');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to char(1).');

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
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
    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
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


-- [Domain] Transport.idTransportType - number(19)
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Transport.idTransportType - (number(19)) insert 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(19).');
    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.description) VALUES ('Ship') RETURNING id iNTO tIdTransType;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Transport.idTransportType - (foreign key constraint) insert non existing');
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