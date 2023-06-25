CREATE OR REPLACE PROCEDURE Get_Container_Route (vIdContainer NUMBER, vIdUser NUMBER, vReturnCursor OUT SYS_REFCURSOR)
AS
    vDATESTART TIMESTAMP;
    vDATEFINISH TIMESTAMP;
BEGIN
    /*Get the datetime when the container was loaded*/
    SELECT
        DATESTARTESTIMATED INTO vDATESTART
    FROM (
             SELECT CARGOMANIFEST.DATESTARTESTIMATED,
               (row_number() over (ORDER BY DATESTARTESTIMATED)) AS OrderedNumber
             FROM CARGOMANIFEST
             INNER JOIN CARGOMANIFESTTYPE ON CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID
             INNER JOIN CARGOMANIFESTLINE ON CARGOMANIFEST.ID = CARGOMANIFESTLINE.IDCARGOMANIFEST
             WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Load' AND
                   CARGOMANIFESTLINE.IDCONTAINER = 1 AND CARGOMANIFESTLINE.idLeasingClient = vIdUser
         )
    WHERE  OrderedNumber = 1;

    /*Get the datetime when the container will/was unloaded*/
    SELECT
        DATEFINISHESTIMATED  INTO vDATEFINISH
    FROM (
             SELECT CARGOMANIFEST.DATEFINISHESTIMATED,
               (row_number() over (ORDER BY DATESTARTESTIMATED DESC )) AS OrderedNumber
             FROM CARGOMANIFEST
             INNER JOIN CARGOMANIFESTTYPE ON CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID
             INNER JOIN CARGOMANIFESTLINE on CARGOMANIFEST.ID = CARGOMANIFESTLINE.IDCARGOMANIFEST
             WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Unload' AND
                   CARGOMANIFESTLINE.IDCONTAINER = vIdContainer AND CARGOMANIFESTLINE.idLeasingClient = vIdUser
         )
    WHERE OrderedNumber = 1;

    OPEN vReturnCursor FOR
    SELECT
        (CASE WHEN EXISTS (SELECT CARGOMANIFESTLINE.IDCARGOMANIFEST FROM CARGOMANIFESTLINE WHERE CARGOMANIFESTLINE.IDCARGOMANIFEST = CARGOMANIFEST.ID AND CARGOMANIFESTLINE.IDCONTAINER = vIdContainer)
            THEN CARGOMANIFESTTYPE.DESCRIPTION ELSE 'NONE' END) AS Action,
        (CASE WHEN CARGOMANIFESTTYPE.DESCRIPTION = 'Load' THEN Orig.NAME ELSE Dest.NAME END) AS OperationLocal,
        (CASE WHEN CARGOMANIFESTTYPE.DESCRIPTION = 'Load' THEN CARGOMANIFEST.DATESTART ELSE CARGOMANIFEST.DATEFINISH END) AS OperationDate,
        TRANSPORTTYPE.DESCRIPTION AS TransportType
    FROM CargoManifest
    INNER JOIN CARGOMANIFESTTYPE ON CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID
    INNER JOIN TRANSPORT ON CARGOMANIFEST.IDTRANSPORT = TRANSPORT.ID
    INNER JOIN TRANSPORTTYPE ON TRANSPORT.IDTRANSPORTTYPE = TRANSPORTTYPE.ID
    INNER JOIN CARGOSITE Dest ON CARGOMANIFEST.IDCARGOSITEDESTINATION = Dest.ID
    INNER JOIN CARGOSITE Orig ON CARGOMANIFEST.IDCARGOSITEORIGIN = Orig.ID
    WHERE (
            (CARGOMANIFESTTYPE.DESCRIPTION = 'Load' AND CARGOMANIFEST.DATESTART IS NOT NULL) OR
            (CARGOMANIFESTTYPE.DESCRIPTION = 'Unload' AND CARGOMANIFEST.DATEFINISH IS NOT NULL AND
             EXISTS (SELECT CARGOMANIFESTLINE.IDCARGOMANIFEST FROM CARGOMANIFESTLINE WHERE CARGOMANIFESTLINE.IDCARGOMANIFEST = CARGOMANIFEST.ID AND CARGOMANIFESTLINE.IDCONTAINER = vIdContainer ))
        ) AND
          CARGOMANIFEST.DATESTART >= vDATESTART AND CARGOMANIFEST.DATESTART <= vDATEFINISH
          AND
          CARGOMANIFEST.IDTRANSPORT IN (SELECT DISTINCT CARGOMANIFEST.IDTRANSPORT
                                        FROM CARGOMANIFEST
                                        INNER JOIN CARGOMANIFESTLINE on CARGOMANIFEST.ID = CARGOMANIFESTLINE.IDCARGOMANIFEST
                                        WHERE CARGOMANIFESTLINE.IDCONTAINER = vIdContainer AND CARGOMANIFESTLINE.idLeasingClient = vIdUser)
    ORDER BY CARGOMANIFEST.DATESTART ASC, CARGOMANIFESTTYPE.DESCRIPTION ASC;
END;