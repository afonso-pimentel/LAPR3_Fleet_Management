CREATE OR REPLACE PROCEDURE Get_Port_work_Map_for_week(vCargoSiteID in NUMBER, targetDate in date, nextWeek in boolean,
                                                       vReturnCursor out SYS_REFCURSOR)
AS
    vFirstDay     date;
    vDayAfterLast date;
    vDayOfWeek    date;

BEGIN

--    [condition] uses inputed date or next week date according to nextWeek parameter
    IF nextWeek = true THEN
        vDayOfWeek := sysdate + 7; -- uses a date of next week
    else
        vDayOfWeek := targetDate; -- uses inputed date
END IF;

-- get the first and last day of the week of given date into vFirstDay and vDayAfterLast(last day of week + 1)
    select
        TRUNC(vDayOfWeek, 'iw'),
        TRUNC(vDayOfWeek, 'iw') + 7
    into vFirstDay, vDayAfterLast
    from dual;

    OPEN vReturnCursor FOR

         select
                CARGOMANIFESTTYPE.DESCRIPTION as Operation,     -- Type of manifest Load or Unload

                case when CARGOMANIFEST.DATESTART is null then  -- Date of operation
                CARGOMANIFEST.DATESTARTESTIMATED
                else
                CARGOMANIFEST.DATEFINISHESTIMATED
                end as "Date",

                TRANSPORTTYPE.DESCRIPTION as Transport,         -- Type of transport Ship or Truck

                case when SHIP.NAME is null then                -- Identification of transport as shipName for Ships and licencePlate for Trucks
                TRUCK.LICENSEPLATE
                else
                    SHIP.NAME
                end as "Identification",

                CONTAINER.IDENTIFICATIONNUMBER as Container     -- Container identification

         --inner joins the cargo tables and left joins the transport tables since Ship or Truck may not be present in all records
                   from CARGOMANIFEST
                   inner join CARGOMANIFESTLINE on CARGOMANIFEST.ID = CARGOMANIFESTLINE.IDCARGOMANIFEST
                    inner join CONTAINER on CARGOMANIFESTLINE.IDCONTAINER = CONTAINER.ID
                    inner join CARGOMANIFESTTYPE on CARGOMANIFEST.IDCARGOMANIFESTTYPE = CARGOMANIFESTTYPE.ID
                    left join SHIP on CARGOMANIFEST.IDTRANSPORT = SHIP.IDTRANSPORT
                    left join TRUCK on CARGOMANIFEST.IDTRANSPORT = TRUCK.IDTRANSPORT
                    left join TRANSPORT on CARGOMANIFEST.IDTRANSPORT = TRANSPORT.ID
                    left join TRANSPORTTYPE on TRANSPORT.IDTRANSPORTTYPE = TRANSPORTTYPE.ID
               where
                     -- Where operation is unload
                    CARGOMANIFEST.IDCARGOSITEDESTINATION = vCargoSiteID
                    and CARGOMANIFESTTYPE.DESCRIPTION = 'Unload'
                    and CARGOMANIFEST.DATEFINISH is null
                    and CARGOMANIFEST.DATEFINISHESTIMATED >= vFirstDay
                    AND CARGOMANIFEST.DATEFINISHESTIMATED < vDayAfterLast
                    or
                     -- Where operation is load
                    CARGOMANIFEST.IDCARGOSITEORIGIN = vCargoSiteID
                    AND CARGOMANIFESTTYPE.DESCRIPTION = 'Load'
                    AND (CARGOMANIFEST.DATESTART is null
                    and CARGOMANIFEST.DATESTARTESTIMATED >= vFirstDay
                    AND CARGOMANIFEST.DATESTARTESTIMATED < vDayAfterLast)

order by
         CARGOMANIFESTTYPE.DESCRIPTION,
         TRANSPORTTYPE.DESCRIPTION,
         "Date"
;
END;
