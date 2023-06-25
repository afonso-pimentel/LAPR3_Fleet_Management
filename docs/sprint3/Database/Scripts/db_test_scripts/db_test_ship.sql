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

-- [Identity] Ship.idTransport - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.idTransport - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');
--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (null, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.idTransport - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Ship.idTransport can not have duplicate values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);
--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

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


-- [Domain] Ship.idTransport - number(19)
--prepare
DECLARE
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.idTransport - ( number(19)) insert 99999999999999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(19).');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (99999999999999999999, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (99, 222222222, 'HWBM99999', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.mmsi - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Ship.mmsi  can not be null.');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, null, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType  number;
    tIdTransport1 number;
    tIdTransport2 number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.mmsi - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Ship.mmsi can not have duplicate values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport1;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport2;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport1, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);
--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport2, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

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


-- [Domain] Ship.mmsi - number(9)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.mmsi - ( number(9)) insert 9999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(9).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 9999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.callSign - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Ship.callSign can not be null.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, null, 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType  number;
    tIdTransport1 number;
    tIdTransport2 number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.callSign - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Ship.callSign can not have duplicate values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport1;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport2;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport1, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);
--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport2, 222222222, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.callSign - ( varchar2(10)) insert "ten_chars|" x3');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(10).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'ten_chars|ten_chars|ten_chars|', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.name - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', null, 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.name - ( varchar2(50)) insert "ten_chars|" x6');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(50).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'ten_chars|ten_chars|ten_chars|ten_chars|ten_chars|ten_chars|', 9999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.imoNumber - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', null, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType  number;
    tIdTransport1 number;
    tIdTransport2 number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.imoNumber - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Ship.imoNumber can not have duplicate values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport1;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport2;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport1, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);
--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport2, 222222222, 'HWBM99999', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, 12.1);

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


-- [Domain] Ship.imoNumber - number(7)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.imoNumber - ( number(7)) insert 99999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(7).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 99999999, 99, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.generators - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, null, 10000, 10, 200, 60, 30, 10.3);

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


-- [Domain] Ship.generators - number(3)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.generators - ( number(3)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(3).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 9999, 10000, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.generators ck_Ship_generators( capacity >= 0) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.generators  check constraint violation');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, -99, 1000, 20, 100, 60, 40, 12.2);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.outputGenerator - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, null, 10, 200, 60, 30, 10.3);

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


-- [Domain] Ship.outputGenerator - number(6)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.generators - ( number(6)) insert 9999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(6).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 9999999, 10, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.outputGenerator ck_Ship_outputGenerator( capacity >= 0) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.outputGenerator  check constraint violation');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, -1, 20, 100, 60, 40, 12.2);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.vesseType - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, null, 200, 60, 30, 10.3);

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


-- [Domain] Ship.vesseType - number(4)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.vesseType - ( number(4)) insert 99999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(4).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 99999, 200, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.vesselType ck_Ship_vesselType( capacity >= 0) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.vesselType  check constraint violation');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, -1, 100, 60, 40, 12.2);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.length - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, null, 60, 30, 10.3);

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


-- [Domain] Ship.length - number(4)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.length - ( number(4)) insert 99999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(4).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 9999, 99999, 60, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.length ck_Ship_length( capacity >= 0) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.length  check constraint violation');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, -1, 60, 40, 12.2);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.width - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, null, 30, 10.3);

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


-- [Domain] Ship.width - number(3)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.width - ( number(3)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(3).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 9999, 999, 9999, 30, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.width ck_Ship_width( capacity >= 0) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.width  check constraint violation');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 30, 100, -1, 40, 12.2);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.capacity - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, null, 10.3);

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


-- [Domain] Ship.capacity - number(7)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.capacity - ( number(7)) insert 99999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(7).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 9999, 999, 99, 99999999, 10.3);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.capacity ck_Ship_capacity( capacity >= 0) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.capacity  check constraint violation');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, -40, 12.2);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Ship.draft - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): A Primary Key can not store null values.');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, null);

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


-- [Domain] Ship.draft - number(3,1)
--prepare
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.draft - ( number(3,1)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to  number(3,1).');
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 999, 999999, 9999, 999, 99, 9999999, 9999);

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
declare
    tIdTransType number;
    tIdTransport number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Ship.draft ck_Ship_draft( capacity >= 0) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Ship.draft  check constraint violation');

    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;

--act
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 1000, 20, 100, 60, 40, -12.2);

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









