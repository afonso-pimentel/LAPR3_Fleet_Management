SELECT  CNT.IDENTIFICATIONNUMBER AS CONTAINER_ID,
        (CML.GROSSWEIGHT - CNT.TAREWEIGHT) AS CONTAINER_LOAD,
        CNT.TEMPERATURE AS CONTAINER_TYPE,
        (CML.XPOSITION || ' - ' || CML.YPOSITION  || ' - ' || CML.ZPOSITION) 
        AS CONTAINER_POSITION, 
        CTY.DESCRIPTION AS CARGO_SITE_TYPE,
        CSITE.NAME AS CARGO_SITE_NAME
FROM CARGOMANIFESTLINE CML, CARGOMANIFEST CM, CARGOSITE CSITE,CONTAINER CNT,
CARGOSITETYPE CTY, SHIP S, CARGOMANIFESTTYPE CMT
WHERE CM.IDTRANSPORT = S.IDTRANSPORT
    AND S.MMSI = ?
    AND CM.IDCARGOMANIFESTTYPE = CMT.ID
    AND CMT.DESCRIPTION = 'Unload'
    AND CML.IDCARGOMANIFEST = CM.ID
    AND CM.DATEFINISH IS NULL
    AND CM.DATESTART IS NOT NULL
    AND CML.IDCONTAINER = CNT.ID
    AND CM.IDCARGOSITEDESTINATION = CSITE.ID
    AND CSITE.IDCARGOSITETYPE = CTY.ID
ORDER BY CNT.IDENTIFICATIONNUMBER