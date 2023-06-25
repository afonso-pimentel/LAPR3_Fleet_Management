DECLARE
    vReturnCursor   SYS_REFCURSOR;
    vCargoSiteId    CARGOSITE.ID%TYPE;
    vOperation      varchar(100);
    vDate           date;
    vTransport      varchar(100);
    vIdentification varchar(100);
    vContainer      varchar(100);

BEGIN
    select ID into vCargoSiteId from CARGOSITE where CARGOSITE.NAME = 'Port_Portugal_A_407';

    Get_Port_work_Map_for_week(vCargoSiteId, TO_DATE('08/02/2022', 'dd/MM/yyyy'), false, vReturnCursor);

    dbms_output.put_line('| Operation |    Date    | Transport | Identification |   Container   |');
    LOOP
        FETCH vReturnCursor INTO vOperation, vDate, vTransport, vIdentification, vContainer;
        EXIT WHEN vReturnCursor%NOTFOUND;

        dbms_output.put_line('|' ||
                             LPAD(to_char(vOperation), 10, ' ')
            || ' |' ||
                             LPAD(to_char(vDate), 11, ' ')
            || ' |' ||
                             LPAD(to_char(vTransport), 10, ' ')
            || ' |' ||
                             LPAD(to_char(vIdentification), 15, ' ')
            || ' |' ||
                             LPAD(to_char(vContainer), 14, ' ')
            || ' |'
            );


    END LOOP;
    CLOSE vReturnCursor;
END;





