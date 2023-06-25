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

-- [Identity] Role.id - Primary Key: unique and not null
--prepare
DECLARE
    tIdRole NUMBER;
    rId   Role.id%TYPE;
    rDesc Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Identity] Role.id Primary Key: unique and not null');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: ...proving that Primary Key is unique and not null thanks to auto-increment');

--act
    INSERT INTO Role (description)
    VALUES ('Client')
    returning ID into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT id, description
        INTO rId, rDesc
        FROM Role WHERE id = tIdRole;
        DBMS_OUTPUT.put_line('SUCCESS ==> Role : id= ' || rId || ' description= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Domain] Role.desc - not null
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Role.description - (not null) insert null');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-01400) because a Primary Key with auto-increment can not allow manual insert, and that includes null and duplicates.');

--act
    INSERT INTO Role (description)
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


-- [Domain] Role.description - unique
--prepare
declare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Role.description - (unique) insert duplicate');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-00001): Role.description can not have duplicate values.');
    INSERT INTO Role (description) VALUES ('Client');

--act
    INSERT INTO Role (description) VALUES ('Client');

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


-- [Domain] Role.desc - varchar2(255)
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Domain] Role.description - (varchar2(255)) insert "ten-Chars|" x26');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-12899) because data type length is limited to varchar2(255).');

--act
    INSERT INTO Role (description)
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


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Client", "Fleet manager", "Traffic manager", "Warehouse staff", "Warehouse manage", "Port staff", "Port manager", "Ship captain", "Ship chief electrical engineer", "Truck driver") insert "string"');
    DBMS_OUTPUT.PUT_LINE('Expects FAIL (ORA-02290): Role.description check constraint violation');

--act
    INSERT INTO Role(description)
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


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Client" ...) ) insert "Client"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Client') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole number;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Fleet manager" ...) ) insert "Fleet manager"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Fleet manager') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole number;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Traffic manager" ...) ) insert "Traffic manager"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Traffic manager') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Wharehouse staff" ...) ) insert "Warehouse staff"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Warehouse staff') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Warehouse manager" ...) ) insert "Warehouse manager"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Warehouse manager') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Port staff" ...) ) insert "Port staff"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Port staff') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Port manager" ...) ) insert "Port manager"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Port manager') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Ship captain" ...) ) insert "Ship captain"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Ship captain') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Ship chief electrical engineer" ...) ) insert "Ship chief electrical engineer"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Ship chief electrical engineer') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/


-- [Aplicational] Role.description - check constraint ck_Role_description
--prepare
DECLARE
    tIdRole NUMBER;
    rId                  Role.id%TYPE;
    rDesc                Role.description%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<Test start> [Aplicational] Role.description ck_Role_description( description IN ("Truck driver" ...) ) insert "Truck driver"');
    DBMS_OUTPUT.PUT_LINE('Expects SUCCESS: Role.description check constraint violation');

--act
    INSERT INTO Role(description)
    VALUES ('Truck driver') returning id into tIdRole;

--assert
    IF SQL%ROWCOUNT > 0 THEN
        SELECT ID, description INTO rId, rDesc FROM Role WHERE id = tIdRole;
        dbms_output.put_line('SUCCESS ==> Role : id= ' || rId || ' desc= ' || rDesc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL ==> ' || SQLERRM);
    END IF;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('<Test end>');
END;
/