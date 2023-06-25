DECLARE
    vReturnCursor SYS_REFCURSOR;
    vCargoSiteId  CARGOSITE.ID%TYPE;
    vDate         date;
    vContainerQty NUMBER;
    vContainerCap NUMBER;
    vShipQty      NUMBER;
    vShipCap      NUMBER;
    vTruckQty     NUMBER;
    vTruckCap     NUMBER;
BEGIN
    select ID into vCargoSiteId from CARGOSITE where CARGOSITE.NAME = 'Port_Portugal_A_310';

    Get_CargoSite_Occupancy(vCargoSiteId, 2022, 02, vReturnCursor);

    dbms_output.put_line('|    Date    | Containers | Ships | Trucks |');
    LOOP
        FETCH vReturnCursor INTO vDate, vContainerQty, vContainerCap, vShipQty, vShipCap, vTruckQty, vTruckCap;
        EXIT WHEN vReturnCursor%NOTFOUND;
        dbms_output.put_line('|' || LPAD(to_char(vDate), 12, ' ') || '|' ||
                             LPAD((vContainerQty || '/' || vContainerCap), 12, ' ') || '|' ||
                             LPAD((vShipQty || '/' || vShipCap), 7, ' ') || '|' ||
                             LPAD((vTruckQty || '/' || vTruckCap), 8, ' ') || '|');
    END LOOP;
    CLOSE vReturnCursor;
END;


