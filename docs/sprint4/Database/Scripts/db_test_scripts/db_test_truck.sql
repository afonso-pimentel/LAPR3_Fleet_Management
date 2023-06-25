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


-- [Identity] Truck.idTransport - Primary Key not null
--prepare
DECLARE
    tIdTransType NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Truck.idTransport - (Primary Key not null) insert null ');
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Truck.idTransport - (Primary Key unique) insert duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Truck.idTransport can not have duplicate values.');
    INSERT INTO TRANSPORTTYPE(DESCRIPTION) VALUES ('Ship') RETURNING ID INTO tIdTransType;
    INSERT INTO TRANSPORT(ACTIVE, IDTRANSPORTTYPE) VALUES ('1', tIdTransType) RETURNING ID INTO tIdTransport;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Truck.licensePlate - (unique) insert duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Truck.licensePlate can not have duplicate VALUES.');
    INSERT INTO TRANSPORTTYPE(DESCRIPTION) VALUES ('Ship') RETURNING ID INTO tIdTransType;
    INSERT INTO TRANSPORT(ACTIVE, IDTRANSPORTTYPE) VALUES ('1', tIdTransType) RETURNING ID INTO tIdTransport1;
    INSERT INTO TRANSPORT(ACTIVE, IDTRANSPORTTYPE) VALUES ('1', tIdTransType) RETURNING ID INTO tIdTransport2;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Truck.licensePlate - (not null) insert null ');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Truck.licensePlate can not be null.');

        INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) VALUES ('Truck') RETURNING id INTO tIdTransportType;
    INSERT INTO Transport (ACTIVE, IDTRANSPORTTYPE) VALUES ('1', tIdTransportType) RETURNING id INTO tIdTransport;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Truck.licensePlate - (varchar2(20)) insert "ten-Chars|" x3');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(20).');

    INSERT INTO TRANSPORTTYPE (TRANSPORTTYPE.DESCRIPTION) VALUES ('Truck') RETURNING id INTO tIdTransportType;
    INSERT INTO Transport (ACTIVE, IDTRANSPORTTYPE) VALUES ('1', tIdTransportType) RETURNING id INTO tIdTransport;

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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Transport.idTransport - (foreign key constraint) insert non existent "99"');
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

