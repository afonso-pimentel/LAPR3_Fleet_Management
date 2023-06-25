DECLARE
    vReturnCursor SYS_REFCURSOR;
    vTransportId  TRANSPORT.ID%TYPE;
    vYear VARCHAR(4);
    vDays NUMBER;
BEGIN

    Get_Ships_Idle_Days(vReturnCursor);

    DBMS_OUTPUT.PUT_LINE(' Transport | Year | Days ');
    LOOP
        FETCH vReturnCursor INTO vTransportId, vYear, vDays;
        EXIT WHEN vReturnCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(' ' || LPAD(TO_CHAR(vTransportId), 9, ' ') || ' | ' ||
                             vYear || ' | ' || TO_CHAR(vDays));
    END LOOP;
    CLOSE vReturnCursor;
END;