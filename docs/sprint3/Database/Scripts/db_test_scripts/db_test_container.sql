/****************************************************************************************************
script Usage:       To have feedback from the script you should activate "Enable DBMS_OUTPUT"
                    This script do not create the database, it should be created first and THEN
                    this script should run in it.
                    On every test, the instructions executed are rolled back
***************************************************************************************************
SUMMARY OF CHANGES
Date(dd-MM-yyyy)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
***************************************************************************************************/

-- [Identity] Container.id - Primary Key: unique and not null
--prepare
DECLARE
    tDate   Date;
    tIdCont  NUMBER;
    tId     CONTAINER.id%TYPE;
    tIdent  CONTAINER.identificationNumber%TYPE;
    tIsocod CONTAINER.isoCod%TYPE;
    tMaxW   CONTAINER.maxWeight%TYPE;
    tTareW  CONTAINER.tareWeight%TYPE;
    tMaxV   CONTAINER.maxVolume%TYPE;
    tRep    CONTAINER.repair%TYPE;
    tTemp   CONTAINER.temperature%TYPE;
    tIdCsc  CONTAINER.idCsc%TYPE;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Container.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), 10, 'temporary isCsc')
    RETURNING id INTO tIdCont;
--assert

    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID,
               identificationNumber,
               isoCod,
               maxWeight,
               tareWeight,
               maxVolume,
               repair,
               temperature,
               idCsc
        INTO tId, tIdent, tIsocod, tMaxW, tTareW, tMaxV, trep, tTemp, tIdCsc
        FROM CONTAINER
        WHERE id = tIDCont;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Container : id= ' || tId || ' IdentificationNumber= ' || tIdent
            || ' isoCod= ' || tIsocod || ' maxWeight= ' || tMaxW || ' tareWeight= ' || tTareW
            || ' maxVolume= ' || tMaxV || ' repair= ' || trep || ' temperature= ' || tTemp
            || ' idCsc= ' || tIdCsc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Container.identificationNumber - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.identificationNumber - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.identificationNumber can not be null.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES (NULL, '22G1', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.identificationNumber - unique
--prepare
DECLARE
    tDate Date;

BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');

    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.identificationNumber - unique');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-00001): Container.identificationNumber can not have duplicate VALUES.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.identificationNumber - varchar2(11)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.identificationNumber - (varchar2(11)) insert "ten-Chars|" x2');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(11).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('ten-Chars|ten-Chars|', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.isoCod - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.isoCod - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.isoCod can not be null.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', NULL, 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.isoCod - varchar2(4)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.isoCod - (varchar2(4)) insert "ten-Chars|" x1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(4).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', 'ten-Chars|', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.maxWeight - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.maxWeight - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.maxWeight can not be null.');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.maxWeight - number(5)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.maxWeight - (number(5)) insert 999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(5).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23E4', 999999, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Aplicational] Container.maxWeight - check constraint ck_container_maxweight
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.maxWeight constraint ck_container_maxweight - ( maxWeight > 0 AND maxWeight > tareWeight ) insert maxWeight = 1999, tareWeight = 2000');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.maxWeight check constraint violation');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 1999, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Aplicational] Container.maxWeight - check constraint ck_container_maxweight
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.maxWeight constraint ck_container_maxweight - ( maxWeight > 0 AND maxWeight > tareWeight ) insert maxWeight = -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.maxWeight check constraint violation');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', -1, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.tareWeight - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.tareWeight - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL: Container.tareWeight can not be null.');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.tareWeight - number(5)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.tareWeight - (number(5)) insert 999999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(5).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23E4', 20000, 999999, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Aplicational] Container.tareWeight - check constraint ck_container_tareWeight
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.tareWeight constraint ck_container_tareWeight - ( tareWeight > 0 AND tareWeight < maxWeight ) insert tareWeight = 1999, maxWeight = 2000');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.tareWeight check constraint violation');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 1999, 2000, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Aplicational] Container.tareWeight - check constraint ck_container_tareWeight
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.tareWeight constraint ck_container_tareWeight - ( tareWeight > 0 AND tareWeight < maxWeight ) insert tareWeight = -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.tareWeight check constraint violation');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 10000, -1, 16.1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.maxVolume - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.maxVolume - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.maxVolume can not be null.');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, NULL, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.maxVolume - number(3,1)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.maxVolume - (number(3,1)) insert 999');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01438) because data type length is limited to number(3,1).');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23E4', 20000, 2000, 999, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Aplicational] Container.maxVolume - check constraint ck_container_maxVolume
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Container.maxVolume constraint ck_container_maxVolume - ( maxVolume > 0 ) insert maxVolume = -1');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Container.maxVolume check constraint violation');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 1999, 2000, -1, add_months(tDate, 12), -200.00, 'temporary isCsc');
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


-- [Domain] Container.repair - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.repair - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.repair can not be null.');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 20000, 2000, 12, NULL, -200.00, 'temporary isCsc');
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


-- [Domain] Container.repair - Date
--prepare
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.repair - (Date) insert "string');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01858) because data type length is Date.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23E4', 20000, 2000, 19.2, 'string', -200.00, 'temporary isCsc');
--assert

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -01858 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Container.temperature - allow not null
--prepare
DECLARE
    tDate   Date;
    tIdCont NUMBER;
    tId     CONTAINER.id%TYPE;
    tIdent  CONTAINER.identificationNumber%TYPE;
    tIsocod CONTAINER.isoCod%TYPE;
    tMaxW   CONTAINER.maxWeight%TYPE;
    tTareW  CONTAINER.tareWeight%TYPE;
    tMaxV   CONTAINER.maxVolume%TYPE;
    tRep    CONTAINER.repair%TYPE;
    tTemp   CONTAINER.temperature%TYPE;
    tIdCsc  CONTAINER.idCsc%TYPE;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.temperature allow null - insert null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS');
--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '22G1', 30000, 2000, 16.1, add_months(tDate, 12), null, 'temporary isCsc')
    RETURNING id INTO tIdCont;
--assert

    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID,
               identificationNumber,
               isoCod,
               maxWeight,
               tareWeight,
               maxVolume,
               repair,
               temperature,
               idCsc
        INTO tId, tIdent, tIsocod, tMaxW, tTareW, tMaxV, trep, tTemp, tIdCsc
        FROM CONTAINER
        WHERE id = tIdCont;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> Container : id= ' || tId || ' IdentificationNumber= ' || tIdent
            || ' isoCod= ' || tIsocod || ' maxWeight= ' || tMaxW || ' tareWeight= ' || tTareW
            || ' maxVolume= ' || tMaxV || ' repair= ' || trep || ' temperature= ' || tTemp
            || ' idCsc= ' || tIdCsc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/

-- [Domain] Container.idCsc - not null
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.idCsc - not null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Container.idCsc can not be null.');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '23R3', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, NULL);
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


-- [Domain] Container.idCsc - varchar2(15)
--prepare
DECLARE
    tDate Date;
BEGIN
    SELECT CURRENT_DATE INTO tDate FROM dual;
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Container.idCsc - (varchar2(15)) insert "ten-Chars|" x2');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(15');

--act
    INSERT
    INTO CONTAINER (CONTAINER.identificationNumber,
                    CONTAINER.isoCod,
                    CONTAINER.maxWeight,
                    CONTAINER.tareWeight,
                    CONTAINER.maxVolume,
                    CONTAINER.repair,
                    CONTAINER.temperature,
                    CONTAINER.idCsc)
    VALUES ('CBCU2000317', '34R5', 30000, 2000, 16.1, add_months(tDate, 12), -200.00, 'ten-Chars|ten-Chars|');
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