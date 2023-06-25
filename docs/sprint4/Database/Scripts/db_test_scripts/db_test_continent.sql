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

-- [Identity] Continent.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdContinent NUMBER;
    tId          Continent.id%TYPE;
    tDesc        Continent.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Continent.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO Continent (description)
    VALUES ('Europe')
    returning ID into tIdContinent;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description
        INTO tId, tDesc
        FROM Continent
        WHERE id = tIdContinent;
        DBMS_OUTPUT.put_line('SUCCESS ==> Continent : id= ' || tId || ' description= ' || tDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Continent.desc - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Continent.description - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400) because a Primary Key with auto-increment can not allow manual insert, and that includes null and duplicates.');

--act
    INSERT INTO Continent (description)
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


-- [Domain] Continent.description - unique
--prepare
DECLARE
    tIdContinent NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Continent.description - (unique) insert duplicate "Europe"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-00001) because a unique column can not allow duplicates.');

    INSERT INTO Continent (description) VALUES ('Europe');

--act
    INSERT INTO Continent (description) VALUES ('Europe') returning ID into tIdContinent;

--assert
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -00001 THEN
            DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
        END IF;
        DBMS_OUTPUT.PUT_LINE('<Test end>');
        ROLLBACK;
END;
/


-- [Domain] Continent.desc - varchar2(50)
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Continent.description - (varchar2(50)) insert "ten-Chars|" x6');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because a Primary Key with auto-increment can not allow manual insert, and that includes null and duplicates.');

--act
    INSERT INTO Continent (description)
    VALUES ('ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|');

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



