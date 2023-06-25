-- [US310] As Port manager, I intend to have a map of the occupation of the existing
-- resources in the port during a given month.
-- o Acceptance Criteria [BDDAD]:
-- Occupation of resources is restricted to the month provided.
-- The reported occupation respects actual port capacity.


CREATE OR REPLACE PROCEDURE Get_CargoSite_Occupancy(vCargoSiteID in NUMBER, vYear in varchar, vMonth in varchar,
                                                    vReturnCursor out SYS_REFCURSOR)
AS
    vCargoManifestTypeLoadID   CARGOMANIFESTTYPE.ID%TYPE;
    vCargoManifestTypeUnloadID CARGOMANIFESTTYPE.ID%TYPE;
    vContainerCapacity         CARGOSITE.CONTAINERCAPACITY%TYPE;
    vShipCapacity              CARGOSITE.SHIPCAPACITY%TYPE;
    vTruckCapacity             CARGOSITE.TRUCKCAPACITY%TYPE;
    vShipTransportTypeID       TRANSPORT.IDTRANSPORTTYPE%TYPE;
    vTruckTransportTypeID      TRANSPORT.IDTRANSPORTTYPE%TYPE;


BEGIN

    SELECT ID INTO vCargoManifestTypeLoadID FROM CARGOMANIFESTTYPE WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Load';
    SELECT ID INTO vCargoManifestTypeUnloadID FROM CARGOMANIFESTTYPE WHERE CARGOMANIFESTTYPE.DESCRIPTION = 'Unload';
    SELECT ID INTO vShipTransportTypeID FROM TRANSPORTTYPE WHERE TRANSPORTTYPE.DESCRIPTION = 'Ship';
    SELECT ID INTO vTruckTransportTypeID FROM TRANSPORTTYPE WHERE TRANSPORTTYPE.DESCRIPTION = 'Truck';
    select CONTAINERCAPACITY, SHIPCAPACITY, TRUCKCAPACITY
    INTO vContainerCapacity, vShipCapacity, vTruckCapacity
    from CARGOSITE
    where CARGOSITE.ID = vCargoSiteID;


    OPEN vReturnCursor FOR
        select dayofmonth.tdate as "date",
-- containers
               (
                       (
                           select count(*)
                           from CARGOMANIFEST
                                    inner join CARGOMANIFESTLINE on CARGOMANIFEST.ID = CARGOMANIFESTLINE.IDCARGOMANIFEST
                           where CARGOMANIFEST.DATEFINISH IS NOT NULL
                             AND CARGOMANIFEST.DATEFINISH <= dayofmonth.tdate
                             and CARGOMANIFEST.IDCARGOMANIFESTTYPE = vCargoManifestTypeUnloadID
                             and CARGOMANIFEST.IDCARGOSITEDESTINATION = vCargoSiteID
                       )
                       -
                       (select count(*)

                        from CARGOMANIFEST
                                 inner join CARGOMANIFESTLINE on CARGOMANIFEST.ID = CARGOMANIFESTLINE.IDCARGOMANIFEST
                        where CARGOMANIFEST.DATESTART IS NOT NULL
                          AND CARGOMANIFEST.DATESTART <= dayofmonth.tdate
                          and CARGOMANIFEST.IDCARGOMANIFESTTYPE = vCargoManifestTypeLoadID
                          and CARGOMANIFEST.IDCARGOSITEORIGIN = vCargoSiteID
                       ))       as containerCount,
               vContainerCapacity,
-- Ships
               (
                       (
                           select count(*)
                           from CARGOMANIFEST
                                    inner join TRANSPORT on TRANSPORT.ID = CARGOMANIFEST.IDTRANSPORT
                           where CARGOMANIFEST.DATEFINISH IS NOT NULL
                             AND CARGOMANIFEST.DATEFINISH <= dayofmonth.tdate
                             and CARGOMANIFEST.IDCARGOMANIFESTTYPE = vCargoManifestTypeUnloadID
                             and CARGOMANIFEST.IDCARGOSITEDESTINATION = vCargoSiteID
                             and TRANSPORT.IDTRANSPORTTYPE = vShipTransportTypeID
                       )
                       -
                       (select count(*)

                        from CARGOMANIFEST
                                 inner join TRANSPORT on TRANSPORT.ID = CARGOMANIFEST.IDTRANSPORT
                        where CARGOMANIFEST.DATESTART IS NOT NULL
                          AND CARGOMANIFEST.DATESTART <= dayofmonth.tdate
                          and CARGOMANIFEST.IDCARGOMANIFESTTYPE = vCargoManifestTypeLoadID
                          and CARGOMANIFEST.IDCARGOSITEORIGIN = vCargoSiteID
                          and TRANSPORT.IDTRANSPORTTYPE = vShipTransportTypeID
                       ))       as shipCount,
               vShipCapacity,

-- Trucks
               (
                       (
                           select count(*)
                           from CARGOMANIFEST
                                    inner join TRANSPORT on TRANSPORT.ID = CARGOMANIFEST.IDTRANSPORT
                           where CARGOMANIFEST.DATEFINISH IS NOT NULL
                             AND CARGOMANIFEST.DATEFINISH <= dayofmonth.tdate
                             and CARGOMANIFEST.IDCARGOMANIFESTTYPE = vCargoManifestTypeUnloadID
                             and CARGOMANIFEST.IDCARGOSITEDESTINATION = vCargoSiteID
                             and TRANSPORT.IDTRANSPORTTYPE = vTruckTransportTypeID
                       )
                       -
                       (select count(*)

                        from CARGOMANIFEST
                                 inner join TRANSPORT on TRANSPORT.ID = CARGOMANIFEST.IDTRANSPORT
                        where CARGOMANIFEST.DATESTART IS NOT NULL
                          AND CARGOMANIFEST.DATESTART <= dayofmonth.tdate
                          and CARGOMANIFEST.IDCARGOMANIFESTTYPE = vCargoManifestTypeLoadID
                          and CARGOMANIFEST.IDCARGOSITEORIGIN = vCargoSiteID
                          and TRANSPORT.IDTRANSPORTTYPE = vTruckTransportTypeID
                       ))       as truckCount,
               vTruckCapacity


        from (SELECT TO_DATE('01/' || vMonth || '/' || vYear, 'DD/MM/YYYY') + (ROWNUM - 1) as tdate
              FROM ALL_OBJECTS
              WHERE ROWNUM <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('01/' || vMonth || '/' || vYear, 'DD/MM/YYYY')),
                                                'DD'))
             ) dayofmonth;

END;
