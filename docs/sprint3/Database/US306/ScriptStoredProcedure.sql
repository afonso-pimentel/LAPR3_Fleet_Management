CREATE OR REPLACE PROCEDURE Get_OccupancyRate_EstimatedContainersLeaving_CargoSite (vReturnCursor OUT SYS_REFCURSOR)
AS
    IdCargoManifestTypeLoad CARGOMANIFESTTYPE.ID%TYPE;
    IdCargoManifestTypeUnload CARGOMANIFESTTYPE.ID%TYPE;
BEGIN

    SELECT ID INTO IdCargoManifestTypeLoad
    FROM CARGOMANIFESTTYPE WHERE DESCRIPTION = 'Load';

    SELECT ID INTO IdCargoManifestTypeUnload
    FROM CARGOMANIFESTTYPE WHERE DESCRIPTION = 'Unload';

    OPEN vReturnCursor FOR
    SELECT
        CARGOSITE.ID,
        CARGOSITE.NAME,
           COALESCE(NULLIF
               (ABS(((Unloads.NumberOfOperations - Loads.NumberOfOperations) / CARGOSITE.CONTAINERCAPACITY) * 100),
               -(((Unloads.NumberOfOperations - Loads.NumberOfOperations) / CARGOSITE.CONTAINERCAPACITY) * 100)), 0)
         OccupancyRate,
        NVL((
            SELECT (SELECT COUNT(*) FROM CARGOMANIFESTLINE WHERE CARGOMANIFESTLINE.IDCARGOMANIFEST = CARGOMANIFEST.ID)
            FROM CARGOMANIFEST
            WHERE CARGOSITE.ID = CARGOMANIFEST.IDCARGOSITEORIGIN
              AND CARGOMANIFEST.IDCARGOMANIFESTTYPE = 2
              AND CARGOMANIFEST.DATESTARTESTIMATED >= SYSDATE
              AND CARGOMANIFEST.DATESTARTESTIMATED <= SYSDATE+30),0) NumberOfLeavingContainers
    FROM
        (
            SELECT
                   CARGOSITE.ID,
                   CASE WHEN EXISTS (
                                SELECT ID
                                FROM CARGOMANIFEST
                                WHERE CARGOSITE.ID = CARGOMANIFEST.IDCARGOSITEDESTINATION
                                  AND CARGOMANIFEST.IDCARGOMANIFESTTYPE = 2
                                  AND CARGOMANIFEST.DATEFINISH IS NOT NULL
                ) THEN COUNT(*) ELSE 0 END NumberOfOperations
            FROM CARGOSITE
            GROUP BY CARGOSITE.ID
        ) Unloads,
        (
            SELECT
                   CARGOSITE.ID,
                   CASE
                       WHEN EXISTS(
                               SELECT ID
                               FROM CARGOMANIFEST
                               WHERE CARGOSITE.ID = CARGOMANIFEST.IDCARGOSITEORIGIN
                                 AND CARGOMANIFEST.IDCARGOMANIFESTTYPE = 1
                                 AND CARGOMANIFEST.DATESTART IS NOT NULL
                           ) THEN COUNT(*)
                       ELSE 0 END NumberOfOperations
            FROM CARGOSITE
            GROUP BY CARGOSITE.ID
        ) Loads,
        CARGOSITE
    WHERE CARGOSITE.ID = Unloads.ID AND CARGOSITE.ID = Loads.ID
    ORDER BY  Loads.ID;

END; 