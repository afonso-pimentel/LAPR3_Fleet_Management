CREATE OR REPLACE PROCEDURE Get_Ships_Idle_Days(vReturnCursor out SYS_REFCURSOR)
AS
BEGIN
    OPEN vReturnCursor FOR
        SELECT
               TRANSPORT.ID,
               TO_CHAR(EXTRACT(YEAR FROM SYSDATE)) AS currentYear, --Extrair o ano atual
               NVL(   --Validar se é null
                       SUM( --Somatorio da diferença entre a data de fim e a proxima data
                                  GREATEST ( --divisao não pode ser menos de 0
                                      TO_DATE(TO_CHAR(TRIPS."next_timestamp", 'YYYY-MM-DD'), 'YYYY-MM-DD') -
                                      TO_DATE(TO_CHAR(TRIPS.DATEFINISH, 'YYYY-MM-DD'), 'YYYY-MM-DD')
                                      ,0
                                  )
                        ), --se for null (não tem cargo manifests), calcula do inicio do ano até hoje
                       TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD') -
                       TO_DATE(EXTRACT(YEAR FROM SYSDATE) || '-01-01', 'YYYY-MM-DD')
                   ) AS idleTime
        FROM TRANSPORT
        LEFT JOIN (SELECT
                           CARGOMANIFEST.IDTRANSPORT,
                           CARGOMANIFEST.DATESTART,
                           CARGOMANIFEST.DATEFINISH,
                           NVL( --caso não tenha data de proxima partida adiciona a data de hoje
                               LEAD(CARGOMANIFEST.DATESTART, 1)  --ir buscar o proximo registo
                                    OVER ( --ordenado por datastart e vai buscar por idTransport
                                        PARTITION BY CARGOMANIFEST.IDTRANSPORT
                                        ORDER BY CARGOMANIFEST.DATESTART)
                               ,SYSDATE) AS "next_timestamp"
                    FROM CARGOMANIFEST
                    INNER JOIN CARGOMANIFESTTYPE ON CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID
                    WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Load' AND
                          EXTRACT(YEAR FROM CARGOMANIFEST.DATESTART) = EXTRACT(YEAR FROM SYSDATE)  --apenas os deste ano
                   ) TRIPS ON TRIPS.IDTRANSPORT = TRANSPORT.ID AND TRIPS.DATESTART IS NOT NULL AND TRIPS.DATEFINISH IS NOT NULL
                            --apenas os que ja foram executados
        GROUP BY TRANSPORT.ID;
END;