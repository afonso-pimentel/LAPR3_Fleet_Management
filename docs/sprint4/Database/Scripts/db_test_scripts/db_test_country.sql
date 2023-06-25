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

-- [Identity] Country.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdConti NUMBER;
    tIdCountry   NUMBER;
    tId          Country.id%TYPE;
    tDesc        Country.description%TYPE;
    tIdContinent        Country.idContinent%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Country.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');
    INSERT INTO Continent (description) VALUES ('Europe') RETURNING id INTO tIdConti;
--act
    INSERT INTO Country (description, idcontinent) VALUES ('Portugal', tIdConti) RETURNING ID INTO tIdCountry;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description, tIdContinent
        INTO tId, tDesc, tIdContinent
        FROM Country
        WHERE id = tIdCountry;
        DBMS_OUTPUT.put_line('SUCCESS ==> Country : id= ' || tId || ' description= ' || tDesc || ' idContinent= ' || tIdContinent);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Country.description - not null
--prepare
DECLARE
    tIdConti NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Country.description - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): Country.description can not be null.');
    INSERT INTO Continent (description) VALUES ('Europe') RETURNING id INTO tIdConti;

--act
    INSERT INTO Country (description, idContinent)    VALUES (NULL, tIdConti);

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


-- [Domain] Country.description - varchar2(50)
--prepare
DECLARE
    tIdConti NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Country.description - (varchar2(50)) insert "ten-Chars|" x6');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(50).');
    INSERT INTO Continent (description) VALUES ('Europe') RETURNING id INTO tIdConti;

--act
    INSERT INTO Country (description, idContinent)    VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|', tIdConti);

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


-- [Referential] Country.idContinent - foreign key constraint
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] Country.idContinent - (foreign key constraint) insert non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');

--act
            INSERT INTO Country (description, idcontinent) VALUES ('Portugal', 99);

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











