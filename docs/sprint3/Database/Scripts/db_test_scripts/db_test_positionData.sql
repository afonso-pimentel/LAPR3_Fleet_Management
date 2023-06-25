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

-- [Identity] PositionData - Primary Key: unique and not null
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
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
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 120, 15, 10, 233, 999999999, 'A');

--assert
    if sql%rowcount > 0 then
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
        dbms_output.put_line('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    else
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/



-- [Identity] PositionData.idShip - not null
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.idShip - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.idShip can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (NULL, tDate, 90, 120, 15, 10, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.dateTimeRecieved - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.dateTimeRecieved can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, NULL, 90, 120, 15, 10, 233, 999999999, 'A');

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
declare
    tDate Date;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] PositionData.idShip - foreign key constraint');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

    select CURRENT_DATE into tDate from dual;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (99, tDate, 90, 120, 15, 10, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.latitude can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, NULL, 120, 15, 10, 233, 999999999, 'A');

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


-- [Domain] PositionData.latitude - number(8,6)
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude - (number(8,6)) insert 999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(8,6).');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 999, 120, 15, 10, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude ck_PositionData_latitude(latitude >= -90 AND latitude <= 90) OR latitude = 91 ) insert -91');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.latitude  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, -91, 120, 15, 120, 120, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude ck_PositionData_latitude(latitude >= -90 AND latitude <= 90) OR latitude = 91 ) insert 92');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.latitude  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 92, 120, 15, 120, 120, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.latitude ck_PositionData_latitude((latitude >= -90 AND latitude <= 90) OR latitude = 91 ) insert 91');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 91, 120, 15, 120, 123, 999999999, 'A');

--assert
    if sql%rowcount > 0 then
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
        dbms_output.put_line('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    else
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] PositionData.longitude - not null
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.longitude can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 67, NULL, 15, 10, 233, 999999999, 'A');

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


-- [Domain] PositionData.longitude - number(9,6)
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude - (number(9,6)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(9,6).');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 66, 9999, 15, 10, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude ck_PositionData_longitude((longitude >= -180 AND longitude <= 180) OR longitude = 181 ) insert -181');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.longitude  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 67, -181, 15, 120, 120, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude ck_PositionData_longitude((longitude >= -180 AND longitude <= 180) OR longitude = 181 ) insert 182');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.longitude  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 182, 15, 120, 120, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.longitude ck_PositionData_longitude((longitude >= -180 AND longitude <= 180) OR longitude = 181 ) insert 181');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 181, 15, 120, 123, 999999999, 'A');

--assert
    if sql%rowcount > 0 then
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
        dbms_output.put_line('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    else
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] PositionData.sog - not null
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.sog - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.sog can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 67, 45, NULL, 10, 233, 999999999, 'A');

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


-- [Domain] PositionData.sog - number(4,1)
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.sog - (number(4,1)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(4,1).');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 66, 34, 9999, 10, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.sog ck_PositionData_sog(cog >= 0) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.sog  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 120, -1, 122, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.cog - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.cog can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 67, 45, 13, NULL, 233, 999999999, 'A');

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


-- [Domain] PositionData.cog - number(4,1)
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.cog - (number(4,1)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(4,1).');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 66, 34, 12, 9999, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.cog ck_PositionData_cog(cog >= 0 AND cog <= 359 ) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.cog  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 120, 15, -1, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.cog ck_PositionData_cog(cog >= 0 AND cog <= 359 ) insert 360');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.cog  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 120, 15, 360, 233, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.heading can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 67, 45, 12, 10, NULL, 999999999, 'A');

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


-- [Domain] PositionData.heading - number(3)
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading - (number(3)) insert 9999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(3).');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 66, 34, 12, 10, 9999, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading ck_PositionData_heading(heading >= 0 AND heading <= 359) OR heading = 511 ) insert -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.heading  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 120, 15, 120, -1, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading ck_PositionData_heading(heading >= 0 AND heading <= 359) OR heading = 511 ) insert 360');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.heading  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 120, 15, 120, 360, 999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.heading ck_PositionData_heading(heading >= 0 AND heading <= 359) OR heading = 511 ) insert 511');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 120, 15, 120, 511, 999999999, 'A');

--assert
    if sql%rowcount > 0 then
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
        dbms_output.put_line('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    else
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] PositionData.position - not null
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.position - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.position can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 67, 45, 12, 10, 231, NULL, 'A');

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


-- [Domain] PositionData.position - number(9)
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.position - (number(9)) insert 9999999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(9).');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 66, 34, 12, 10, 23, 9999999999, 'A');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PositionData.transcieverClass can not be null.');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 67, 45, 12, 10, 231, 999999999, NULL);

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass - ( char(1)) insert "AA"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to  char(1).');

    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 66, 34, 12, 10, 23, 999999999, 'AA');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass ck_PositionData_transceiverClass(transceiverClass IN ("A", "B")) insert "C"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): PositionData.transcieverClass  check constraint violation');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 120, 12, 122, 233, 999999999, 'C');

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
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass ck_PositionData_transceiverClass(transceiverClass IN ("A", "B")) insert "A"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 181, 15, 120, 123, 999999999, 'A');

--assert
    if sql%rowcount > 0 then
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
        dbms_output.put_line('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    else
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/



-- [Domain] PositionData.transcieverClass - check constraint ck_PositionData_transceiverClass
--prepare
declare
    tDate        Date;
    tIdTransType number;
    tIdTransport number;
    tIdShip      number;
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
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PositionData.transcieverClass ck_PositionData_transceiverClass(transceiverClass IN ("A", "B")) insert "B"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
    select CURRENT_DATE into tDate from dual;
    insert into TRANSPORTTYPE (DESCRIPTION) values ('Ship') returning id into tIdTransType;
    insert into Transport (ACTIVE, IDTRANSPORTTYPE) values ('1', tIdTransType) returning id into tIdTransport;
    insert into Ship (IDTRANSPORT, mmsi, CALLSIGN, NAME, IMONUMBER, GENERATORS, OUTPUTGENERATOR, VESSELTYPE, LENGTH,
                      WIDTH, CAPACITY, DRAFT)
    values (tIdTransport, 999999999, 'HWBM11111', 'Titanic', 9999999, 99, 10000, 10, 200, 60, 30, 10.3)
    returning IDTRANSPORT into tIdShip;

--act
    insert into POSITIONDATA (IDSHIP, DATETIMERECEIVED, LATITUDE, LONGITUDE, SOG, COG, HEADING, POSITION,
                              TRANSCEIVERCLASS)
    values (tIdShip, tDate, 90, 181, 15, 120, 123, 999999999, 'B');

--assert
    if sql%rowcount > 0 then
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
        dbms_output.put_line('SUCCESS ==> CargoManifest : pdIdShip= ' || pdIdShip || ' pdDateRec= ' ||
                             pdDateRec || ' pdLatitude= ' || pdLatitude || ' pdLongitude= ' || pdLongitude
            || ' pdSog= ' || pdSog || ' pdCog= ' || pdCog || ' pdHeading= ' || pdHeading ||
                             ' pdPosition= ' || pdPosition || ' pdTransClass= ' || pdTransClass);
    else
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/