SELECT ((COUNT(CML.IDCONTAINER)/TO_NUMBER(S.CAPACITY)*100 ))  AS OCCUPANCY_PERC
FROM CARGOMANIFEST CM
    INNER JOIN CARGOMANIFESTLINE CML ON CML.IDCARGOMANIFEST = CM.ID
    INNER JOIN TRANSPORT T ON T.ID = CM.IDTRANSPORT
    INNER JOIN SHIP S on T.ID = S.IDTRANSPORT
WHERE T.ID = ? AND CM.ID = ?
group by S.CAPACITY