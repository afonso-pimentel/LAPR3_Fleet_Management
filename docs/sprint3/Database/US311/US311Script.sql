INSERT INTO PLATFORMUSER (USERNAME, PASSWORD, DESCRIPTION, IDROLE) VALUES ('crew','bd7wd5aF','ShipCaptainUS311','4');
SELECT * FROM PLATFORMUSER;
INSERT INTO DATABASEACCOUNTLINK (dbUser,IDCAPITAN) VALUES ('crew',?);

create user crew identified by bd7wd5aF;
GRANT CONNECT TO crew;

CREATE PROCEDURE CHECK_MY_CONTAINERS AS
   BEGIN
      SELECT * FROM CARGOMANIFESTLINE CML
        INNER JOIN CARGOMANIFEST CM ON CML.IDCARGOMANIFEST = CM.ID
        INNER JOIN CARGOMANIFESTTYPE CMT ON CM.IDCARGOMANIFESTTYPE = CMT.ID
        INNER JOIN  TRANSPORT T ON CM.IDTRANSPORT = T.ID
        INNER JOIN SHIP S ON S.IDTRANSPORT = T.ID
        INNER JOIN PLATFORMUSER P ON P.ID = S.IDCAPITAN
        INNER JOIN DATABASEACCOUNTLINK DBAL ON DBAL.IDCAPITAN = P.ID
       WHERE CMT.DESCRIPTION='Load' AND DBAL.DBUSER = USER;
   END;

GRANT EXECUTE ON CHECK_MY_CONTAINERS TO crew;