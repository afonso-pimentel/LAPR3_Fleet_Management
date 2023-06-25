CREATE OR REPLACE TRIGGER REGISTER_CONTAINER_OPERATION_INSERT
AFTER INSERT ON CARGOMANIFESTLINE
FOR EACH ROW
BEGIN
    INSERT INTO LOGCONTAINEROPERATIONS (DATETIME, TYPE, DBUSER, IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION, IDLEASINGCLIENT)
    VALUES (SYSDATE, 'Insert', SYS_CONTEXT('USERENV','SESSION_USER'), :NEW.IDCONTAINER, :NEW.IDCARGOMANIFEST, :NEW.GROSSWEIGHT, :NEW.XPOSITION, :NEW.YPOSITION, :NEW.ZPOSITION, :NEW.IDLEASINGCLIENT);
END;

CREATE OR REPLACE TRIGGER REGISTER_CONTAINER_OPERATION_UPDATE
AFTER UPDATE ON CARGOMANIFESTLINE
FOR EACH ROW
BEGIN
    INSERT INTO LOGCONTAINEROPERATIONS (DATETIME, TYPE, DBUSER, IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION, IDLEASINGCLIENT)
    VALUES (SYSDATE, 'Update', SYS_CONTEXT('USERENV','SESSION_USER'), :NEW.IDCONTAINER, :NEW.IDCARGOMANIFEST, :NEW.GROSSWEIGHT, :NEW.XPOSITION, :NEW.YPOSITION, :NEW.ZPOSITION, :NEW.IDLEASINGCLIENT);
END;

CREATE OR REPLACE TRIGGER REGISTER_CONTAINER_OPERATION_DELETE
AFTER DELETE ON CARGOMANIFESTLINE
FOR EACH ROW
BEGIN
    INSERT INTO LOGCONTAINEROPERATIONS (DATETIME, TYPE, DBUSER, IDCONTAINER, IDCARGOMANIFEST, GROSSWEIGHT, XPOSITION, YPOSITION, ZPOSITION, IDLEASINGCLIENT)
    VALUES (SYSDATE, 'Delete', SYS_CONTEXT('USERENV','SESSION_USER'), :OLD.IDCONTAINER, :OLD.IDCARGOMANIFEST, :OLD.GROSSWEIGHT, :OLD.XPOSITION, :OLD.YPOSITION, :OLD.ZPOSITION, :OLD.IDLEASINGCLIENT);
END;