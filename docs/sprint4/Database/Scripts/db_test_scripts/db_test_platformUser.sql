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


-- [Identity] PlatformUser.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdRo     NUMBER;
    tId       PlatformUser.id%TYPE;
    tUserName PlatformUser.userName%TYPE;
    tPass     PlatformUser.password%TYPE;
    tDesc     PlatformUser.description%TYPE;
    tIdRole   PlatformUser.idRole%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] PlatformUser.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;
--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco da Game', 'password1', 'description', tIdRo);
--assert
    if sql%rowcount > 0 then
        SELECT id, userName, password, description, idRole
        INTO tId, tUserName, tPass, tDesc, tIdRole
        FROM PlatformUser;
        DBMS_OUTPUT.PUT_LINE('SUCCESS ==> PlatformUser : id= ' || tId || ' userName= ' || tUserName
            || ' password= ' || tPass || ' description= ' || tdesc || ' idRole= ' || tIdRole);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] PlatformUser.userName - unique
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.userName - (unique) insert duplicate "Vasco da Game"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-00001) because a unique column can not allow duplicates.');
    INSERT INTO Role (DESCRIPTION) VALUES ('Client') RETURNING id INTO tIdRo;
    INSERT INTO PlatformUser (USERNAME, PASSWORD, DESCRIPTION, IDROLE)
    VALUES ('Vasco da Game', 'password1', 'description', tIdRo);
--act
    INSERT INTO PlatformUser (USERNAME, PASSWORD, DESCRIPTION, IDROLE)
    VALUES ('Vasco da Game', 'password1', 'description', tIdRo);
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

-- [Domain] PlatformUser.userName - not null
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.userName - (not null) insert null');
        DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PlatformUser.userName can not be null.');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;
--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES (NULL, 'password1', 'description', tIdRo);
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


-- [Domain] PlatformUser.userName - varchar2(20)
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.userName - (varchar2(20)) insert "ten-Chars|" x3');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(20).');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;

--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('ten-Chars|ten-Chars|ten-Chars|', 'password1', 'description', tIdRo);

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


-- [Domain] PlatformUser.password - not null
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.password - (not null) insert null');
        DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PlatformUser.password can not be null.');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;
--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco de Game', NULL, 'description', tIdRo);
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


-- [Domain] PlatformUser.password - varchar2(20)
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.password - (varchar2(20)) insert "ten-Chars|" x3');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(20).');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;

--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco de Game', 'ten-Chars|ten-Chars|ten-Chars|', 'description', tIdRo);

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


-- [Domain] PlatformUser.description - not null
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.description - (not null) insert null');
        DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400): PlatformUser.description can not be null.');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;
--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco de Game', 'password', NULL, tIdRo);
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


-- [Domain] PlatformUser.description - varchar2(255)
--prepare
DECLARE
    tIdRo NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] PlatformUser.description - (varchar2(255)) insert "ten-Chars|" x26');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(255).');
    INSERT INTO Role (description) VALUES ('Client') RETURNING id INTO tIdRo;

--act
    INSERT INTO PlatformUser (userName, password, description, idRole)
    VALUES ('Vasco de Game', 'password', 'ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|ten-Chars|', tIdRo);

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


-- [Referential] PlatformUser.idRole - foreign key constraint
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Referential] PlatformUser.idRole - (foreign key constraint) insert non existing');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02291): A parent key must exist for the foreign key to relate');
--act
    insert INTO PlatformUser (USERNAME, PASSWORD, DESCRIPTION, IDROLE)
    VALUES ('Vasco da Game', 'password1', 'description', 99);
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